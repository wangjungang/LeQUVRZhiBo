//
//  tixianCell.m
//  LeQuVRZhiBo
//
//  Created by 王俊钢 on 2016/11/29.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "tixianCell.h"

@interface tixianCell()

@end

@implementation tixianCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.zhifuimg];
        [self.contentView addSubview:self.zhifuname];
        [self.contentView addSubview:self.zhfuxinx];
        [self.contentView addSubview:self.choosebtn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.zhifuimg.frame = CGRectMake(10, 15, 50, 50);
    self.zhifuname.frame = CGRectMake(70, 15, 100, 25);
    self.zhfuxinx.frame = CGRectMake(70, self.frame.size.height/2+5, 300, 25);
    self.choosebtn.frame = CGRectMake(self.frame.size.width-25, self.frame.size.height/2-5, 10, 10);
}

#pragma mark - getters

-(UIImageView *)zhifuimg
{
    if(!_zhifuimg)
    {
        _zhifuimg = [[UIImageView alloc] init];
        
    }
    return _zhifuimg;
}

-(UILabel *)zhifuname
{
    if(!_zhifuname)
    {
        _zhifuname = [[UILabel alloc] init];
        
    }
    return _zhifuname;
}

-(UILabel *)zhfuxinx
{
    if(!_zhfuxinx)
    {
        _zhfuxinx = [[UILabel alloc] init];
        _zhfuxinx.font = [UIFont systemFontOfSize:12];
    }
    return _zhfuxinx;
}

-(UIButton *)choosebtn
{
    if(!_choosebtn)
    {
        _choosebtn = [[UIButton alloc] init];
        [_choosebtn addTarget:self action:@selector(choosebtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choosebtn;
}

#pragma mark - 协议方法
-(void)choosebtnclick
{
    [self.delegate myTabVClick:self];
}

@end
