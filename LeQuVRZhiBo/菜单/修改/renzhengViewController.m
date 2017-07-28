//
//  renzhengViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/28.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "renzhengViewController.h"

@interface renzhengViewController ()<UITextFieldDelegate>

@end

@implementation renzhengViewController
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
    self.navigationItem.title = @"实名认证";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    NSArray *arr = @[@"请输入真实姓名",@"请输入身份证号码"];
    NSArray *arr2 = @[@"姓名:",@"身份证:"];

    for (int i=0; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0+50*i, self.view.frame.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 70, 50)];
        leftLable.text = arr2[i];
        leftLable.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        leftLable.font = [UIFont systemFontOfSize:14];
        leftLable.textAlignment = NSTextAlignmentLeft;
        [view addSubview:leftLable];
        
        UITextField *rightText = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, self.view.frame.size.width-20-115, 50)];
        rightText.placeholder = arr[i];
        rightText.tag = 200+i;
        rightText.delegate = self;
        rightText.font = [UIFont systemFontOfSize:14];
        rightText.textAlignment = NSTextAlignmentLeft;
        [view addSubview:rightText];
        
        
        
    }
    for (int i=1; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0+49*i, self.view.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:view];
    }
    
    
    
    UIButton *dengluBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 140, WIDTH-40, 40)];
    [dengluBtn setTitle:@"认证" forState:UIControlStateNormal];
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dengluBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [dengluBtn setBackgroundColor:RGBColor(203, 70, 111)];
    dengluBtn.layer.cornerRadius = 20;
    [dengluBtn addTarget:self action:@selector(dengluBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dengluBtn];
}
-(void)dengluBtn:(UIButton *)btn{
    UITextField *field = (id)[self.view viewWithTag:200];
    UITextField *field2 = (id)[self.view viewWithTag:201];
    if ([field.text isEqualToString:@""]) {
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"请输入姓名" andSelfVC:self];

    }else if ([field2.text isEqualToString:@""]){
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"请输入身份证" andSelfVC:self];

    }else{
        [AFManager postReqURL:RENZHENG reqBody:@{@"uid":[USERDEFAULT valueForKey:@"uid"],@"realname":field.text,@"idcard":field2.text} block:^(id infor) {
            NSLog(@"%@--",infor);
        }];
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
