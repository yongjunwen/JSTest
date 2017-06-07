/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <XCTest/XCTest.h>
#import "JUDURLRewriteProtocol.h"
#import "JUDHandlerFactory.h"
#import "JUDSDKInstance.h"
#import "JUDSDKEngine.h"
#import <OCMock/OCMock.h>

@interface JUDURLRewriteTests : XCTestCase

@property (nonatomic, strong) id<JUDURLRewriteProtocol> rewriteHandler;
@property (nonatomic, strong) JUDSDKInstance *instance;

@end

static id _mockNSBundle;

@implementation JUDURLRewriteTests

- (void)setUp {
    [super setUp];
    [JUDSDKEngine registerHandler:[[NSClassFromString(@"JUDURLRewriteDefaultImpl") alloc] init] withProtocol:@protocol(JUDURLRewriteProtocol)];
    _rewriteHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDURLRewriteProtocol)];
    _instance = [[JUDSDKInstance alloc] init];
    _instance.scriptURL = [NSURL URLWithString:@"https://www.jud.com/test/test.js"];
    
    _mockNSBundle = [OCMockObject niceMockForClass:[NSBundle class]];
    NSBundle *correctMainBundle = [NSBundle bundleForClass:self.class];
    [[[_mockNSBundle stub] andReturn:correctMainBundle] mainBundle];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _rewriteHandler = nil;
}

- (void)testHttpURL {
    NSString *testURL1 = @"http://www.jud2.net/test.jpg";
    NSURL *rewriteURL1 = [_rewriteHandler rewriteURL:testURL1 withResourceType:JUDResourceTypeImage withInstance:_instance];
    XCTAssertEqualObjects(testURL1, rewriteURL1.absoluteString);
    
    NSString *testURL2 = @"https://www.jud3.org/test.ttf";
    NSURL *rewriteURL2 = [_rewriteHandler rewriteURL:testURL2 withResourceType:JUDResourceTypeFont withInstance:_instance];
    XCTAssertEqualObjects(testURL2, rewriteURL2.absoluteString);
}

- (void)testNoSchemeURL {
    NSString *testURL = @"//www.jud.net/test.jpg";
    NSURL *rewriteURL = [_rewriteHandler rewriteURL:testURL withResourceType:JUDResourceTypeImage withInstance:_instance];
    XCTAssertEqualObjects(@"https://www.jud.net/test.jpg", [rewriteURL absoluteString]);
}

- (void)testRelativeURL {
    NSString *testURL1 = @"./test.jpg";
    NSURL *rewriteURL1 = [_rewriteHandler rewriteURL:testURL1 withResourceType:JUDResourceTypeImage withInstance:_instance];
    XCTAssertEqualObjects(@"https://www.jud.com/test/test.jpg", rewriteURL1.absoluteString);
    
    NSString *testURL2 = @"../test.jpg";
    NSURL *rewriteURL2 = [_rewriteHandler rewriteURL:testURL2 withResourceType:JUDResourceTypeImage withInstance:_instance];
    XCTAssertEqualObjects(@"https://www.jud.com/test.jpg", rewriteURL2.absoluteString);
    
    NSString *testURL3 = @"/test.jpg";
    NSURL *rewriteURL3 = [_rewriteHandler rewriteURL:testURL3 withResourceType:JUDResourceTypeImage withInstance:_instance];
    XCTAssertEqualObjects(@"https://www.jud.com/test.jpg", rewriteURL3.absoluteString);
    
    NSString *testURL4 = @"test.jpg";
    NSURL *rewriteURL4 = [_rewriteHandler rewriteURL:testURL4 withResourceType:JUDResourceTypeImage withInstance:_instance];
    XCTAssertEqualObjects(@"https://www.jud.com/test/test.jpg", rewriteURL4.absoluteString);
}

- (void)testFileURL {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *fileURL = [bundle URLForResource:@"testRootView" withExtension:@"js"];
    NSURL *rewriteURL = [_rewriteHandler rewriteURL:fileURL.absoluteString withResourceType:JUDResourceTypeMainBundle withInstance:_instance];
    XCTAssertEqualObjects(fileURL.absoluteString, [rewriteURL absoluteString]);
}

- (void)testLocalURL {
    NSString *testURL = @"local://testRootView.js";
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *fileURL = [bundle URLForResource:@"testRootView" withExtension:@"js"];
    NSURL *rewriteURL = [_rewriteHandler rewriteURL:testURL withResourceType:JUDResourceTypeMainBundle withInstance:_instance];
    XCTAssertEqualObjects(fileURL.absoluteString, [rewriteURL absoluteString]);
}

@end
