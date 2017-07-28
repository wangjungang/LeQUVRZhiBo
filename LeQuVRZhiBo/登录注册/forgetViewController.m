//
//  forgetViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/22.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "forgetViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "getPasswordViewController.h"
#import<CommonCrypto/CommonDigest.h>
@interface forgetViewController ()<UITextFieldDelegate>
{
    NSTimer *timer;
}
@end

@implementation forgetViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self CustomBackButton];
    self.navigationItem.title = @"短信验证";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict2;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11"]forBarMetrics:UIBarMetricsDefault];
    NSArray *arr = @[@"请输入手机号",@"请填写验证码"];
    for (int i=0; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 50*i, self.view.frame.size.width, 50)];
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
            
            [view addSubview:rightText];
        }
        
        
    }
    for (int i=1; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 49*i, self.view.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:view];
    }
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 220-64, WIDTH-40, 40)];
    [finishBtn setTitle:@"获取密码" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [finishBtn setBackgroundColor:RGBColor(205, 71, 111)];
    finishBtn.layer.cornerRadius = 20;
    [finishBtn addTarget:self action:@selector(finishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
}
//-(NSString *)md5:(NSString *)str
//{
//    const char *cStr = [str UTF8String];
//    unsigned char result[16];
//    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
//}
-(void)finishBtn:(UIButton *)btn{
    
    
    UITextField *text = (id)[self.view viewWithTag:200];
    UITextField *text2 = (id)[self.view viewWithTag:201];

    if ([text.text isEqualToString:@""]) {
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"请输入手机号" andSelfVC:self];
        
    }else if ([text2.text isEqualToString:@""]){
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"请输入验证码" andSelfVC:self];
    }else if (![text2.text isEqualToString:@""]&&![text.text isEqualToString:@""]){
        [SMSSDK commitVerificationCode:text2.text phoneNumber:text.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
            if (!error)
            {
                NSLog(@"验证成功");
                    UITextField *text = (id)[self.view viewWithTag:200];
                NSDictionary *dic = @{@"phone":text.text};
                NSLog(@"%@",dic);
                [AFManager postReqURL:FORGETMIMA reqBody:dic block:^(id infor) {
                    if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                        NSLog(@"-%@-",infor[@"password"]);
                        
                        getPasswordViewController *get = [[getPasswordViewController alloc]init];
                        get.password = infor[@"password"];
                        [self.navigationController pushViewController:get animated:YES];
                    }
                }];
            }
            else
            {
                [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"验证码不正确" andSelfVC:self];
                NSLog(@"错误信息:%@",error);
            }
        }];
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
