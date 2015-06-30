//
//  TopicViewCell.h
//  ZakerDemo
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicCellModel.h"

@interface TopicViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbFrom;
@property (weak, nonatomic) IBOutlet UIImageView *ivImage0;
@property (weak, nonatomic) IBOutlet UIImageView *ivImage1;
@property (weak, nonatomic) IBOutlet UIImageView *ivImage2;


@property (retain,nonatomic) TopicCellModel* model;
@property (retain,nonatomic) TopicCellModel* modelOnePic;
@property (retain,nonatomic) TopicCellModel* modelNoPic;
@end
