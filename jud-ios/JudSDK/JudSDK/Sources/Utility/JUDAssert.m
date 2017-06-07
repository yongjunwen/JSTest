/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDAssert.h"
#import "JUDLog.h"

void JUDAssertInternal(NSString *func, NSString *file, int lineNum, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    JUDLogError(@"%@", message);
    [[NSAssertionHandler currentHandler] handleFailureInFunction:func file:file lineNumber:lineNum description:format, message];
}
