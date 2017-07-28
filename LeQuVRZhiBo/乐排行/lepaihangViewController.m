//
//  lepaihangViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/7.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "lepaihangViewController.h"
#import "lepaihangTableViewCell.h"
#import "lepaihang2TableViewCell.h"

#import "personInfoViewController.h"
@interface lepaihangViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table;
    NSMutableArray *dataSource;
    UIView *view;
}


@end

@implementation lepaihangViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [AFManager getReqURL:MEILI block:^(id infor) {
        NSLog(@"--%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:infor[@"data"]];
            [table reloadData];
            
        }
    } errorblock:^(NSError *error) {
        
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"left" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"right" object:nil];
}
-(void)left:(id)user{
    if ([[user userInfo][@"left"] isEqualToString:@"2"]) {
        zhiboingViewController *zhiboing = [[zhiboingViewController alloc] init];
        [self.navigationController pushViewController:zhiboing animated:YES];
    }
    
}
-(void)right:(id)user{
    if ([[user userInfo][@"right"] isEqualToString:@"2"]) {
        [self presentViewController:[SmallVideoController new] animated:YES completion:nil];
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(left:) name:@"left" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(right:) name:@"right" object:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11"]forBarMetrics:UIBarMetricsDefault];
    UIView *segeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 114)];
    
    [self.view addSubview:segeView];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 114)];
    backView.image = [UIImage imageNamed:@"11"];
    [segeView addSubview:backView];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    lable.text = @"乐排行";
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:22];
    lable.textAlignment = NSTextAlignmentCenter;
    [segeView addSubview:lable];
    NSArray *array = [NSArray arrayWithObjects:@"魅力排行",@"土豪排行", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    //设置frame
    segment.frame = CGRectMake(40, 74, self.view.frame.size.width-80, 30);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = [UIColor whiteColor];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],
                         NSForegroundColorAttributeName,
                         [UIFont boldSystemFontOfSize:14],
                         NSFontAttributeName,nil];
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                          NSForegroundColorAttributeName,
                          [UIFont boldSystemFontOfSize:14],
                          NSFontAttributeName,nil];
    [segment setTitleTextAttributes:dic2 forState:UIControlStateNormal];
    [segment setTitleTextAttributes:dic forState:UIControlStateSelected];
    //添加到视图
    [segeView addSubview:segment];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    view.backgroundColor = [UIColor whiteColor];
    view.hidden = YES;
    /*
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    image.image = [UIImage imageNamed:@"2222"];
    [view addSubview:image];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-40-70, 60, 70, 70)];
    image2.image = [UIImage imageNamed:@"q"];
    [view addSubview:image2];
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-80/2, 20, 80, 80)];
    image3.image = [UIImage imageNamed:@"qqqq"];
    [view addSubview:image3];
    UIImageView *image4 = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/1.8+30, 85, 60, 60)];
    image4.image = [UIImage imageNamed:@"qqq"];
    [view addSubview:image4];
    */
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, self.view.frame.size.height-114-44) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    dataSource = [[NSMutableArray alloc]init];
//    table.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];
    [table registerNib:[UINib nibWithNibName:@"lepaihangTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];
    [table registerNib:[UINib nibWithNibName:@"lepaihang2TableViewCell" bundle:nil] forCellReuseIdentifier:@"str2"];

    table.tableHeaderView = view;
    

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<=2) {
        static NSString *str = @"str";
        lepaihangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[lepaihangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.avatar.layer.cornerRadius = 30;
        cell.avatar.layer.masksToBounds = YES;
        [cell.avatar setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"head_pic"]] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.name.text = dataSource[indexPath.row][@"nickname"];
        cell.money.text = dataSource[indexPath.row][@"earn"];
        if (indexPath.row==0) {
            cell.dengji.image = [UIImage imageNamed:@"乐排行_03.3"];
        }else if (indexPath.row==1) {
            cell.dengji.image = [UIImage imageNamed:@"乐排行_03.1"];

        }else{
            cell.dengji.image = [UIImage imageNamed:@"乐排行_03.2"];

        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else{
        static NSString *str = @"str2";
        lepaihang2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[lepaihang2TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.avatar.layer.cornerRadius = 30;
        cell.avatar.layer.masksToBounds = YES;
        [cell.avatar setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"head_pic"]] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.name.text = dataSource[indexPath.row][@"nickname"];
        cell.money.text = dataSource[indexPath.row][@"earn"];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    personInfoViewController *person = [[personInfoViewController alloc]init];
    person.uid = dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:person animated:YES];
}
-(void)change:(UISegmentedControl *)sender{
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"1");
        view.frame = CGRectMake(0, 0, WIDTH, 0);
        view.hidden = YES;
        [AFManager getReqURL:MEILI block:^(id infor) {
            NSLog(@"--%@",infor);
            if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                [dataSource removeAllObjects];
                [dataSource addObjectsFromArray:infor[@"data"]];
                [table reloadData];
                
            }
        } errorblock:^(NSError *error) {
            
        }];

    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"2");
        view.frame = CGRectMake(0, 0, WIDTH, 0);
        view.hidden = YES;
        [AFManager getReqURL:TUHAO block:^(id infor) {
            NSLog(@"--%@",infor);
            if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                [dataSource removeAllObjects];
                [dataSource addObjectsFromArray:infor[@"data"]];
                [table reloadData];
                
            }
        } errorblock:^(NSError *error) {
            
        }];
    }
    /*
    else if (sender.selectedSegmentIndex == 2){
        NSLog(@"3");
        view.frame = CGRectMake(0, 0, WIDTH, 0);
        view.hidden = YES;
        dataSource = [[NSMutableArray alloc]initWithArray:@[@"",@"",@"",@"",@""]];
        [table reloadData];
    }
     */
    
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
