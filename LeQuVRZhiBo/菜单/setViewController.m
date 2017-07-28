//
//  setViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/11.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "setViewController.h"
#import "setTableViewCell.h"
#import "helpViewController.h"
#import "quanxianViewController.h"
#import "dengluViewController.h"
#import "guanyuViewController.h"
#import "safeViewController.h"
@interface setViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table;
    NSMutableArray *dataSource;
}


@end

@implementation setViewController

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
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
//    table.bounces = NO;
    table.showsVerticalScrollIndicator = NO;
    //    table.separatorColor = [UIColor clearColor];
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"setTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];
    
    dataSource = [[NSMutableArray alloc]initWithArray:@[@"账号与安全",@"短视频权限",@"开播提醒",@"未关注人私信",@"清理缓存",@"帮助与反馈",@"关于我们",@"网络诊断"]];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 100)];
    bottomView.backgroundColor = [UIColor whiteColor];
    table.tableFooterView = bottomView;
    
    UIButton *zhuxiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, WIDTH-40, 40)];
    [zhuxiaoBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [zhuxiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zhuxiaoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [zhuxiaoBtn setBackgroundColor:RGBColor(203, 70, 111)];
    zhuxiaoBtn.layer.cornerRadius = 5;
    zhuxiaoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [zhuxiaoBtn addTarget:self action:@selector(zhuxiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:zhuxiaoBtn];
    
}
-(void)zhuxiaoBtn:(UIButton *)btn{

    [NSObject wj_selVcWithTitle:@"退出登录" TitleExplain:nil FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:WJNewPresentFromCenter FirstOrSureBlock:^(NSString *userSelStr) {
        NSLog(@"1");
        
        
    } SecondSelOrCancelBlock:^(NSString *userSelStr) {
        NSLog(@"2");
        [AFManager getReqURL:[NSString stringWithFormat:ZHUXIAO,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
            if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [USERDEFAULT setValue:nil forKey:@"uid"];
                    [USERDEFAULT setValue:nil forKey:@"nickname"];
                    [USERDEFAULT setValue:nil forKey:@"imgUrl"];
                    [USERDEFAULT setValue:nil forKey:@"account"];
                    [USERDEFAULT setValue:nil forKey:@"token"];
                    [USERDEFAULT synchronize];
                    dengluViewController *denglu = [[dengluViewController alloc]init];
                    [self.navigationController pushViewController:denglu animated:YES];
                    
                });
            }else{
                [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"退出失败" andSelfVC:self];
                
            }
        } errorblock:^(NSError *error) {
            
        }];

    }];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        static NSString *str = @"str";
        setTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[setTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.lable.text = dataSource[indexPath.row];
        cell.button.selected = NO;
        [cell.button setImage:[UIImage imageNamed:@"_03"] forState:UIControlStateNormal];
        [cell.button setImage:[UIImage imageNamed:@"设置_03"] forState:UIControlStateSelected];
        [cell.button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }else{
        static NSString *str = @"str2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.textLabel.textColor = RGBColor(146, 146, 146);
        cell.textLabel.text = dataSource[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==4) {
           
            cell.detailTextLabel.text = @"30.05M";
            cell.detailTextLabel.textColor = RGBColor(146, 146, 146);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                
        }else{
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;

    }
    
    
}
-(void)button:(UIButton *)btn{
    if (btn.selected == NO) {
        btn.selected = YES;
    }else{
        btn.selected = NO;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 5) {
        helpViewController *help = [[helpViewController alloc]init];
        [self.navigationController pushViewController:help animated:YES];
    }
    
    if (indexPath.row == 1) {
        quanxianViewController *help = [[quanxianViewController alloc]init];
        [self.navigationController pushViewController:help animated:YES];
    }
    if (indexPath.row == 6) {
        guanyuViewController *help = [[guanyuViewController alloc]init];
        [self.navigationController pushViewController:help animated:YES];
    }
    if (indexPath.row == 0) {
        safeViewController *help = [[safeViewController alloc]init];
        [self.navigationController pushViewController:help animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
