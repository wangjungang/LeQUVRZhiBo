//
//  dongtai2TableViewCell.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/23.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "dongtai2TableViewCell.h"
#define kIntroLabelFont [UIFont systemFontOfSize:14]

@implementation dongtai2TableViewCell
-(void)setIntroductionText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.jieshao.text = text;
    //设置label的最大行数
    self.jieshao.numberOfLines = 0;
    
    CGSize size = CGSizeMake(self.jieshao.size.width, 1000);
    NSDictionary *attributeDict = @{NSFontAttributeName : kIntroLabelFont};
    
    CGSize introLabelSize = [self.jieshao.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size;
    
    self.jieshao.frame = CGRectMake(self.jieshao.frame.origin.x, self.jieshao.frame.origin.y, introLabelSize.width, introLabelSize.height);
    
    //计算出自适应的高度
    frame.size.height = introLabelSize.height+202;
//    NSLog(@"--%f",frame.size.height);
    self.frame = frame;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
