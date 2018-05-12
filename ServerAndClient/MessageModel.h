//
//  MessageModel.h
//  ServerAndClient
//
//  Created by qianfeng on 14-9-4.
//  Copyright (c) 2014年 DevilHunter. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kMessageType)
{
    kConnectionType,//连接请求
    kBreakType,
    kChatMessageType,//普通聊天信息
    kChatUserListType,//客户端获得用户列表的信息
    kChatUserNameType,//客户端修改自己昵称的消息
       
};

@interface MessageModel : NSObject

@property (nonatomic,assign) kMessageType type;
@property (nonatomic,retain) NSMutableDictionary *dic;


@end
