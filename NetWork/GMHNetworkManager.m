//
//  GMHNetworkManager.m
//  GomeHigo
//
//  Created by liuda on 17/1/3.
//  Copyright © 2017年 gomehigo. All rights reserved.
//

#import "GMHNetworkManager.h"
#import "Reachability.h"
@interface GMHNetworkManager ()

/// 被监测的Reachability实例变量
@property (nonatomic, strong) Reachability *reachHost;

/// 是否有网络连接
@property (nonatomic, assign) BOOL isNetConnected;

/// 当前网络状态
@property (nonatomic, assign) GMHNetworkStatus networkStatus;

/// 记录变化之前上一次的网络状态
//@property (nonatomic, assign) NetworkStatus lastNetworkStatus;


@end


@implementation GMHNetworkManager

/// 单例
+ (GMHNetworkManager *)shareManager
{
    static GMHNetworkManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      manager = [[GMHNetworkManager alloc] init];
                  });
    
    return manager;
}

- (id)init
{
    if (self = [super init])
    {
        /// 初始化Reachability变量
        _reachHost = [Reachability reachabilityForInternetConnection];
        
        /// 初始化网络状态
        _networkStatus = [_reachHost currentReachabilityStatus];
        
        [GMHAppTool shared].strNetType = strNetworkStatus(_networkStatus);
        //        _lastNetworkStatus = _networkStatus;
        
        /// 初始化是否联网状态
        _isNetConnected = ([_reachHost currentReachabilityStatus] != NotReachable) ? YES : NO;
    }
    
    return self;
}

- (void)dealloc
{
    /// 停止监测
    [_reachHost stopNotifier];
    
    /// 移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
   
}

- (void)startReachNotifier
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gmn_ReachNotication:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    /// 开始监测网络状态变化
    [_reachHost startNotifier];
}


- (void)gmn_ReachNotication:(NSNotification *)notiReach
{
    Reachability *reachCurrent = [notiReach object];
    if (![reachCurrent isKindOfClass: [Reachability class]])
    {
        return;
    }
    //    NSParameterAssert([reachCurrent isKindOfClass: [Reachability class]]);
    
    /// 获取当前状态
    GMHNetworkStatus status = [reachCurrent currentReachabilityStatus];
    _networkStatus = status;
    
    /// 判断是否连接
    _isNetConnected = (status == NotReachable) ? NO : YES;
    
    /// TODO:这里修改GMBAppInfo单例中的strNetType为当前网络状态字符串
    [GMHAppTool shared].strNetType = strNetworkStatus(_networkStatus);
    
   
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kReachabilityChangedNotificationNoticeToTarget"
                                                        object:[NSNumber numberWithInteger:_networkStatus]];
    
    
   
}

- (GMHNetworkStatus)currentNetworkStatus
{
    return _networkStatus;
}

- (BOOL)isConneted
{
    return _isNetConnected;
}

- (void)addMonitorNetworkChangeObserver:(nonnull NSObject *)observer action:(nonnull SEL)action
{
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:action
                                                 name:@"kReachabilityChangedNotificationNoticeToTarget"
                                               object:nil];
}

- (void)removeMonitorNetworkChangeObserver:(nonnull NSObject *)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end

