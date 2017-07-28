//
//  UIViewController+Back.m
//  手保
//
//  Created by my-mac on 16/1/11.
//  Copyright © 2016年 my-mac. All rights reserved.
//

#import "UIViewController+Back.h"

@implementation UIViewController (Back)

-(void)CustomBackButton
{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, ReturnWidth, ReturnHeight);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickedCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
}

-(void)clickedCancelBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)HideNavigationLine
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }


}
@end


