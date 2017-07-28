//
//  dengjiViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/18.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "dengjiViewController.h"

@interface dengjiViewController ()

@end

@implementation dengjiViewController
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
    self.navigationItem.title = @"我的等级";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    backView.image = [UIImage imageNamed:@"等级_02"];
    [self.view addSubview:backView];
    
    UIView *jinduView = [[UIView alloc]initWithFrame:CGRectMake(30, 210, WIDTH-60, 15)];
    jinduView.backgroundColor = RGBColor(1, 5, 34);
    jinduView.layer.cornerRadius = 7.5;
    [self.view addSubview:jinduView];
    
    UIView *jinduView2 = [[UIView alloc]initWithFrame:CGRectMake(1, 1, WIDTH-200, 13)];
    jinduView2.backgroundColor = RGBColor(118, 200, 200);
    jinduView2.layer.cornerRadius = 6.5;
    [jinduView addSubview:jinduView2];
    
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 240, WIDTH-20, 30)];
    rightLable.text = @"观看直播就可以获得经验值哦";
    rightLable.font = [UIFont systemFontOfSize:12];
    rightLable.textAlignment = NSTextAlignmentCenter;
    rightLable.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self.view addSubview:rightLable];
    
    UILabel *rightLable2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 270, WIDTH-20, 30)];
    rightLable2.text = @"自己直播经验更多哦";
    rightLable2.font = [UIFont systemFontOfSize:12];
    rightLable2.textAlignment = NSTextAlignmentCenter;
    rightLable2.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self.view addSubview:rightLable2];
    
    UILabel *rightLable3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, WIDTH-20, 30)];
    rightLable3.text = @"等级生的慢?礼物刷的越多等级就越快哦~";
    rightLable3.font = [UIFont systemFontOfSize:12];
    rightLable3.textAlignment = NSTextAlignmentCenter;
    rightLable3.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    [self.view addSubview:rightLable3];
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-81-64, WIDTH, 1)];
    lineview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineview];
    NSArray *arr = @[@"等级_05",@"等级_07",@"等级_09"];
    NSArray *arr2 = @[@"专属图标",@"排名在前",@"实名认证"];
    for (int i=0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0+WIDTH/3*i, HEIGHT-80-64, WIDTH/3, 80)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/3/2-15, 10, 30, 30)];
        [button setBackgroundImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [view addSubview:button];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, WIDTH/3, 30)];
        lable.text = arr2[i];
        lable.font = [UIFont systemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = RGBColor(69, 69, 69);
        [view addSubview:lable];
    }
    for (int i=1; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0+WIDTH/3*i, HEIGHT-80-64, 1, 80)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:view];
    }
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
