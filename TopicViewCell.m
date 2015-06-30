//
//  TopicViewCell.m
//  ZakerDemo
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "TopicViewCell.h"

@implementation TopicViewCell

- (void)awakeFromNib
{
    _lbFrom.font=[UIFont fontWithName:@"FZLanTingHei-R-GBK" size:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelNoPic:(TopicCellModel *)modelNoPic
{
    _lbTitle.text=modelNoPic.mTitle;
    _lbFrom.text=modelNoPic.mAuther;
}


-(void)setModelOnePic:(TopicCellModel *)modelOnePic
{
    
    _ivImage0.image=nil;
    
    _lbTitle.text=modelOnePic.mTitle;
    _lbFrom.text=modelOnePic.mAuther;
    
    for (UIImage* image in modelOnePic.mImgArr) {
        _ivImage0.image=image;
        break;
    }
}


-(void)setModel:(TopicCellModel *)model
{
    _lbTitle.text=model.mTitle;
    _lbFrom.text=model.mAuther;
    
    NSArray* arrayImg=model.mImgArr;
    
    NSArray* arrayIV=@[_ivImage0,_ivImage1,_ivImage2];
    
    for (int i=0; i<arrayImg.count; i++) {
        UIImageView* iView=arrayIV[i];
        iView.image=arrayImg[i];
    }
}

@end
