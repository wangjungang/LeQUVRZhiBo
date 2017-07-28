//
//  gengduoTableViewCell.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/28.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "gengduoTableViewCell.h"

@implementation gengduoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}
-(void)createUI{
    CGRect rx = [UIScreen mainScreen].bounds;
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rx.size.width, 40)];
    self.headView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.headView];
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
    self.name.font = [UIFont systemFontOfSize:12];
    self.name.textAlignment = NSTextAlignmentLeft;
    self.name.textColor = RGBColor(69, 69, 69);
    [self.headView addSubview:self.name];
    self.avatar1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, (rx.size.width-40)/3, (rx.size.width-40)/3)];
    [self.contentView addSubview:self.avatar1];
    
    self.avatar2 = [[UIImageView alloc]initWithFrame:CGRectMake(10+(rx.size.width-40)/3+10, 40, (rx.size.width-40)/3, (rx.size.width-40)/3)];
    [self.contentView addSubview:self.avatar2];
    
    self.avatar3 = [[UIImageView alloc]initWithFrame:CGRectMake(10+(rx.size.width-40)/3*2+20, 40, (rx.size.width-40)/3, (rx.size.width-40)/3)];
    [self.contentView addSubview:self.avatar3];
    
    self.view1 = [[UIView alloc]initWithFrame:CGRectMake(10, (rx.size.width-40)/3+40+10, 30, 20)];
    self.view1.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.view1];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 10, 10)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"乐排行_03.2"] forState:UIControlStateNormal];
    [self.view1 addSubview:leftBtn];
    
    self.juli1 = [[UILabel alloc]initWithFrame:CGRectMake(45, (rx.size.width-40)/3+40+10, (rx.size.width-40)/3-40, 20)];
    self.juli1.font = [UIFont systemFontOfSize:12];
    self.juli1.textAlignment = NSTextAlignmentLeft;
    self.juli1.textColor = RGBColor(69, 69, 69);
    [self.contentView addSubview:self.juli1];
    
    self.view2 = [[UIView alloc]initWithFrame:CGRectMake(10+(rx.size.width-40)/3+10, (rx.size.width-40)/3+40+10, 30, 20)];
    self.view2.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.view2];
    
    UIButton *leftBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 10, 10)];
    [leftBtn2 setBackgroundImage:[UIImage imageNamed:@"乐排行_03.2"] forState:UIControlStateNormal];
    [self.view2 addSubview:leftBtn2];
    
    self.juli2 = [[UILabel alloc]initWithFrame:CGRectMake(45+(rx.size.width-40)/3+10, (rx.size.width-40)/3+40+10, (rx.size.width-40)/3-40, 20)];
    self.juli2.font = [UIFont systemFontOfSize:12];
    self.juli2.textAlignment = NSTextAlignmentLeft;
    self.juli2.textColor = RGBColor(69, 69, 69);
    [self.contentView addSubview:self.juli2];
    
    self.view3 = [[UIView alloc]initWithFrame:CGRectMake(10+(rx.size.width-40)/3*2+20, (rx.size.width-40)/3+40+10, 30, 20)];
    self.view3.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.view3];
    
    UIButton *leftBtn3 = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 10, 10)];
    [leftBtn3 setBackgroundImage:[UIImage imageNamed:@"乐排行_03.2"] forState:UIControlStateNormal];
    [self.view3 addSubview:leftBtn3];
    
    self.juli3 = [[UILabel alloc]initWithFrame:CGRectMake(45+(rx.size.width-40)/3*2+20, (rx.size.width-40)/3+40+10, (rx.size.width-40)/3-40, 20)];
    self.juli3.font = [UIFont systemFontOfSize:12];
    self.juli3.textAlignment = NSTextAlignmentLeft;
    self.juli3.textColor = RGBColor(69, 69, 69);
    [self.contentView addSubview:self.juli3];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
