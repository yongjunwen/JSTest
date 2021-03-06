/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDPickerModule.h"
#import "JUDConvert.h"
#import "JUDUtility.h"
#import <UIKit/UIPickerView.h>
#import <UIKit/UIDatePicker.h>
#import <UIKit/UIKit.h>

#define JUDPickerHeight 266
#define JUDPickerToolBarHeight 44

@interface JUDPickerModule()

//picker
@property(nonatomic,strong)UIPickerView *picker;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UIView *pickerView;

//data
@property(nonatomic,copy)NSArray *items;
@property(nonatomic)BOOL isAnimating;
@property(nonatomic)NSInteger index;
@property(nonatomic,copy)JUDModuleCallback callback;

//date picker
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic)UIDatePickerMode datePickerMode;

@end

@implementation JUDPickerModule
@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(pick:callback:))
JUD_EXPORT_METHOD(@selector(pickDate:callback:))
JUD_EXPORT_METHOD(@selector(pickTime:callback:))

#pragma mark -
#pragma mark Single Picker
-(void)pick:(NSDictionary *)options callback:(JUDModuleCallback)callback
{
    NSArray *items = @[];
    NSInteger index = 0 ;
    if (options[@"items"]) {
        items = options[@"items"];
    }
    if (options[@"index"]) {
        index = [JUDConvert NSInteger:options[@"index"]];
    }
    if (items && [items count]>0 && [self isRightItems:items]) {
        [self createPicker:items index:index];
        self.callback = callback;
    } else {
        if (callback) {
            callback(@{ @"result": @"error" });
        }
        self.callback = nil;
    }
}

-(void)createPicker:(NSArray *)items index:(NSInteger)index
{
    [self configPickerView];
    self.items = [items copy];
    self.index = index;
    if (items && index < [items count]) {
        [self.picker selectRow:index inComponent:0 animated:NO];
    } else if(items && [items count]>0) {
        [self.picker selectRow:0 inComponent:0 animated:NO];
    }
    [self show];
}

-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];  //hide keyboard
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backgroundView];
    if (self.isAnimating) {
        return;
    }
    self.isAnimating = YES;
    self.backgroundView.hidden = NO;
    [UIView animateWithDuration:0.35f animations:^{
        self.pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - JUDPickerHeight, [UIScreen mainScreen].bounds.size.width, JUDPickerHeight);
        self.backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
    }];
}

-(void)hide
{
    if (self.isAnimating) {
        return;
    }
    self.isAnimating = YES;
    [UIView animateWithDuration:0.35f animations:^{
        self.pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, JUDPickerHeight);
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backgroundView.hidden = YES;
        self.isAnimating = NO;
        [self.backgroundView removeFromSuperview];
    }];
}

-(void)cancel:(id)sender
{
    [self hide];
    if (self.callback) {
        self.callback(@{ @"result": @"cancel"});
        self.callback=nil;
    }
}

-(void)done:(id)sender
{
    [self hide];
    if (self.callback) {
        self.callback(@{ @"result": @"success",@"data":[NSNumber numberWithInteger:self.index]});
        self.callback=nil;
    }
}

-(BOOL)isRightItems:(NSArray *)array
{
    for (id value in array) {
        if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            continue;
        }else {
            return NO;
        }
    }
    return YES;
}

-(NSString *)convertItem:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%ld",[value longValue]];
    }
    return value;
}

#pragma mark -
#pragma mark Picker View

-(void)configPickerView
{
    self.backgroundView = [self createbackgroundView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self.backgroundView addGestureRecognizer:tapGesture];
    self.pickerView = [self createPickerView];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JUDPickerToolBarHeight)];
    [toolBar setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem* noSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    noSpace.width=10;
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    [toolBar setItems:[NSArray arrayWithObjects:noSpace,cancelBtn,flexSpace,doneBtn,noSpace, nil]];
    [self.pickerView addSubview:toolBar];
    self.picker = [[UIPickerView alloc]init];
    self.picker.delegate = self;
    CGRect pickerFrame = CGRectMake(0, JUDPickerToolBarHeight, [UIScreen mainScreen].bounds.size.width, JUDPickerHeight-JUDPickerToolBarHeight);
    self.picker.backgroundColor = [UIColor whiteColor];
    self.picker.frame = pickerFrame;
    [self.pickerView addSubview:self.picker];
    [self.backgroundView addSubview:self.pickerView];
}

-(UIView *)createPickerView
{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, JUDPickerHeight);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(UIView *)createbackgroundView
{
    UIView *view = [UIView new];
    view.frame = [UIScreen mainScreen].bounds;
    view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    return view;
}

#pragma mark -
#pragma UIPickerDelegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.items count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self convertItem:self.items[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.index = row;
}

#pragma mark -
#pragma Date & Time Picker
-(void)pickDate:(NSDictionary *)options callback:(JUDModuleCallback)callback
{
    self.datePickerMode = UIDatePickerModeDate;
    [self datepick:options callback:callback];
}

-(void)pickTime:(NSDictionary *)options callback:(JUDModuleCallback)callback
{
    self.datePickerMode = UIDatePickerModeTime;
    [self datepick:options callback:callback];
}
    
-(void)datepick:(NSDictionary *)options callback:(JUDModuleCallback)callback
{
    if ((UIDatePickerModeTime == self.datePickerMode) || (UIDatePickerModeDate == self.datePickerMode)) {
        [self createDatePicker:options callback:callback];
    } else {
        if (callback) {
            callback(@{ @"result": @"error" });
        }
        self.callback = nil;
    }
}

- (void)createDatePicker:(NSDictionary *)options callback:(JUDModuleCallback)callback
{
    self.callback = callback;
    self.datePicker = [[UIDatePicker alloc]init];
    if (UIDatePickerModeDate == self.datePickerMode) {
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        NSString *value = [JUDConvert NSString:options[@"value"]];
        if (value) {
            NSDate *date = [JUDUtility dateStringToDate:value];
            if (date) {
                self.datePicker.date =date;
            }
        }
        NSString *max = [JUDConvert NSString:options[@"max"]];
        if (max) {
            NSDate *date = [JUDUtility dateStringToDate:max];
            if (date) {
                self.datePicker.maximumDate =date;
            }
        }
        NSString *min = [JUDConvert NSString:options[@"min"]];
        if (min) {
            NSDate *date = [JUDUtility dateStringToDate:min];
            if (date) {
                self.datePicker.minimumDate =date;
            }
        }
    } else if (UIDatePickerModeTime == self.datePickerMode) {
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        NSString *value = [JUDConvert NSString:options[@"value"]];
        if (value) {
            NSDate *date = [JUDUtility timeStringToDate:value];
            if (date) {
                self.datePicker.date = date;
            }
        }
    }
    [self configDatePickerView];
    [self show];
}

-(void)configDatePickerView
{
    self.backgroundView = [self createbackgroundView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self.backgroundView addGestureRecognizer:tapGesture];
    self.pickerView = [self createPickerView];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JUDPickerToolBarHeight)];
    [toolBar setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem* noSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    noSpace.width=10;
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDatePicker:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:noSpace,cancelBtn,flexSpace,doneBtn,noSpace, nil]];
    [self.pickerView addSubview:toolBar];
    CGRect pickerFrame = CGRectMake(0, JUDPickerToolBarHeight, [UIScreen mainScreen].bounds.size.width, JUDPickerHeight-JUDPickerToolBarHeight);
    self.datePicker.frame = pickerFrame;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [self.pickerView addSubview:self.datePicker];
    [self.backgroundView addSubview:self.pickerView];
}
    
-(void)cancelDatePicker:(id)sender
{
    [self hide];
    if (self.callback) {
        self.callback(@{ @"result": @"cancel"});
        self.callback = nil;
    }
}

-(void)doneDatePicker:(id)sender
{
    [self hide];
    NSString *value = @"";
    if (UIDatePickerModeTime == self.datePicker.datePickerMode) {
        value = [JUDUtility timeToString:self.datePicker.date];
    } else if(UIDatePickerModeDate == self.datePicker.datePickerMode)
    {
        value = [JUDUtility dateToString:self.datePicker.date];
    }
    if (self.callback) {
        self.callback(@{ @"result": @"success",@"data":value});
        self.callback=nil;
    }
}

@end
