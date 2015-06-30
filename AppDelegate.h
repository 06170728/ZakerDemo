//
//  AppDelegate.h
//  ZakerDemo
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIImageView* _firstImg;
    UIView* _bkView;
    UIButton* _downBtn;
    NSTimer* _timer;
    UIImageView* _loadingView;
}
@property (strong, nonatomic) UIWindow *window;


@end
