//
//  myshouyiView.m
//  LeQuVRZhiBo
//
//  Created by 王俊钢 on 2016/11/28.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "myshouyiView.h"
@interface myshouyiView()
@property (nonatomic,strong) UILabel *linelabel;
@property (nonatomic,strong) UILabel *shouyinamelab1;
@property (nonatomic,strong) UILabel *shouyinamelab2;
@end

@implementation myshouyiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shouyinumber1];
        [self addSubview:self.shouyinumber2];
        [self addSubview:self.linelabel];
        [self addSubview:self.shouyinamelab1];
        [self addSubview:self.shouyinamelab2];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.shouyinamelab1.frame = CGRectMake(self.frame.size.width/2-50, 50, 100, 30);
    self.shouyinumber1.frame = CGRectMake(0, 90, self.frame.size.width, 50);
    self.linelabel.frame = CGRectMake(0, self.frame.size.height/3, self.frame.size.width, 1);
    self.shouyinamelab2.frame = CGRectMake(self.frame.size.width/2-50, self.frame.size.height/3+30, 100, 30);
    self.shouyinumber2.frame = CGRectMake(0, self.frame.size.height/3+90, self.frame.size.width, 50);
}

#pragma mark - getters

-(UILabel *)shouyinumber1
{
    if(!_shouyinumber1)
    {
        _shouyinumber1 = [[UILabel alloc] init];
        _shouyinumber1.textColor = [UIColor wjColorFloat:@"DB3559"];
        _shouyinumber1.textAlignment = NSTextAlignmentCenter;
        _shouyinumber1.text = @"0";
        _shouyinumber1.font = [UIFont systemFontOfSize:28];
        
    }
    return _shouyinumber1;
}


-(UILabel *)shouyinumber2
{
    if(!_shouyinumber2)
    {
        _shouyinumber2 = [[UILabel alloc] init];
        _shouyinumber2.textColor = [UIColor wjColorFloat:@"DB3559"];
        _shouyinumber2.textAlignment = NSTextAlignmentCenter;
        _shouyinumber2.text = @"0";
        _shouyinumber2.font = [UIFont systemFontOfSize:28];
    }
    return _shouyinumber2;
}

-(UILabel *)shouyinamelab1
{
    if(!_shouyinamelab1)
    {
        _shouyinamelab1 = [[UILabel alloc] init];
        _shouyinamelab1.textAlignment = NSTextAlignmentCenter;
        _shouyinamelab1.text = @"乐宝余额";
        _shouyinamelab1.font = [UIFont systemFontOfSize:14];
        
    }
    return _shouyinamelab1;
}

-(UILabel *)shouyinamelab2
{
    if(!_shouyinamelab2)
    {
        _shouyinamelab2 = [[UILabel alloc] init];
        _shouyinamelab2.textAlignment = NSTextAlignmentCenter;
        _shouyinamelab2.text = @"已赚乐宝";
        _shouyinamelab2.font = [UIFont systemFontOfSize:14];
    }
    return _shouyinamelab2;
}

-(UILabel *)linelabel
{
    if(!_linelabel)
    {
        _linelabel = [[UILabel alloc] init];
        _linelabel.backgroundColor = [UIColor wjColorFloat:@"e88169"];
    }
    return _linelabel;
}

@end
