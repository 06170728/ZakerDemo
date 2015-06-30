//
//  AppDelegate.m
//  ZakerDemo
//
//  Created by qianfeng on 14-9-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewVC.h"
#import "HotViewController.h"
#import "DiscoveryViewController.h"
#import "AboutMeViewController.h"
#import "UIImage+MyUIImage.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSLog(@"%@",NSHomeDirectory());
    
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self createFirstPage];
    [self createVC];
    
    [self.window addSubview:_bkView];
    
    return YES;
}


- (void)createFirstPage
{
    //下载首页图
    _bkView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 460)];
    _bkView.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    _firstImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    _firstImg.userInteractionEnabled=YES;
    _firstImg.contentMode=UIViewContentModeScaleAspectFill;
    _firstImg.alpha=0.3;
    _firstImg.tag=666;
    
    
    _downBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _downBtn.frame=CGRectMake(20, 420, 20, 20);
    _downBtn.alpha=0.7;
    [_downBtn setBackgroundImage:[UIImage imageNamed:@"home_icon_download"] forState:UIControlStateNormal];
    [_firstImg addSubview:_downBtn];
    
    
    
    [_bkView addSubview:_firstImg];
    
    UIView* blackStatus=[[UIView alloc]initWithFrame:CGRectMake(0, -20, 320, 20)];
    blackStatus.backgroundColor=[UIColor blackColor];
    [_bkView addSubview:blackStatus];
    
    
    //logo
    UIImage* imageOri=[UIImage imageNamed:@"home_logo"];
    UIImage* imageColor=[imageOri imageWithColor:[UIColor blackColor]];
    
    UIImageView* logo=[[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 100, 30)];
    logo.image=imageColor;
    logo.tag=777;
    logo.contentMode=UIViewContentModeScaleAspectFit;
    [_bkView addSubview:logo];
    [self showLoadingView];
}


- (void)showLoadingView
{
    _loadingView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _loadingView.image=[UIImage imageNamed:@"home_loading"];
    _loadingView.contentMode=UIViewContentModeScaleAspectFit;
    _loadingView.center=CGPointMake(160, 250);
    
    [_bkView addSubview:_loadingView];
    
    if (_timer==nil) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateLoadView:) userInfo:nil repeats:YES];
    }
}


- (void)updateLoadView:(NSTimer*)timer
{
    if (_firstImg.image!=nil) {
        [timer invalidate];
        timer=nil;
        [_loadingView removeFromSuperview];
        return;
    }
    _loadingView.transform=CGAffineTransformRotate(_loadingView.transform, 0.1);
}


- (void)createVC
{
    NSArray* arrayStrClass=@[@"MainViewVC",@"HotViewController",@"DiscoveryViewController",@"AboutMeViewController"];
    NSArray* arrayTitle=@[@"订阅",@"推荐",@"发现",@"我的"];
    
    NSMutableArray* arrayVC=[[NSMutableArray alloc]init];
    
    for (NSString* strClass in arrayStrClass) {
        Class classVC=NSClassFromString(strClass);
        
        MainViewVC* vc=(MainViewVC*)[[classVC alloc]init];
        if ([strClass isEqualToString:@"MainViewVC"]) {
            vc.firstImgView=_bkView;
            
            [_downBtn addTarget:vc action:@selector(downFirstImgBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        
        NSString* strTitle=arrayTitle[[arrayStrClass indexOfObject:strClass]];
        vc.title=strTitle;
        UINavigationController* nav=[[UINavigationController alloc]initWithRootViewController:vc];
//        [nav.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"addRootBlock_toolbar_bg"]]];
        UIImage* image=[UIImage imageNamed:@"addRootBlock_toolbar_bg"];
        UIImage* stretchedImage=[image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        [nav.navigationBar setBackgroundImage:stretchedImage forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"FZLanTingHei-DB-GBK" size:16],NSFontAttributeName, nil]];
        nav.navigationBar.translucent=NO;
        nav.navigationBar.tintColor=[UIColor whiteColor];
        [arrayVC addObject:nav];
    }
    
    
    
    UITabBarController* tabbarC=[[UITabBarController alloc]init];
    tabbarC.viewControllers=arrayVC;
    
    
    NSArray* arrayTabIcon=@[@"icon_newboxview_boxview_tab",
                            @"icon_newboxview_hotdaily_tab",
                            @"icon_newboxview_channallist_tab",
                            @"icon_newboxview_messagecenter_tab"];
    NSArray* arrayTabTitle=@[@"订阅",
                             @"推荐",
                             @"发现",
                             @"我的"];
    
    
    for (UIViewController* vc  in arrayVC) {
        int index=[arrayVC indexOfObject:vc];
        UIImage* imageOri=[UIImage imageNamed:arrayTabIcon[index]];
        UIImage* image=[imageOri imageWithSize:CGSizeMake(24, 24)];
        UITabBarItem* item=[[UITabBarItem alloc]initWithTitle:arrayTabTitle[index] image:image tag:1];
        vc.tabBarItem=item;
    }
    
    self.window.rootViewController=tabbarC;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
