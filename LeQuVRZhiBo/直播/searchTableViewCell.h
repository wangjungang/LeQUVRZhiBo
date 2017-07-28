//
//  searchTableViewCell.h
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/21.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *jieshao;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *level;
@end
