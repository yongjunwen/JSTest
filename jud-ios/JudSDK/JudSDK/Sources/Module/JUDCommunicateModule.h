//
//  JUDCommunicateModule.h
//  Pods
//
//  Created by Leo on 2017/6/2.
//
//

#import <Foundation/Foundation.h>
#import "JUDModuleProtocol.h"

#define JUDCommunicatePrefix(name) \
[NSString stringWithFormat:@"JUDCommunicate_%@", name]

#define JUDCommunicateListenPrefix(name) \
[NSString stringWithFormat:@"JUDCommunicateListenPrefix_%@", name]

/**
 JS和本地相互进行通信模块
 */
@interface JUDCommunicateModule : NSObject<JUDModuleProtocol>

@end
