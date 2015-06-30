//
//  TopicViewController.m
//  ZakerDemo
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "TopicViewController.h"

#import "MyConst.h"
#import "MyImageViewInSV.h"

#import "MyFocusButtonView.h"
#import "BlockViewController.h"

@interface TopicViewController ()

@end

@implementation TopicViewController

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
    
    [self createStatusBK];
   
   
    self.view.backgroundColor=[UIColor whiteColor];
     
    
    _topicHeadView=[[UIView alloc]init];
    _headView=[[UIImageView alloc]init];
    
    _headSV=[[MyCustomScrollView alloc]init];
   
    _focusView=[[UIView alloc]init];
    
    [_topicHeadView addSubview:_headView];
    [_topicHeadView addSubview:_headSV];
    [_topicHeadView addSubview:_focusView];
    
    
    
    _arrayData=[[NSMutableArray alloc]init];
    _conncetArr=[[NSMutableArray alloc]init];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-55) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    [self loadDataWithUrl];
    
    [self.view addSubview:_tableView];
    
    [self createToolBar];
}


- (void)loadDataWithUrl
{
    ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:_topicUrl]];
    request.delegate=self;
    request.tag=2;
    [_conncetArr addObject:request];
    [request startAsynchronous];
}


- (void)createStatusBK
{
    //状态栏黑色
    UIView* statusBarView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    [self.view addSubview:statusBarView];
}

- (void)createToolBar
{
    UIView* toolBar=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-35, 320, 35)];
    toolBar.backgroundColor=[UIColor whiteColor];
    toolBar.alpha=0.8;
    
    //返回
    UIButton* backBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame=CGRectMake(0, 0, 35, 35);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"circle_icon_quit"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backBtn];
    
    //微信
    UIButton* weChatBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    weChatBtn.frame=CGRectMake(self.view.frame.size.width-85, 0, 35, 35);
    [weChatBtn setBackgroundImage:[UIImage imageNamed:@"common_icon_weixin"] forState:UIControlStateNormal];
    [weChatBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:weChatBtn];
    
    //刷新
    UIButton* refreshBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    refreshBtn.frame=CGRectMake(self.view.frame.size.width-35, 0, 35, 35);
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"common_icon_refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(pressBack) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:refreshBtn];
    [self.view addSubview:toolBar];
}




- (void)pressBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tapFocusAct:(UITapGestureRecognizer*)tap
{
    if ([(MyImageViewInSV*)tap.view isKindOfClass:[MyImageViewInSV class]]) {
        MyImageViewInSV* sv=(MyImageViewInSV*)tap.view;
        ReadingPageViewController* read=[[ReadingPageViewController alloc]init];
        read.strUrl=sv.strFullUrl;
        read.strTitle=sv.strTitle;
        [self presentViewController:read animated:YES completion:nil];
        return;
    }
    
    MyFocusButtonView* iView=(MyFocusButtonView*)tap.view;
    NSString* strUrl=iView.strUrl;
    NSString* strType=iView.strType;
    
    if ([strType isEqualToString:@"topic"]) {
        TopicViewController* topic=[[TopicViewController alloc]init];
        topic.topicUrl=strUrl;
        [self presentViewController:topic animated:YES completion:nil];
    }
    else if ([strType isEqualToString:@"block"])
    {
        BlockViewController* block=[[BlockViewController alloc]init];
        block.strUrl=strUrl;
        block.headPicUrl=iView.strBlockHeadUrl;
        [self presentViewController:block animated:YES completion:nil];
    }
    
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Topic failedTag---%d",request.tag);
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* data=request.responseData;
    int tag=request.tag;
    
    if (data!=nil) {
        
        //头部SV图像视图
        if (tag>=50) {
            UIImage* image=[UIImage imageWithData:data];
            MyImageViewInSV* iView=(MyImageViewInSV*)[_headSV.scrollView viewWithTag:tag];
            iView.image=image;
            [_headSV startScroll];
        }
        
        //tagView
        if (tag>=13 && tag<=23) {
            int index=tag+37;
            MyImageViewInSV* iView=(MyImageViewInSV*)[self.view viewWithTag:index];
            CGSize size=iView.tagSize;
            iView.tagView.frame=CGRectMake(320-size.width,10, size.width, size.height);
            UIImage* image=[UIImage imageWithData:data];
            iView.tagView.image=image;
        }
        
        //头部标题视图
        if (tag==3)
        {
            UIImage* image=[UIImage imageWithData:data];
            _headView.image=image;
        }
        
        
        //Focus按钮
        if (tag>=4 && tag<13)
        {
            UIImage* image=[UIImage imageWithData:data];
            MyFocusButtonView* iView=(MyFocusButtonView*)[_focusView viewWithTag:tag];
            iView.image=image;
        }
        
        
        //总下载Data
        if (tag==2) {
            NSDictionary* dicAll=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary* dicData=[dicAll objectForKey:@"data"];
            
           
#pragma mark-头标题Icon视图 tag(N3)
            NSDictionary* dicBlockInfo=[dicData objectForKey:@"block_info"];
            NSString* strTitle=[dicBlockInfo objectForKey:@"title"];
            
            NSDictionary* dicBlockDiy=[dicBlockInfo objectForKey:@"diy"];
            
            NSString* strHeadIconUrl=[dicBlockDiy objectForKey:@"bgimage_url"];
            
            ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strHeadIconUrl]];
            request.delegate=self;
            request.tag=3;
            [_conncetArr addObject:request];
            [request startAsynchronous];
            

            //文本定义头部标题尺寸
            NSString* strHeadIconFrame=[dicBlockDiy objectForKey:@"bgimage_frame"];
            NSString* strHeadIconHeight=[dicBlockDiy objectForKey:@"title_h"];
            int headIconHeight=[strHeadIconHeight intValue];
            _headView.frame=CGRectMake(0, 0, 320, headIconHeight);
            
            //隐藏头部标题YES NO
            NSString* strHideTitle=[dicBlockDiy objectForKey:@"hide_title"];
            
            
            
#pragma  mark-头部滚动图像视图 tag(V50+)
            NSArray* arrayGallery=[dicData objectForKey:@"gallery"];
            float headSVHeight=0;
            for (NSDictionary* dicGallery in arrayGallery) {

                NSString* strImgHeight=[dicGallery objectForKey:@"img_height"];
                NSString* strImgWidth=[dicGallery objectForKey:@"img_width"];
                float width=[strImgWidth floatValue];
                float height=[strImgHeight floatValue];
                if (width>=320) {
                    float radio=width/320;
                    width/=radio;
                    height/=radio;
                }
                headSVHeight=height;
                
                NSString* strTitle=[dicGallery objectForKey:@"title"];
                NSDictionary* dicArticle=[dicGallery objectForKey:@"article"];
                NSString* strFullUrl=[dicArticle objectForKey:@"full_url"];
                NSString* strArticleTitle=[dicArticle objectForKey:@"title"];
                
                int index=[arrayGallery indexOfObject:dicGallery];
                
                MyImageViewInSV* iView=[[MyImageViewInSV alloc]initWithFrame:CGRectMake(index*width, 0, width, height)];
                iView.tag=index+50;
                iView.titleLabel.text=strTitle;
                iView.userInteractionEnabled=YES;
                iView.strFullUrl=strFullUrl;
                iView.strTitle=strArticleTitle;
                
                NSString* strImgUrl=[dicGallery objectForKey:@"promotion_img"];
                ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strImgUrl]];
                request.delegate=self;
                request.tag=index+50;
                [_conncetArr addObject:request];
                [request startAsynchronous];
                
                UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]init];
                [tap addTarget:self action:@selector(tapFocusAct:)];
                [iView addGestureRecognizer:tap];
                
                
                [_headSV.scrollView addSubview:iView];
                
                NSDictionary* dicTag=[dicGallery objectForKey:@"tag_info"];
                //标签小图
                NSString* strTagImageUrl=[dicTag objectForKey:@"image_url"];
                
                ASIHTTPRequest* requestTag=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strTagImageUrl]];
                requestTag.delegate=self;
                requestTag.tag=index+13;
                [_conncetArr addObject:requestTag];
                [requestTag startAsynchronous];
                
                //标签尺寸
                float tagWidth=[[dicTag objectForKey:@"img_width"] floatValue];
                float tagHeight=[[dicTag objectForKey:@"img_height"] floatValue];
                if (tagWidth>=30)
                {
                    float ratio=tagWidth/30;
                    tagWidth/=ratio;
                    tagHeight/=ratio;
                }
                
                CGSize tagSize=CGSizeMake(tagWidth, tagHeight);
                iView.tagSize=tagSize;
            }
          
            
            _headSV.frame=CGRectMake(0, headIconHeight, 320, headSVHeight);
            _headSV.scrollView.frame=CGRectMake(0, 0, 320, headSVHeight);
            _headView.frame=CGRectMake(0, 0, 320, headIconHeight);
            
            int count=[arrayGallery count];
            
            _headSV.scrollView.contentSize=CGSizeMake(count*320, 0);
       
            
#pragma mark-Focus按钮tag(V4+)
            
            NSArray* arrayFocus=[dicData objectForKey:@"focus"];
            int focusHeight=0;
            for (NSArray* arr in arrayFocus) {
                for (NSDictionary* dicFocus in arr) {
                    
                    NSString* strType=[dicFocus objectForKey:@"type"];
                    NSString* strImgUrl=[dicFocus objectForKey:@"promotion_img"];
                    NSMutableString* strBlockHeadUrl;
                    NSDictionary* dicKind=[dicFocus objectForKey:@"block_info"];
                    NSString* strUrl;
                    if (dicKind) {
                         NSString* strPic=[dicKind objectForKey:@"pic"];
                        strUrl=[[dicKind objectForKey:@"api_url"] stringByAppendingString:Suffix];
                        strBlockHeadUrl=[NSMutableString stringWithString:strPic];
                        [strBlockHeadUrl replaceOccurrencesOfString:@"logo" withString:@"template/iphone" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strBlockHeadUrl.length)];
                    }
                    else
                    {
                        dicKind=[dicFocus objectForKey:@"topic"];
                        strUrl=[[dicKind objectForKey:@"api_url"] stringByAppendingString:Suffix];
                    }
                    
                    int index=[arr indexOfObject:dicFocus];
                
                    MyFocusButtonView* iView=[[MyFocusButtonView alloc]initWithFrame:CGRectMake(10+index*(145+10), 10, 145, 50)];
                    iView.strType=strType;
                    iView.strUrl=strUrl;
                    iView.strBlockHeadUrl=strBlockHeadUrl;
                    
                    ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strImgUrl]];
                    request.delegate=self;
                    request.tag=index+4;
                    [_conncetArr addObject:request];
                    [request startAsynchronous];
                    
                    iView.userInteractionEnabled=YES;
                    iView.tag=index+4;
                    focusHeight=50+20;
                    
                    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]init];
                    [tap addTarget:self action:@selector(tapFocusAct:)];
                    [iView addGestureRecognizer:tap];
                    
                    
                    _focusView.frame=CGRectMake(0, headSVHeight+headIconHeight, 320, focusHeight);
                    [_focusView addSubview:iView];
                }
            }
            _topicHeadView.frame=CGRectMake(0, 0, 320, headSVHeight+headIconHeight+focusHeight);
            _tableView.tableHeaderView=_topicHeadView;
        
            
            NSArray* arrayArticles=[dicData objectForKey:@"articles"];
#pragma  mark-新闻列表
            for (NSDictionary* dic in arrayArticles) {
                
                NSString* strComment=[dic objectForKey:@"title"];
                NSArray* arrayList=[dic objectForKey:@"list"];
                
                NSMutableArray* appsArr=[[NSMutableArray alloc]init];
                
                int index=[arrayArticles indexOfObject:dic];
                
                
                for (NSDictionary* dicList in arrayList) {
                    TopicCellModel* model=[[TopicCellModel alloc]init];
                    
                    NSDictionary* dicArticle=[dicList objectForKey:@"article"];
                    
                    NSString* strAuther=[dicArticle objectForKey:@"auther_name"];
                    NSString* strTitle=[dicArticle objectForKey:@"title"];
                    NSString* strPK=[dicArticle objectForKey:@"pk"];
                    NSString* strFullUrl=[dicArticle objectForKey:@"full_url"];
                    
                    model.mStrFullUrl=strFullUrl;
                    model.mAuther=strAuther;
                    model.mTitle=strTitle;
                    model.mPK=strPK;
                    model.mComment=strComment;
                    
                    [appsArr addObject:model];
                    
                    NSArray* arrayImages=[dicArticle objectForKey:@"thumbnail_medias"];
                    
                    for (NSDictionary* dicImg in arrayImages) {
                        int index_img=[arrayImages indexOfObject:dicImg];
                        
                        if (index_img>=3) {
                            break;
                        }
                        
                        NSString* strImgUrl=[dicImg objectForKey:@"url"];
                        
                        NetDownloadImage* downImg=[[NetDownloadImage alloc]init];
                        downImg.delegate=self;
                        
                        [_conncetArr addObject:downImg];
                        
                        [downImg startDownload:strImgUrl withTag:index andID:model.mPK];
                    }
                }
                [_arrayData addObject:appsArr];
            }
        }
        [_tableView reloadData];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCellModel* model=[[_arrayData objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    ReadingPageViewController* readVC=[[ReadingPageViewController alloc]init];
    readVC.strUrl=model.mStrFullUrl;
    readVC.strTitle=model.mTitle;
    [self presentViewController:readVC animated:YES completion:nil];
}


-(void)finishDownlod:(NSData *)data withTag:(NSInteger)tag andID:(NSString *)ID
{
    if (data!=nil) {
        for (TopicCellModel* model in _arrayData[tag]) {
            if ([model.mPK isEqualToString:ID]) {
                UIImage* image=[UIImage imageWithData:data];
                [model.mImgArr addObject:image];
            }
        }
    }
    
    [_tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray* array=[_arrayData objectAtIndex:section];
    TopicCellModel* model=array[0];
    return model.mComment;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _arrayData.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_arrayData objectAtIndex:section] count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCellModel* model=[[_arrayData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (model.mImgArr.count>=3)
    {
        NSString* strID=@"ID";
        TopicViewCell* cell=[tableView dequeueReusableCellWithIdentifier:strID];
        if (cell==nil) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"TopicViewCell" owner:self options:nil][0];
        }
        cell.model=model;
        return cell;
    }
    else if (model.mImgArr.count>=1)
    {
        NSString* strID=@"ID2";
        TopicViewCell* cell=[tableView dequeueReusableCellWithIdentifier:strID];
        if (cell==nil) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"TopicViewCell" owner:self options:nil][1];
        }
        cell.modelOnePic=model;
        return cell;
    }
    else
    {
        NSString* strID=@"ID3";
        TopicViewCell* cell=[tableView dequeueReusableCellWithIdentifier:strID];
        if (cell==nil) {
            cell=[[NSBundle mainBundle]loadNibNamed:@"TopicViewCell" owner:self options:nil][2];
        }
        cell.modelNoPic=model;
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCellModel* model=[[_arrayData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (model.mImgArr.count>=3) {
        return 132;
    }
    else if(model.mImgArr.count>=1)
    {
        return 80;
    }
    else
    {
        return 64;
    }
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
    [_headSV.timer invalidate];
    _headSV.timer=nil;
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
