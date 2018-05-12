//
//  ClientViewController.m
//  ServerAndClient
//
//  Created by qianfeng on 14-9-2.
//  Copyright (c) 2014年 DevilHunter. All rights reserved.
//

#import "ClientViewController.h"
#import "SocketManager.h"
#import "MessageModel.h"
#import "NSObject+DHF.h"

@interface ClientViewController ()
<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *cTableView;
    UITextField *msgTextField;
    
    NSMutableArray *cDataArray;
}
@end

@implementation ClientViewController
- (void)dealloc
{
    cDataArray   = nil;
    cTableView   = nil;
    msgTextField = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    
}
- (void)buttonClick:(UIButton *)button
{
    MessageModel *message = [[MessageModel alloc] init];
    message.type = button.tag;//每个按键对应一种消息类型
    [message.dic setValue:msgTextField.text forKey:@"content"];//发送消息的内容
    
    NSDictionary *sendDic = [message propertyList:YES];
    NSData *sendData = [NSJSONSerialization dataWithJSONObject:sendDic options:NSJSONWritingPrettyPrinted error:Nil];
    
    [[SocketManager sharedManager] disposeRequestFromHost:@"192.168.127.205" withType:button.tag onPort:0x1234 data:sendData clientArray:&cDataArray clientTableView:&cTableView];
}


#pragma mark -UI
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cDataArray.count;
}

- (void)createUI
{
    NSArray *nameArray = @[@"连接",@"断开",@"发送",@"列表",@"昵称"];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 90)];
    headerView.backgroundColor = [UIColor blueColor];
    msgTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 300, 40)];
    msgTextField.backgroundColor = [UIColor greenColor];
    msgTextField.borderStyle = UITextBorderStyleRoundedRect;
    msgTextField.placeholder = @"   大家来聊天啦 啦 啦   ";
    msgTextField.clearButtonMode = YES;
    msgTextField.clearsOnBeginEditing = YES;
    msgTextField.delegate = self;
    msgTextField.text = @"你好呀!";
    [headerView addSubview:msgTextField];
    
    int width = 50, height = 30;
    int space = (320-width*nameArray.count)/(nameArray.count+1);
    for (int i=0; i<nameArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 8;
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(space+(space+width)*i, 55, width, height);
        button.backgroundColor = [UIColor yellowColor];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kConnectionType+i;
        [headerView addSubview:button];
    }
    
    cDataArray = [[NSMutableArray alloc] init];
    cTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    cTableView.delegate = self;
    cTableView.dataSource = self;
    cTableView.rowHeight = 60.0;
    cTableView.tableHeaderView = headerView;
    [self.view addSubview:cTableView];
}
@end
