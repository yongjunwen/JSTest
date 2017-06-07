/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <XCTest/XCTest.h>
#import "JUDStreamModule.h"
#import <JudSDK/JudSDK.h>
#import "JUDResourceRequestHandlerDefaultImpl.h"

@interface JUDStreamModuleTests : XCTestCase
@property (nonatomic, strong)  JUDStreamModule *streamModule;
@property (nonatomic, strong)XCTestExpectation *exp;

@end

@implementation JUDStreamModuleTests

- (void)setUp {
    [super setUp];
    _streamModule = [[JUDStreamModule alloc] init];
    [JUDSDKEngine registerHandler:[JUDResourceRequestHandlerDefaultImpl new] withProtocol:@protocol(JUDResourceRequestHandler)];
    _exp = [self expectationWithDescription:@"SendRequestSuccess Unit Test Error!"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)fetch:(NSDictionary*)options {
    __block id callbackRet = nil, progressCallbackRet = nil;
    [_streamModule fetch:options callback:^(id result) {
        callbackRet = result;
    } progressCallback:^(id result, BOOL keepAlive) {
        progressCallbackRet = result;
        [_exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * error) {
        XCTAssertNotNil(callbackRet); // final result
    }];
}

@end
