//
//  SocketManager.m
//  ServerAndClient
//
//  Created by qianfeng on 14-9-2.
//  Copyright (c) 2014年 DevilHunter. All rights reserved.
//

#import "SocketManager.h"
#import "NSObject+DHF.h"

@implementation SocketManager

+ (SocketManager *)sharedManager
{
    static SocketManager *manager;
    if (!manager)
    {
        manager = [[SocketManager alloc] init];
    }
    return manager;
}

- (id)init
{
    if (self = [super init])
    {
        serverSock = [[AsyncSocket alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    serverSock = nil;
    [super dealloc];
}


//前四个参数是要传入的值,后两个参数是要传出的值
- (void)disposeRequestFromHost:(NSString *)host withType:(kMessageType)type onPort:(UInt16)port data:(NSData *)data clientArray:(NSMutableArray **)cArray clientTableView:(UITableView **)cTableView
{
    //为引用赋值
    clientArray = cArray;
    clientTableView = cTableView;
    
    switch (type) {
        case kConnectionType:
        {
            if (![serverSock isConnected])
            {
                [serverSock connectToHost:host onPort:port error:nil];
            }
        }
            break;
        case kBreakType:
        {
            if ([serverSock isConnected])
            {
                [serverSock disconnect];
                NSLog(@"与服务器断开连接!");
            }
        }
            break;
        case kChatMessageType:
        {
            if ([serverSock isConnected])
            {
                //向服务器写
                [serverSock writeData:data withTimeout:-1 tag:kReceiveTag];
                //读取回复
                [serverSock readDataWithTimeout:-1 tag:kNewReadTag];
                
            }
        }
            break;
        case kChatUserListType:
        {
            if ([serverSock isConnected]) {
                [serverSock writeData:data withTimeout:-1 tag:kChatListReadTag];
                [serverSock readDataWithTimeout:-1 tag:kChatListReceiveTag];
            }
        }
            break;
        case kChatUserNameType:
        {
            
        }
            break;
        default:
            NSLog(@"本地请求错误!");
            break;
    }
}
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    
}

#pragma mark -

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"已经连接到服务器:%@",[sock connectedHost]);
    //再次读取数据
    [sock readDataWithTimeout:-1 tag:kReadAgainTag];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString * msg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"服务器回复:%@",msg);
    
    //服务器返回的数据转成数组,里面包含有用户信息的字典
    NSArray *userArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //如果收到的数据是数组
    if ([userArray isKindOfClass:[NSArray class]])
    {
        //表格清除旧数据
        [*clientArray removeAllObjects];
        //解析用户列表
        for (NSDictionary *dic in userArray)
        {
            MessageModel *message = [[MessageModel alloc] init];
            [message propertyList:YES];
            [*clientArray addObject:message];
        }
        [*clientTableView reloadData];
    }
    //再次读取数据
    [sock readDataWithTimeout:-1 tag:kReadAgainTag];
}
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"已发送!");
}
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    
}
@end













