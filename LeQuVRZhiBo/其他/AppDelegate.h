//
//  AppDelegate.h
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/7.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "livingViewController.h"
static NSString *shareSDK_AppKey = @"199e55dcd8f28";
static NSString *sinaWiebo_AppKey = @"";
static NSString *sinaWiebo_AppSecret = @"";
static NSString *sinaWiebo_RedirectUri = @"";
static NSString *wechat_AppId = @"wx5f2c5ad9aff524ee";
static NSString *wechat_AppSecret = @"5d711fc155e92dc5f0d9bac2ca211dcb";
static NSString *qq_AppId = @"";
static NSString *qq_AppKey = @"";
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) livingViewController *vc;

@property (strong, nonatomic) UIWindow *window;


@end

