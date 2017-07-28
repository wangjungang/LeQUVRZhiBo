//
//  gengduoViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/28.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "gengduoViewController.h"
#import "gengduoTableViewCell.h"

@interface gengduoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *table;
    NSMutableArray *dataSource;
}



@end

@implementation gengduoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [AFManager getReqURL:MOREZHUBO block:^(id infor) {
        NSLog(@"%@--",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:infor[@"data"]];
            [table reloadData];
        }else{
            [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"没有更多主播" andSelfVC:self];
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
    self.navigationItem.title = @"更多";
    [self CustomBackButton];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    dataSource = [[NSMutableArray alloc]init];
    table.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];

    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"str";
    gengduoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[gengduoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }

    cell.name.text = dataSource[indexPath.row][@"type"];
    if ([dataSource[indexPath.row][@"user"] count]==3) {
        cell.juli1.text = dataSource[indexPath.row][@"user"][0][@"nickname"];
        cell.juli2.text = dataSource[indexPath.row][@"user"][1][@"nickname"];
        cell.juli3.text = dataSource[indexPath.row][@"user"][2][@"nickname"];
        [cell.avatar1 setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"user"][0][@"head_pic"]] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.avatar1.tag = [dataSource[indexPath.row][@"user"][0][@"id"] intValue]+500;
        cell.avatar1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
        [cell.avatar1 addGestureRecognizer:tap];
        [cell.avatar2 setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"user"][1][@"head_pic"]] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.avatar2.tag = [dataSource[indexPath.row][@"user"][1][@"id"] intValue]+500;
        cell.avatar2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
        [cell.avatar2 addGestureRecognizer:tap2];
        [cell.avatar3 setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"user"][2][@"head_pic"]] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.avatar3.tag = [dataSource[indexPath.row][@"user"][2][@"id"] intValue]+500;
        cell.avatar3.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap3:)];
        [cell.avatar3 addGestureRecognizer:tap3];
        cell.avatar1.hidden = NO;
        cell.avatar2.hidden = NO;
        cell.avatar3.hidden = NO;
        cell.view1.hidden = NO;
        cell.view2.hidden = NO;
        cell.view3.hidden = NO;


    }else if ([dataSource[indexPath.row][@"user"] count]==2){
        cell.juli1.text = dataSource[indexPath.row][@"user"][0][@"nickname"];
        cell.juli2.text = dataSource[indexPath.row][@"user"][1][@"nickname"];
        cell.juli3.hidden = YES;
        [cell.avatar1 setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"user"][0][@"head_pic"]] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.avatar1.tag = [dataSource[indexPath.row][@"user"][0][@"id"] intValue]+500;
        cell.avatar1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
        [cell.avatar1 addGestureRecognizer:tap];
        [cell.avatar2 setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"user"][1][@"head_pic"]] placeholderImage:[UIImage imageNamed:@"load"]] ;
        cell.avatar2.tag = [dataSource[indexPath.row][@"user"][1][@"id"] intValue]+500;
        cell.avatar2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2:)];
        [cell.avatar2 addGestureRecognizer:tap2];
        cell.avatar1.hidden = NO;
        cell.avatar2.hidden = NO;
        cell.avatar3.hidden = YES;
        cell.view1.hidden = NO;
        cell.view2.hidden = NO;
        cell.view3.hidden = YES;
    }else{
        
        cell.juli1.text = dataSource[indexPath.row][@"user"][0][@"nickname"];
        cell.juli2.hidden = YES;
        cell.juli3.hidden = YES;
        [cell.avatar1 setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"user"][0][@"head_pic"]] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.avatar1.tag = [dataSource[indexPath.row][@"user"][0][@"id"] intValue]+500;
        cell.avatar1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1:)];
        [cell.avatar1 addGestureRecognizer:tap];
        cell.avatar1.hidden = NO;
        cell.avatar2.hidden = YES;
        cell.avatar3.hidden = YES;
        cell.view1.hidden = NO;
        cell.view2.hidden = YES;
        cell.view3.hidden = YES;
        
    }
    

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tap1:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld",(long)tap.view.tag);
}
-(void)tap2:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld",(long)tap.view.tag);
}
-(void)tap3:(UITapGestureRecognizer *)tap{
    NSLog(@"%ld",(long)tap.view.tag);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (self.view.frame.size.width-40)/3+40+10+25;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
