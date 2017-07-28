//
//  MyPhotosCell.m
//  LeQuVRZhiBo
//
//  Created by 李壮 on 2016/12/23.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "MyPhotosCell.h"

@implementation MyPhotosCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self)
    {
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (DEVICE_WIDTH-40)/3, (DEVICE_WIDTH-40)/3)];
        _imageView.userInteractionEnabled=YES;
        [self.contentView addSubview:_imageView];
        [[imageAryObjet instance].imageViews addObject:_imageView];
        NSLog(@"走几次啊");
    }
    return self;
}
@end

@implementation imageAryObjet
static imageAryObjet*imageObject;
+(instancetype)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageObject=[[imageAryObjet alloc]init];
        imageObject.imageViews=[NSMutableArray array];
    });
    return imageObject;
}

@end
