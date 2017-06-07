/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "SRWebSocket.h"
#import "JUDWebSocketHandler.h"
#import <objc/runtime.h>

@interface SRWebSocket (Jud)

@property (nonatomic, copy) NSString *jud_Identifier;
@property (nonatomic, weak) id<JUDWebSocketDelegate> jud_WebSocketDelegate;

@end
