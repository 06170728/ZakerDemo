//
//  MyConst.h
//  ZakerDemo
//
//  Created by qianfeng on 14-9-23.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#ifndef ZakerDemo_MyConst_h
#define ZakerDemo_MyConst_h

//ScrollImage
#define ScrollImg_Info @"http://iphone.myzaker.com/zaker/follow_promote.php?_appid=iphone&_dev=iPhone%2C7.1&_udid=CE1AC1E9-01A6-4C96-BD37-B88AEFBE1E38&_uid=&_version=4.5"

//Topic
#define Topic(topic_id,app_id)  [NSString stringWithFormat:@"http://iphone.myzaker.com/zaker/topic.php?app_id=%@&topic_id=%@&_appid=iphone&_bsize=640_960&_dev=iPhone%2C7.1&_v=4.4.3&_version=4.5",topic_id,app_id]

//Block
#define Block(app_id,page) [NSString stringWithFormat:@"http://iphone.myzaker.com/zaker/news.php?&app_id=%@&_appid=iphone&_bsize=640_960&_dev=iPhone%2C7.1&_v=4.4.3&_version=4.5&opage=%d",app_id,page]

#define Suffix @"&_appid=iphone&_bsize=640_960&_dev=iPhone%2C7.1&_v=4.4.3&_version=4.5"

//订阅内容库
#define RSS @"http://iphone.myzaker.com/zaker/apps_v3.php?_appid=iphone&_version=4.5&act=getAllAppsData"

//封面图片
#define FirstImg @"http://iphone.myzaker.com/zaker/cover.php?_appid=iphone&_bsize=640_960&api_version=1.1"

#endif
