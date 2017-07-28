//
//  guanyuViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/28.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "guanyuViewController.h"
#import "guanyudetailViewController.h"
@interface guanyuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *table;
    NSMutableArray *dataSource;
}


@end

@implementation guanyuViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *segeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 542.f/750.f*WIDTH+64)];
    
    UIImageView *backView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    backView2.image = [UIImage imageNamed:@"11"];
    [segeView addSubview:backView2];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 542.f/750.f*WIDTH)];
    backView.image = [UIImage imageNamed:@"登录"];
    [segeView addSubview:backView];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    lable.text = @"关于我们";
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:22];
    lable.textAlignment = NSTextAlignmentCenter;
    [segeView addSubview:lable];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(20, 30, ReturnWidth, ReturnHeight);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickedCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [segeView addSubview:cancelBtn];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
//    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    dataSource = [[NSMutableArray alloc]initWithArray:@[@"社区公约",@"隐私政策",@"服务条款",@"联系我们"]];
    table.tableHeaderView = segeView;

}
-(void)clickedCancelBtn{

    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"str";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text = dataSource[indexPath.row];
    cell.textLabel.textColor = RGBColor(69, 69, 69);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    guanyudetailViewController *guanyu = [[guanyudetailViewController alloc]init];
    if (indexPath.row == 0) {
        guanyu.title = @"社区公约";
    }else if(indexPath.row == 1){
        guanyu.title = @"隐私政策";
    }else if(indexPath.row == 2){
        guanyu.title = @"服务条款";
    }else if(indexPath.row == 3){
        guanyu.title = @"联系我们";
    }
    [self.navigationController pushViewController:guanyu animated:YES];
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
