//
//  safeCell.m
//  LeQuVRZhiBo
//
//  Created by 王俊钢 on 2016/11/29.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "safeCell.h"
@interface safeCell()
@property (nonatomic,strong) UILabel *textlab;

@end
@implementation safeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.textlab];
        [self.contentView addSubview:self.nextlab];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textlab.frame = CGRectMake(15, 10, 100, 30);
    self.nextlab.frame = CGRectMake(self.frame.size.width-80, 15, 60, 20);
}

#pragma mark - getters


-(UILabel *)textlab
{
    if(!_textlab)
    {
        _textlab = [[UILabel alloc] init];
        _textlab.text = @"手机绑定";
        _textlab.font = [UIFont systemFontOfSize:15];
        _textlab.textColor = [UIColor wjColorFloat:@"CCCDCE"];
    }
    return _textlab;
}

-(UILabel *)nextlab
{
    if(!_nextlab)
    {
        _nextlab = [[UILabel alloc] init];
        _nextlab.text = @"未绑定";
        _nextlab.textColor = [UIColor redColor];
        _nextlab.font = [UIFont systemFontOfSize:12];
    }
    return _nextlab;
}


@end
