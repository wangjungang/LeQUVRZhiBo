//
//  NSObject+SelectedVc.m
//  Zhai
//
//  Created by 王静帅 on 16/8/9.
//  Copyright © 2016年 lechuangshidai. All rights reserved.
//

#import "NSObject+SelectedVc.h"

#define kTopAndBottom 80
#define kTitleWith 40
@implementation NSObject (SelectedVc)

/// 实现 是 否 两种选择
///
/// @param title         描述选择的标题
/// @param titleExplain  对标题进行解释
/// @param firstSel      第一个选择
/// @param secondSel     第二个选择
/// @param selfVc        调用该方法的当前类
/// @param presentStyle  呈现方式
/// @param SelFirstBlock 用户点击第一个选择的回调Block
/// @param SelSecondStr  用户点击第二个选择的回调Block
+ (void)wj_selectedVcWithTitle:(NSString *)title andTitleExplain:(NSString *)titleExplain andFirstSel:(NSString *)firstSel andSecondSel:(NSString *)secondSel andSelfVc:(UIViewController *)selfVc andPresentStyle:(JSPresentStyle)presentStyle andBackFirtsSelBlock:(js_BackFirstSelBlock) SelFirstBlock andBackSecondSelBlock:(js_BackSecondSelBlock) SelSecondStr {
    
        dispatch_async(dispatch_get_global_queue(0, 0), ^{//开一条子线程去执行作用于内代码
                UIAlertControllerStyle style;
                if (presentStyle) {
                    style = UIAlertControllerStyleAlert;
                } else {
                    style = UIAlertControllerStyleActionSheet;
                }
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:titleExplain preferredStyle:style];
                
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消"  style:UIAlertActionStyleCancel handler:nil];
                
                
                UIAlertAction* otherActionOne = [UIAlertAction actionWithTitle:firstSel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    SelFirstBlock(firstSel);
                    
                }];
                
                UIAlertAction* otherActionTwo = [UIAlertAction actionWithTitle:secondSel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    SelSecondStr(secondSel);
                    
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:otherActionOne];
                [alertController addAction:otherActionTwo];
            
                 dispatch_sync(dispatch_get_main_queue(), ^{//异步主队列和同步主队列效果等同
                //显示
                [selfVc presentViewController:alertController animated:true completion:nil];
            });
        });

}

+ (void)wj_alterSingleVCWithOneTitle:(NSString *)oneTitle andTwoTitle:(NSString *)twoTitle andSelfVC:(UIViewController *)selfVC
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:oneTitle message:twoTitle preferredStyle:  UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    
    //弹出提示框；
    [selfVC presentViewController:alert animated:YES completion:nil];

}

+ (void)wj_alterDoubleVCWithOneTitle:(NSString *)oneTitle andTwoTitle:(NSString *)twoTitle andSelfVC:(UIViewController *)selfVC andMakeSureBlock:(makeSureBlock)makeSureBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:oneTitle message:twoTitle preferredStyle:  UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
      
        makeSureBlock();
        
    }];
    
    [alert addAction:leftAction];
    [alert addAction:rightAction];
    
    //弹出提示框；
    [selfVC presentViewController:alert animated:YES completion:nil];

}


/// 实现imgView的简单缩放
///
/// @param imgUrlArr imgUrl数组
/// @param imgStr    占位图
+ (void)js_imgViewScaleWithImgUrlArr:(NSArray *)imgUrlArr andPlaceImgStr:(NSString *)imgStr {
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGRect rect = CGRectMake(0, kTopAndBottom, screenWith, screenHeight - kTopAndBottom * 2);
    UIScrollView *scr = [[UIScrollView alloc] initWithFrame:rect];
    scr.showsVerticalScrollIndicator = NO;
    scr.showsHorizontalScrollIndicator = NO;
    scr.pagingEnabled = YES;
    scr.contentSize = CGSizeMake(screenWith * imgUrlArr.count, 0);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickScr:)];
    [scr addGestureRecognizer:tap];
    
    [imgUrlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * screenWith, (screenHeight - kTopAndBottom * 2 - screenWith)/2, screenWith, screenWith)];
        //        [imgView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:imgStr]];
        imgView.image = [UIImage imageNamed:obj];
        [scr addSubview:imgView];
        
        
    }];
    
    UIView *bjView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bjView.backgroundColor = [UIColor blackColor];
    [bjView addSubview:scr];
    [[UIApplication sharedApplication].keyWindow addSubview:bjView];
}

- (void)clickScr:(UIScrollView*) scr {
    
    [[UIApplication sharedApplication].keyWindow.subviews.lastObject removeFromSuperview];
}

@end

