/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponentManager.h"
#import "JUDComponent.h"
#import "JUDComponent_internal.h"
#import "JUDComponentFactory.h"
#import "JUDDefine.h"
#import "NSArray+Jud.h"
#import "JUDSDKInstance.h"
#import "JUDAssert.h"
#import "JUDUtility.h"
#import "JUDMonitor.h"
#import "JUDScrollerProtocol.h"
#import "JUDSDKManager.h"
#import "JUDSDKError.h"
#import "JUDInvocationConfig.h"

static NSThread *JUDComponentThread;

#define JUDAssertComponentExist(component)  JUDAssert(component, @"component not exists")

@implementation JUDComponentManager
{
    __weak JUDSDKInstance *_judInstance;
    BOOL _isValid;
    
    BOOL _stopRunning;
    NSUInteger _noTaskTickCount;
    
    // access only on component thread
    NSMapTable<NSString *, JUDComponent *> *_indexDict;
    NSMutableArray<dispatch_block_t> *_uiTaskQueue;
    
    JUDComponent *_rootComponent;
    NSMutableArray *_fixedComponents;
    
    css_node_t *_rootCSSNode;
    CADisplayLink *_displayLink;
}

+ (instancetype)sharedManager
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)initWithJudInstance:(id)judInstance
{
    if (self = [self init]) {
        _judInstance = judInstance;
        
        _indexDict = [NSMapTable strongToWeakObjectsMapTable];
        _fixedComponents = [NSMutableArray jud_mutableArrayUsingWeakReferences];
        _uiTaskQueue = [NSMutableArray array];
        _isValid = YES;
        [self _startDisplayLink];
    }
    
    return self;
}

- (void)dealloc
{
    free_css_node(_rootCSSNode);
    [NSMutableArray jud_releaseArray:_fixedComponents];
}

#pragma mark Thread Management

+ (NSThread *)componentThread
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JUDComponentThread = [[NSThread alloc] initWithTarget:[self sharedManager] selector:@selector(_runLoopThread) object:nil];
        [JUDComponentThread setName:JUD_COMPONENT_THREAD_NAME];
        if(JUD_SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            [JUDComponentThread setQualityOfService:[[NSThread mainThread] qualityOfService]];
        } else {
            [JUDComponentThread setThreadPriority:[[NSThread mainThread] threadPriority]];
        }
        
        [JUDComponentThread start];
    });
    
    return JUDComponentThread;
}

- (void)_runLoopThread
{
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    while (!_stopRunning) {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

+ (void)_performBlockOnComponentThread:(void (^)())block
{
    if([NSThread currentThread] == [self componentThread]){
        block();
    } else {
        [self performSelector:@selector(_performBlockOnComponentThread:)
                     onThread:JUDComponentThread
                   withObject:[block copy]
                waitUntilDone:NO];
    }
}

- (void)startComponentTasks
{
    [self _awakeDisplayLink];
}

- (void)rootViewFrameDidChange:(CGRect)frame
{
    JUDAssertComponentThread();
    
    if (_rootCSSNode) {
        [self _applyRootFrame:frame toRootCSSNode:_rootCSSNode];
        if (!_rootComponent.styles[@"width"]) {
            _rootComponent.cssNode->style.dimensions[CSS_WIDTH] = frame.size.width;
        }
        if (!_rootComponent.styles[@"height"]) {
            _rootComponent.cssNode->style.dimensions[CSS_HEIGHT] = frame.size.height;
        }
        [_rootComponent setNeedsLayout];
        [self startComponentTasks];
    }
}

- (void)_applyRootFrame:(CGRect)rootFrame toRootCSSNode:(css_node_t *)rootCSSNode
{
    _rootCSSNode->style.position[CSS_LEFT] = self.judInstance.frame.origin.x;
    _rootCSSNode->style.position[CSS_TOP] = self.judInstance.frame.origin.y;
    
    // if no instance width/height, use layout width/height, as Android's wrap_content
    _rootCSSNode->style.dimensions[CSS_WIDTH] = self.judInstance.frame.size.width ?: CSS_UNDEFINED;
    _rootCSSNode->style.dimensions[CSS_HEIGHT] =  self.judInstance.frame.size.height ?: CSS_UNDEFINED;
}

- (void)_addUITask:(void (^)())block
{
    [_uiTaskQueue addObject:block];
}

#pragma mark Component Tree Building

- (void)createRoot:(NSDictionary *)data
{
    JUDAssertComponentThread();
    JUDAssertParam(data);
    
    _rootComponent = [self _buildComponentForData:data];

    [self _initRootCSSNode];
    
    __weak typeof(self) weakSelf = self;
    [self _addUITask:^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.judInstance.rootView.jud_component = strongSelf->_rootComponent;
        [strongSelf.judInstance.rootView addSubview:strongSelf->_rootComponent.view];
    }];
}

static bool rootNodeIsDirty(void *context)
{
    JUDComponentManager *manager = (__bridge JUDComponentManager *)(context);
    return [manager->_rootComponent needsLayout];
}

static css_node_t * rootNodeGetChild(void *context, int i)
{
    JUDComponentManager *manager = (__bridge JUDComponentManager *)(context);
    if (i == 0) {
        return manager->_rootComponent.cssNode;
    } else if(manager->_fixedComponents.count > 0) {
        return ((JUDComponent *)((manager->_fixedComponents)[i-1])).cssNode;
    }
    
    return NULL;
}

- (void)addComponent:(NSDictionary *)componentData toSupercomponent:(NSString *)superRef atIndex:(NSInteger)index appendingInTree:(BOOL)appendingInTree
{
    JUDAssertComponentThread();
    JUDAssertParam(componentData);
    JUDAssertParam(superRef);
    
    JUDComponent *supercomponent = [_indexDict objectForKey:superRef];
    JUDAssertComponentExist(supercomponent);
    
    [self _recursivelyAddComponent:componentData toSupercomponent:supercomponent atIndex:index appendingInTree:appendingInTree];
}

- (void)_recursivelyAddComponent:(NSDictionary *)componentData toSupercomponent:(JUDComponent *)supercomponent atIndex:(NSInteger)index appendingInTree:(BOOL)appendingInTree
{
    JUDComponent *component = [self _buildComponentForData:componentData];
    
    index = (index == -1 ? supercomponent->_subcomponents.count : index);
    
    [supercomponent _insertSubcomponent:component atIndex:index];
    // use _lazyCreateView to forbid component like cell's view creating
    if(supercomponent && component && supercomponent->_lazyCreateView) {
        component->_lazyCreateView = YES;
    }
    
    [self _addUITask:^{
        [supercomponent insertSubview:component atIndex:index];
    }];

    NSArray *subcomponentsData = [componentData valueForKey:@"children"];
    
    BOOL appendTree = !appendingInTree && [component.attributes[@"append"] isEqualToString:@"tree"];
    // if ancestor is appending tree, child should not be laid out again even it is appending tree.
    for(NSDictionary *subcomponentData in subcomponentsData){
        [self _recursivelyAddComponent:subcomponentData toSupercomponent:component atIndex:-1 appendingInTree:appendTree || appendingInTree];
    }
    if (appendTree) {
        // If appending tree，force layout in case of too much tasks piling up in syncQueue
        [self _layoutAndSyncUI];
    }
}

- (void)moveComponent:(NSString *)ref toSuper:(NSString *)superRef atIndex:(NSInteger)index
{
    JUDAssertComponentThread();
    JUDAssertParam(ref);
    JUDAssertParam(superRef);
    
    JUDComponent *component = [_indexDict objectForKey:ref];
    JUDComponent *newSupercomponent = [_indexDict objectForKey:superRef];
    JUDAssertComponentExist(component);
    JUDAssertComponentExist(newSupercomponent);
    
    if (component.supercomponent == newSupercomponent && [newSupercomponent.subcomponents indexOfObject:component] < index) {
        // if the supercomponent moved to is the same as original supercomponent,
        // unify it into the index after removing.
        index--;
    }
    
    [component _moveToSupercomponent:newSupercomponent atIndex:index];
    
    [self _addUITask:^{
        [component moveToSuperview:newSupercomponent atIndex:index];
    }];
}

- (void)removeComponent:(NSString *)ref
{
    JUDAssertComponentThread();
    JUDAssertParam(ref);
    
    JUDComponent *component = [_indexDict objectForKey:ref];
    JUDAssertComponentExist(component);
    
    [component _removeFromSupercomponent];
    
    [_indexDict removeObjectForKey:ref];
    
    [self _addUITask:^{
        if (component.supercomponent) {
            [component.supercomponent willRemoveSubview:component];
        }
        [component removeFromSuperview];
    }];
    
    [self _checkFixedSubcomponentToRemove:component];
}

- (void)_checkFixedSubcomponentToRemove:(JUDComponent *)component
{
    for (JUDComponent *subcomponent in component.subcomponents) {
        if (subcomponent->_positionType == JUDPositionTypeFixed) {
             [self _addUITask:^{
                 [subcomponent removeFromSuperview];
             }];
        }
        
        [self _checkFixedSubcomponentToRemove:subcomponent];
    }
}

- (JUDComponent *)componentForRef:(NSString *)ref
{
    JUDAssertComponentThread();
    
    return [_indexDict objectForKey:ref];
}

- (JUDComponent *)componentForRoot
{
    return _rootComponent;
}

- (NSUInteger)numberOfComponents
{
    JUDAssertComponentThread();
    
    return _indexDict.count;
}

- (JUDComponent *)_buildComponentForData:(NSDictionary *)data
{
    NSString *ref = data[@"ref"];
    NSString *type = data[@"type"];
    NSDictionary *styles = data[@"style"];
    NSDictionary *attributes = data[@"attr"];
    NSArray *events = data[@"event"];
    
    Class clazz = [JUDComponentFactory classWithComponentName:type];
    JUDComponent *component = [[clazz alloc] initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:self.judInstance];
    JUDAssert(component, @"Component build failed for data:%@", data);
    
    [_indexDict setObject:component forKey:component.ref];
    [component readyToRender];// notify redyToRender event when init
    return component;
}

#pragma mark Reset
-(BOOL)isShouldReset:(id )value
{
    if([value isKindOfClass:[NSString class]]) {
        if(!value || [@"" isEqualToString:value]) {
            return YES;
        }
    }
    return NO;
}

-(void)filterStyles:(NSDictionary *)styles normalStyles:(NSMutableDictionary *)normalStyles resetStyles:(NSMutableArray *)resetStyles
{
    for (NSString *key in styles) {
        id value = [styles objectForKey:key];
        if([self isShouldReset:value]) {
            [resetStyles addObject:key];
        }else{
            [normalStyles setObject:styles[key] forKey:key];
        }
    }
}

- (void)updateStyles:(NSDictionary *)styles forComponent:(NSString *)ref
{
    [self handleStyles:styles forComponent:ref isUpdateStyles:YES];
}

- (void)updatePseudoClassStyles:(NSDictionary *)styles forComponent:(NSString *)ref
{
    [self handleStyles:styles forComponent:ref isUpdateStyles:NO];
}

- (void)handleStyles:(NSDictionary *)styles forComponent:(NSString *)ref isUpdateStyles:(BOOL)isUpdateStyles
{
    JUDAssertParam(styles);
    JUDAssertParam(ref);
    
    JUDComponent *component = [_indexDict objectForKey:ref];
    JUDAssertComponentExist(component);
    
    NSMutableDictionary *normalStyles = [NSMutableDictionary new];
    NSMutableArray *resetStyles = [NSMutableArray new];
    [self filterStyles:styles normalStyles:normalStyles resetStyles:resetStyles];
    [component _updateStylesOnComponentThread:normalStyles resetStyles:resetStyles isUpdateStyles:isUpdateStyles];
    [self _addUITask:^{
        [component _updateStylesOnMainThread:normalStyles resetStyles:resetStyles];
        [component readyToRender];
    }];
}

- (void)updateAttributes:(NSDictionary *)attributes forComponent:(NSString *)ref
{
    JUDAssertParam(attributes);
    JUDAssertParam(ref);
    
    JUDComponent *component = [_indexDict objectForKey:ref];
    JUDAssertComponentExist(component);
    
    [component _updateAttributesOnComponentThread:attributes];
    [self _addUITask:^{
        [component _updateAttributesOnMainThread:attributes];
        [component readyToRender];
    }];
}

- (void)addEvent:(NSString *)eventName toComponent:(NSString *)ref
{
    JUDAssertComponentThread();
    JUDAssertParam(eventName);
    JUDAssertParam(ref);
    
    JUDComponent *component = [_indexDict objectForKey:ref];
    JUDAssertComponentExist(component);
    
    [component _addEventOnComponentThread:eventName];
    
    [self _addUITask:^{
        [component _addEventOnMainThread:eventName];
    }];
}

- (void)removeEvent:(NSString *)eventName fromComponent:(NSString *)ref
{
    JUDAssertComponentThread();
    JUDAssertParam(eventName);
    JUDAssertParam(ref);
    
    JUDComponent *component = [_indexDict objectForKey:ref];
    JUDAssertComponentExist(component);
    
    [component _removeEventOnComponentThread:eventName];
    
    [self _addUITask:^{
        [component _removeEventOnMainThread:eventName];
    }];
}

- (void)scrollToComponent:(NSString *)ref options:(NSDictionary *)options
{
    JUDAssertComponentThread();
    JUDAssertParam(ref);
    
    JUDComponent *toComponent = [_indexDict objectForKey:ref];
    JUDAssertComponentExist(toComponent);

    id<JUDScrollerProtocol> scrollerComponent = toComponent.ancestorScroller;
    if (!scrollerComponent) {
        return;
    }

    CGFloat offset = [[options objectForKey:@"offset"] floatValue];
    BOOL animated = YES;
    if ([options objectForKey:@"animated"]) {
        animated = [[options objectForKey:@"animated"] boolValue];
    }
    
    [self _addUITask:^{
        [scrollerComponent scrollToComponent:toComponent withOffset:offset animated:animated];
    }];
}

#pragma mark Life Cycle

- (void)createFinish
{
    JUDAssertComponentThread();
    
    JUDSDKInstance *instance  = self.judInstance;
    [self _addUITask:^{        
        UIView *rootView = instance.rootView;
        
        JUD_MONITOR_INSTANCE_PERF_END(JUDPTFirstScreenRender, instance);
        JUD_MONITOR_INSTANCE_PERF_END(JUDPTAllRender, instance);
        JUD_MONITOR_SUCCESS(JUDMTJSBridge);
        JUD_MONITOR_SUCCESS(JUDMTNativeRender);
        
        if(instance.renderFinish){
            instance.renderFinish(rootView);
        }
    }];
}

- (void)updateFinish
{
    JUDAssertComponentThread();
    
    JUDSDKInstance *instance = self.judInstance;
    JUDComponent *root = [_indexDict objectForKey:JUD_SDK_ROOT_REF];
    
    [self _addUITask:^{
        if(instance.updateFinish){
            instance.updateFinish(root.view);
        }
    }];
}

- (void)refreshFinish
{
    JUDAssertComponentThread();
    
    JUDSDKInstance *instance = self.judInstance;
    JUDComponent *root = [_indexDict objectForKey:JUD_SDK_ROOT_REF];
    
    [self _addUITask:^{
        if(instance.refreshFinish){
            instance.refreshFinish(root.view);
        }
    }];
}

- (void)unload
{
    JUDAssertComponentThread();
    
    NSEnumerator *enumerator = [_indexDict objectEnumerator];
    JUDComponent *component;
    while ((component = [enumerator nextObject])) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [component _unloadViewWithReusing:NO];
        });
    }
    
    [_indexDict removeAllObjects];
    [_uiTaskQueue removeAllObjects];

    dispatch_async(dispatch_get_main_queue(), ^{
         _rootComponent = nil;
    });
    
    [self _stopDisplayLink];
    
    _isValid = NO;
}

- (BOOL)isValid
{
    return _isValid;
}

#pragma mark Layout Batch

- (void)_startDisplayLink
{
    JUDAssertComponentThread();
    
    if(!_displayLink){
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_handleDisplayLink)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)_stopDisplayLink
{
    JUDAssertComponentThread();
    
    if(_displayLink){
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)_suspendDisplayLink
{
    JUDAssertComponentThread();
    
    if(_displayLink && !_displayLink.paused) {
        _displayLink.paused = YES;
    }
}

- (void)_awakeDisplayLink
{
    JUDAssertComponentThread();
    
    if(_displayLink && _displayLink.paused) {
        _displayLink.paused = NO;
    }
}

- (void)_handleDisplayLink
{
    JUDAssertComponentThread();
    
    [self _layoutAndSyncUI];
}

- (void)_layoutAndSyncUI
{
    [self _layout];
    if(_uiTaskQueue.count > 0){
        [self _syncUITasks];
        _noTaskTickCount = 0;
    } else {
        // suspend display link when there's no task for 1 second, in order to save CPU time.
        _noTaskTickCount ++;
        if (_noTaskTickCount > 60) {
            [self _suspendDisplayLink];
        }
    }
}

- (void)_layout
{
    BOOL needsLayout = NO;

    NSEnumerator *enumerator = [_indexDict objectEnumerator];
    JUDComponent *component;
    while ((component = [enumerator nextObject])) {
        if ([component needsLayout]) {
            needsLayout = YES;
            break;
        }
    }

    if (!needsLayout) {
        return;
    }
    
    layoutNode(_rootCSSNode, _rootCSSNode->style.dimensions[CSS_WIDTH], _rootCSSNode->style.dimensions[CSS_HEIGHT], CSS_DIRECTION_INHERIT);
    
    if ([_rootComponent needsLayout]) {
        if ([JUDLog logLevel] >= JUDLogLevelDebug) {
            print_css_node(_rootCSSNode, CSS_PRINT_LAYOUT | CSS_PRINT_STYLE | CSS_PRINT_CHILDREN);
        }
    }
    
    NSMutableSet<JUDComponent *> *dirtyComponents = [NSMutableSet set];
    [_rootComponent _calculateFrameWithSuperAbsolutePosition:CGPointZero gatherDirtyComponents:dirtyComponents];
    [self _calculateRootFrame];
  
    for (JUDComponent *dirtyComponent in dirtyComponents) {
        [self _addUITask:^{
            [dirtyComponent _layoutDidFinish];
        }];
    }
}

- (void)_syncUITasks
{
    NSArray<dispatch_block_t> *blocks = _uiTaskQueue;
    _uiTaskQueue = [NSMutableArray array];
    dispatch_async(dispatch_get_main_queue(), ^{
        for(dispatch_block_t block in blocks) {
            block();
        }
    });
}

- (void)_initRootCSSNode
{
    _rootCSSNode = new_css_node();
    
    [self _applyRootFrame:self.judInstance.frame toRootCSSNode:_rootCSSNode];
    
    _rootCSSNode->style.flex_wrap = CSS_NOWRAP;
    _rootCSSNode->is_dirty = rootNodeIsDirty;
    _rootCSSNode->get_child = rootNodeGetChild;
    _rootCSSNode->context = (__bridge void *)(self);
    _rootCSSNode->children_count = 1;
}

- (void)_calculateRootFrame
{
    if (!_rootCSSNode->layout.should_update) {
        return;
    }
    _rootCSSNode->layout.should_update = false;
    
    CGRect frame = CGRectMake(JUDRoundPixelValue(_rootCSSNode->layout.position[CSS_LEFT]),
                              JUDRoundPixelValue(_rootCSSNode->layout.position[CSS_TOP]),
                              JUDRoundPixelValue(_rootCSSNode->layout.dimensions[CSS_WIDTH]),
                              JUDRoundPixelValue(_rootCSSNode->layout.dimensions[CSS_HEIGHT]));
    JUDPerformBlockOnMainThread(^{
        if(!self.judInstance.isRootViewFrozen) {
            self.judInstance.rootView.frame = frame;
        }
    });
    
    resetNodeLayout(_rootCSSNode);
}


#pragma mark Fixed 

- (void)addFixedComponent:(JUDComponent *)fixComponent
{
    [_fixedComponents addObject:fixComponent];
    _rootCSSNode->children_count = (int)[_fixedComponents count] + 1;
}

- (void)removeFixedComponent:(JUDComponent *)fixComponent
{
    [_fixedComponents removeObject:fixComponent];
    _rootCSSNode->children_count = (int)[_fixedComponents count] + 1;
}

@end

void JUDPerformBlockOnComponentThread(void (^block)())
{
    [JUDComponentManager _performBlockOnComponentThread:block];
}
