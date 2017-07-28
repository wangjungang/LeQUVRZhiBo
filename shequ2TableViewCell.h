//
//  shequ2TableViewCell.h
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/23.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shequ2TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *jieshao;
@property (strong, nonatomic) IBOutlet UILabel *time;
-(void)setIntroductionText:(NSString*)text;
@end
