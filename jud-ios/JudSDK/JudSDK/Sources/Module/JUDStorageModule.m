/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDStorageModule.h"
#import "JUDSDKManager.h"
#import "JUDThreadSafeMutableDictionary.h"
#import "JUDThreadSafeMutableArray.h"
#import <CommonCrypto/CommonCrypto.h>
#import "JUDUtility.h"

static NSString * const JUDStorageDirectory            = @"judstorage";
static NSString * const JUDStorageFileName             = @"judstorage.plist";
static NSString * const JUDStorageInfoFileName         = @"judstorage.info.plist";
static NSString * const JUDStorageIndexFileName        = @"judstorage.index.plist";
static NSUInteger const JUDStorageLineLimit            = 1024;
static NSUInteger const JUDStorageTotalLimit           = 5 * 1024 * 1024;
static NSString * const JUDStorageThreadName           = @"com.jingdong.jud.storage";
static NSString * const JUDStorageNullValue            = @"#{eulaVlluNegarotSXW}";

@implementation JUDStorageModule

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(length:))
JUD_EXPORT_METHOD(@selector(getItem:callback:))
JUD_EXPORT_METHOD(@selector(setItem:value:callback:))
JUD_EXPORT_METHOD(@selector(setItemPersistent:value:callback:))
JUD_EXPORT_METHOD(@selector(getAllKeys:))
JUD_EXPORT_METHOD(@selector(removeItem:callback:))

#pragma mark - Export

- (dispatch_queue_t)targetExecuteQueue {
    return [JUDStorageModule storageQueue];
}

- (void)length:(JUDModuleCallback)callback
{
    if (callback) {
        callback(@{@"result":@"success",@"data":@([[JUDStorageModule memory] count])});
    }
}

- (void)getAllKeys:(JUDModuleCallback)callback
{
    if (callback) {
        callback(@{@"result":@"success",@"data":[JUDStorageModule memory].allKeys});
    }
}

- (void)getItem:(NSString *)key callback:(JUDModuleCallback)callback
{
    if ([self checkInput:key]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"key must a string or number!"}); // forgive my english
        }
        return;
    }
    
    if ([key isKindOfClass:[NSNumber class]]) {
        key = [((NSNumber *)key) stringValue]; // oh no!
    }
    
    if ([JUDUtility isBlankString:key]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"invalid_param"});
        }
        return ;
    }
    
    NSString *value = [self.memory objectForKey:key];
    if ([JUDStorageNullValue isEqualToString:value]) {
        value = [[JUDUtility globalCache] objectForKey:key];
        if (!value) {
            NSString *filePath = [JUDStorageModule filePathForKey:key];
            NSString *contents = [JUDUtility stringWithContentsOfFile:filePath];
            if (contents) {
                [[JUDUtility globalCache] setObject:contents forKey:key cost:contents.length];
                value = contents;
            }
        }
    }
    if (!value) {
        [self executeRemoveItem:key];
        if (callback) {
            callback(@{@"result":@"failed"});
        }
        return;
    }
    [self updateTimestampForKey:key];
    [self updateIndexForKey:key];
    if (callback) {
        callback(@{@"result":@"success",@"data":value});
    }
}

- (void)setItem:(NSString *)key value:(NSString *)value callback:(JUDModuleCallback)callback
{
    if ([self checkInput:key]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"key must a string or number!"});
        }
        return;
    }
    if ([self checkInput:value]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"value must a string or number!"});
        }
        return;
    }
    
    if ([key isKindOfClass:[NSNumber class]]) {
        key = [((NSNumber *)key) stringValue];
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [((NSNumber *)value) stringValue];
    }
    
    if ([JUDUtility isBlankString:key]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"invalid_param"});
        }
        return ;
    }
    [self setObject:value forKey:key persistent:NO callback:callback];
}

- (void)setItemPersistent:(NSString *)key value:(NSString *)value callback:(JUDModuleCallback)callback
{
    if ([self checkInput:key]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"key must a string or number!"});
        }
        return;
    }
    if ([self checkInput:value]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"value must a string or number!"});
        }
        return;
    }
    
    if ([key isKindOfClass:[NSNumber class]]) {
        key = [((NSNumber *)key) stringValue];
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [((NSNumber *)value) stringValue];
    }
    
    if ([JUDUtility isBlankString:key]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"invalid_param"});
        }
        return ;
    }
    [self setObject:value forKey:key persistent:YES callback:callback];
}

- (void)removeItem:(NSString *)key callback:(JUDModuleCallback)callback
{
    if ([self checkInput:key]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"key must a string or number!"});
        }
        return;
    }
    
    if ([key isKindOfClass:[NSNumber class]]) {
        key = [((NSNumber *)key) stringValue];
    }
    
    if ([JUDUtility isBlankString:key]) {
        if (callback) {
            callback(@{@"result":@"failed",@"data":@"invalid_param"});
        }
        return ;
    }
    BOOL removed = [self executeRemoveItem:key];
    if (removed) {
        if (callback) {
            callback(@{@"result":@"success"});
        }
    } else {
        if (callback) {
            callback(@{@"result":@"failed"});
        }
    }
}

- (BOOL)executeRemoveItem:(NSString *)key {
    if ([JUDStorageNullValue isEqualToString:self.memory[key]]) {
        [self.memory removeObjectForKey:key];
        NSDictionary *dict = [self.memory copy];
        [self write:dict toFilePath:[JUDStorageModule filePath]];
        dispatch_async([JUDStorageModule storageQueue], ^{
            NSString *filePath = [JUDStorageModule filePathForKey:key];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [[JUDUtility globalCache] removeObjectForKey:key];
        });
    } else if (self.memory[key]) {
        [self.memory removeObjectForKey:key];
        NSDictionary *dict = [self.memory copy];
        [self write:dict toFilePath:[JUDStorageModule filePath]];
    } else {
        return NO;
    }
    [self removeInfoForKey:key];
    [self removeIndexForKey:key];
    return YES;
}

#pragma mark - Utils
- (void)setObject:(NSString *)obj forKey:(NSString *)key persistent:(BOOL)persistent callback:(JUDModuleCallback)callback {
    NSString *filePath = [JUDStorageModule filePathForKey:key];
    if (obj.length <= JUDStorageLineLimit) {
        if ([JUDStorageNullValue isEqualToString:self.memory[key]]) {
            [[JUDUtility globalCache] removeObjectForKey:key];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
        self.memory[key] = obj;
        NSDictionary *dict = [self.memory copy];
        [self write:dict toFilePath:[JUDStorageModule filePath]];
        [self setInfo:@{@"persistent":@(persistent),@"size":@(obj.length)} ForKey:key];
        [self updateIndexForKey:key];
        [self checkStorageLimit];
        if (callback) {
            callback(@{@"result":@"success"});
        }
        return;
    }
    
    [[JUDUtility globalCache] setObject:obj forKey:key cost:obj.length];
    
    if (![JUDStorageNullValue isEqualToString:self.memory[key]]) {
        self.memory[key] = JUDStorageNullValue;
        NSDictionary *dict = [self.memory copy];
        [self write:dict toFilePath:[JUDStorageModule filePath]];
    }
    
    dispatch_async([JUDStorageModule storageQueue], ^{
        [obj writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    });
    
    [self setInfo:@{@"persistent":@(persistent),@"size":@(obj.length)} ForKey:key];
    [self updateIndexForKey:key];
    
    [self checkStorageLimit];
    if (callback) {
        callback(@{@"result":@"success"});
    }
}

- (void)checkStorageLimit {
    NSInteger size = [self totalSize] - JUDStorageTotalLimit;
    if (size > 0) {
        [self removeItemsBySize:size];
    }
}

- (void)removeItemsBySize:(NSInteger)size {
    NSArray *indexs = [[self indexs] copy];
    if (size < 0 || indexs.count == 0) {
        return;
    }
    
    NSMutableArray *removedKeys = [NSMutableArray array];
    for (NSInteger i = 0; i < indexs.count; i++) {
        NSString *key = indexs[i];
        NSDictionary *info = [self getInfoForKey:key];
        
        // persistent data, can't be removed
        if ([info[@"persistent"] boolValue]) {
            continue;
        }
        
        [removedKeys addObject:key];
        size -= [info[@"size"] integerValue];
        
        if (size < 0) {
            break;
        }
    }
    
    // actually remove data
    for (NSString *key in removedKeys) {
        [self executeRemoveItem:key];
    }
}

- (void)write:(NSDictionary *)dict toFilePath:(NSString *)filePath{
    [dict writeToFile:filePath atomically:YES];
}

+ (NSString *)filePathForKey:(NSString *)key
{
    NSString *safeFileName = [JUDUtility md5:key];
    
    return [[JUDStorageModule directory] stringByAppendingPathComponent:safeFileName];
}

+ (void)setupDirectory{
    BOOL isDirectory = NO;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[JUDStorageModule directory] isDirectory:&isDirectory];
    if (!isDirectory && !fileExists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[JUDStorageModule directory]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
}

+ (NSString *)directory {
    static NSString *storageDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storageDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        storageDirectory = [storageDirectory stringByAppendingPathComponent:JUDStorageDirectory];
    });
    return storageDirectory;
}

+ (NSString *)filePath {
    static NSString *storageFilePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storageFilePath = [[JUDStorageModule directory] stringByAppendingPathComponent:JUDStorageFileName];
    });
    return storageFilePath;
}

+ (NSString *)infoFilePath {
    static NSString *infoFilePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        infoFilePath = [[JUDStorageModule directory] stringByAppendingPathComponent:JUDStorageInfoFileName];
    });
    return infoFilePath;
}

+ (NSString *)indexFilePath {
    static NSString *indexFilePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indexFilePath = [[JUDStorageModule directory] stringByAppendingPathComponent:JUDStorageIndexFileName];
    });
    return indexFilePath;
}

+ (dispatch_queue_t)storageQueue {
    static dispatch_queue_t storageQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storageQueue = dispatch_queue_create("com.jingdong.jud.storage", DISPATCH_QUEUE_SERIAL);
    });
    return storageQueue;
}

+ (JUDThreadSafeMutableDictionary<NSString *, NSString *> *)memory {
    static JUDThreadSafeMutableDictionary<NSString *,NSString *> *memory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JUDStorageModule setupDirectory];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[JUDStorageModule filePath]]) {
            NSDictionary *contents = [NSDictionary dictionaryWithContentsOfFile:[JUDStorageModule filePath]];
            if (contents) {
                memory = [[JUDThreadSafeMutableDictionary alloc] initWithDictionary:contents];
            }
        }
        if (!memory) {
            memory = [JUDThreadSafeMutableDictionary new];
        }
//        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:nil usingBlock:^(__unused NSNotification *note) {
//            [memory removeAllObjects];
//        }];
    });
    return memory;
}

+ (JUDThreadSafeMutableDictionary<NSString *, NSDictionary *> *)info {
    static JUDThreadSafeMutableDictionary<NSString *,NSDictionary *> *info;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JUDStorageModule setupDirectory];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[JUDStorageModule infoFilePath]]) {
            NSDictionary *contents = [NSDictionary dictionaryWithContentsOfFile:[JUDStorageModule infoFilePath]];
            if (contents) {
                info = [[JUDThreadSafeMutableDictionary alloc] initWithDictionary:contents];
            }
        }
        if (!info) {
            info = [JUDThreadSafeMutableDictionary new];
        }
    });
    return info;
}

+ (JUDThreadSafeMutableArray *)indexs {
    static JUDThreadSafeMutableArray *indexs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JUDStorageModule setupDirectory];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[JUDStorageModule indexFilePath]]) {
            NSArray *contents = [NSArray arrayWithContentsOfFile:[JUDStorageModule indexFilePath]];
            if (contents) {
                indexs = [[JUDThreadSafeMutableArray alloc] initWithArray:contents];
            }
        }
        if (!indexs) {
            indexs = [JUDThreadSafeMutableArray new];
        }
    });
    return indexs;
}

- (JUDThreadSafeMutableDictionary<NSString *, NSString *> *)memory {
    return [JUDStorageModule memory];
}

- (JUDThreadSafeMutableDictionary<NSString *, NSDictionary *> *)info {
    return [JUDStorageModule info];
}

- (JUDThreadSafeMutableArray *)indexs {
    return [JUDStorageModule indexs];
}

- (BOOL)checkInput:(id)input{
    return !([input isKindOfClass:[NSString class]] || [input isKindOfClass:[NSNumber class]]);
}

#pragma mark
#pragma mark - Storage Info method
- (NSDictionary *)getInfoForKey:(NSString *)key {
    NSDictionary *info = [[self info] objectForKey:key];
    if (!info) {
        return nil;
    }
    return info;
}

- (void)setInfo:(NSDictionary *)info ForKey:(NSString *)key {
    NSAssert(info, @"info must not be nil");
    
    // save info for key
    NSMutableDictionary *newInfo = [NSMutableDictionary dictionaryWithDictionary:info];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    [newInfo setObject:@(interval) forKey:@"ts"];
    
    [[self info] setObject:[newInfo copy] forKey:key];
    NSDictionary *dict = [[self info] copy];
    [self write:dict toFilePath:[JUDStorageModule infoFilePath]];
}

- (void)removeInfoForKey:(NSString *)key {
    [[self info] removeObjectForKey:key];
    NSDictionary *dict = [[self info] copy];
    [self write:dict toFilePath:[JUDStorageModule infoFilePath]];
}

- (void)updateTimestampForKey:(NSString *)key {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSDictionary *info = [[self info] objectForKey:key];
    if (!info) {
        info = @{@"persistent":@(NO),@"size":@(0),@"ts":@(interval)};
    } else {
        NSMutableDictionary *newInfo = [NSMutableDictionary dictionaryWithDictionary:info];
        [newInfo setObject:@(interval) forKey:@"ts"];
        info = [newInfo copy];
    }
    
    [[self info] setObject:info forKey:key];
    NSDictionary *dict = [[self info] copy];
    [self write:dict toFilePath:[JUDStorageModule infoFilePath]];
}

- (NSInteger)totalSize {
    NSInteger totalSize = 0;
    for (NSDictionary *info in [self info].allValues) {
        totalSize += (info[@"size"] ? [info[@"size"] integerValue] : 0);
    }
    return totalSize;
}

#pragma mark
#pragma mark - Storage Index method
- (void)updateIndexForKey:(NSString *)key {
    [[self indexs] removeObject:key];
    [[self indexs] addObject:key];
    [self write:[[self indexs] copy] toFilePath:[JUDStorageModule indexFilePath]];
}

- (void)removeIndexForKey:(NSString *)key {
    [[self indexs] removeObject:key];
    [self write:[[self indexs] copy] toFilePath:[JUDStorageModule indexFilePath]];
}

@end

