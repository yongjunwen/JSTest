/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "JUDComponent.h"
@class JUDResourceRequest;

extern NSString *const bundleUrlOptionKey;

@interface JUDSDKInstance : NSObject

/**
 * The viewControler which the jud bundle is rendered in.
 **/
@property (nonatomic, weak) UIViewController *viewController;

/**
 * The Native root container used to bear the view rendered by jud file. 
 * The root view is controlled by JUDSDKInstance, so you can only get it, but not change it.
 **/
@property (nonatomic, strong) UIView *rootView;

/**
 * Component can freeze the rootview frame through the variable isRootViewFrozen
 * If Component want to freeze the rootview frame, set isRootViewFrozen YES, jud will not change the rootview frame when layout,or set NO.
 **/
@property (nonatomic, assign) BOOL isRootViewFrozen;

/**
 * The scriptURL of jud bundle.
 **/
@property (nonatomic, strong) NSURL *scriptURL;

/**
 * The parent instance.
 **/
@property (nonatomic, weak) JUDSDKInstance *parentInstance;

/**
 * The node reference of parent instance.
 **/
@property (nonatomic, weak) NSString *parentNodeRef;

/**
 * The unique id to identify current jud instance.
 **/
@property (nonatomic, strong) NSString *instanceId;

/**
 * The state of current instance.
 **/
typedef NS_ENUM(NSInteger, JUDState) {//state.code
    JudInstanceAppear = 100,
    JudInstanceDisappear,
    JudInstanceForeground,
    JudInstanceBackground,
    JudInstanceMemoryWarning,
    JudInstanceBindChanged,
    JudInstanceDestroy
};


typedef NS_ENUM(NSInteger, JUDErrorType) {//error.domain
    TemplateErrorType = 1,
};

typedef NS_ENUM(NSInteger, JUDErrorCode) {//error.code
    PlatformErrorCode = 1000,
    OSVersionErrorCode,
    AppVersionErrorCode,
    JudSDKVersionErrorCode,
    DeviceModelErrorCode,
    FrameworkVersionErrorCode,
};


@property (nonatomic, assign) JUDState state;

/**
 *  The callback triggered when the instance finishes creating the body.
 *
 *  @return A block that takes a UIView argument, which is the root view
 **/
@property (nonatomic, copy) void (^onCreate)(UIView *);

/**
 *  The callback triggered when the root container's frame has changed.
 *
 *  @return A block that takes a UIView argument, which is the root view
 **/
@property (nonatomic, copy) void (^onLayoutChange)(UIView *);

/**
 *  The callback triggered when the instance finishes rendering.
 *
 *  @return A block that takes a UIView argument, which is the root view
 **/
@property (nonatomic, copy) void (^renderFinish)(UIView *);

/**
 *  The callback triggered when the instance finishes refreshing jud view.
 *
 *  @return A block that takes a UIView argument, which is the root view
 **/
@property (nonatomic, copy) void (^refreshFinish)(UIView *);

/**
 *  The callback triggered when the instance fails to render.
 *
 *  @return A block that takes a NSError argument, which is the error occured
 **/
@property (nonatomic, copy) void (^onFailed)(NSError *error);

/**
 *  The callback triggered when the instacne executes scrolling .
 *
 *  @return A block that takes a CGPoint argument, which is content offset of the scroller
 **/
@property (nonatomic, copy) void (^onScroll)(CGPoint contentOffset);

/**
 * the callback to be run repeatedly while the instance is rendering.
 *
 * @return A block that takes a CGRect argument, which is the rect rendered
 **/
@property (nonatomic, copy) void (^onRenderProgress)(CGRect renderRect);

/**
 *  the frame of current instance.
 **/
@property (nonatomic, assign) CGRect frame;

/**
 *  the info stored by user.
 */
@property (nonatomic, strong) NSMutableDictionary *userInfo;

/**
 *  scale factor from css unit to device pixel.
 */
@property (nonatomic, assign, readonly) CGFloat pixelScaleFactor;

/**
 * track component render
 */
@property (nonatomic, assign)BOOL trackComponent;
/**
 * Renders jud view with bundle url.
 *
 * @param url The url of bundle rendered to a jud view.
 **/
- (void)renderWithURL:(NSURL *)url;

/**
 * Renders jud view with bundle url and some others.
 *
 * @param url The url of bundle rendered to a jud view.
 *
 * @param options The params passed by user
 *
 * @param data The data the bundle needs when rendered.  Defalut is nil.
 **/
- (void)renderWithURL:(NSURL *)url options:(NSDictionary *)options data:(id)data;

///**
// * Renders jud view with resource request.
// *
// * @param request The resource request specifying the URL to render with.
// *
// * @param options The params passed by user.
// *
// * @param data The data the bundle needs when rendered.  Defalut is nil.
// **/
//- (void)renderWithRequest:(JUDResourceRequest *)request options:(NSDictionary *)options data:(id)data;

/**
 * Renders jud view with source string of bundle and some others.
 *
 * @param options The params passed by user.
 *
 * @param data The data the bundle needs when rendered. Defalut is nil.
 **/
- (void)renderView:(NSString *)source options:(NSDictionary *)options data:(id)data;

/**
 * Reload the js bundle from the current URL and rerender.
 *
 * @param forcedReload when this parameter is true, the js bundle will always be reloaded from the server. If it is false, the instance may reload the js bundle from its cache. Default is false.
 *
 **/
- (void)reload:(BOOL)forcedReload;

/**
 * Refreshes current instance with data.
 *
 * @param data The data the bundle needs when rendered.
 **/
- (void)refreshInstance:(id)data;

/**
 * Destroys current instance.
 **/
- (void)destroyInstance;

/**
 * Trigger full GC, for dev and debug only.
 **/
- (void)forceGarbageCollection;

/**
 * get module instance by class
 */
- (id)moduleForClass:(Class)moduleClass;

/**
 * get Component instance by ref, must be called on component thread by calling JUDPerformBlockOnComponentThread
 */
- (JUDComponent *)componentForRef:(NSString *)ref;

/**
 * Number of components created, must be called on component thread by calling JUDPerformBlockOnComponentThread
 */
- (NSUInteger)numberOfComponents;


/**
 * check whether the module eventName is registered
 */
- (BOOL)checkModuleEventRegistered:(NSString*)event moduleClassName:(NSString*)moduleClassName;

/**
 * fire module event;
 */
- (void)fireModuleEvent:(Class)module eventName:(NSString *)eventName params:(NSDictionary*)params;

/**
 * fire global event
 */
- (void)fireGlobalEvent:(NSString *)eventName params:(NSDictionary *)params;

/**
 * complete url based with bundle url
 */
- (NSURL *)completeURL:(NSString *)url;

/**
 * application performance statistics
 */
@property (nonatomic, strong) NSString *bizType;
@property (nonatomic, strong) NSString *pageName;
@property (nonatomic, weak) id pageObject;
@property (nonatomic, strong) NSMutableDictionary *performanceDict;


/** 
 * Deprecated 
 */
@property (nonatomic, strong) NSDictionary *properties DEPRECATED_MSG_ATTRIBUTE();
@property (nonatomic, assign) NSTimeInterval networkTime DEPRECATED_MSG_ATTRIBUTE();
@property (nonatomic, copy) void (^updateFinish)(UIView *);

@end

@interface JUDSDKInstance (Deprecated)

- (void)finishPerformance DEPRECATED_MSG_ATTRIBUTE();
- (void)reloadData:(id)data  DEPRECATED_MSG_ATTRIBUTE("Use refreshInstance: method instead.");
- (void)creatFinish DEPRECATED_MSG_ATTRIBUTE();

@end
