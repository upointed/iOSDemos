//
//  ServerViewController.m
//  ServerAndClient
//
//  Created by qianfeng on 14-9-2.
//  Copyright (c) 2014年 DevilHunter. All rights reserved.
//

#import "ServerViewController.h"

@interface ServerViewController ()
<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *sTableView;
    NSMutableArray *sDataArray;
}
@end

@implementation ServerViewController
- (void)dealloc
{
    sDataArray = nil;
    sTableView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sDataArray = [[NSMutableArray alloc] init];
    sTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    sTableView.delegate = self;
    sTableView.dataSource = self;
    [self.view addSubview:sTableView];
    NSLog(@"已交由终端,请移步!");
    
}


#pragma mark - table
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
    return sDataArray.count;
}
@end
