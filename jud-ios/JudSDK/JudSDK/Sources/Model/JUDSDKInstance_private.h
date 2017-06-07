/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDSDKInstance.h"
#import "JUDComponentManager.h"
#import "JUDModuleMethod.h"

@interface JUDSDKInstance ()

@property (nonatomic, assign) CGFloat viewportWidth;

@property (nonatomic, strong) NSMutableDictionary *moduleInstances;
@property (nonatomic, strong) NSMutableDictionary *naviBarStyles;
@property (nonatomic, strong) NSMutableDictionary *styleConfigs;
@property (nonatomic, strong) NSMutableDictionary *attrConfigs;

@property (nonatomic, readonly, strong) JUDComponentManager *componentManager;

- (void)addModuleEventObservers:(NSString*)event callback:(NSString*)callbackId option:(NSDictionary*)option moduleClassName:(NSString*)moduleClassName;
- (void)_addModuleEventObserversWithModuleMethod:(JUDModuleMethod*)method;
- (void)removeModuleEventObserver:(NSString*)event moduleClassName:(NSString*)moduleClassName;
- (void)_removeModuleEventObserverWithModuleMethod:(JUDModuleMethod*)method;

@end
