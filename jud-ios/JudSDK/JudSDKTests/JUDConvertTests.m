/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <XCTest/XCTest.h>
#import "JUDConvert.h"

@interface JUDConvertTests : XCTestCase

@end

@implementation JUDConvertTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBOOL {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    BOOL boolval = [JUDConvert BOOL:@"-1"];
     XCTAssertTrue(boolval);
    boolval = [JUDConvert BOOL:@"true"];
    XCTAssertTrue(boolval);
    
    boolval = [JUDConvert BOOL:@"false"];
    XCTAssertTrue(!boolval);
    
}

- (void) testNSUInteger{
    NSUInteger val= [JUDConvert NSUInteger:@"x"];
    XCTAssertTrue(0==val);
    
    
    val= [JUDConvert NSUInteger:@"9"];
    XCTAssertTrue(9);
    
    //test max
    NSString * unsignedIntMax = [NSString stringWithFormat:@"%lu", NSUIntegerMax ];
    val= [JUDConvert NSUInteger:unsignedIntMax];
    XCTAssertTrue(val==NSUIntegerMax);
    
    
    
    //test overflow
    unsigned long long uio = NSUIntegerMax;
    uio++;
    
    NSString * ulval  = [NSString stringWithFormat:@"%llu", uio ];
    val = [JUDConvert NSUInteger:ulval];
    XCTAssertTrue(0==val);//overflowed
    
}

@end
