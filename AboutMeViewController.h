//
//  AboutMeViewController.h
//  ZakerDemo
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutMeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray* _arrayData;
}

@end
