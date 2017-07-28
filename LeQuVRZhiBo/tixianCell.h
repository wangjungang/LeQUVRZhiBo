//
//  tixianCell.h
//  LeQuVRZhiBo
//
//  Created by 王俊钢 on 2016/11/29.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import <UIKit/UIKit.h>
//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(UITableViewCell *)cell;

@end
@interface tixianCell : UITableViewCell
@property (nonatomic,strong) UIImageView *zhifuimg;
@property (nonatomic,strong) UILabel *zhifuname;
@property (nonatomic,strong) UILabel *zhfuxinx;
@property (nonatomic,strong) UIButton *choosebtn;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
