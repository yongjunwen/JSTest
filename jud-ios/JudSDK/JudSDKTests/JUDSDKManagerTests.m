/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <XCTest/XCTest.h>
#import "JUDSDKManager.h"
#import "JUDSDKInstance.h"
#import "TestSupportUtils.h"

@interface JUDSDKManagerTests : XCTestCase

@end

@implementation JUDSDKManagerTests

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

- (void)testJUDSDKManager {
    id bridgeMgr = [JUDSDKManager bridgeMgr];
    XCTAssertNotNil(bridgeMgr);
    XCTAssertTrue([bridgeMgr isKindOfClass:NSClassFromString(@"JUDBridgeManager")]);
    
    [JUDSDKManager storeInstance:[JUDSDKInstance new] forID:@"0"];
    JUDSDKInstance *instance0 = [JUDSDKManager instanceForID:@"0"];
    XCTAssertNotNil(instance0);
    
    [JUDSDKManager storeInstance:[JUDSDKInstance new] forID:@"1"];
    JUDSDKInstance *instance1 = [JUDSDKManager instanceForID:@"1"];
    XCTAssertNotNil(instance1);
    
    [JUDSDKManager removeInstanceforID:@"0"];
    instance0 = [JUDSDKManager instanceForID:@"0"];
    XCTAssertNil(instance0);
    
    [JUDSDKManager unload];
   // [TestSupportUtils waitSecs:5];
    instance1 = [JUDSDKManager instanceForID:@"1"];
    //XCTAssertNil(instance1);
}

- (void)testUnload {
    
}

@end
