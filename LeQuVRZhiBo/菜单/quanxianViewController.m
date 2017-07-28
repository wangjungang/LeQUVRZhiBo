//
//  quanxianViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/15.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "quanxianViewController.h"

@interface quanxianViewController ()

@end

@implementation quanxianViewController
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
    self.navigationItem.title = @"短视频权限";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self CustomBackButton];
    NSArray *arr = @[@"关注我的人",@"互相关注的人"];
    for (int i=0; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10+41*i, WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 150, 30)];
        rightLable.text = arr[i];
        rightLable.textColor = RGBColor(67, 67, 67);
        rightLable.font = [UIFont systemFontOfSize:14];
        rightLable.textAlignment = NSTextAlignmentLeft;
        [view addSubview:rightLable];
        
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-30, 15, 10, 10)];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [view addSubview:rightBtn];
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
