/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "SRWebSocket+Jud.h"
static char jud_IdentifierKey;
static char jud_WebSocketDelegateKey;


@implementation SRWebSocket (Jud)

-(void)setJud_Identifier:(NSString *)jud_Identifier
{
    objc_setAssociatedObject(self, &jud_IdentifierKey, jud_Identifier, OBJC_ASSOCIATION_COPY);
}

-(NSString *)jud_Identifier
{
    return objc_getAssociatedObject(self, &jud_IdentifierKey);
}

-(void)setJud_WebSocketDelegate:(id<JUDWebSocketDelegate>)jud_WebSocketDelegate
{
    objc_setAssociatedObject(self, &jud_WebSocketDelegateKey, jud_WebSocketDelegate, OBJC_ASSOCIATION_COPY);
}

-(NSString *)jud_WebSocketDelegate
{
    return objc_getAssociatedObject(self, &jud_WebSocketDelegateKey);
}

@end
