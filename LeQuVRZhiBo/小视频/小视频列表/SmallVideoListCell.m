//
//  SmallVideoListCell.m
//  LeQuVRZhiBo
//
//  Created by 李壮 on 2016/12/28.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "SmallVideoListCell.h"
#import "NSString+Extend.h"
@interface SmallVideoListCell ()

@end

@implementation SmallVideoListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _headerImage=[[UIImageView alloc]initWithFrame:CGRectMake(F_I6_SIZE(10), F_I6_SIZE(10), F_I6_SIZE(45), F_I6_SIZE(45))];
        _headerImage.clipsToBounds=YES;
        _headerImage.layer.cornerRadius=F_I6_SIZE(22.5);
        [self.contentView addSubview:_headerImage];
        
        _nickLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(56), F_I6_SIZE(10), DEVICE_WIDTH-F_I6_SIZE(60), F_I6_SIZE(16))];
        _nickLb.font =[UIFont systemFontOfSize:F_I6_SIZE(15)];
        [self.contentView addSubview:_nickLb];
        
        _peopleCountLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(10), F_I6_SIZE(10), DEVICE_WIDTH-F_I6_SIZE(20), F_I6_SIZE(16))];
        _peopleCountLb.textAlignment=2;
        _peopleCountLb.font =[UIFont systemFontOfSize:F_I6_SIZE(15)];
        [self.contentView addSubview:_peopleCountLb];
        
        _contentLb =[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(56), F_I6_SIZE(27), DEVICE_WIDTH-F_I6_SIZE(66), 0)];
        _contentLb.font =[UIFont systemFontOfSize:F_I6_SIZE(15)];
        _contentLb.numberOfLines=0;
        [self.contentView addSubview:_contentLb];
    
        _videoImage=[[UIImageView alloc]initWithFrame:CGRectMake(F_I6_SIZE(56), _contentLb.frame.origin.y+_contentLb.frame.size.height+F_I6_SIZE(5), F_I6_SIZE(80), F_I6_SIZE(80))];
        _videoImage.userInteractionEnabled=YES;
        [self.contentView addSubview:_videoImage];
        _startBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        _startBtn.bounds=CGRectMake(0, 0, F_I6_SIZE(30), F_I6_SIZE(30));
        _startBtn.frame=CGRectMake(F_I6_SIZE(25), F_I6_SIZE(25), F_I6_SIZE(30), F_I6_SIZE(30));
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"视频列表_06.png"] forState:0];
//        _startBtn.center=_videoImage.center;
        [_videoImage addSubview:_startBtn];
        _addTimeLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(56), _videoImage.frame.origin.y+_videoImage.frame.size.height+F_I6_SIZE(5), DEVICE_WIDTH, F_I6_SIZE(15))];
        _addTimeLb.font=[UIFont systemFontOfSize:F_I6_SIZE(15)];
        _addTimeLb.textColor=[UIColor grayColor];
        [self.contentView addSubview:_addTimeLb];
    }
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    return self;
}
- (void)setCellData:(SmallVideoListData*)data
{
    [_headerImage setImageWithURL:[NSURL URLWithString:data.headPic] placeholderImage:[UIImage imageNamed:@"load"]];
    _nickLb.text=data.nickname;
    
    CGFloat height=[data.content getHeightWithFontSize:F_I6_SIZE(15) andConstrainedWidth:DEVICE_WIDTH-F_I6_SIZE(70)];
    _contentLb.frame=CGRectMake(F_I6_SIZE(56), F_I6_SIZE(27), DEVICE_WIDTH-F_I6_SIZE(66), height);
    _videoImage.frame=CGRectMake(F_I6_SIZE(56), _contentLb.frame.origin.y+_contentLb.frame.size.height+F_I6_SIZE(5), F_I6_SIZE(80), F_I6_SIZE(80));
    _addTimeLb.frame=CGRectMake(F_I6_SIZE(56), _videoImage.frame.origin.y+_videoImage.frame.size.height+F_I6_SIZE(5), DEVICE_WIDTH, F_I6_SIZE(15));
    
    _addTimeLb.text=data.utime;
    _contentLb.text=data.content;
    _peopleCountLb.text=[NSString stringWithFormat:@"%@人看过",data.count];
    [_videoImage setImageWithURL:[NSURL URLWithString:data.img] placeholderImage:[UIImage imageNamed:@"load"]];
    
    data.rowHeight=_addTimeLb.frame.origin.y+F_I6_SIZE(20);
}
@end
