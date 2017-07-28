//
//  imageViewController.h
//  类似微信发朋友圈图片
//
//  Created by CuiJianZhou on 16/2/2.
//  Copyright © 2016年 CJZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) NSInteger imageCount;
@property (copy  , nonatomic) void(^callBack)(NSMutableArray *delectImageIndexAry);
@end
// 屏幕宽度
#define DEVICE_WIDTH   [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define DEVICE_HEIGHT  [UIScreen mainScreen].bounds.size.height
// 导航栏
#define NAV_H   44
// Tabbar
#define TABBAR_H    49/// 根据iphone6 效果图的尺寸 算出实际设备中尺寸
#define F_I6_SIZE(f)    ( ( (int)( (DEVICE_WIDTH * ((f)/375.f)) * 2 ) ) / 2.f )
/// 根据iphone5 效果图的尺寸 算出实际设备中尺寸
#define F_I5_SIZE(f)    ( ( (int)( (DEVICE_WIDTH * ((f)/320.f)) * 2 ) ) / 2.f )