//
//  helpViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/15.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "helpViewController.h"

@interface helpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table;
    NSMutableArray *dataSource;
}


@end

@implementation helpViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"帮助与反馈";
    self.view.backgroundColor = RGBColor(246, 246, 246);
    [self CustomBackButton];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    //    table.bounces = NO;
    table.showsVerticalScrollIndicator = NO;
    //    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"setTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];
    
    dataSource = [[NSMutableArray alloc]initWithArray:@[@"才艺频道相关",@"黑名单",@"短视频权限",@"开播提醒"]];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    view.backgroundColor = RGBColor(246, 246, 246);
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 150, 30)];
    rightLable.text = @"热门问题";
    rightLable.textColor = RGBColor(67, 67, 67);
    rightLable.font = [UIFont systemFontOfSize:14];
    rightLable.textAlignment = NSTextAlignmentLeft;
    [view addSubview:rightLable];
    table.tableHeaderView = view;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString *str = @"str2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.textLabel.textColor = RGBColor(146, 146, 146);
    cell.textLabel.text = dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==5) {
        
        cell.detailTextLabel.text = @"30.05M";
        cell.detailTextLabel.textColor = RGBColor(146, 146, 146);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        
    }else{
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
