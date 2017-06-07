/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDModuleProtocol.h"

@protocol JUDWebSocketDelegate<NSObject>
- (void)didOpen;
- (void)didFailWithError:(NSError *)error;
- (void)didReceiveMessage:(id)message;
- (void)didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
@end

@protocol JUDWebSocketHandler<NSObject>

- (void)open:(NSString *)url protocol:(NSString *)protocol identifier:(NSString *)identifier withDelegate:(id<JUDWebSocketDelegate>)delegate;
- (void)send:(NSString *)identifier data:(NSString *)data;
- (void)close:(NSString *)identifier;
- (void)close:(NSString *)identifier code:(NSInteger)code reason:(NSString *)reason;
- (void)clear:(NSString *)identifier;
@end
