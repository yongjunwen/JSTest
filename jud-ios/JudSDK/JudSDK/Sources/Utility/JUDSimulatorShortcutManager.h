/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JUDSimulatorShortcutManager : NSObject

+ (void)registerSimulatorShortcutWithKey:(NSString *)key modifierFlags:(UIKeyModifierFlags)flags action:(dispatch_block_t)action;

@end
