/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

@protocol JUDDatePickerManagerDelegate <NSObject>
@optional
- (void)fetchDatePickerValue:(NSString *)value;
@end

@interface JUDDatePickerManager : NSObject

@property (nonatomic, weak) id<JUDDatePickerManagerDelegate> delegate;

-(void)show;
-(void)hide;
-(void)updateDatePicker:(NSDictionary *)attributes;

@end
