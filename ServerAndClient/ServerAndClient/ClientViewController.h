//
//  ClientViewController.h
//  ServerAndClient
//
//  Created by qianfeng on 14-9-2.
//  Copyright (c) 2014年 DevilHunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"


@interface ClientViewController : UIViewController
{
    //与服务器通信的对象
    AsyncSocket *serverSocket;
    //监听别的主机的对象
    AsyncSocket *listenSocket;
}
@end








