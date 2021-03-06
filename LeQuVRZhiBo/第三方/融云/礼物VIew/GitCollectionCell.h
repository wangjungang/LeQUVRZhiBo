//
//  GitCollectionCell.h
//  zhibotest
//
//  Created by 李壮 on 2016/12/7.
//  Copyright © 2016年 李壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftListData.h"

@protocol  GitCollectionCellDelegate <NSObject>

- (void)sendBtnIndex:(NSInteger)btnIndex;

@end


@interface GitCollectionCell : UICollectionViewCell
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UIImageView*giftImage,*goldImage;
@property (nonatomic,strong)UIButton*selectBtn,*btn1,*btn2,*btn3,*btn4,*btn5;
@property (nonatomic,strong)UIButton*btn6,*btn7,*btn8,*btn9,*btn10;
@property (nonatomic,strong)UILabel *typeLb;
@property (nonatomic,strong)UILabel*numLb;
@property (nonatomic,assign)NSInteger btnIndex;
@property (nonatomic,copy)void(^myBlock)(NSInteger btnIndex);
@property (nonatomic,assign)id<GitCollectionCellDelegate>delegate;
- (void)btnIndex:(NSIndexPath*)indexPath data:(NSArray*)data ;
- (void)setBtnStatus:(NSInteger)index status:(BOOL)btnStatus;
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
