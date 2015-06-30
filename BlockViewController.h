//
//  BlockViewController.h
//  ZakerDemo
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyConst.h"
#import "BlockViewCell.h"
#import "DownloadStatusPageViewController.h"
#import "ASIHTTPRequest.h"

@interface BlockViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PushReadingPageDelegate,ASIHTTPRequestDelegate,UIGestureRecognizerDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _arrayData;
    BOOL _isAddArr;
    BOOL _isAddImg;
    NSMutableArray* _conncetArr;
    UIImage* _headImg;
    NSString* _nextUrl;
    
    NSString* _strArticleColor;
    
    UILabel* _pageLabel;
    
    DownloadStatusPageViewController* _downPage;
}

@property (retain,nonatomic)NSString* strUrl;
@property (retain,nonatomic)NSString* headPicUrl;


@end
