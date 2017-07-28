//
//  CommunityAnswerCell.m
//  LeQuVRZhiBo
//
//  Created by 李壮 on 2016/12/16.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "CommunityAnswerCell.h"
#import "NSString+Extend.h"

@interface CommunityAnswerCell ()
{
    UILabel*lineLb;
}
@end

@implementation CommunityAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.heardImage=[[UIImageView alloc]initWithFrame:CGRectMake(F_I6_SIZE(10), F_I6_SIZE(10), F_I6_SIZE(45), F_I6_SIZE(45))];
        self.heardImage.clipsToBounds=YES;
        self.heardImage.layer.cornerRadius=F_I6_SIZE(45/2.0f);
        [self.contentView addSubview:self.heardImage];
        
        self.nickNameLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(60), F_I6_SIZE(10), DEVICE_WIDTH-F_I6_SIZE(60), F_I6_SIZE(18))];
        self.nickNameLb.font=[UIFont systemFontOfSize:F_I6_SIZE(18)];
        [self.contentView addSubview:_nickNameLb];
        
        self.contentLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(60), F_I6_SIZE(45), DEVICE_WIDTH-F_I6_SIZE(70), 0)];
        self.contentLb.font =[UIFont systemFontOfSize:F_I6_SIZE(14)];
        self.contentLb.numberOfLines=0;
        self.contentLb.numberOfLines=0;
        [self.contentView addSubview:_contentLb];
        
        self.timeLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(60), F_I6_SIZE(30), DEVICE_WIDTH-F_I6_SIZE(70), F_I6_SIZE(14))];
        self.timeLb.textColor=[UIColor grayColor];
        self.timeLb.font=[UIFont systemFontOfSize:F_I6_SIZE(12)];
        [self.contentView addSubview:self.timeLb];
        
//        self.deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//        self.deleteBtn.frame=CGRectMake(DEVICE_WIDTH-F_I6_SIZE(50), F_I6_SIZE(10), F_I6_SIZE(40), F_I6_SIZE(30));
//        [self.deleteBtn setImage:[UIImage imageNamed:@"laji"] forState:0];
//        [self.contentView addSubview:self.deleteBtn];
        
        self.answerBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.answerBtn setTitle:@"回复" forState:0];
        self.answerBtn.titleLabel.font=[UIFont systemFontOfSize:F_I6_SIZE(12)];
        [self.answerBtn setTitleColor:[UIColor whiteColor] forState:0];
        self.answerBtn.frame =CGRectMake(DEVICE_WIDTH-F_I6_SIZE(50), F_I6_SIZE(10), F_I6_SIZE(40), F_I6_SIZE(20));
        self.answerBtn.clipsToBounds=YES;
        self.answerBtn.layer.cornerRadius=5;
        self.answerBtn.backgroundColor=kCOLOR(211, 57, 86, 1);
        [self.contentView addSubview:self.answerBtn];
        lineLb =[[UILabel alloc]init];
        lineLb.backgroundColor=kCOLOR(210, 210, 210, 0.3);
        [self.contentView addSubview:lineLb];
    }
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    return self;
}
- (void)setContentData:(ReplyListData*)data
{
    if ([[USERDEFAULT valueForKey:@"uid"]isEqualToString:data.uid])
    {
        self.answerBtn.hidden=YES;
        self.deleteBtn.hidden=NO;
    }else
    {
        self.answerBtn.hidden=NO;
        self.deleteBtn.hidden=YES;
    }
    CGFloat contenTextHeight=[data.content getHeightWithFontSize:F_I6_SIZE(14) andConstrainedWidth:DEVICE_WIDTH-F_I6_SIZE(80)];
    self.timeLb.text=data.time;
    [self.heardImage setImageWithURL:[NSURL URLWithString:data.headPic] placeholderImage:[UIImage imageNamed:@"load"]];
    self.nickNameLb.text=data.nickname;
    self.contentLb.text=data.content;
    self.contentLb.frame=CGRectMake(F_I6_SIZE(60), F_I6_SIZE(45), DEVICE_WIDTH-F_I6_SIZE(70), contenTextHeight);
    data.rowHeight=contenTextHeight+F_I6_SIZE(60);
    lineLb.frame=CGRectMake(0, contenTextHeight+F_I6_SIZE(59), DEVICE_WIDTH, 1);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
