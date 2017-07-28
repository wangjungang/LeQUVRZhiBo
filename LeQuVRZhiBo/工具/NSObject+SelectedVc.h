//
//  NSObject+SelectedVc.h
//  Zhai
//
//  Created by 王静帅 on 16/8/9.
//  Copyright © 2016年 lechuangshidai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JSPresentStyle) {
    JSPresentFromBottom = 0,
    JSPresentFromCenter,
};

typedef void (^js_BackFirstSelBlock)(NSString *userSelStr);
typedef void (^js_BackSecondSelBlock)(NSString *userSelStr);
//确定按钮
typedef void (^makeSureBlock)();

@interface NSObject (SelectedVc)

/**
 目的:实现 是、否 两种选择 和 底部 中心 两种呈现方式,并传递选择后的内容和点击事件
 */
+ (void)wj_selectedVcWithTitle:(NSString *)title andTitleExplain:(NSString *)titleExplain andFirstSel:(NSString *)firstSel andSecondSel:(NSString *)secondSel andSelfVc:(UIViewController *)selfVc andPresentStyle:(JSPresentStyle)presentStyle andBackFirtsSelBlock:(js_BackFirstSelBlock) SelFirstBlock andBackSecondSelBlock:(js_BackSecondSelBlock) SelSecondStr;


/**
 目的:单个提示框,仅提示功能
 */
+ (void)wj_alterSingleVCWithOneTitle:(NSString *)oneTitle andTwoTitle:(NSString *)twoTitle andSelfVC:(UIViewController *)selfVC;


/**
 目的:提示框,两个选择,可确定和取消
 */
+ (void)wj_alterDoubleVCWithOneTitle:(NSString *)oneTitle andTwoTitle:(NSString *)twoTitle andSelfVC:(UIViewController *)selfVC andMakeSureBlock:(makeSureBlock)makeSureBlock;

/**
 目的:实现imgView上的图片的简单缩放
 */
+ (void)js_imgViewScaleWithImgUrlArr:(NSArray *)imgUrlArr andPlaceImgStr:(NSString *)imgStr;

@end
