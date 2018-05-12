//
//  GMHRequestCache.m
//  GomeHigo
//
//  Created by liuda on 16/10/25.
//  Copyright © 2016年 gomehigo. All rights reserved.
//

#import "GMHRequestCache.h"
#import <YYCache.h>

@implementation GMHRequestCache
static NSString *const NetworkResponseCache = @"NetworkResponseCache";
static YYCache *_dataCache;
+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

+ (void)saveResponseCache:(id)responseCache forKey:(NSString *)key
{
    //异步缓存,不会阻塞主线程
    [_dataCache setObject:responseCache forKey:key withBlock:nil];
}

+ (id)getResponseCacheForKey:(NSString *)key
{
    return [_dataCache objectForKey:key];
}

@end
