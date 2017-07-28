//
//  cityViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/21.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "cityViewController.h"
@interface cityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSMutableArray *cityGroups;
}

@end

@implementation cityViewController
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
    [self CustomBackButton];
    self.navigationItem.title = @"城市";
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置组索引字体的颜色
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityGroups" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    cityGroups = [NSMutableArray arrayWithArray:arr];
    NSLog(@"-%@-",cityGroups);
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return cityGroups.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *g = cityGroups[section];
    return [g[@"cities"] count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    NSDictionary *g = cityGroups[indexPath.section];
    
    cell.textLabel.text = g[@"cities"][indexPath.row];
    return cell;
    
    
}

#pragma mark   ==============  header  ==============
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *g = cityGroups[section];
    return g[@"title"];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // 把每一组的title装到一个数组里在返回
    return [cityGroups valueForKeyPath:@"title"];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cityGroup = cityGroups[indexPath.section];
    
    NSString *city = [NSString stringWithFormat:@"%@",cityGroup[@"cities"][indexPath.row]];
    if ([city isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"city" object:nil userInfo:@{@"city":city}];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"city2" object:nil userInfo:@{@"city2":city}];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
