/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDDisplayQueue.h"

#define MAX_CONCURRENT_COUNT 8

static dispatch_semaphore_t JUDDisplayConcurrentSemaphore;

@implementation JUDDisplayQueue

+ (dispatch_queue_t)displayQueue
{
    static dispatch_queue_t displayQueue = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        displayQueue = dispatch_queue_create("com.jingdong.jud.displayQueue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_set_target_queue(displayQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    });
    
    return displayQueue;
}

+ (void)addBlock:(void(^)())block
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUInteger processorCount = [NSProcessInfo processInfo].activeProcessorCount;
        NSUInteger maxConcurrentCount = processorCount <= MAX_CONCURRENT_COUNT ? processorCount : MAX_CONCURRENT_COUNT;
        JUDDisplayConcurrentSemaphore = dispatch_semaphore_create(maxConcurrentCount);
    });
    
    dispatch_async([self displayQueue], ^{
        dispatch_semaphore_wait(JUDDisplayConcurrentSemaphore, DISPATCH_TIME_FOREVER);
        block();
        dispatch_semaphore_signal(JUDDisplayConcurrentSemaphore);
    });
}

@end
