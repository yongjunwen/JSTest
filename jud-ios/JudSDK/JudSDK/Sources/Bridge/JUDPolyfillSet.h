/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JUDPolyfillSetJSExports <JSExport>

+ (instancetype)create;

- (BOOL)has:(id)value;

- (NSUInteger)size;

- (void)add:(id)value;

- (BOOL)delete:(id)value;

- (void)clear;

@end

@interface JUDPolyfillSet : NSObject <JUDPolyfillSetJSExports>

@end

