//
//  DiscoveryViewController.h
//  ZakerDemo
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetDownload.h"

@interface DiscoveryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NetDownloadProtocol>
{
    UITableView* _tableView;
    NSMutableArray* _arrayData;
    NSMutableArray* _conncetArr;
}

@end
