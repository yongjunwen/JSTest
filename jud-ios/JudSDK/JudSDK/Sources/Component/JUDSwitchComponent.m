/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDSwitchComponent.h"
#import "JUDConvert.h"

@interface JUDSwitchView : UISwitch

@end

@implementation JUDSwitchView

@end

@interface JUDSwitchComponent()

@property (nonatomic, strong)   JUDSwitchView    *switchView;
@property (nonatomic, assign)   BOOL    changeEvent;
@property (nonatomic, assign)   BOOL    checked;
@property (nonatomic, assign)   BOOL    disabled;

@end

@implementation JUDSwitchComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance]) {
        _checked = attributes[@"checked"] ? [JUDConvert BOOL:attributes[@"checked"]] : NO;
        _disabled = attributes[@"disabled"] ? [JUDConvert BOOL:attributes[@"disabled"]] : NO;
        
        self.cssNode->style.dimensions[CSS_WIDTH] = 51;
        self.cssNode->style.dimensions[CSS_HEIGHT] = 31;
    }
    return self;
}

- (UIView *)loadView
{
    return [[JUDSwitchView alloc] init];
}

- (void)viewDidLoad
{
    _switchView = (JUDSwitchView *)self.view;
    [_switchView setOn:_checked animated:YES];
    [_switchView setEnabled:!_disabled];
    [_switchView addTarget:self action:@selector(checkChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)addEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"change"]) {
        _changeEvent = YES;
    }
}

- (void)removeEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"change"]) {
        _changeEvent = NO;
    }
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"checked"]) {
        _checked = [JUDConvert BOOL:attributes[@"checked"]];
        [_switchView setOn:_checked animated:YES];
    }
    else if (attributes[@"disabled"]) {
        _disabled = [JUDConvert BOOL:attributes[@"disabled"]];
        [_switchView setEnabled:!_disabled];
    }
}

- (void)checkChanged
{
   if (_changeEvent) {
        [self fireEvent:@"change" params:@{@"value":@([_switchView isOn])} domChanges:@{@"attrs": @{@"checked": @([_switchView isOn])}}];
   }
}

@end
