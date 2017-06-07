/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDListComponent.h"
#import "JUDCellComponent.h"
#import "JUDComponent.h"
#import "JUDComponent_internal.h"
#import "NSArray+Jud.h"
#import "JUDAssert.h"
#import "JUDMonitor.h"
#import "JUDUtility.h"
#import "NSObject+JUDSwizzle.h"
#import "JUDSDKInstance_private.h"
#import "JUDRefreshComponent.h"
#import "JUDLoadingComponent.h"

@interface JUDTableView : UITableView

@end

@implementation JUDTableView

+ (BOOL)requiresConstraintBasedLayout
{
    return NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.jud_component layoutDidFinish];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    // FIXME: side effect caused by hooking _adjustContentOffsetIfNecessary.
    // When UITableView is pulled down and finger releases，contentOffset will be set from -xxxx to about -0.5(greater than -0.5), then contentOffset will be reset to zero by calling _adjustContentOffsetIfNecessary.
    // So hooking _adjustContentOffsetIfNecessary will always cause remaining 1px space between list's top and navigator.
    // Demo: http://dotwe.org/895630945793a9a044e49abe39cbb77f
    // Have to reset contentOffset to zero manually here.
    if (fabs(contentOffset.y) < 0.5) {
        contentOffset.y = 0;
    }
    
    [super setContentOffset:contentOffset];
}

@end

@interface JUDHeaderComponent : JUDComponent

@property (nonatomic, weak) JUDListComponent *list;

@end

@implementation JUDHeaderComponent

//TODO: header remove->need reload
- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    
    if (self) {
        _async = YES;
        _isNeedJoinLayoutSystem = NO;
    }
    
    return self;
}

- (void)_frameDidCalculated:(BOOL)isChanged
{
    [super _frameDidCalculated:isChanged];
    
    if (isChanged) {
        [self.list headerDidLayout:self];
    }
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

@interface JUDSection : NSObject<NSCopying>

@property (nonatomic, strong) JUDHeaderComponent *header;
@property (nonatomic, strong) NSMutableArray<JUDCellComponent *> *rows;

@end

@implementation JUDSection

- (instancetype)init
{
    if (self = [super init]) {
        _rows = [NSMutableArray array];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    JUDSection *newSection = [[[self class] allocWithZone:zone] init];
    newSection.header = _header;
    newSection.rows = [_rows mutableCopyWithZone:zone];
    
    return newSection;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n%@", [_header description], [_rows description]];
}
@end

@interface JUDListComponent () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation JUDListComponent
{
    __weak UITableView * _tableView;

    // Only accessed on component thread
    NSMutableArray<JUDSection *> *_sections;
    // Only accessed on main thread
    NSMutableArray<JUDSection *> *_completedSections;
    
    NSUInteger _previousLoadMoreRowNumber;
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance]) {
        
        _sections = [NSMutableArray array];
        _completedSections = [NSMutableArray array];
        
        [self fixFlicker];
    }
    
    return self;
}

- (void)dealloc
{
    if (_tableView) {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
    }
}

- (UIView *)loadView
{
    return [[JUDTableView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = (UITableView *)self.view;
    _tableView.allowsSelection = NO;
    _tableView.allowsMultipleSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.userInteractionEnabled = YES;
}

- (void)viewWillUnload
{
    [super viewWillUnload];
    
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)setContentSize:(CGSize)contentSize
{
    // Do Nothing
}

- (void)_handleFirstScreenTime
{
    // Do Nothing， firstScreenTime is set by cellDidRendered:
}

- (void)scrollToComponent:(JUDComponent *)component withOffset:(CGFloat)offset animated:(BOOL)animated
{
    CGPoint contentOffset = _tableView.contentOffset;
    CGFloat contentOffsetY = 0;
    
    JUDComponent *cellComponent = component;
    CGRect cellRect;
    while (cellComponent) {
        if ([cellComponent isKindOfClass:[JUDCellComponent class]]) {
            NSIndexPath *toIndexPath = [self indexPathForCell:(JUDCellComponent*)cellComponent sections:_completedSections];
            cellRect = [_tableView rectForRowAtIndexPath:toIndexPath];
            break;
        }
        if ([cellComponent isKindOfClass:[JUDHeaderComponent class]]) {
            NSUInteger toIndex = [self indexForHeader:(JUDHeaderComponent *)cellComponent sections:_completedSections];
            cellRect = [_tableView rectForSection:toIndex];
            break;
        }
        contentOffsetY += cellComponent.calculatedFrame.origin.y;
        cellComponent = cellComponent.supercomponent;
    }
    
    contentOffsetY += cellRect.origin.y;
    contentOffsetY += offset * self.judInstance.pixelScaleFactor;
    
    if (contentOffsetY > _tableView.contentSize.height - _tableView.frame.size.height) {
        contentOffset.y = _tableView.contentSize.height - _tableView.frame.size.height;
    } else {
        contentOffset.y = contentOffsetY;
    }
    
    [_tableView setContentOffset:contentOffset animated:animated];
}


#pragma mark - Inheritance

- (void)_insertSubcomponent:(JUDComponent *)subcomponent atIndex:(NSInteger)index
{
    if ([subcomponent isKindOfClass:[JUDCellComponent class]]) {
        ((JUDCellComponent *)subcomponent).list = self;
    } else if ([subcomponent isKindOfClass:[JUDHeaderComponent class]]) {
        ((JUDHeaderComponent *)subcomponent).list = self;
    } else if (![subcomponent isKindOfClass:[JUDRefreshComponent class]]
               && ![subcomponent isKindOfClass:[JUDLoadingComponent class]]
               && subcomponent->_positionType != JUDPositionTypeFixed) {
        JUDLogError(@"list only support cell/header/refresh/loading/fixed-component as child.");
        return;
    }
    
    [super _insertSubcomponent:subcomponent atIndex:index];
    
    if (![subcomponent isKindOfClass:[JUDHeaderComponent class]]
        && ![subcomponent isKindOfClass:[JUDCellComponent class]]) {
        // Don't insert section if subcomponent is not header or cell
        return;
    }
    
    NSIndexPath *indexPath = [self indexPathForSubIndex:index];
    if (_sections.count <= indexPath.section) {
        JUDSection *section = [JUDSection new];
        if ([subcomponent isKindOfClass:[JUDHeaderComponent class]]) {
            section.header = (JUDHeaderComponent*)subcomponent;
        }
        //TODO: consider insert header at middle
        [_sections addObject:section];
        NSUInteger index = [_sections indexOfObject:section];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        JUDSection *completedSection = [section copy];
        
        [self.judInstance.componentManager _addUITask:^{
            [_completedSections addObject:completedSection];
            JUDLogDebug(@"Insert section:%ld",  (unsigned long)[_completedSections indexOfObject:completedSection]);
            [UIView performWithoutAnimation:^{
                [_tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }];
        }];
    }
}

- (void)insertSubview:(JUDComponent *)subcomponent atIndex:(NSInteger)index
{
    //Here will not insert cell or header's view again
    if (![subcomponent isKindOfClass:[JUDCellComponent class]]
        && ![subcomponent isKindOfClass:[JUDHeaderComponent class]]) {
        [super insertSubview:subcomponent atIndex:index];
    }
}

- (void)headerDidLayout:(JUDHeaderComponent *)header
{
    [self.judInstance.componentManager _addUITask:^{
        // trigger section header update
        [_tableView beginUpdates];
        [_tableView endUpdates];
    }];
    
}


- (void)cellDidRemove:(JUDCellComponent *)cell
{
    JUDAssertComponentThread();
    
    NSIndexPath *indexPath = [self indexPathForCell:cell sections:_sections];
    [self removeCellForIndexPath:indexPath withSections:_sections];
    
    [self.judInstance.componentManager _addUITask:^{
        [self removeCellForIndexPath:indexPath withSections:_completedSections];
        
        JUDLogDebug(@"Delete cell:%@ at indexPath:%@", cell.ref, indexPath);
        if (cell.deleteAnimation == UITableViewRowAnimationNone) {
            [UIView performWithoutAnimation:^{
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self handleAppear];
            }];
        } else {
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:cell.deleteAnimation];
            [self handleAppear];
        }
    }];
}

- (void)cellDidLayout:(JUDCellComponent *)cell
{
    JUDAssertComponentThread() ;
    
    NSUInteger index = [self.subcomponents indexOfObject:cell];
    NSIndexPath *indexPath = [self indexPathForSubIndex:index];

    NSInteger sectionNum = indexPath.section;
    NSInteger row = indexPath.row;
    NSMutableArray *sections = _sections;
    JUDSection *section = sections[sectionNum];
    JUDAssert(section, @"no section found for section number:%ld", sectionNum);
    NSMutableArray *completedSections;
    BOOL isReload = [section.rows containsObject:cell];
    if (!isReload) {
        [section.rows insertObject:cell atIndex:row];
        // deep copy
        completedSections = [[NSMutableArray alloc] initWithArray:sections copyItems:YES];;
    }
    
    [self.judInstance.componentManager _addUITask:^{
        if (!isReload) {
            JUDLogDebug(@"Insert cell:%@ at indexPath:%@", cell.ref, indexPath);
            _completedSections = completedSections;
            if (cell.insertAnimation == UITableViewRowAnimationNone) {
                [UIView performWithoutAnimation:^{
                    [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [self handleAppear];
                }];
            } else {
                [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:cell.insertAnimation];
                [self handleAppear];
            }
        } else {
            JUDLogInfo(@"Reload cell:%@ at indexPath:%@", cell.ref, indexPath);
            [UIView performWithoutAnimation:^{
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self handleAppear];
            }];
        }
    }];
}

- (void)cellDidRendered:(JUDCellComponent *)cell
{
    JUDAssertMainThread();
    
    if (JUD_MONITOR_INSTANCE_PERF_IS_RECORDED(JUDPTFirstScreenRender, self.judInstance) && !self.judInstance.onRenderProgress) {
        // improve performance
        return;
    }
    
    NSIndexPath *indexPath = [self indexPathForCell:cell sections:_completedSections];
    if (!indexPath || indexPath.section >= [_tableView numberOfSections] ||
        indexPath.row < 0 || indexPath.row >= [_tableView numberOfRowsInSection:indexPath.section]) {
        JUDLogWarning(@"Rendered cell:%@ out of range, sections:%@", cell, _completedSections);
        return;
    }
    
    CGRect cellRect = [_tableView rectForRowAtIndexPath:indexPath];
    if (cellRect.origin.y + cellRect.size.height >= _tableView.frame.size.height) {
        JUD_MONITOR_INSTANCE_PERF_END(JUDPTFirstScreenRender, self.judInstance);
    }
    
    if (self.judInstance.onRenderProgress) {
        CGRect renderRect = [_tableView convertRect:cellRect toView:self.judInstance.rootView];
        self.judInstance.onRenderProgress(renderRect);
    }

}

- (void)cell:(JUDCellComponent *)cell didMoveToIndex:(NSUInteger)index
{
    JUDAssertComponentThread();
    
    NSIndexPath *fromIndexPath = [self indexPathForCell:cell sections:_sections];
    NSIndexPath *toIndexPath = [self indexPathForSubIndex:index];
    [self removeCellForIndexPath:fromIndexPath withSections:_sections];
    [self insertCell:cell forIndexPath:toIndexPath withSections:_sections];
    
    [self.judInstance.componentManager _addUITask:^{
        [self removeCellForIndexPath:fromIndexPath withSections:_completedSections];
        [self insertCell:cell forIndexPath:toIndexPath withSections:_completedSections];
        [UIView performWithoutAnimation:^{
            [_tableView beginUpdates];
            [_tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
            [self handleAppear];
            [_tableView endUpdates];
        }];
    }];
}

- (void)addStickyComponent:(JUDComponent *)sticky
{
    
}

- (void)removeStickyComponent:(JUDComponent *)sticky
{

}
#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JUDLogDebug(@"Did end displaying cell:%@, at index path:%@", cell, indexPath);
    NSArray *visibleIndexPaths = [tableView indexPathsForVisibleRows];
    if (![visibleIndexPaths containsObject:indexPath]) {
        if (cell.contentView.subviews.count > 0) {
            UIView *judCellView = [cell.contentView.subviews firstObject];
            // Must invoke synchronously otherwise it will remove the view just added.
            JUDCellComponent *cellComponent = (JUDCellComponent *)judCellView.jud_component;
            if (cellComponent.isRecycle) {
                [judCellView.jud_component _unloadViewWithReusing:YES];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JUDCellComponent *cell = [self cellForIndexPath:indexPath];
    return cell.calculatedFrame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    JUDHeaderComponent *header = ((JUDSection *)_completedSections[section]).header;
    if (header) {
        return header.calculatedFrame.size.height;
    } else {
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JUDHeaderComponent *header = ((JUDSection *)_completedSections[section]).header;
    JUDLogDebug(@"header view for section %ld:%@", (long)section, header.view);
    return header.view;
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _completedSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((JUDSection *)[_completedSections jud_safeObjectAtIndex:section]).rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JUDLogDebug(@"Getting cell at indexPath:%@", indexPath);
    static NSString *reuseIdentifier = @"JUDTableViewCell";
    
    UITableViewCell *cellView = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cellView) {
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cellView.backgroundColor = [UIColor clearColor];
    }
    
    JUDCellComponent *cell = [self cellForIndexPath:indexPath];
    
    if (!cell) {
        return cellView;
    }
    
    if (cell.view.superview == cellView.contentView) {
        return cellView;
    }
    
    for (UIView *view in cellView.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cellView.contentView addSubview:cell.view];
    
    JUDLogDebug(@"Created cell:%@ view:%@ cellView:%@ at indexPath:%@", cell.ref, cell.view, cellView, indexPath);
    return cellView;
}

#pragma mark - Load More Event

- (void)setLoadmoreretry:(NSUInteger)loadmoreretry
{
    if (loadmoreretry != self.loadmoreretry) {
        _previousLoadMoreRowNumber = 0;
    }
    
    [super setLoadmoreretry:loadmoreretry];
}

- (void)loadMore
{
    [super loadMore];
    
    _previousLoadMoreRowNumber = [self totalNumberOfRows];
}

- (BOOL)isNeedLoadMore
{
    BOOL superNeedLoadMore = [super isNeedLoadMore];
    return superNeedLoadMore && _previousLoadMoreRowNumber != [self totalNumberOfRows];
}

- (NSUInteger)totalNumberOfRows
{
    NSUInteger rowNumber = 0;
    NSUInteger sectionCount = [_tableView numberOfSections];
    for (int section = 0; section < sectionCount; section ++) {
        rowNumber += [_tableView numberOfRowsInSection:section];
    }
    
    return rowNumber;
}

- (void)resetLoadmore{
    [super resetLoadmore];
    _previousLoadMoreRowNumber=0;
}

#pragma mark Private

- (JUDCellComponent *)cellForIndexPath:(NSIndexPath *)indexPath
{
    JUDSection *section = [_completedSections jud_safeObjectAtIndex:indexPath.section];
    if (!section) {
        JUDLogError(@"No section found for num:%ld, completed sections:%ld", (long)indexPath.section, (unsigned long)_completedSections.count);
        return nil;
    }
    
    JUDCellComponent *cell = [section.rows jud_safeObjectAtIndex:indexPath.row];
    if (!cell) {
        JUDLogError(@"No cell found for num:%ld, completed rows:%ld", (long)indexPath.row, (unsigned long)section.rows.count);
        return nil;
    }
    
    return cell;
}

- (void)insertCell:(JUDCellComponent *)cell forIndexPath:(NSIndexPath *)indexPath withSections:(NSMutableArray *)sections
{
    JUDSection *section = [sections jud_safeObjectAtIndex:indexPath.section];
    JUDAssert(section, @"inserting cell at indexPath:%@ section has not been inserted to list before, sections:%@", indexPath, sections);
    JUDAssert(indexPath.row <= section.rows.count, @"inserting cell at indexPath:%@ outof range, sections:%@", indexPath, sections);
    [section.rows insertObject:cell atIndex:indexPath.row];
}

- (void)removeCellForIndexPath:(NSIndexPath *)indexPath withSections:(NSMutableArray *)sections
{
    JUDSection *section = [sections jud_safeObjectAtIndex:indexPath.section];
    JUDAssert(section, @"Removing cell at indexPath:%@ has not been inserted to cell list before, sections:%@", indexPath, sections);
    JUDAssert(indexPath.row < section.rows.count, @"Removing cell at indexPath:%@ outof range, sections:%@", indexPath, sections);
    [section.rows removeObjectAtIndex:indexPath.row];
}

- (NSIndexPath *)indexPathForCell:(JUDCellComponent *)cell sections:(NSMutableArray<JUDSection *> *)sections
{
    __block NSIndexPath *indexPath;
    [sections enumerateObjectsUsingBlock:^(JUDSection * _Nonnull section, NSUInteger sectionIndex, BOOL * _Nonnull sectionStop) {
        [section.rows enumerateObjectsUsingBlock:^(JUDCellComponent * _Nonnull row, NSUInteger rowIndex, BOOL * _Nonnull stop) {
            if (row == cell) {
                indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                *stop = YES;
                *sectionStop = YES;
            }
        }];
    }];
    
    return indexPath;
}

- (NSUInteger)indexForHeader:(JUDHeaderComponent *)header sections:(NSMutableArray<JUDSection *> *)sections
{
    __block NSUInteger index;
    [sections enumerateObjectsUsingBlock:^(JUDSection * _Nonnull section, NSUInteger sectionIndex, BOOL * _Nonnull stop) {
        if (section.header == header) {
            index = sectionIndex;
            *stop = YES;
        }
    }];
    
    return index;
}

- (NSIndexPath *)indexPathForSubIndex:(NSUInteger)index
{
    NSInteger section = 0;
    NSInteger row = -1;
    JUDComponent *firstComponent;
    for (int i = 0; i <= index; i++) {
        JUDComponent* component = [self.subcomponents jud_safeObjectAtIndex:i];
        if (!component) {
            continue;
        }
        if (([component isKindOfClass:[JUDHeaderComponent class]]
            || [component isKindOfClass:[JUDCellComponent class]])
            && !firstComponent) {
            firstComponent = component;
        }
        
        if (component != firstComponent && [component isKindOfClass:[JUDHeaderComponent class]]) {
            section ++;
            row = -1;
        }
        
        if ([component isKindOfClass:[JUDCellComponent class]]) {
            row ++;
        }
    }

    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)fixFlicker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // FIXME:(ง •̀_•́)ง┻━┻ Stupid scoll view, always reset content offset to zero by calling _adjustContentOffsetIfNecessary after insert cells.
        // So if you pull down list while list is rendering, the list will be flickering.
        // Demo:    
        // Have to hook _adjustContentOffsetIfNecessary here.
        // Any other more elegant way?
        NSString *a = @"ntOffsetIfNe";
        NSString *b = @"adjustConte";
        
        NSString *originSelector = [NSString stringWithFormat:@"_%@%@cessary", b, a];
        [[self class] jud_swizzle:[JUDTableView class] Method:NSSelectorFromString(originSelector) withMethod:@selector(fixedFlickerSelector)];
    });
}

- (void)fixedFlickerSelector
{
    // DO NOT delete this method.
}


@end
