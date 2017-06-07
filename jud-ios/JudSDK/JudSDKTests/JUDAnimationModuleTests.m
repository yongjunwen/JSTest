/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <XCTest/XCTest.h>
#import "JUDSDKInstance.h"
#import "JUDComponent.h"
#import "JUDConvert.h"
#import "JUDComponent_internal.h"
#import "JUDAnimationModule.h"
#import "TestSupportUtils.h"

@interface JUDAnimationModuleTests : XCTestCase

@end

@implementation JUDAnimationModuleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
}

- (void)testAnimationRotate {
    JUDComponent *component = [self component];
    JUDAnimationModule *object = [[JUDAnimationModule alloc]init];
    [object animation:component args:@{@"duration":@500, @"timingFunction":@"ease-in-out", @"styles":@{@"transform":@"rotate(90deg)"}} callback:nil];
    [TestSupportUtils waitSecs:1];
    
    CATransform3D transformToVerify = CATransform3DMakeAffineTransform(CGAffineTransformRotate(CGAffineTransformIdentity, M_PI / 2));
    XCTAssert(JUDTransform3DApproximateToTransform(component.layer.transform, transformToVerify));
}

- (void)testAnimationTranslate {
    JUDComponent *component = [self component];
    JUDAnimationModule *object = [[JUDAnimationModule alloc]init];
    [object animation:component args:@{@"duration":@500, @"timingFunction":@"linear", @"styles":@{@"transform":@"translate(50%, 50%)"}} callback:nil];
    [TestSupportUtils waitSecs:1];
    
    CGRect frame = component.layer.frame;
    XCTAssert(frame.origin.x == 50.0f && frame.origin.y == 50.0f);
}

- (void)testAnimationScale {
    JUDComponent *component = [self component];
    JUDAnimationModule *object = [[JUDAnimationModule alloc]init];
    [object animation:component args:@{@"duration":@500, @"timingFunction":@"linear", @"styles":@{@"transform":@"scale(2)"}} callback:nil];
    [TestSupportUtils waitSecs:1];
    
    CGRect frame = component.layer.frame;
    XCTAssert(frame.size.width == 200.0f && frame.size.height == 200.0f);
}

- (void)testAnimationOpacity {
    JUDComponent *component = [self component];
    JUDAnimationModule *object = [[JUDAnimationModule alloc]init];
    [object animation:component args:@{@"duration":@500, @"timingFunction":@"linear", @"styles":@{@"backgroundColor":@"blue"}} callback:nil];
    [TestSupportUtils waitSecs:1];
    XCTAssert(component.layer.backgroundColor==[JUDConvert CGColor:@"blue"]);
}

- (JUDComponent *)component {
    JUDComponent *component = [[JUDComponent alloc] initWithRef:@"0" type:@"div" styles:@{} attributes:@{} events:@[] judInstance:[[JUDSDKInstance alloc] init]];
    XCTAssertNotNil(component.view, @"Component's view should be created");
    
    component.view.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    component.view.backgroundColor = [UIColor redColor];
    
    return component;
}

@end
