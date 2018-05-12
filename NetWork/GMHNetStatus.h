//
//  GMHNetStatus.h
//  GomeHigo
//
//  Created by liuda on 17/1/4.
//  Copyright © 2017年 gomehigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"

@interface GMHNetStatus : NSObject
@property (assign, nonatomic) AFNetworkReachabilityStatus netClientStatus;

+ (instancetype)shareNetStatus;
@end
