//
//  TopicViewController.h
//  ZakerDemo
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "NetDownloadImage.h"
#import "MyCustomScrollView.h"
#import "TopicViewCell.h"
#import "TopicCellModel.h"
#import "ReadingPageViewController.h"
@interface TopicViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,NetDownloadImageProtocol>
{
    UITableView* _tableView;
    NSMutableArray* _arrayData;
    NSMutableArray* _conncetArr;
    
    UIView* _focusView;
    
    UIView* _topicHeadView;
    UIImageView* _headView;
    MyCustomScrollView* _headSV;
}
- (void)loadDataWithUrl;
@property (retain,nonatomic)NSString* topicUrl;
@end
