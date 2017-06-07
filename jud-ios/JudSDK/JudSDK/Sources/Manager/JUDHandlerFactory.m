/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDHandlerFactory.h"
#import "JUDThreadSafeMutableDictionary.h"
#import "JUDNavigationDefaultImpl.h"
#import "JUDAssert.h"

@interface JUDHandlerFactory ()

@property (nonatomic, strong) JUDThreadSafeMutableDictionary *handlers;

@end

@implementation JUDHandlerFactory

+ (instancetype)sharedInstance {
    static JUDHandlerFactory* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.handlers = [[JUDThreadSafeMutableDictionary alloc] init];
    });
    return _sharedInstance;
}

+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol
{
    JUDAssert(handler && protocol, @"Handler or protocol for registering can not be nil.");
    JUDAssertProtocol(handler, protocol);
        
    [[JUDHandlerFactory sharedInstance].handlers setObject:handler forKey:NSStringFromProtocol(protocol)];
}

+ (id)handlerForProtocol:(Protocol *)protocol
{
    JUDAssert(protocol, @"Can not find handler for a nil protocol");
    NSLog(@"JUDHandlerFactory:%@",[JUDHandlerFactory sharedInstance].handlers);
    id handler = [[JUDHandlerFactory sharedInstance].handlers objectForKey:NSStringFromProtocol(protocol)];
    return handler;
}

+ (NSDictionary *)handlerConfigs {
    return [JUDHandlerFactory sharedInstance].handlers;
}

@end
