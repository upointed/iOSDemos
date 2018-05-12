//
//  GMHNetworkManager.h
//  GomeHigo
//
//  Created by liuda on 17/1/3.
//  Copyright © 2017年 gomehigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 @author 刘达, 17-01-03
 
 @brief  根据网络状态枚举获取相应地字符串
 
 @param networkStatus 网络状态枚举类型
 
 @return 网络状态字符串
 
 @since 4.1.1
 */
static inline NSString *strNetworkStatus(GMHNetworkStatus networkStatus)
{
    NSString *strResult = @"";
    switch (networkStatus)
    {
        case NotReachable:
            strResult = @"NotReachable";
            break;
            
        case ReachableViaWiFi:
            strResult = @"WIFI";
            break;
            
        case ReachableViaWWAN:
            strResult = @"WWAN";
            break;
            
        case ReachableVia4G:
            strResult = @"4G";
            break;
            
        case ReachableVia3G:
            strResult = @"3G";
            break;
            
        case ReachableVia2G:
            strResult = @"2G";
            break;
            
        default:
            break;
    }
    
    return strResult;
}

/*!
 @author 刘达, 17-01-03
 
 @brief  网络状态监测类
 
 @since 4.1.1
 */
@interface GMHNetworkManager : NSObject

/*!
 @author 刘达, 17-01-03
 
 @brief  GMCNetworkManager 单例
 
 @since 4.1.1
 */
+ (GMHNetworkManager *)shareManager;

/*!
 @author 刘达, 17-01-03
 
 @brief  开始监测网络状态
 
 @since 4.1.1
 */
- (void)startReachNotifier;

/*!
 @author 刘达, 17-01-03
 
 @brief  获取当前网络的类型状态
 
 @return 当前网络状态NetworkStatus的枚举
 
 @since 4.1.1
 */
- (GMHNetworkStatus)networkStatus;

/*!
 @author 刘达, 17-01-03
 
 @brief  判断当前是否有网络连接
 
 @return 是否有网络连接bool值
 
 @since 4.1.1
 */
- (BOOL)isConneted;

///  刘达, 17-01-03   添加监听网络注册
- (void)addMonitorNetworkChangeObserver:(nonnull NSObject *)observer action:(nonnull SEL)action;

/// 刘达, 17-01-03 添加删除注册的网络监听
- (void)removeMonitorNetworkChangeObserver:(nonnull NSObject *)observer;

@end
NS_ASSUME_NONNULL_END
