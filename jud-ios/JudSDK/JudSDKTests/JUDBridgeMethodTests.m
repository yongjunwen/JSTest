/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <XCTest/XCTest.h>
#import "JUDCallJSMethod.h"
#import "JUDSDKInstance.h"

@interface JUDBridgeMethodTests : XCTestCase

@end

@implementation JUDBridgeMethodTests

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
    JUDSDKInstance *instance = [[JUDSDKInstance alloc] init];
    
    JUDCallJSMethod *method = [[JUDCallJSMethod alloc] initWithModuleName:@"dom" methodName:@"test" arguments:@[@"1", @"2", @"3"] instance:instance];
    
    NSDictionary *task = [method callJSTask];
    XCTAssertEqualObjects(task[@"module"], @"dom");
    XCTAssertEqualObjects(task[@"method"], @"test");
    
    NSArray *args = task[@"args"];
    XCTAssertTrue(args.count == 3);
    XCTAssertEqualObjects(args[0], @"1");
    XCTAssertEqualObjects(args[1], @"2");
    XCTAssertEqualObjects(args[2], @"3");
    
    JUDCallJSMethod *method2 = [[JUDCallJSMethod alloc] initWithModuleName:nil methodName:nil arguments:nil instance:[[JUDSDKInstance alloc] init]];
    
    task = [method2 callJSTask];
    XCTAssertEqualObjects(task[@"module"], @"");
    XCTAssertEqualObjects(task[@"method"], @"");
    
    args = task[@"args"];
    XCTAssertNotNil(args);
    XCTAssertTrue(args.count == 0);
}

@end
