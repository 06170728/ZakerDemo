//
//  DiscoveryViewController.m
//  ZakerDemo
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "DiscoveryViewController.h"

#import "DiscoveryBlockListCell.h"
#import "DiscoveryBlockListModel.h"
#import "MyConst.h"
#import "DiscoverySonListViewController.h"

@interface DiscoveryViewController ()

@end

@implementation DiscoveryViewController

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
    // Do any additional setup after loading the view.
    _arrayData=[[NSMutableArray alloc]init];
    _conncetArr=[[NSMutableArray alloc]init];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    NSString* strUrl=RSS;
    NetDownload* download=[[NetDownload alloc]init];
    download.delegate=self;
    [_conncetArr addObject:download];
    [download startDownload:strUrl withTag:2];
    
    [self.view addSubview:_tableView];
}





-(void)finishDownlod:(NSData *)data withTag:(NSInteger)tag
{
    if (data!=nil) {
        if (tag>=5) {
            int index=tag-5;
            UIImage* image=[UIImage imageWithData:data];
            DiscoveryBlockListModel* model=_arrayData[index];
            model.icon=image;
            return;
        }
        
        NSDictionary* dicAll=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary* dicData=dicAll[@"data"];
        NSArray* arrayDatas=dicData[@"datas"];
        for (NSDictionary* dic in arrayDatas) {
            NSString* isNew=dic[@"is_new"];
            NSString* strTitle=dic[@"title"];
            
            
            NSString* strIcon=dic[@"list_icon"];
            NetDownload* download=[[NetDownload alloc]init];
            download.delegate=self;
            
            NSArray* arraySon=dic[@"sons"];
            
            [_conncetArr addObject:download];
            int index=[arrayDatas indexOfObject:dic];
            
            [download startDownload:strIcon withTag:index+5];
            

            DiscoveryBlockListModel* model=[[DiscoveryBlockListModel alloc]init];
            model.strTitle=strTitle;
            model.strIsNew=isNew;
            model.arraySon=arraySon;
            
            [_arrayData addObject:model];
        }
    }
    
    [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strID=@"ID";
    DiscoveryBlockListCell* cell=[tableView dequeueReusableCellWithIdentifier:strID];
    if (cell==nil) {
        cell=[[DiscoveryBlockListCell alloc]init];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
     
    DiscoveryBlockListModel* model=[_arrayData objectAtIndex:indexPath.row];
    
    cell.model=model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoveryBlockListModel* model=[_arrayData objectAtIndex:indexPath.row];
    
    DiscoverySonListViewController* son=[[DiscoverySonListViewController alloc]init];
    son.title=model.strTitle;
    son.arraySon=model.arraySon;
    
    [self.navigationController pushViewController:son animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    for (int i=0; i<_conncetArr.count; i++) {
        [[_conncetArr objectAtIndex:i] setDelegate:nil];
    }
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
