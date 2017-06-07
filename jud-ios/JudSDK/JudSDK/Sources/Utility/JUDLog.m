/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDLog.h"
#import "JUDUtility.h"
#import "JUDAssert.h"
#import "JUDSDKManager.h"

// Xcode does NOT natively support colors in the Xcode debugging console.
// You'll need to install the XcodeColors plugin to see colors in the Xcode console.
// https://github.com/robbiehanson/XcodeColors
//
// The following is documentation from the XcodeColors project:
//
//
// How to apply color formatting to your log statements:
//
// To set the foreground color:
// Insert the ESCAPE_SEQ into your string, followed by "fg124,12,255;" where r=124, g=12, b=255.
//
// To set the background color:
// Insert the ESCAPE_SEQ into your string, followed by "bg12,24,36;" where r=12, g=24, b=36.
//
// To reset the foreground color (to default value):
// Insert the ESCAPE_SEQ into your string, followed by "fg;"
//
// To reset the background color (to default value):
// Insert the ESCAPE_SEQ into your string, followed by "bg;"
//
// To reset the foreground and background color (to default values) in one operation:
// Insert the ESCAPE_SEQ into your string, followed by ";"

#define XCODE_COLORS_ESCAPE_SEQ "\033["

#define XCODE_COLORS_RESET_FG   XCODE_COLORS_ESCAPE_SEQ "fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG   XCODE_COLORS_ESCAPE_SEQ "bg;" // Clear any background color
#define XCODE_COLORS_RESET      XCODE_COLORS_ESCAPE_SEQ ";"  // Clear any foreground or background color


#ifdef DEBUG
static const JUDLogLevel defaultLogLevel = JUDLogLevelLog;
#else
static const JUDLogLevel defaultLogLevel = JUDLogLevelWarning;
#endif

static id<JUDLogProtocol> _externalLog;

@implementation JUDLog
{
    JUDLogLevel _logLevel;
}

+ (instancetype)sharedInstance
{
    static JUDLog *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance->_logLevel = defaultLogLevel;
    });
    return _sharedInstance;
}


+ (void)setLogLevel:(JUDLogLevel)level
{
    if (((JUDLog*)[self sharedInstance])->_logLevel != level) {
        ((JUDLog*)[self sharedInstance])->_logLevel = level;
        
        [[JUDSDKManager bridgeMgr] resetEnvironment];
    }
}

+ (JUDLogLevel)logLevel
{
    return ((JUDLog*)[self sharedInstance])->_logLevel;
}

+ (NSString *)logLevelString
{
    NSDictionary *logLevelEnumToString =
    @{
      @(JUDLogLevelOff) : @"off",
      @(JUDLogLevelError) : @"error",
      @(JUDLogLevelWarning) : @"warn",
      @(JUDLogLevelInfo) : @"info",
      @(JUDLogLevelLog) : @"log",
      @(JUDLogLevelDebug) : @"debug",
      @(JUDLogLevelAll) : @"debug"
      };
    return [logLevelEnumToString objectForKey:@([self logLevel])];
}

+ (void)setLogLevelString:(NSString *)levelString
{
    NSDictionary *logLevelStringToEnum =
    @{
      @"all" : @(JUDLogLevelAll),
      @"error" : @(JUDLogLevelError),
      @"warn" : @(JUDLogLevelWarning),
      @"info" : @(JUDLogLevelInfo),
      @"debug" : @(JUDLogLevelDebug),
      @"log" : @(JUDLogLevelLog)
    };
    
    [self setLogLevel:[logLevelStringToEnum[levelString] unsignedIntegerValue]];
}

+ (void)log:(JUDLogFlag)flag file:(const char *)fileName line:(NSUInteger)line message:(NSString *)message
{
    NSString *flagString;
    NSString *flagColor;
    switch (flag) {
        case JUDLogFlagError: {
            flagString = @"error";
            flagColor = @"fg255,0,0;";
        }
            break;
        case JUDLogFlagWarning:
            flagString = @"warn";
            flagColor = @"fg255,165,0;";
            break;
        case JUDLogFlagDebug:
            flagString = @"debug";
            flagColor = @"fg0,128,0;";
            break;
        case JUDLogFlagLog:
            flagString = @"log";
            flagColor = @"fg128,128,128;";
            break;
        default:
            flagString = @"info";
            flagColor = @"fg100,149,237;";
            break;
    }
    
    NSString *logMessage = [NSString stringWithFormat:@"%s%@ <Jud>[%@]%s:%ld, %@ %s", XCODE_COLORS_ESCAPE_SEQ, flagColor, flagString, fileName, (unsigned long)line, message, XCODE_COLORS_RESET];
    
    
    if ([_externalLog logLevel] & flag) {
        [_externalLog log:flag message:logMessage];
    }
    
    [[JUDSDKManager bridgeMgr] logToWebSocket:flagString message:message];
    
    if ([JUDLog logLevel] & flag) {
        NSLog(@"%@", logMessage);
    }
}

+ (void)devLog:(JUDLogFlag)flag file:(const char *)fileName line:(NSUInteger)line format:(NSString *)format, ... {
    if ([JUDLog logLevel] & flag || [_externalLog logLevel] & flag) {
        if (!format) {
            return;
        }
        NSString *flagString = @"log";
        switch (flag) {
            case JUDLogFlagError:
                flagString = @"error";
                break;
            case JUDLogFlagWarning:
                flagString = @"warn";
                break;
            case JUDLogFlagDebug:
                flagString = @"debug";
                break;
            case JUDLogFlagLog:
                flagString = @"log";
                break;
            default:
                flagString = @"info";
                break;
        }
        
        va_list args;
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        NSArray *messageAry = [NSArray arrayWithObjects:message, nil];
        Class JUDLogClass = NSClassFromString(@"JUDDebugger");
        if (JUDLogClass) {
            SEL selector = NSSelectorFromString(@"coutLogWithLevel:arguments:");
            NSMethodSignature *methodSignature = [JUDLogClass instanceMethodSignatureForSelector:selector];
            if (methodSignature == nil) {
                NSString *info = [NSString stringWithFormat:@"%@ not found", NSStringFromSelector(selector)];
                [NSException raise:@"Method invocation appears abnormal" format:info, nil];
            }
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setTarget:[JUDLogClass alloc]];
            [invocation setSelector:selector];
            [invocation setArgument:&flagString atIndex:2];
            [invocation setArgument:&messageAry atIndex:3];
            [invocation invoke];
        }
        
        [self log:flag file:fileName line:line message:message];
    }
}

#pragma mark - External Log

+ (void)registerExternalLog:(id<JUDLogProtocol>)externalLog
{
    _externalLog = externalLog;
}

@end
