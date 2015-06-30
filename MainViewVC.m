//
//  MainViewVC.m
//  ZakerDemo
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//


//Tile图标               (tag>=100)
//tag图标                (tag>=13)
//下载更新scrollImg页面   (tag>2 && tag<=12)
//下载总链接              (tag==2)


#import "MainViewVC.h"

#import "MyConst.h"
#import "ScrollImgModel.h"
#import "TopicViewController.h"
#import "BlockViewController.h"
#import "UIColor+UIColorFromHexString.h"
#import "UIImage+MyUIImage.h"
#import "SortTileViewController.h"
#import "MyImageViewInSV.h"
#import "WebViewController.h"
#import "SaveAndReadTilesButton.h"


#define ScrollImageViewHeight 180

@interface MainViewVC ()

@end

@implementation MainViewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _conncetArr=[[NSMutableArray alloc]init];
    _arrayData=[[NSMutableArray alloc]init];
    _tilesArr=[[NSMutableArray alloc]init];
    
    self.view.backgroundColor=[UIColor clearColor];
    _mainSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480-64)];
    _mainSV.delegate=self;
    _mainSV.backgroundColor=[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    
    _scrollImageView=[[MyCustomScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScrollImageViewHeight)];
    
    //点击空白手势
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBlank)];
    [self.view addGestureRecognizer:tap];
    
    
    [self.view addSubview:_mainSV];
    [self refreshView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshView) name:@"reloadBlockList" object:nil];

    [self createToolView];
    
    
    UIBarButtonItem* weatherBtn=[[UIBarButtonItem alloc]initWithTitle:@"获取天气" style:UIBarButtonItemStyleDone target:self action:@selector(weatherAct)];
    self.navigationItem.rightBarButtonItem=weatherBtn;
    
    _headPull=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -40, 320, 40) arrowImageName:@"cricle_icon_refresh_arrow_black" textColor:nil];
    _headPull.delegate=self;
    _headPull.EGOOPullRefreshPullingString=@"松开即可出现封面";
    _headPull.EGOOPullRefreshNormalString=@"下拉可以出现封面";
    [_mainSV addSubview:_headPull];
    
    //下载首页图
    UIPanGestureRecognizer* pan=[[UIPanGestureRecognizer alloc]init];
    [_firstImgView addGestureRecognizer:pan];
    pan.delegate=self;
    [pan addTarget:self action:@selector(panAct:)];
    
    
    ASIHTTPRequest* requestFirstImg=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:FirstImg]];
    requestFirstImg.delegate=self;
    requestFirstImg.tag=25;
    [_conncetArr addObject:requestFirstImg];
    [requestFirstImg startAsynchronous];
}




- (void)panAct:(UIPanGestureRecognizer*)pan
{
    CGPoint pt=[pan translationInView:self.view];
    _panHeight+=pt.y;
    
    if (pan.state==UIGestureRecognizerStateEnded) {
        [self firstImgAni];
    }
    
    CGRect frame=_firstImgView.frame;
    frame.origin.y+=pt.y;
    if (frame.origin.y<=20) {
        _firstImgView.frame=frame;
    }
    
    [pan setTranslation:CGPointZero inView:self.view];
}



- (void)firstImgAni
{
    if (_firstImgView.frame.origin.y<=-210) {
        [UIView animateWithDuration:0.3 animations:^{
            _firstImgView.frame=CGRectMake(0, -460, 320, 460);
        }];
        
    }
    
    else
    {
        [self fallDownAni];
    }
}


//封面掉落动画
- (void)fallDownAni
{
    [UIView animateWithDuration:0.4 animations:^{
        _firstImgView.frame=CGRectMake(0, 20, 320, 460);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 animations:^{
            _firstImgView.frame=CGRectMake(0, 20+_panHeight/11.5, 320, 460);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2 animations:^{
                _firstImgView.frame=CGRectMake(0, 20, 320, 460);
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.005 animations:^{
                    _firstImgView.frame=CGRectMake(0, 20+_panHeight/46, 320, 460);
                } completion:^(BOOL finished){
                    [UIView animateWithDuration:0.005 animations:^{
                        _firstImgView.frame=CGRectMake(0, 20, 320, 460);
                    } completion:^(BOOL finished){
                        _panHeight=0;
                    }];
                }];
                
            }];
            
        }];
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headPull egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_headPull egoRefreshScrollViewDidEndDragging:scrollView];
}


-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [UIView animateWithDuration:0.5 animations:^{
        _panHeight=-480;
        [self fallDownAni];
    } completion:^(BOOL finished){
        [_headPull egoRefreshScrollViewDataSourceDidFinishedLoading:_mainSV];
        _mainSV.frame=CGRectMake(0, 0, 320, 480-64-49);
    }];
}

- (void)endShowFirstImgAct
{
    [UIView animateWithDuration:0.7 animations:^{
        _firstImgView.frame=CGRectMake(0, -460, 320, 460);
    }];
}


#pragma mark-创建工具条
- (void)createToolView
{
    //底部排序删除tile工具条
    editTileView=[[UIView alloc]initWithFrame:CGRectMake(0, 480, 320, 80)];
    UIImage* imageOri=[UIImage imageNamed:@"addRootBlock_toolbar_bg"];
    UIImage* image=[imageOri stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    
    //排序
    UIButton* sortBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160,80)];
    sortBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    
    [sortBtn setTitle:@"频道排序" forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortBlockTileAct) forControlEvents:UIControlEventTouchUpInside];
    [sortBtn setImage:[UIImage imageNamed:@"SubscriptionFreeSortDay"] forState:UIControlStateNormal];
    
    [sortBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -sortBtn.titleLabel.frame.size.width)];
    [sortBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -sortBtn.imageView.frame.size.width, -35, 0)];

    [sortBtn setBackgroundImage:image forState:UIControlStateNormal];
  
    //删除
    UIButton* deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(160, 0, 160, 80)];
    deleteBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [deleteBtn setTitle:@"删除频道" forState:UIControlStateNormal];
    
    [deleteBtn setImage:[UIImage imageNamed:@"SubscriptionDayDeleteBlock"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBlockTileAct) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -sortBtn.titleLabel.frame.size.width)];
    [deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -sortBtn.imageView.frame.size.width, -35, 0)];
    [deleteBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    [editTileView addSubview:sortBtn];
    [editTileView addSubview:deleteBtn];
    
    [self.view addSubview:editTileView];
}


#pragma mark-天气按钮
- (void)weatherAct
{
    
}




- (void)refreshView
{
    ASIHTTPRequest* downSVImage=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:ScrollImg_Info]];
    downSVImage.delegate=self;
    downSVImage.tag=2;
    [_conncetArr addObject:downSVImage];
    [downSVImage startAsynchronous];
    
    [self createTileView];
}



#pragma mark-创建Tile
- (void)createTileView
{
    //清理重叠的tileBtn
    for (MyTileButtonView* view in _mainSV.subviews) {
        [view removeFromSuperview];
    }
    
    [_mainSV addSubview:_headPull];
    
    [_mainSV addSubview:_scrollImageView];
    
    NSString* strFilePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/TileList.plist"];
    NSFileManager* fm=[NSFileManager defaultManager];
    NSMutableArray* array;
    if ([fm fileExistsAtPath:strFilePath]) {
        array=[NSMutableArray arrayWithContentsOfFile:strFilePath];
    }
    else
    {
        NSString* strPath=[[NSBundle mainBundle]pathForResource:@"TileList" ofType:@"plist"];
        array=[NSMutableArray arrayWithContentsOfFile:strPath];
    }
    
    [_tilesArr removeAllObjects];
    for (NSDictionary* dic in array) {
        NSString* strApiUrl=[dic objectForKey:@"api_url"];
        NSString* strTitle=[dic objectForKey:@"title"];
        NSString* strPicUrl=[dic objectForKey:@"pic"];
        NSString* strPK=[dic objectForKey:@"pk"];
        NSString* strBlockColor=[dic objectForKey:@"block_color"];
        
        int index=[array indexOfObject:dic];
        
        MyTileButtonView* iView=[[MyTileButtonView alloc]initWithFrame:CGRectMake((index%3)*107, (index/3)*107+ScrollImageViewHeight, 106, 106)];
        iView.tag=index+100;
        [_tilesArr addObject:iView];
        
        iView.strApiUrl=strApiUrl;
        iView.strPicUrl=strPicUrl;
        iView.strPk=strPK;
        iView.strTitle=strTitle;
        iView.titleLabel.text=strTitle;
        iView.strBlockColor=strBlockColor;
        
        
        //点击
        UITapGestureRecognizer* tapOne=[[UITapGestureRecognizer alloc]init];
        [tapOne addTarget:self action:@selector(tileActOneTap:)];
        [iView addGestureRecognizer:tapOne];
        
         [_mainSV addSubview:iView];
 
        if ([strApiUrl isEqualToString:@"617728"]) {
            iView.iView.image=[UIImage imageNamed:@"SubscriptionDayAddChannel"];
            continue;
        }
        
        
        //长按
        UILongPressGestureRecognizer* longPress=[[UILongPressGestureRecognizer alloc]init];
        [longPress addTarget:self action:@selector(longPressAct:)];
        [iView addGestureRecognizer:longPress];
        

        ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strPicUrl]];
        request.delegate=self;
        request.tag=iView.tag;
        [_conncetArr addObject:request];
        [request startAsynchronous];
    }
    
    if (_tilesArr.count<=3) {
        _mainSV.contentSize=CGSizeMake(320, 2*107+180);
    }
    else
    {
    _mainSV.contentSize=CGSizeMake(320, ((_tilesArr.count-1)/3+1)*107+180);
    }
}


#pragma mark-长按Tile
- (void)longPressAct:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state==UIGestureRecognizerStateEnded) {
        return;
    }
    else if(longPress.state==UIGestureRecognizerStateBegan)
    {
        [UIView animateWithDuration:0.3 animations:^{
            editTileView.frame=CGRectMake(0, 480-64-80, 320, 80);
            self.tabBarController.tabBar.frame=CGRectMake(0, 480, 320, 49);
        }];
        
        _selectTile=(MyTileButtonView*)longPress.view;
        _mainSV.userInteractionEnabled=NO;
    }
}

- (void)tapBlank
{
    if (editTileView.frame.origin.y<=480-60) {
        [UIView animateWithDuration:0.3 animations:^{
            editTileView.frame=CGRectMake(0, 480, 320, 80);
            
        } completion:^(BOOL finished){
            
            [self showTabbar];
        }];
    }
    _mainSV.userInteractionEnabled=YES;
}


-(void)showTabbar
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tabBarController.tabBar.frame=CGRectMake(0, 480-49, 320, 49);
    }];
}



#pragma mark-点击Tile跳转
- (void)tileActOneTap:(UITapGestureRecognizer*)tap
{
    MyTileButtonView* btn=(MyTileButtonView*)tap.view;
    
    //添加内容按钮
    if ([btn.strApiUrl isEqualToString:@"617728"]) {
        self.tabBarController.selectedIndex=2;
        return;
    }
    
    //Tile内容按钮
    NSString* strUrl=[btn.strApiUrl stringByAppendingString:Suffix];
    BlockViewController* block=[[BlockViewController alloc]init];
    block.strUrl=strUrl;
    
    
#pragma mark-BlockUrl头部连接处理
    NSMutableString* mulStr=[NSMutableString stringWithString:btn.strPicUrl];
    [mulStr replaceOccurrencesOfString:@"logo" withString:@"template/iphone" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mulStr.length)];

    block.headPicUrl=mulStr;
    [self presentViewController:block animated:YES completion:nil];
}


- (void)sortBlockTileAct
{
    SortTileViewController* sortVC=[[SortTileViewController alloc]init];
    [self.navigationController pushViewController:sortVC animated:YES];
}


#pragma mark-删除按钮
- (void)deleteBlockTileAct
{
    NSString* strPK=_selectTile.strPk;
    NSString* strFilePath=[NSHomeDirectory() stringByAppendingString:@"/Documents/TileList.plist"];
    NSFileManager* fm=[NSFileManager defaultManager];
    NSMutableArray* array;
    if ([fm fileExistsAtPath:strFilePath]) {
        array=[NSMutableArray arrayWithContentsOfFile:strFilePath];
    }
    else
    {
        NSString* strPath=[[NSBundle mainBundle]pathForResource:@"TileList" ofType:@"plist"];
        array=[NSMutableArray arrayWithContentsOfFile:strPath];
    }
    for (int i=0; i<array.count; i++) {
        NSDictionary* dic=array[i];
        NSString* strDicPK=dic[@"pk"];
        if ([strDicPK isEqualToString:strPK]) {
            [array removeObject:dic];
            break;
        }
    }
    [array writeToFile:strFilePath atomically:YES];
    
    
    //删除tile特效
    [UIView animateWithDuration:0.3 animations:^{
        _selectTile.transform=CGAffineTransformMakeScale(0.1, 0.1);
        _selectTile.alpha=0;
    }];
    
    [_tilesArr removeObject:_selectTile];
    for (int i=0; i<_tilesArr.count; i++) {
        MyTileButtonView* iView=_tilesArr[i];
        [UIView animateWithDuration:0.5 animations:^{
            iView.frame=CGRectMake((i%3)*107, (i/3)*107+ScrollImageViewHeight, 106, 106);
        }];
    }
    
    if (editTileView.frame.origin.y<=480-60) {
        [UIView animateWithDuration:0.3 animations:^{
            editTileView.frame=CGRectMake(0, 480, 320, 60);
        } completion:^(BOOL finished){
            [self showTabbar];
        }];
    }
    if (_tilesArr.count<=3) {
         _mainSV.contentSize=CGSizeMake(320, 2*107+180);
    }
    else
    {
    _mainSV.contentSize=CGSizeMake(320, ((_tilesArr.count-1)/3+1)*107+180);
    }
    _mainSV.userInteractionEnabled=YES;
}


#pragma mark-存储首页图
- (void)downFirstImgBtn
{
    if (_firstImg!=nil) {
        UIImageWriteToSavedPhotosAlbum(_firstImg, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:
(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView* alert;
    if (!error) {
        alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else
    {
        alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"保存失败,请重试" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    [alert show];
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"mainView failed---%d",request.tag);
}


#pragma mark-下载解析Data
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSData* data=request.responseData;
    int tag=request.tag;
    
    //Tile图标
    if (tag>=100) {
        UIImage* image=[UIImage imageWithData:data];
        
        MyTileButtonView* iView=(MyTileButtonView*)[self.view viewWithTag:tag];
        UIColor* color;
        
        if (![iView.strBlockColor isEqualToString:@""]) {
            color=[UIColor colorWithHexString:iView.strBlockColor];
        }
        else
        {
            color=[UIColor blackColor];
        }
        
        UIImage* imageColor=[image imageWithColor:color];
        iView.iView.image=imageColor;
        
        return;
    }
    
    if (tag>=27 & tag<=37) {
        int index=tag-27;
        ScrollImgModel* model=[_arrayData objectAtIndex:index];
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary* dicData=[dic objectForKey:@"data"];
        NSString* strTitle=[dicData objectForKey:@"title"];
        
        NSDictionary* dicVideo=[dicData objectForKey:@"video"];
        NSString* strUrl=[dicVideo objectForKey:@"url"];
        model.mTitle=strTitle;
        model.mStrWebUrl=strUrl;
        
        return;
    }
    
    
    //下载首页图
    if (tag==26) {
        UIImage* image=[UIImage imageWithData:data];
        UIImageView* iView=(UIImageView*)[_firstImgView viewWithTag:666];
        UIImageView* iViewLogo=(UIImageView*)[_firstImgView viewWithTag:777];
        iViewLogo.image=[UIImage imageNamed:@"home_logo"];
        iView.image=image;
        _firstImg=image;
        [UIView animateWithDuration:0.5 animations:^{
            iView.alpha=1;
        }];
        
        [self performSelector:@selector(endShowFirstImgAct) withObject:nil afterDelay:2];
        return;
    }
    

    if (tag==25) {
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary* dicData=dic[@"data"];
        NSString* strPic=dicData[@"pic"];
        
        ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strPic]];
        request.delegate=self;
        request.tag=26;
        [_conncetArr addObject:request];
        [request startAsynchronous];

        return;
    }
    
    //tag图标
    if (tag>=13 && tag<=23) {
        UIImage* image=[UIImage imageWithData:data];
        int index=tag-13;
        
        int iViewTag=index+3;
        
        MyImageViewInSV* iView=(MyImageViewInSV*)[self.view viewWithTag:iViewTag];
        ScrollImgModel* model=[_arrayData objectAtIndex:index];
        CGSize size=model.mTagSize;
        
        iView.tagView.frame=CGRectMake(320-size.width,10, size.width, size.height);
        iView.tagView.image=image;
        return;
    }
    
    
    
    //下载更新scrollImg页面
    if (tag>2 && tag<=12) {
        
        UIImage* image=[UIImage imageWithData:data];
        int index=tag-3;
        ScrollImgModel* model=[_arrayData objectAtIndex:index];
        model.mImage=image;
        
        //取出SV
        MyImageViewInSV* iView=(MyImageViewInSV*)[self.view viewWithTag:tag];
        iView.image=image;
        
        //SV图片标题
        iView.titleLabel.text=model.mTitle;
        
        //开始滚动
        [_scrollImageView startScroll];
        
        return;
    }
    
    
    //下载总链接
    if (tag==2) {
        NSDictionary* dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary* dicData=[dic objectForKey:@"data"];
        //列表
        NSArray* arrayList=[dicData objectForKey:@"list"];
        
        for (NSDictionary* dic in arrayList) {
            
            //图片地址
            NSString* strImageUrl=[dic objectForKey:@"promotion_img"];
            
            //标题
            NSString* strTitle=[dic objectForKey:@"title"];
            
            //链接类型
            NSString* strType=[dic objectForKey:@"type"];
            
            //图片尺寸
            float width=[[dic objectForKey:@"img_width"] floatValue];
            float height=[[dic objectForKey:@"img_height"] floatValue];
            if (width>=320) {
                float ratio=width/320;
                width/=ratio;
                height/=ratio;
                if (height>=180) {
                    height=180;
                }
            }
            CGSize imgSize=CGSizeMake(width, height);
            
            int index=[arrayList indexOfObject:dic];
            
            ASIHTTPRequest* request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strImageUrl]];
            request.delegate=self;
            request.tag=index+3;
            [_conncetArr addObject:request];
            [request startAsynchronous];
            
#pragma  mark-tag标签小图
            //标签信息
            NSDictionary* dicTag=[dic objectForKey:@"tag_info"];
            //标签小图
            NSString* strTagImageUrl=[dicTag objectForKey:@"image_url"];
            
            ASIHTTPRequest* downTagImg=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strTagImageUrl]];
            downTagImg.delegate=self;
            downTagImg.tag=index+13;
            [_conncetArr addObject:downTagImg];
            [downTagImg startAsynchronous];
            
            //标签尺寸
            float tagWidth=[[dicTag objectForKey:@"img_width"] floatValue];
            float tagHeight=[[dicTag objectForKey:@"img_height"] floatValue];
            if (tagWidth>=30) {
                float ratio=tagWidth/30;
                tagWidth/=ratio;
                tagHeight/=ratio;
            }
            CGSize tagSize=CGSizeMake(tagWidth, tagHeight);
            
#pragma mark-Topic信息
            NSDictionary* dicTopic=[dic objectForKey:@"topic"];
            NSString* strTopicUrl=[dicTopic objectForKey:@"api_url"];
            
            
#pragma mark-Block信息
            NSDictionary* dicBlock=[dic objectForKey:@"block_info"];
            NSString* strBlockUrl=[dicBlock objectForKey:@"api_url"];
            NSString* strHeadUrlOri=[dicBlock objectForKey:@"pic"];
            NSMutableString* strHeadUrl;
            if (strHeadUrlOri!=nil) {
                strHeadUrl=[NSMutableString stringWithString:strHeadUrlOri];
                [strHeadUrl replaceOccurrencesOfString:@"logo" withString:@"template/iphone" options:NSCaseInsensitiveSearch range:NSMakeRange(0, strHeadUrl.length)];
            }
      
            
#pragma mark-Article信息
            NSDictionary* dicArticle=[dic objectForKey:@"article"];
            NSString* strArticleFullUrl=[dicArticle objectForKey:@"full_url"];
            NSString* strArticleTitle=[dicArticle objectForKey:@"title"];
            
#pragma mark-Web信息
            NSDictionary* dicWeb=[dic objectForKey:@"web"];
            NSString* strWebUrl=[dicWeb objectForKey:@"url"];
            
#pragma mark-Live直播
            NSDictionary* dicLive=[dic objectForKey:@"live"];
            NSString* strLiveUrl=[dicLive objectForKey:@"api_url"];
            
            ASIHTTPRequest* requestLive=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:strLiveUrl]];
            requestLive.delegate=self;
            requestLive.tag=27+index;
            [requestLive startAsynchronous];
            
            ScrollImgModel* model=[[ScrollImgModel alloc]init];
            model.mTitle=strTitle;
            model.mTag=index;
            model.mImgSize=imgSize;
            model.mTagSize=tagSize;
            model.mType=strType;
            
            model.mStrWebUrl=strWebUrl;
            
            model.mStrArticleTitle=strArticleTitle;
            model.mStrArticleUrl=strArticleFullUrl;
            
            model.mStrBlockUrl=strBlockUrl;
            model.mStrBlockHeadUrl=strHeadUrl;
            
            model.mStrTopicUrl=[strTopicUrl stringByAppendingString:Suffix];
            
            [_arrayData addObject:model];
            
            
            //预加载图片view数
            _scrollImageView.frame=CGRectMake(0, 0, 320, imgSize.height);
            _scrollImageView.scrollView.frame=CGRectMake(0, 0, 320, imgSize.height);
            _scrollImageView.scrollView.contentSize=CGSizeMake((index+1)*320, imgSize.height);
            
            
            //SV图片View
            MyImageViewInSV* iView=[[MyImageViewInSV alloc]initWithFrame:CGRectMake(index*320, 0, 320, imgSize.height)];
            UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tapScrollAct:)];
            [iView addGestureRecognizer:tap];
            iView.userInteractionEnabled=YES;
            
            iView.tag=index+3;
            [_scrollImageView.scrollView addSubview:iView];
        }
    }
}



#pragma mark-滚动视图点击跳转
- (void)tapScrollAct:(UITapGestureRecognizer*)tap
{
    int tag=tap.view.tag;
    int index=tag-3;
    ScrollImgModel* model=[_arrayData objectAtIndex:index];
    NSString* strType=model.mType;
    
    //ScrollView点击跳转形式
    //专题
    if ([strType isEqualToString:@"topic"])
    {
        TopicViewController* topic=[[TopicViewController alloc]init];
        topic.topicUrl=model.mStrTopicUrl;
        [self presentViewController:topic animated:YES completion:nil];
    }
    
    //版块
    else if ([strType isEqualToString:@"block"])
    {
        BlockViewController* block=[[BlockViewController alloc]init];
        block.strUrl=[model.mStrBlockUrl stringByAppendingString:Suffix];
        block.headPicUrl=model.mStrBlockHeadUrl;
        [self presentViewController:block animated:YES completion:nil];
    }

    //网页  &&  直播
    else if([strType isEqualToString:@"web"] | [strType isEqualToString:@"live"])
    {
        WebViewController* webVC=[[WebViewController alloc]init];
        webVC.strUrl=model.mStrWebUrl;
        webVC.strTitle=model.mTitle;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    
    //文章
    else if([strType isEqualToString:@"a"])
    {
        ReadingPageViewController* readVC=[[ReadingPageViewController alloc]init];
        readVC.strUrl=model.mStrArticleUrl;
        readVC.strTitle=model.mStrArticleTitle;
        [self presentViewController:readVC animated:YES completion:nil];
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
    

    [_scrollImageView.timer invalidate];
    _scrollImageView.timer=nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_scrollImageView startScroll];
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
