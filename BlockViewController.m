//
//  BlockViewController.m
//  ZakerDemo
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "BlockViewController.h"
#import "MyTileNewsView.h"
#import "TileNewsModel.h"
#import "ReadingPageViewController.h"

@interface BlockViewController ()

@end

@implementation BlockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isAddArr=YES;
        _isAddImg=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //状态栏黑色
    UIView* statusBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    [self.view addSubview:statusBarView];
    
    
    _conncetArr=[[NSMutableArray alloc]init];
    _arrayData=[[NSMutableArray alloc]init];
    
    self.view.backgroundColor=[UIColor clearColor];
    
    _tableView=[[UITableView alloc]init];
    _tableView.transform=CGAffineTransformMakeRotation(-M_PI/2);
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.pagingEnabled=YES;
    
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.frame=CGRectMake(0, 20, 320, 480-35-20);
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.view addSubview:_tableView];
    
    //toolBar
    UIView* toolBar=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-34, 320, 34)];
    toolBar.backgroundColor=[UIColor whiteColor];
    toolBar.alpha=0.8;
    
    //返回
    UIButton* backBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame=CGRectMake(0, 0, 35, 35);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"circle_icon_quit"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backBtn];
    
    //页数显示label
    _pageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 34)];
    _pageLabel.center=CGPointMake(160, 17);
    _pageLabel.textAlignment=NSTextAlignmentCenter;
    _pageLabel.font=[UIFont fontWithName:@"FZLanTingHei-DB-GBK" size:13];
    [toolBar addSubview:_pageLabel];
    
    
    //刷新
    UIButton* refreshBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshBtn.frame=CGRectMake(self.view.frame.size.width-35, 0, 35, 35);
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"common_icon_refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(pressRefresh) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:refreshBtn];
    
    [self.view addSubview:toolBar];
    
    
    //下载版块6格新闻
    ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:_strUrl]];
    request.tag=10;
    request.delegate=self;
    [_conncetArr addObject:request];
    [request startAsynchronous];
    
    //下载版块头部视图
    ASIHTTPRequest* requestHead=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:_headPicUrl]];
    requestHead.tag=5;
    requestHead.delegate=self;
    [_conncetArr addObject:requestHead];
    [requestHead startAsynchronous];
    
    _downPage=[DownloadStatusPageViewController sharedDownloadStatusPageView];
    _downPage.blockVC=self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pressRefresh) name:@"refreshBlock" object:nil];
}


//- (void)panAct:(UIPanGestureRecognizer*)pan
//{
//    CGPoint pt=[pan translationInView:self.view];
//    CGRect frame=_tableView.frame;
//    frame.origin.y+=pt.y;
//    _tableView.frame=frame;
//    NSLog(@"%f",pt.y);
//    [pan setTranslation:CGPointZero inView:self.view];
//}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.tag==10) {
        [_downPage showErrorView];
    }
}




-(void)requestStarted:(ASIHTTPRequest *)request
{
    if (request.tag==10) {
        [self.view addSubview:_downPage.view];
        [_downPage showLoadingView];
    }
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* data=request.responseData;
    int tag=request.tag;
    
    if (data!=nil) {
        if (tag==5) {
            UIImage* image=[UIImage imageWithData:data];
            _headImg=image;
            [_tableView reloadData];
            return;
        }
        
        if (tag>=21) {
            UIImage* image=[UIImage imageWithData:data];
            int index=tag-21;
            NSArray* arraySix=[_arrayData objectAtIndex:index/6];
            
            TileNewsModel* model=[arraySix objectAtIndex:index%6];
            model.mImage=image;
            [_tableView reloadData];
            return;
        }
        if (tag==10) {
            [_downPage dismissView];
            
            
            NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary* dicData=[dic objectForKey:@"data"];
            
         
#pragma mark-文章标题颜色
            NSDictionary* dicConfig=[dicData objectForKey:@"ipadconfig"];
            NSArray* arrColor=[dicConfig objectForKey:@"article_block_colors"];
            if ([arrColor count]) {
                _strArticleColor=arrColor[0];
            }
            
            
            
#pragma mark-下一页链接
            NSDictionary* dicInfo=[dicData objectForKey:@"info"];
            NSString* strNextPageUrl=[dicInfo objectForKey:@"next_url"];
            _nextUrl=strNextPageUrl;
            
            
            
#pragma mark-文章列表
            NSArray* arrayArticles=[dicData objectForKey:@"articles"];
            NSMutableArray* arraySix=[[NSMutableArray alloc]init];
            
            for (NSDictionary* dicNews in arrayArticles) {
                NSString* strAuther=[dicNews objectForKey:@"auther_name"];
                NSString* strFullUrl=[dicNews objectForKey:@"full_url"];
                NSString* strTitle=[dicNews objectForKey:@"title"];
                NSString* strImage=[dicNews objectForKey:@"thumbnail_mpic"];
                NSString* strDate=[dicNews objectForKey:@"date"];
                
                //http://iphone.myzaker.com/zaker/news.php?_appid=iphone&_bsize=640_960&_version=4.5&app_id=720
                //http://iphone.myzaker.com/zaker/blog2news.php?_appid=iphone&_bsize=640_960&_version=4.5&app_id=720&nt=1&since_date=1411510138
                NSArray* arrMedia=[dicNews objectForKey:@"media"];
                if (arrMedia.count) {
                    strImage=[arrMedia[0]objectForKey:@"m_url"];
                }
                
                TileNewsModel* model=[[TileNewsModel alloc]init];
                model.mTitle=strTitle;
                model.mAuther=strAuther;
                model.mFullUrl=strFullUrl;
                model.mDate=strDate;
                
                [arraySix addObject:model];
                
                int count= arraySix.count;
                
                if (_isAddArr==YES) {
                    [_arrayData addObject:arraySix];
                    _isAddArr=NO;
                }
                
                
                if (_isAddArr==NO) {
                    int index=_arrayData.count-1;
                    [_arrayData replaceObjectAtIndex:index withObject:arraySix];
                }
                
                
                if (_isAddImg==YES) {
                    if (strImage!=nil) {
                        int index=_arrayData.count-1;
                        ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strImage]];
                        request.tag=count+(index*6)+20;
                        request.delegate=self;
                        [_conncetArr addObject:request];
                        [request startAsynchronous];
                        _isAddImg=NO;
                    }
                }
                
                
                //6个一组
                if (count==6) {
                    arraySix=[[NSMutableArray alloc]init];
                    _isAddArr=YES;
                    _isAddImg=YES;
                }
            }
        }
    }
    
    int nowPage=_tableView.contentOffset.y/320+1;
    int totalPage=_arrayData.count;
    _pageLabel.text=[NSString stringWithFormat:@"%d/%d",nowPage,totalPage];
    
    [_tableView reloadData];
}



#pragma mark-返回
- (void)pressBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-刷新
- (void)pressRefresh
{
    //下载版块6格新闻
    [_arrayData removeAllObjects];
    [_tableView reloadData];
    
    _tableView.contentOffset=CGPointMake(0, 0);
    
    
    ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:_strUrl]];
    request.tag=10;
    request.delegate=self;
    [_conncetArr addObject:request];
    [request startAsynchronous];
    
    
    //下载版块头部视图
    ASIHTTPRequest* requestHead=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:_headPicUrl]];
    requestHead.tag=5;
    requestHead.delegate=self;
    [_conncetArr addObject:requestHead];
    [requestHead startAsynchronous];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int nowPage=scrollView.contentOffset.y/320+1;
    int totalPage=_arrayData.count;
    _pageLabel.text=[NSString stringWithFormat:@"%d/%d",nowPage,totalPage];
    
    if (scrollView.contentOffset.y>=(_arrayData.count-1)*320) {
        ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:_nextUrl]];
        request.tag=10;
        request.delegate=self;
        [_conncetArr addObject:request];
        [request startAsynchronous];
    }
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strID=@"ID";
    BlockViewCell* cell=[tableView dequeueReusableCellWithIdentifier:strID];
    if (cell==nil) {
        cell=[[BlockViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        cell.transform=CGAffineTransformMakeRotation(M_PI/2);
        cell.delegate=self;
    }
    
    if (_headImg!=nil) {
        cell.headImg=_headImg;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.arraySix=[_arrayData objectAtIndex:indexPath.row];
    return cell;
}



- (void)pushReadingPageViewWihtURL:(NSString *)fullUrl andTitle:(NSString *)strTitle andTagInfo:(NSString *)strTag
{
    ReadingPageViewController* readVC=[[ReadingPageViewController alloc]init];
    readVC.strUrl=fullUrl;
    readVC.strTitle=strTitle;
    readVC.strArticleColor=_strArticleColor;
    readVC.strTag=strTag;
    [self presentViewController:readVC animated:YES completion:nil];
}



- (void)viewWillDisappear:(BOOL)animated
{
    for (int i=0; i<_conncetArr.count; i++) {
        [[_conncetArr objectAtIndex:i] setDelegate:nil];
    }
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
