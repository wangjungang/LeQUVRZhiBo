//
//  NotNetworkView.m
//  YeWenOwner
//
//  Created by HOSO MAC 1 on 16/9/19.
//  Copyright © 2016年 HOSO Mac2. All rights reserved.
//

#import "NotNetworkView.h"

@implementation NotNetworkView
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        CGFloat height=self.frame.size.height;
//        self.backgroundColor=YEWEN_GAY;
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH/2-50, height/2-90, 100, 80)];
        image.image=[UIImage imageNamed:@"WIFI@3x.png"];
        [self addSubview:image];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0,height/2, DEVICE_WIDTH, 30)];
        lable.text=@"网络请求失败";
        lable.textAlignment=1;
        lable.font=[UIFont systemFontOfSize:15];
        [self addSubview:lable];
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0,height/2+30, DEVICE_WIDTH, 40)];
        lable1.numberOfLines=0;
        lable1.text=@"请检查您的网络\n重新加载吧";
        lable1.textAlignment=1;
        lable1.textColor=[UIColor grayColor];
        lable1.font=[UIFont systemFontOfSize:13];
        [self addSubview:lable1];
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame=CGRectMake(DEVICE_WIDTH/2-50, height/2+80, 100, 30);
        [btn setTitle:@"重新加载" forState:0];
        [btn  setTitleColor:[UIColor blackColor] forState:0];
        btn.backgroundColor =[UIColor whiteColor];
        btn.layer.borderColor=[[UIColor blackColor]CGColor];
        btn.layer.borderWidth=1.0f;
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)btnClick
{
    _notNetworkBlock();
}
@end
