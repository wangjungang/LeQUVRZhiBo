//
//  UIImage+Extension.m
//  河科院微博
//
//  Created by 👄 on 15/6/4.
//  Copyright (c) 2015年 sczy. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
// 如果是iOS7，自动在图片名后面加上_os7
+(UIImage *)imageWithName:(NSString *)name
{
    
    UIImage *image = nil;
 
    
    // 如果是6或者7（67同用一张）image都为空！
    if (!image) {
        image = [UIImage imageNamed:name];
    }
    return image;
}


@end
