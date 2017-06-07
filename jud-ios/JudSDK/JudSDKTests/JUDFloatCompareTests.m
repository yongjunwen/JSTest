/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <XCTest/XCTest.h>
#import "JUDUtility.h"

@interface JUDFloatCompareTests : XCTestCase

@end

@implementation JUDFloatCompareTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJUDFloatEqual {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    float a = 0.1;
    double b = 0.1;
    BOOL boolval = JUDFloatEqual(a, b);
    XCTAssertTrue(boolval);
}

- (void)testJUDFloatEqualWithPrecision {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    float a = 0.1;
    double b = 0.1;
    BOOL boolval = JUDFloatEqualWithPrecision(a, b , 0.01);
    XCTAssertTrue(boolval);
}

- (void)testJUDFloatLessThan {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    float a = 0.1;
    double b = 0.2;
    BOOL boolval = JUDFloatLessThan(a, b);
    XCTAssertTrue(boolval);
}

- (void)testJUDFloatLessThanWithPrecision {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    float a = 0.1;
    double b = 0.2;
    BOOL boolval = JUDFloatLessThanWithPrecision(a, b, 0.01);
    XCTAssertTrue(boolval);
}

- (void)testJUDFloatGreaterThan {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    float a = 0.2;
    double b = 0.1;
    BOOL boolval = JUDFloatGreaterThan(a, b);
    XCTAssertTrue(boolval);
}

- (void)testJUDFloatGreaterThanWithPrecision {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    float a = 0.2;
    double b = 0.1;
    BOOL boolval = JUDFloatGreaterThanWithPrecision(a, b,0.01);
    XCTAssertTrue(boolval);
}

@end
