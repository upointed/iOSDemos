//
//  GMHNetStatus.m
//  GomeHigo
//
//  Created by liuda on 17/1/4.
//  Copyright © 2017年 gomehigo. All rights reserved.
//

#import "GMHNetStatus.h"

@implementation GMHNetStatus
+ (instancetype)shareNetStatus
{
    static GMHNetStatus * info = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        info = [[self alloc] init];
    });
    
    return info;
}
@end
