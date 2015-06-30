//
//  MainViewVC.h
//  ZakerDemo
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTileButtonView.h"
#import "MyCustomScrollView.h"
#import "EGORefreshTableHeaderView.h"
#import "ASIHTTPRequest.h"

@interface MainViewVC : UIViewController<ASIHTTPRequestDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView* _mainSV;
    MyCustomScrollView* _scrollImageView;
    
    UIView* editTileView;
  
    NSMutableArray* _tilesArr;
    NSMutableArray* _conncetArr;
    NSMutableArray* _arrayData;
    CGFloat _svHeight;
    
    NSTimer* _timer;
    MyTileButtonView* _selectTile;
    EGORefreshTableHeaderView* _headPull;
    
    UIView* _firstImgView;
    CGFloat _panHeight;
    UIImage* _firstImg;
}
@property (retain,nonatomic)UIView* firstImgView;


@end
