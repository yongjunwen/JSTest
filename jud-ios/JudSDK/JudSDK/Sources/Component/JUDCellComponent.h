/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent.h"
@class JUDListComponent;

@interface JUDCellComponent : JUDComponent

@property (nonatomic, strong) NSString *scope;
@property (nonatomic, assign) BOOL isRecycle;
@property (nonatomic, assign) UITableViewRowAnimation insertAnimation;
@property (nonatomic, assign) UITableViewRowAnimation deleteAnimation;
@property (nonatomic, weak) JUDListComponent *list;

@end
