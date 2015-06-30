//
//  AboutMeViewController.m
//  ZakerDemo
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "AboutMeViewController.h"
#import "WebViewController.h"
#import "LoginUserModel.h"
#import "UserInfoView.h"


@interface AboutMeViewController ()

@end

@implementation AboutMeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=nil;

    // Do any additional setup after loading the view.
    NSString* fullPath=[[NSBundle mainBundle]pathForResource:@"AboutMeList" ofType:@"plist"];
    _arrayData=[NSMutableArray arrayWithContentsOfFile:fullPath];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.view addSubview:_tableView];
    
    
    UIBarButtonItem* loginBtn=[[UIBarButtonItem alloc]initWithTitle:@"登录新浪账户 >" style:UIBarButtonItemStyleDone target:self action:@selector(loginBtn)];
    self.navigationItem.rightBarButtonItem=loginBtn;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBtn:) name:@"refreshUserInfo" object:nil];
}

- (void)updateBtn:(NSNotification*)noti
{
    
    UserInfoView* userView=[[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    
    
    LoginUserModel* model=(LoginUserModel*)noti.object;
    userView.icon.image=model.userIcon;
    userView.name.text=model.userName;
    
    UIBarButtonItem* showInfoBnt=[[UIBarButtonItem alloc]initWithCustomView:userView];
    self.navigationItem.leftBarButtonItem=showInfoBnt;
}


- (void)loginBtn
{
    NSString* strUrl=@"https://api.weibo.com/oauth2/authorize?client_id=2139801026&redirect_uri=http://www.baidu.com";
    
    WebViewController* wVC=[[WebViewController alloc]init];
    wVC.strUrl=strUrl;
    [self.navigationController pushViewController:wVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrayData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayData[section] count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strId=@"ID";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:strId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strId];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString* str=_arrayData[indexPath.section][indexPath.row];
    cell.textLabel.text=str;
    cell.textLabel.font=[UIFont fontWithName:@"FZLanTingHei-R-GBK" size:15];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
