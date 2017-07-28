//
//  getPasswordViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/22.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "getPasswordViewController.h"
#import "dengluViewController.h"
@interface getPasswordViewController ()<UITextFieldDelegate>

@end

@implementation getPasswordViewController
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
    [self CustomBackButton];
    self.navigationItem.title = @"获取密码";
    self.view.backgroundColor = [UIColor whiteColor];
    for (int i=0; i<1; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 50*i, self.view.frame.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 50)];
        leftLable.text = @"密码";
        leftLable.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        leftLable.font = [UIFont systemFontOfSize:14];
        leftLable.textAlignment = NSTextAlignmentLeft;
        [view addSubview:leftLable];
        
        UITextField *rightText = [[UITextField alloc]initWithFrame:CGRectMake(85, 0, self.view.frame.size.width-20-115, 50)];
        rightText.text = self.password;
        rightText.tag = 200+i;
        rightText.delegate = self;
        rightText.font = [UIFont systemFontOfSize:14];
        rightText.textAlignment = NSTextAlignmentLeft;
        
        [view addSubview:rightText];
        
        
        
    }
    for (int i=1; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 49*i, self.view.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:view];
    }
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 220-64-50, WIDTH-40, 40)];
    [finishBtn setTitle:@"重新登录" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [finishBtn setBackgroundColor:RGBColor(205, 71, 111)];
    finishBtn.layer.cornerRadius = 20;
    [finishBtn addTarget:self action:@selector(finishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    
}
-(void)finishBtn:(UIButton *)btn{
    for (UIViewController *view in self.navigationController.viewControllers) {
        if ([view isKindOfClass:[dengluViewController class]]) {
            [USERDEFAULT setValue:nil forKey:@"uid"];
            [USERDEFAULT setValue:nil forKey:@"nickname"];
            [USERDEFAULT setValue:nil forKey:@"imgUrl"];
            [USERDEFAULT setValue:nil forKey:@"account"];
            [USERDEFAULT synchronize];
            [self.navigationController popToViewController:view animated:YES];
        }
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
