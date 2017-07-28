//
//  zhuceViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/14.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "zhuceViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "wanshanViewController.h"
@interface zhuceViewController ()<UITextFieldDelegate>
{
    NSTimer *timer;
}
@end

@implementation zhuceViewController
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
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.image = [UIImage imageNamed:@"注册-背景"];
    [self.view addSubview:backView];
    NSArray *arr = @[@"请输入手机号",@"请填写验证码",@"密  码",@"确认密码"];
    for (int i=0; i<4; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 150+50*i, self.view.frame.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
        leftLable.text = arr[i];
        leftLable.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        leftLable.font = [UIFont systemFontOfSize:14];
        leftLable.textAlignment = NSTextAlignmentLeft;
        [view addSubview:leftLable];
        if (i==1) {
            UITextField *rightText = [[UITextField alloc]initWithFrame:CGRectMake(115, 0, 100, 50)];
            rightText.text = @"";
            rightText.font = [UIFont systemFontOfSize:14];
            rightText.textAlignment = NSTextAlignmentLeft;
            rightText.tag = 200+i;
            rightText.delegate = self;
            [view addSubview:rightText];
            UIButton *yanzhengBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 15, 80, 20)];
            [yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [yanzhengBtn setTitleColor:RGBColor(208, 98, 115) forState:UIControlStateNormal];
            yanzhengBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            yanzhengBtn.tag = 300;
            [yanzhengBtn addTarget:self action:@selector(yanzhengCode:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:yanzhengBtn];
            
            
        }else{
            UITextField *rightText = [[UITextField alloc]initWithFrame:CGRectMake(115, 0, self.view.frame.size.width-20-115, 50)];
            rightText.placeholder = @"";
            rightText.tag = 200+i;
            rightText.delegate = self;
            rightText.font = [UIFont systemFontOfSize:14];
            rightText.textAlignment = NSTextAlignmentLeft;
            if (i==2||i==3) {
                rightText.secureTextEntry = YES;
            }
            [view addSubview:rightText];
        }
       
        
    }
    for (int i=1; i<4; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 150+49*i, self.view.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:view];
    }
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 370, WIDTH-40, 40)];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [finishBtn setBackgroundColor:RGBColor(205, 71, 111)];
    finishBtn.layer.cornerRadius = 20;
    [finishBtn addTarget:self action:@selector(finishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 35, 13, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickedCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
}
-(void)clickedCancelBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finishBtn:(UIButton *)btn{

    UITextField *text = (id)[self.view viewWithTag:200];
    UITextField *text2 = (id)[self.view viewWithTag:201];
    UITextField *text3 = (id)[self.view viewWithTag:202];
    UITextField *text4 = (id)[self.view viewWithTag:203];

    if ([text.text isEqualToString:@""]) {
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"请输入手机号" andSelfVC:self];
        
    }else if ([text2.text isEqualToString:@""]){
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"请输入验证码" andSelfVC:self];
    }else if (![text2.text isEqualToString:@""]&&![text.text isEqualToString:@""]){
        [SMSSDK commitVerificationCode:text2.text phoneNumber:text.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
            if (!error)
            {
                NSLog(@"验证成功");
                if (![text3.text isEqualToString:@""]&&[text4.text isEqualToString:text4.text])
                {
                   
                    wanshanViewController *wanshan = [[wanshanViewController alloc]init];
                    wanshan.phone = text.text;
                    wanshan.password = text3.text;
                    wanshan.repassword = text4.text;
                    [self.navigationController pushViewController:wanshan animated:YES];
                    
                    

                    
                    
                }
                else if([text3.text isEqualToString:@""])
                {
                    [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"密码不能为空" andSelfVC:self];
                    
                }
                else if (![text3.text isEqualToString:text4.text])
                {
                    [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"两次密码不一致" andSelfVC:self];
                    
                }
                else
                {
                    
                }
            }
            else
            {
                [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"验证码不正确" andSelfVC:self];
                NSLog(@"错误信息:%@",error);
            }
        }];

    }
    

}
-(void)yanzhengCode:(UIButton *)btn{
    NSLog(@"Rrrrr");
    UITextField *text = (id)[self.view viewWithTag:200];
    NSLog(@"%@",text.text);
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:text.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error){
                                     if (!error) {
                                         [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"获取验证码成功" andSelfVC:self];


                                         NSLog(@"获取验证码成功");
                                         timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:YES];
                                     } else {
                                         NSLog(@"错误信息：%@",error);
                                     }
                                 }];
    
    

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)time{
    static int i=60;
    UIButton *btn = (id)[self.view viewWithTag:300];
    btn.enabled = NO;
    [btn setTitle:[NSString stringWithFormat:@"%ds后重试",i] forState:UIControlStateNormal];
    i--;
    if (i==0) {
        [timer invalidate];
        timer = nil;
        btn.enabled = YES;
        [btn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        i=60;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
