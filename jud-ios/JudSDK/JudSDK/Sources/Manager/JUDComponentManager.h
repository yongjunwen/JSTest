/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

@class JUDBridgeMethod;
@class JUDSDKInstance;
@class JUDComponent;

extern void JUDPerformBlockOnComponentThread(void (^block)());


@interface JUDComponentManager : NSObject

@property (nonatomic, readonly, weak) JUDSDKInstance *judInstance;
@property (nonatomic, readonly, assign) BOOL isValid;

/**
 * @abstract initialize with jud instance
 **/
- (instancetype)initWithJudInstance:(JUDSDKInstance *)judInstance;

/**
 * @abstract return the component thread
 **/
+ (NSThread *)componentThread;

/**
 * @abstract starting component tasks
 **/
- (void)startComponentTasks;

/**
 * @abstract tell the component manager that instance root view's frame has been changed
 **/
- (void)rootViewFrameDidChange:(CGRect)frame;

///--------------------------------------
/// @name Component Tree Building
///--------------------------------------

/**
 * @abstract create root of component tree
 **/
- (void)createRoot:(NSDictionary *)data;

/**
 * @abstract add component
 **/
- (void)addComponent:(NSDictionary *)componentData toSupercomponent:(NSString *)superRef atIndex:(NSInteger)index appendingInTree:(BOOL)appendingInTree;

/**
 * @abstract remove component
 **/
- (void)removeComponent:(NSString *)ref;

/**
 * @abstract move component
 **/
- (void)moveComponent:(NSString *)ref toSuper:(NSString *)superRef atIndex:(NSInteger)index;

/**
 * @abstract return component for specific ref, must be called on component thread by calling JUDPerformBlockOnComponentThread
 */
- (JUDComponent *)componentForRef:(NSString *)ref;

/**
 * @abstract return root component
 */
- (JUDComponent *)componentForRoot;

/**
 * @abstract number of components created, must be called on component thread by calling JUDPerformBlockOnComponentThread
 */
- (NSUInteger)numberOfComponents;


///--------------------------------------
/// @name Updating
///--------------------------------------

/**
 * @abstract update styles
 **/
- (void)updateStyles:(NSDictionary *)styles forComponent:(NSString *)ref;

///--------------------------------------
/// @name Updating pseudo class
///--------------------------------------

/**
 * @abstract update  pseudo class styles
 **/

- (void)updatePseudoClassStyles:(NSDictionary *)styles forComponent:(NSString *)ref;

/**
 * @abstract update attributes
 **/
- (void)updateAttributes:(NSDictionary *)attributes forComponent:(NSString *)ref;

/**
 * @abstract add event
 **/
- (void)addEvent:(NSString *)event toComponent:(NSString *)ref;

/**
 * @abstract remove event
 **/
- (void)removeEvent:(NSString *)event fromComponent:(NSString *)ref;

/**
 * @abstract scroll to specific component
 **/
- (void)scrollToComponent:(NSString *)ref options:(NSDictionary *)options;

///--------------------------------------
/// @name Life Cycle
///--------------------------------------

/**
 * @abstract called when all doms are created
 **/
- (void)createFinish;

/**
 * @abstract called when all doms are refreshed
 **/
- (void)refreshFinish;

/**
 * @abstract called when all doms are updated
 **/
- (void)updateFinish;

/**
 * @abstract unload
 **/
- (void)unload;


///--------------------------------------
/// @name Fixed
///--------------------------------------

/**
 *  @abstract add a component which has a fixed position
 *
 *  @param fixComponent the fixed component to add
 */
- (void)addFixedComponent:(JUDComponent *)fixComponent;

/**
 *  @abstract remove a component which has a fixed position
 *
 *  @param fixComponent the fixed component to remove
 */
- (void)removeFixedComponent:(JUDComponent *)fixComponent;

- (void)_addUITask:(void (^)())block;


@end
