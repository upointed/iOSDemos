//
//  ChooseViewController.h
//  ServerAndClient
//
//  Created by qianfeng on 14-9-2.
//  Copyright (c) 2014年 DevilHunter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerViewController;
@class ClientViewController;
@interface ChooseViewController : UIViewController
<UITextFieldDelegate>
{
    UITextField *mTextField;
    
    ServerViewController *servervc;
    ClientViewController *clientvc;
}
@end
