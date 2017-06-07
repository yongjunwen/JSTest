/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <XCTest/XCTest.h>
#import "JUDSDKEngine.h"
#import "JUDModuleFactory.h"
#import "JUDComponentFactory.h"
#import "JUDHandlerFactory.h"
#import "JUDResourceRequest.h"
#import "JUDResourceRequestHandlerDefaultImpl.h"

@interface JUDSDKEngineTests : XCTestCase

@end

@implementation JUDSDKEngineTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testRegisterModule {
    
    [JUDSDKEngine registerModule:@"stream" withClass:NSClassFromString(@"JUDStreamModule")];
    
    NSDictionary *result = [JUDModuleFactory moduleMethodMapsWithName:@"stream"];
    NSArray *maps = result[@"stream"];
    XCTAssertTrue(maps.count > 0);
    
    NSDictionary *moduleConfigs = [JUDModuleFactory moduleConfigs];
    XCTAssertNotNil(moduleConfigs);
    XCTAssertEqualObjects(moduleConfigs[@"stream"], @"JUDStreamModule");
    
    Class cls = [JUDModuleFactory classWithModuleName:@"stream"];
    XCTAssertEqualObjects(NSStringFromClass(cls), @"JUDStreamModule");
    
    SEL selector = [JUDModuleFactory selectorWithModuleName:@"stream" methodName:@"fetch" isSync:nil];
    XCTAssertEqualObjects(NSStringFromSelector(selector), @"fetch:callback:progressCallback:");
}

- (void)testRegisterComponent {
    
    [JUDSDKEngine registerComponent:@"embed" withClass:NSClassFromString(@"JUDEmbedComponent")];
    
    Class cls = [JUDComponentFactory classWithComponentName:@"embed"];
    XCTAssertEqualObjects(NSStringFromClass(cls), @"JUDEmbedComponent");
    
    NSDictionary *componentConfigs = [JUDComponentFactory componentConfigs];
    NSDictionary *config = componentConfigs[@"embed"];
    XCTAssertNotNil(config);
    XCTAssertEqualObjects(config[@"name"], @"embed");
    XCTAssertEqualObjects(config[@"clazz"], @"JUDEmbedComponent");
}

- (void)testRegisterComponentwithProperties {
    
    [JUDSDKEngine registerComponent:@"embed" withClass:NSClassFromString(@"JUDEmbedComponent") withProperties: @{@"key":@"abc"}];
    
    Class cls = [JUDComponentFactory classWithComponentName:@"embed"];
    XCTAssertEqualObjects(NSStringFromClass(cls), @"JUDEmbedComponent");
    
    NSDictionary *componentConfigs = [JUDComponentFactory componentConfigs];
    NSDictionary *config = componentConfigs[@"embed"];
    XCTAssertNotNil(config);
    
    XCTAssertEqualObjects(config[@"name"], @"embed");
    XCTAssertEqualObjects(config[@"clazz"], @"JUDEmbedComponent");
    XCTAssertEqualObjects(config[@"pros"], @{@"key":@"abc"});
}

- (void)testRegisterHandler {
    
    [JUDSDKEngine registerHandler:[JUDResourceRequestHandlerDefaultImpl new] withProtocol:@protocol(JUDResourceRequestHandler)];
    id handler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDResourceRequestHandler)];
    XCTAssertNotNil(handler);
    XCTAssertTrue([handler conformsToProtocol:@protocol(JUDResourceRequestHandler)]);
    
    NSDictionary *handlerConfigs = [JUDHandlerFactory handlerConfigs];
    handler = [handlerConfigs objectForKey:NSStringFromProtocol(@protocol(JUDResourceRequestHandler))];
    XCTAssertNotNil(handler);
    XCTAssertTrue([handler conformsToProtocol:@protocol(JUDResourceRequestHandler)]);
}

- (void)testComponentFactory {
    NSDictionary *component = @{@"name": @"div", @"class": @"JUDComponent"};
    [JUDComponentFactory registerComponents: [NSArray arrayWithObjects:component, nil]];
    
    NSDictionary *componentConfigs = [JUDComponentFactory componentConfigs];
    NSDictionary *config = componentConfigs[@"div"];
    XCTAssertNotNil(config);
    XCTAssertEqualObjects(config[@"name"], @"div");
    XCTAssertEqualObjects(config[@"clazz"], @"JUDComponent");
    
    Class cls = [JUDComponentFactory classWithComponentName:@"abc"];
    XCTAssertEqualObjects(NSStringFromClass(cls), @"JUDComponent");
    
    [JUDComponentFactory unregisterAllComponents];
    componentConfigs = [JUDComponentFactory componentConfigs];
    XCTAssertTrue([componentConfigs allKeys].count == 0);
}

- (void)testModuleFactory {
    
    Class cls = [JUDModuleFactory classWithModuleName:@"abc"];
    XCTAssertNil(cls);
}

- (void)testInitSDKEnviroment {
    
}

@end
