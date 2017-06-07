/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDModuleProtocol.h"

@interface JUDTimerModule : NSObject <JUDModuleProtocol>

- (NSMutableDictionary *)timers;

- (void)createTimerWithCallback:(NSString *)callbackID time:(NSTimeInterval)milliseconds target:(id)target selector:(SEL)selector shouldRepeat:(BOOL)shouldRepeat;

- (void)clearTimeout:(NSString *)callbackID;

@end
