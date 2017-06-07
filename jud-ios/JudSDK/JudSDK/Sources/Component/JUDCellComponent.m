/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDSDKInstance.h"
#import "JUDLog.h"
#import "JUDCellComponent.h"
#import "JUDListComponent.h"
#import "JUDComponent_internal.h"

@implementation JUDCellComponent
{
    NSIndexPath *_indexPathBeforeMove;
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    
    if (self) {
        _async = attributes[@"async"] ? [JUDConvert BOOL:attributes[@"async"]] : YES;
        _isRecycle = attributes[@"recycle"] ? [JUDConvert BOOL:attributes[@"recycle"]] : YES;
        _insertAnimation = [JUDConvert UITableViewRowAnimation:attributes[@"insertAnimation"]];
        _deleteAnimation = [JUDConvert UITableViewRowAnimation:attributes[@"deleteAnimation"]];
        _lazyCreateView = YES;
        _isNeedJoinLayoutSystem = NO;
    }
    
    return self;
}

- (void)dealloc
{
    
}

- (void)_frameDidCalculated:(BOOL)isChanged
{
    [super _frameDidCalculated:isChanged];
    
    if (isChanged) {
        [self.list cellDidLayout:self];
    }
}

- (JUDDisplayCompletionBlock)displayCompletionBlock
{
    return ^(CALayer *layer, BOOL finished) {
        if ([super displayCompletionBlock]) {
            [super displayCompletionBlock](layer, finished);
        }
        
        [self.list cellDidRendered:self];
    };
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"async"]) {
        _async = [JUDConvert BOOL:attributes[@"async"]];
    }
    
    if (attributes[@"recycle"]) {
        _isRecycle = [JUDConvert BOOL:attributes[@"recycle"]];
    }
    
    if (attributes[@"insertAnimation"]) {
        _insertAnimation = [JUDConvert UITableViewRowAnimation:attributes[@"insertAnimation"]];
    }
    
    if (attributes[@"deleteAnimation"]) {
        _deleteAnimation = [JUDConvert UITableViewRowAnimation:attributes[@"deleteAnimation"]];
    }
}

- (void)_moveToSupercomponent:(JUDComponent *)newSupercomponent atIndex:(NSUInteger)index
{
    if (self.list == newSupercomponent) {
        [self.list cell:self didMoveToIndex:index];
        [super _removeFromSupercomponent];
        [newSupercomponent _insertSubcomponent:self atIndex:index];
    } else {
        [super _moveToSupercomponent:newSupercomponent atIndex:index];
    }
}

- (void)_removeFromSupercomponent
{
    [super _removeFromSupercomponent];
    
    [self.list cellDidRemove:self];
}

- (void)removeFromSuperview
{
    // do nothing
}

- (void)_calculateFrameWithSuperAbsolutePosition:(CGPoint)superAbsolutePosition gatherDirtyComponents:(NSMutableSet<JUDComponent *> *)dirtyComponents
{
    if (isUndefined(self.cssNode->style.dimensions[CSS_WIDTH]) && self.list) {
        self.cssNode->style.dimensions[CSS_WIDTH] = self.list.scrollerCSSNode->style.dimensions[CSS_WIDTH];
    }
    
    if ([self needsLayout]) {
        layoutNode(self.cssNode, CSS_UNDEFINED, CSS_UNDEFINED, CSS_DIRECTION_INHERIT);
        if ([JUDLog logLevel] >= JUDLogLevelDebug) {
            print_css_node(self.cssNode, CSS_PRINT_LAYOUT | CSS_PRINT_STYLE | CSS_PRINT_CHILDREN);
        }
    }
    
    [super _calculateFrameWithSuperAbsolutePosition:superAbsolutePosition gatherDirtyComponents:dirtyComponents];
}
@end

