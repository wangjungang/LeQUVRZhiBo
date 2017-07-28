//
//  myLivingViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/14.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "myLivingViewController.h"

@interface myLivingViewController ()

@end

@implementation myLivingViewController
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
    self.navigationItem.title = @"我的直播";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 150, 30)];
    leftLable.text = @"0个精彩回放";
    leftLable.textColor = RGBColor(69, 69, 69);
    leftLable.font = [UIFont systemFontOfSize:12];
    leftLable.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:leftLable];
    UIButton *newBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-100, 5, 40, 30)];
    [newBtn setTitle:@"最新" forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = [UIFont systemFontOfSize:14];

    [newBtn addTarget:self action:@selector(newBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBtn];
    
    UIButton *hotBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-50, 5, 40, 30)];
    [hotBtn setTitle:@"最热" forState:UIControlStateNormal];
    [hotBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    hotBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [hotBtn addTarget:self action:@selector(hotBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hotBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView];
    
    UILabel *leftLable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, WIDTH, 30)];
    leftLable2.text = @"您没有开过直播";
    leftLable2.textColor = RGBColor(69, 69, 69);
    leftLable2.font = [UIFont systemFontOfSize:14];
    leftLable2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:leftLable2];
}
-(void)newBtn:(UIButton *)btn{

}
-(void)hotBtn:(UIButton *)btn{
    
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
