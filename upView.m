//
//  upView.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/7.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "upView.h"
#import "upViewTableViewCell.h"
@implementation upView
{
    
    UITableView *table;
    NSMutableArray *dataSource;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.bounces = NO;
        table.showsVerticalScrollIndicator = NO;
//        table.separatorColor = [UIColor clearColor];
        table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:table];
        table.backgroundColor = [UIColor clearColor];
        dataSource = [[NSMutableArray alloc]initWithArray:@[@"分享",@"翻转",@"美艳",@"镜像"]];
        [table registerNib:[UINib nibWithNibName:@"upViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];
    }
    return self;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"str";
    upViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[upViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.lable.text = dataSource[indexPath.row];
    cell.lable.textColor = RGBColor(69, 69, 69);
    cell.button.selected = NO;
    cell.button.tag = 500+indexPath.row;
    [cell.button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == 0) {
        [cell.button setImage:[[UIImage imageNamed:@"直播-正在直播_01_03"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [cell.button setImage:[[UIImage imageNamed:@"直播-正在直播1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];

    }else if (indexPath.row == 1) {
        [cell.button setImage:[[UIImage imageNamed:@"直播-正在直播_01_06"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [cell.button setImage:[[UIImage imageNamed:@"直播-正在直播2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    }else if (indexPath.row == 2) {
        [cell.button setImage:[[UIImage imageNamed:@"直播-正在直播_01_08"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [cell.button setImage:[[UIImage imageNamed:@"直播-正在直播3"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    }else if (indexPath.row == 3) {
        [cell.button setImage:[[UIImage imageNamed:@"直播-正在直播"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [cell.button setImage:[[UIImage imageNamed:@"直播-正在直播_01_10"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(void)button:(UIButton *)btn{

    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndexNum:)]) {
        [self.delegate selectIndexNum:[NSString stringWithFormat:@"%ld",(long)btn.tag-500]];
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"upview" object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%ld",(long)indexPath.row]}];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectIndexNum:)]) {
        [self.delegate selectIndexNum:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"upview" object:nil userInfo:@{@"index":[NSString stringWithFormat:@"%ld",(long)indexPath.row]}];
    }
    upViewTableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    for (upViewTableViewCell *cell2 in [table visibleCells]) {
        if (cell == cell2) {
            cell.button.selected = YES;
            cell.lable.textColor = [UIColor redColor];
            
        }else{
            cell2.button.selected = NO;
            cell2.lable.textColor = RGBColor(69, 69, 69);

        }
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
