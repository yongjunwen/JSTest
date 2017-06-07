/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JSValue+Jud.h"
#import <objc/runtime.h>

@implementation JSValue (Jud)

+ (JSValue *)jud_valueWithReturnValueFromInvocation:(NSInvocation *)invocation inContext:(JSContext *)context
{
    if (!invocation || !context) {
        return nil;
    }
    
    const char * returnType = [invocation.methodSignature methodReturnType];
    
    JSValue *returnValue;
    switch (returnType[0] == _C_CONST ? returnType[1] : returnType[0]) {
        case _C_VOID: {
            // 1.void
            returnValue = [JSValue valueWithUndefinedInContext:context];
            break;
        }
        
        case _C_ID: {
            // 2.id
            void *value;
            [invocation getReturnValue:&value];
            id object = (__bridge id)value;
        
            returnValue = [JSValue valueWithObject:[object copy] inContext:context];
            break;
        }
        
#define JUD_JS_VALUE_RET_CASE(typeString, type) \
        case typeString: {                      \
            type value;                         \
            [invocation getReturnValue:&value];  \
            returnValue = [JSValue valueWithObject:@(value) inContext:context]; \
            break; \
        }
        // 3.number
        JUD_JS_VALUE_RET_CASE(_C_CHR, char)
        JUD_JS_VALUE_RET_CASE(_C_UCHR, unsigned char)
        JUD_JS_VALUE_RET_CASE(_C_SHT, short)
        JUD_JS_VALUE_RET_CASE(_C_USHT, unsigned short)
        JUD_JS_VALUE_RET_CASE(_C_INT, int)
        JUD_JS_VALUE_RET_CASE(_C_UINT, unsigned int)
        JUD_JS_VALUE_RET_CASE(_C_LNG, long)
        JUD_JS_VALUE_RET_CASE(_C_ULNG, unsigned long)
        JUD_JS_VALUE_RET_CASE(_C_LNG_LNG, long long)
        JUD_JS_VALUE_RET_CASE(_C_ULNG_LNG, unsigned long long)
        JUD_JS_VALUE_RET_CASE(_C_FLT, float)
        JUD_JS_VALUE_RET_CASE(_C_DBL, double)
        JUD_JS_VALUE_RET_CASE(_C_BOOL, BOOL)
            
        case _C_STRUCT_B: {
            NSString *typeString = [NSString stringWithUTF8String:returnType];
            
#define JUD_JS_VALUE_RET_STRUCT(_type, _methodName)                             \
            if ([typeString rangeOfString:@#_type].location != NSNotFound) {   \
                _type value;                                                   \
                [invocation getReturnValue:&value];                            \
                returnValue = [JSValue _methodName:value inContext:context]; \
                break;                                                         \
            }
            // 4.struct
            JUD_JS_VALUE_RET_STRUCT(CGRect, valueWithRect)
            JUD_JS_VALUE_RET_STRUCT(CGPoint, valueWithPoint)
            JUD_JS_VALUE_RET_STRUCT(CGSize, valueWithSize)
            JUD_JS_VALUE_RET_STRUCT(NSRange, valueWithRange)
            
        }
        case _C_CHARPTR:
        case _C_PTR:
        case _C_CLASS: {
            returnValue = [JSValue valueWithUndefinedInContext:context];
            break;
        }
    }
    
    return returnValue;
}

@end
