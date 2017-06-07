/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JUDLogFlag) {
    JUDLogFlagError      = 1 << 0,
    JUDLogFlagWarning    = 1 << 1,
    JUDLogFlagInfo       = 1 << 2,
    JUDLogFlagLog        = 1 << 3,
    JUDLogFlagDebug      = 1 << 4
};

/**
 *  Use Log levels to filter logs.
 */
typedef NS_ENUM(NSUInteger, JUDLogLevel){
    /**
     *  No logs
     */
    JUDLogLevelOff       = 0,
    
    /**
     *  Error only
     */
    JUDLogLevelError     = JUDLogFlagError,
    
    /**
     *  Error and warning
     */
    JUDLogLevelWarning   = JUDLogLevelError | JUDLogFlagWarning,
    
    /**
     *  Error, warning and info
     */
    JUDLogLevelInfo      = JUDLogLevelWarning | JUDLogFlagInfo,
    
    /**
     *  Log, warning info
     */
    JUDLogLevelLog       = JUDLogFlagLog | JUDLogLevelInfo,
    
    /**
     *  Error, warning, info and debug logs
     */
    JUDLogLevelDebug     = JUDLogLevelLog | JUDLogFlagDebug,
    
    /**
     *  All
     */
    JUDLogLevelAll       = NSUIntegerMax
};

/**
 *  External log protocol, which is used to output the log to the external.
 */
@protocol JUDLogProtocol <NSObject>

@required

/**
 * External log level.
 */
- (JUDLogLevel)logLevel;

- (void)log:(JUDLogFlag)flag message:(NSString *)message;

@end

@interface JUDLog : NSObject

+ (JUDLogLevel)logLevel;

+ (void)setLogLevel:(JUDLogLevel)level;

+ (NSString *)logLevelString;

+ (void)setLogLevelString:(NSString *)levelString;

//+ (void)log:(JUDLogFlag)flag file:(const char *)fileName line:(NSUInteger)line format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

+ (void)log:(JUDLogFlag)flag file:(const char *)fileName line:(NSUInteger)line message:(NSString *)message;

+ (void)devLog:(JUDLogFlag)flag file:(const char *)fileName line:(NSUInteger)line format:(NSString *)format, ... NS_FORMAT_FUNCTION(4,5);

+ (void)registerExternalLog:(id<JUDLogProtocol>)externalLog;

@end

#define JUD_FILENAME (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)

 
#define JUD_LOG(flag, fmt, ...)          \
do {                                    \
    [JUDLog devLog:flag                     \
             file:JUD_FILENAME              \
             line:__LINE__                 \
           format:(fmt), ## __VA_ARGS__];  \
} while(0)

extern void _JUDLogObjectsImpl(NSString *severity, NSArray *arguments);

#define JUDLog(format,...)               JUD_LOG(JUDLogFlagLog, format, ##__VA_ARGS__)
#define JUDLogDebug(format, ...)         JUD_LOG(JUDLogFlagDebug, format, ##__VA_ARGS__)
#define JUDLogInfo(format, ...)          JUD_LOG(JUDLogFlagInfo, format, ##__VA_ARGS__)
#define JUDLogWarning(format, ...)       JUD_LOG(JUDLogFlagWarning, format ,##__VA_ARGS__)
#define JUDLogError(format, ...)         JUD_LOG(JUDLogFlagError, format, ##__VA_ARGS__)
