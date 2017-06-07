/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDModuleProtocol.h"

@interface JUDInstanceWrap : NSObject <JUDModuleProtocol>

- (void)error:(NSInteger)type code:(NSInteger)code info:(NSString *)info;

@end
