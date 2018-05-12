//
//  SocketManager.h
//  ServerAndClient
//
//  Created by qianfeng on 14-9-2.
//  Copyright (c) 2014年 DevilHunter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "MessageModel.h"

typedef NS_ENUM(NSInteger, kTransTag)
{

    kNewReadTag = 300,
    kReceiveTag = 400,
    //以上是连接服务器和发送普通消息的连接
    kChatListReadTag = 500,
    kChatListReceiveTag = 600,
    //以上是获取用户列表的连接
    
    kReadAgainTag,
    kReadContinueTag,

};


@interface SocketManager : NSObject
<AsyncSocketDelegate>

{
    AsyncSocket *serverSock;
    
    //客户端页面的数组
    NSMutableArray **clientArray;
    UITableView **clientTableView;
}
+ (SocketManager *)sharedManager;
- (id)init;
//! @brief 该方法处理客户端向服务器发送的请求,加工请求用来修改客户端页面的数组以及刷新表格
- (void)disposeRequestFromHost:(NSString *)host withType:(kMessageType)type onPort:(UInt16)port data:(NSData *)data clientArray:(NSMutableArray **)cArray clientTableView:(UITableView **)cTableView;
@end
