//
//  AppDelegate.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/7.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "AppDelegate.h"
#import "zhiboViewController.h"
#import "shequViewController.h"
#import "lepaihangViewController.h"
#import "xiaoxiViewController.h"
#import "zhiboingViewController.h"
#import "MainViewController.h"
#import "cehuaViewController.h"
#import "MMDrawerController.h"
#import "dengluViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
//
#import <AlipaySDK/AlipaySDK.h>

#import <ShareSDK/ShareSDK.h>

#import <ShareSDKConnector/ShareSDKConnector.h>
#import <RongIMLib/RongIMLib.h>
#import "RCDLive.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDLiveGiftMessage.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import "ChetListController.h"

@interface AppDelegate ()<UITabBarControllerDelegate,WXApiDelegate,QQApiInterfaceDelegate,WeiboSDKDelegate>


@end

@implementation AppDelegate
-(void)login{
    [[RCDLive sharedRCDLive] initRongCloud:RONGCLOUD_IM_APPKEY];
    //注册自定义消息
    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDLiveGiftMessage class]];
    NSLog(@"-%@-",[USERDEFAULT valueForKey:@"token"]);
    [[RCDLive sharedRCDLive]connectRongCloudWithToken:[USERDEFAULT valueForKey:@"token"] success:^(NSString *userId) {
        NSLog(@"登陆成功");
        NSUserDefaults *mySettingDataR = [NSUserDefaults standardUserDefaults];
        NSString *uid = [mySettingDataR objectForKey:@"uid"];
        NSString *user_phone = [mySettingDataR objectForKey:@"nickname"];
        NSString *avatar = [mySettingDataR objectForKey:@"imgUrl"];
        RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:uid name:user_phone portrait:avatar];
        [RCIMClient sharedRCIMClient].currentUserInfo = user;
    } error:^(RCConnectErrorCode status) {
        
    } tokenIncorrect:^{
        
    }];
    MainViewController *myUITabBarController=[[MainViewController alloc]init];
    // 添加子控制器
    [myUITabBarController addChildVc:[[zhiboViewController alloc] init] title:@"直播" image:@"iconfont-luxiang" selectedImage:@"wd1"];
    [myUITabBarController addChildVc:[[shequViewController alloc] init] title:@"社区" image:@"iconfont-shequ" selectedImage:@"wd3"];
    [myUITabBarController addChildVc:[[lepaihangViewController alloc] init] title:@"乐排行" image:@"iconfont-7" selectedImage:@"wd2"];
    [myUITabBarController addChildVc:[[ChetListController alloc] init] title:@"消息" image:@"iconfont-shequ(1)" selectedImage:@"wd"];
    //左边抽屉
    cehuaViewController * myVC = [[cehuaViewController alloc]init];
    UINavigationController * myNav = [[UINavigationController alloc]initWithRootViewController:myVC];
    MMDrawerController * drawerVC = [[MMDrawerController alloc]initWithCenterViewController:myUITabBarController leftDrawerViewController:myNav];
    [drawerVC setShowsShadow:YES];
    [drawerVC setRestorationIdentifier:@"MMDrawer"];
    [drawerVC setMaximumLeftDrawerWidth:[UIScreen mainScreen].bounds.size.width/4*3];
    [drawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
    [drawerVC setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        
        
        
    }];
    
    self.window.rootViewController=drawerVC;
    [AFManager getReqURL:[NSString stringWithFormat:@"%@?uid=%@",USERLEVEL,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
        NSLog(@"%@====",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            [USERDEFAULT setValue:infor[@"data"][@"levelid"] forKey:@"level"];
            [USERDEFAULT synchronize];

        }
    } errorblock:^(NSError *error) {
        
    }];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login) name:@"login" object:nil];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]);
    [SMSSDK registerApp:@"191499d11522f" withSecret:@"f0724c701f6f66bb8fccdeb9e953a1f0"];
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
//    [ShareSDK registerApp:shareSDK_AppKey
//     
//          activePlatforms:@[
//                            @(SSDKPlatformTypeSinaWeibo),
//                            @(SSDKPlatformTypeWechat),
//                            @(SSDKPlatformTypeQQ)]
//                 onImport:^(SSDKPlatformType platformType)
//     {
//         switch (platformType)
//         {
//             case SSDKPlatformTypeWechat:
//                 [ShareSDKConnector connectWeChat:[WXApi class]];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                 break;
//             case SSDKPlatformTypeSinaWeibo:
//                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                 break;
//             default:
//                 break;
//         }
//     }
//          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//     {
//         
//         switch (platformType)
//         {
//             case SSDKPlatformTypeSinaWeibo:
//                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                 [appInfo SSDKSetupSinaWeiboByAppKey:sinaWiebo_AppKey
//                                           appSecret:sinaWiebo_AppSecret
//                                         redirectUri:sinaWiebo_RedirectUri
//                                            authType:SSDKAuthTypeBoth];
//                 break;
//             case SSDKPlatformTypeWechat:
//                 [appInfo SSDKSetupWeChatByAppId:wechat_AppId
//                                       appSecret:wechat_AppSecret];
//                 break;
//             case SSDKPlatformTypeQQ:
//                 [appInfo SSDKSetupQQByAppId:qq_AppId
//                                      appKey:qq_AppKey
//                                    authType:SSDKAuthTypeBoth];
//                 break;
//             default:
//                 break;
//         }
//     }];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]) {
        [self login];
    }else{
        dengluViewController *denglu = [[dengluViewController alloc]init];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:denglu];
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];


    return YES;
}


//IOS9之后必须要在这个方法里面写，否则很可能会出现不回调的情况
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSLog(@"urlscheme:%@",url.scheme);
    if ([url.host isEqualToString:@"safepay"]) {
        
        
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        
    }
    if ([url.host isEqualToString:@"platformapi"]) {
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result 2=%@",resultDic);
        }];
    }
    if ([url.scheme isEqualToString:@"wx5f2c5ad9aff524ee"]) {
        NSLog(@"WXApi222:-*-*-*-*-*-*-");
        return [WXApi handleOpenURL:url delegate:self];
        
    }

    
    return YES;
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
    /**
     *  这里移动要注意，条件判断成功的是在播放器播放过程中返回的
     下面的是播放器没有弹出来的所支持的设备方向
//     */
//    if (self.vc.playerManager)
//    {
//        return self.vc.playerManager.supportInterOrtation;
//    }
//    else
//    {
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//}

@end
