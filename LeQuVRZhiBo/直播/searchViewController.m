//
//  searchViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/20.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "searchViewController.h"
#import "searchTableViewCell.h"
#import "personInfoViewController.h"
@interface searchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *rightLable;
    UITableView *table;
    NSMutableArray *dataSource;
    UILabel *tuijian;
}
@end

@implementation searchViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

    [AFManager getReqURL: [NSString stringWithFormat:SOUSUOQIAN] block:^(id infor) {
        NSLog(@"%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:infor[@"data"]];
            [table reloadData];
        }else{
            [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"没有更多粉丝" andSelfVC:self];
        }
    } errorblock:^(NSError *error) {
        
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CustomBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *search = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-100, 30)];
    search.layer.borderWidth = 1;
    search.layer.cornerRadius = 15;
    search.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1];
    search.layer.borderColor = [[UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1]CGColor];
    search.userInteractionEnabled = YES;
    [self.navigationItem setTitleView:search];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"搜索_03"] forState:UIControlStateNormal];
    [search addSubview:leftBtn];
    rightLable = [[UITextField alloc]initWithFrame:CGRectMake(30, 0, self.view.frame.size.width - 100, 30)];
    rightLable.placeholder = @"请输入昵称或频道号";
    rightLable.delegate = self;
    rightLable.font = [UIFont systemFontOfSize:12];
    rightLable.textAlignment = NSTextAlignmentLeft;
    rightLable.textColor = [UIColor colorWithRed:185/255.f green:185/255.f blue:185/255.f alpha:1];
    [search addSubview:rightLable];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(pressSearch:)];
    self.navigationItem.rightBarButtonItem = item;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    tuijian = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 60, 40)];
    tuijian.text = @"今日推荐";
    tuijian.font = [UIFont systemFontOfSize:12];
    tuijian.textAlignment = NSTextAlignmentLeft;
    [view addSubview:tuijian];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    view2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:view2];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    //    table.bounces = NO;
    table.showsVerticalScrollIndicator = NO;
    //    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    table.tableHeaderView = view;
    dataSource = [[NSMutableArray alloc]init];
    table.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];
    [table registerNib:[UINib nibWithNibName:@"searchTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    personInfoViewController *person = [[personInfoViewController alloc]init];
    person.uid = dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:person animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"str";
    searchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[searchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.name.text = dataSource[indexPath.row][@"nickname"];
    cell.jieshao.text = dataSource[indexPath.row][@"auto"];
    if ([dataSource[indexPath.row][@"levelid"] isEqual:[NSNull null]]) {
        cell.level.text = @"";

        
    }else{

        cell.level.text = dataSource[indexPath.row][@"levelid"];

    }
    [cell.avatar setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"head_pic"]]];
    cell.avatar.layer.cornerRadius = 25;
    cell.avatar.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


-(void)pressSearch:(UIBarButtonItem *)item{

    [AFManager postReqURL:SOUSUOHOU reqBody:@{@"content":rightLable.text} block:^(id infor) {
        NSLog(@"%@--",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            tuijian.text = @"搜索结果";
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:infor[@"data"]];
            [table reloadData];
            rightLable.text = @"";
            

        }else{
            tuijian.text = @"没有搜索结果";
            [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"没有更多信息" andSelfVC:self];
            [dataSource removeAllObjects];
            [table reloadData];
            rightLable.text = @"";



        }
    }];
    
   
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [rightLable resignFirstResponder];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    rightLable.text = @"";
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
