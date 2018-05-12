//
//  ChooseViewController.m
//  ServerAndClient
//
//  Created by qianfeng on 14-9-2.
//  Copyright (c) 2014年 DevilHunter. All rights reserved.
//

#import "ChooseViewController.h"
#import "ServerViewController.h"
#import "ClientViewController.h"

@interface ChooseViewController ()

@end

@implementation ChooseViewController

- (void)dealloc
{
    servervc = nil;
    clientvc = nil;
    mTextField = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"服务器/客户机";
    mTextField = [[UITextField alloc] init];
    mTextField.bounds = CGRectMake(0, 0, 200, 30);
    mTextField.center = self.view.center;
    mTextField.clearButtonMode = YES;
    mTextField.clearsOnBeginEditing = YES;
    mTextField.textAlignment = NSTextAlignmentCenter;
    mTextField.placeholder = @"服务器 写1 客户机 写2";
    mTextField.delegate = self;
    [self.view addSubview:mTextField];
    
    UIBarButtonItem *back = [[[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:nil action:nil] autorelease];
    self.navigationItem.backBarButtonItem = back;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([mTextField.text isEqualToString:@"1"])
    {
        servervc = [[ServerViewController alloc] init];
        servervc.title = @"服务器";
        [self.navigationController pushViewController:servervc animated:YES];
    }
    else if([mTextField.text isEqualToString:@"2"])
    {
        clientvc = [[ClientViewController alloc] init];
        clientvc.title = @"客户端";
        [self.navigationController pushViewController:clientvc animated:YES];
    }
    else
    {
        NSLog(@"输入有误,请重新输入!");
        mTextField.text = @"";
    }
    return YES;
}

@end








