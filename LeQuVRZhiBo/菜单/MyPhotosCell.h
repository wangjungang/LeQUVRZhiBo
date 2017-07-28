//
//  MyPhotosCell.h
//  LeQuVRZhiBo
//
//  Created by 李壮 on 2016/12/23.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface imageAryObjet : NSObject
@property(nonatomic,strong)NSMutableArray*imageViews;
+ (imageAryObjet*)instance;

@end

@interface MyPhotosCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView*imageView;
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
//屏幕宽度比
#define WIDTH_SCALE [UIScreen mainScreen].bounds.size.width / 320
//屏幕高度比
#define HEIGHT_SCALE [UIScreen mainScreen].bounds.size.height / 568
//颜色RGBA
#define kCOLOR(R, G, B, A) [UIColor colorWithRed:R /255.0 green:G /255.0 blue:B /255.0 alpha:A]
