//
//  UIBarButtonItem+Extension.m
//  河科院微博
//
//  Created by 👄 on 15/6/4.
//  Copyright (c) 2015年 sczy. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+(UIBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName higImageName:(NSString *)higIamgeName action:(SEL)action target:(id)target
{
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageWithName:higIamgeName] forState:UIControlStateHighlighted];
    btn1.size = btn1.currentImage.size;
    
    [btn1 addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn1];
}

@end
