//
//  giftView.h
//  zhibotest
//
//  Created by 李壮 on 2016/12/7.
//  Copyright © 2016年 李壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftListData.h"
@protocol giftViewDelegate <NSObject>

- (void)giftInfo:(GiftListData*)giftModel;

@end


@interface giftView : UIView
@property (nonatomic,strong)UICollectionView*collection;
@property (nonatomic,strong)UIView*bgView;
@property (nonatomic,strong)UIButton *payBtn,*giveBtn;
@property (nonatomic,assign)id<giftViewDelegate>delegate;
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
