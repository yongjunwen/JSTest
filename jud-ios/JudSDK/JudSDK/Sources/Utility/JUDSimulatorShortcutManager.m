/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDSimulatorShortcutManager.h"
#import "JUDUtility.h"
#import <objc/message.h>

#if TARGET_OS_SIMULATOR

@interface UIEvent (JUDSimulatorShortcutManager)

@property (nonatomic, strong) NSString *_modifiedInput;
@property (nonatomic, strong) NSString *_unmodifiedInput;
@property (nonatomic, assign) UIKeyModifierFlags _modifierFlags;
@property (nonatomic, assign) BOOL _isKeyDown;
@property (nonatomic, assign) long _keyCode;

@end

@interface JUDKeyInput : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) UIKeyModifierFlags flags;

@end

@implementation JUDKeyInput

+ (instancetype)keyInputForKey:(NSString *)key flags:(UIKeyModifierFlags)flags
{
    JUDKeyInput *keyInput = [[self alloc] init];
    if (keyInput) {
        keyInput.key = key;
        keyInput.flags = flags;
    }
    return keyInput;
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = NO;
    if ([object isKindOfClass:[JUDKeyInput class]]) {
        JUDKeyInput *keyInput = (JUDKeyInput *)object;
        isEqual = [self.key isEqualToString:keyInput.key] && self.flags == keyInput.flags;
    }
    return isEqual;
}

@end


@implementation JUDSimulatorShortcutManager
{
    NSCache *_actions;
}

+ (instancetype)sharedManager
{
    static JUDSimulatorShortcutManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance->_actions = [[NSCache alloc] init];
        SEL handleKeyEventSelector = NSSelectorFromString(@"handleKeyUIEvent:");
        SEL replacedSelector = JUDSwizzledSelectorForSelector(handleKeyEventSelector);
        JUDSwizzleInstanceMethodWithBlock([UIApplication class], handleKeyEventSelector, ^(UIApplication *application, UIEvent *event) {
            [[[self class] sharedManager] handleKeyUIEvent:event];
            ((void(*)(id, SEL, id))objc_msgSend)(application, replacedSelector, event);
        }, replacedSelector);
    });
    return _sharedInstance;
}

+ (void)registerSimulatorShortcutWithKey:(NSString *)key modifierFlags:(UIKeyModifierFlags)flags action:(dispatch_block_t)action
{
    JUDKeyInput *keyInput = [JUDKeyInput keyInputForKey:key flags:flags];
    [[JUDSimulatorShortcutManager sharedManager]->_actions setObject:action forKey:keyInput];
}

- (void)handleKeyUIEvent:(UIEvent *)event
{
    BOOL isKeyDown = NO;
    NSString *modifiedInput = nil;
    NSString *unmodifiedInput = nil;
    UIKeyModifierFlags flags = 0;
    if ([event respondsToSelector:NSSelectorFromString(@"_isKeyDown")]) {
        isKeyDown = [event _isKeyDown];
    }
    
    if ([event respondsToSelector:NSSelectorFromString(@"_modifiedInput")]) {
        modifiedInput = [event _modifiedInput];
    }
    
    if ([event respondsToSelector:NSSelectorFromString(@"_unmodifiedInput")]) {
        unmodifiedInput = [event _unmodifiedInput];
    }
    
    if ([event respondsToSelector:NSSelectorFromString(@"_modifierFlags")]) {
        flags = [event _modifierFlags];
    }
    
    if (isKeyDown && [modifiedInput length] > 0) {
        JUDKeyInput *keyInput = [JUDKeyInput keyInputForKey:unmodifiedInput flags:flags];
        dispatch_block_t block = [_actions objectForKey:keyInput];
        if (block) {
            block();
        }
    }
}

@end

#endif
