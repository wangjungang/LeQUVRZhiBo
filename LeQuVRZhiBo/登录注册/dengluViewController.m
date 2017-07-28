//
//  dengluViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/14.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "dengluViewController.h"
#import "zhuceViewController.h"
#import "forgetViewController.h"
#import <ShareSDK/ShareSDK.h>

#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface dengluViewController ()<UITextFieldDelegate>

@end

@implementation dengluViewController
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 542.f/750.f*WIDTH)];
    backView.image = [UIImage imageNamed:@"登录"];
    [self.view addSubview:backView];
    NSArray *arr = @[@"请输入账号",@"请输入密码"];
    for (int i=0; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 542.f/750.f*WIDTH+50*i, self.view.frame.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
        leftLable.text = arr[i];
        leftLable.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        leftLable.font = [UIFont systemFontOfSize:14];
        leftLable.textAlignment = NSTextAlignmentLeft;
        [view addSubview:leftLable];

        UITextField *rightText = [[UITextField alloc]initWithFrame:CGRectMake(115, 0, self.view.frame.size.width-20-115, 50)];
        rightText.text = @"";
        rightText.tag = 200+i;
        rightText.delegate = self;
        rightText.font = [UIFont systemFontOfSize:14];
        rightText.textAlignment = NSTextAlignmentLeft;
        if (i==1) {
            rightText.secureTextEntry = YES;
        }
        [view addSubview:rightText];
        
        
        
    }
    for (int i=1; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 542.f/750.f*WIDTH+49*i, self.view.frame.size.width, 1)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.view addSubview:view];
    }
    
    UIButton *forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-80, 110+542.f/750.f*WIDTH, 60, 20)];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn addTarget:self action:@selector(forgetBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    
    UIButton *dengluBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 140+542.f/750.f*WIDTH, WIDTH-40, 40)];
    [dengluBtn setTitle:@"完成" forState:UIControlStateNormal];
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dengluBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [dengluBtn setBackgroundColor:RGBColor(203, 70, 111)];
    dengluBtn.layer.cornerRadius = 20;
    [dengluBtn addTarget:self action:@selector(dengluBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dengluBtn];
    
    UIButton *weiboBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-140, 190+542.f/750.f*WIDTH, 30, 30)];
    [weiboBtn setBackgroundImage:[UIImage imageNamed:@"个人-个人信息_07"] forState:UIControlStateNormal];
    
    weiboBtn.layer.cornerRadius = 15;
    [weiboBtn addTarget:self action:@selector(weiboBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboBtn];
    
    UIButton *QQbtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-100, 190+542.f/750.f*WIDTH, 30, 30)];
    [QQbtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    
    QQbtn.layer.cornerRadius = 15;
    [QQbtn addTarget:self action:@selector(QQbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QQbtn];
    
    UIButton *weixinBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-60, 190+542.f/750.f*WIDTH, 30, 30)];
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"微信呢"] forState:UIControlStateNormal];
    
    weixinBtn.layer.cornerRadius = 15;
    [weixinBtn addTarget:self action:@selector(weixinBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    
    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, HEIGHT-60, WIDTH-40, 40)];
    [phoneBtn setTitle:@"手机号注册>>" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [phoneBtn addTarget:self action:@selector(phoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];

}
-(void)phoneBtn:(UIButton *)btn{
    zhuceViewController *zhuce = [[zhuceViewController alloc]init];
    [self.navigationController pushViewController:zhuce animated:YES];
}
-(void)QQbtn:(UIButton *)btn{
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"%@",user);
             NSLog(@"uid=%@",user.uid);
             NSLog(@"--%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             NSLog(@"class=%@",[user.credential.token class]);
             
             NSDictionary *dic = @{@"dsf":@"1",@"nickname":user.nickname,@"head_pic":user.icon,@"dsftoken":[NSString stringWithFormat:@"%@",user.uid]};
             [AFManager postReqURL:THIRDLOGIN reqBody:dic block:^(id infor) {
                 NSLog(@"%@",infor);
                 if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                     [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",TOKEN,infor[@"data"][@"id"]] block:^(id infor) {
                         if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                             [USERDEFAULT setValue:infor[@"token"] forKey:@"token"];
                             [USERDEFAULT synchronize];
                             
                         }
                     } errorblock:^(NSError *error) {
                         
                     }];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [USERDEFAULT setValue:infor[@"data"][@"id"] forKey:@"uid"];
                         [USERDEFAULT setValue:infor[@"data"][@"nickname"] forKey:@"nickname"];
                         [USERDEFAULT setValue:infor[@"data"][@"head_pic"] forKey:@"imgUrl"];
                         [USERDEFAULT setValue:infor[@"data"][@"account"] forKey:@"account"];
                         [USERDEFAULT synchronize];
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
                     });
                 }
                 
             }];
             NSLog(@"55--%@",dic);
             //在这里面实现app界面的跳转：
             //1.如果用户将qq和app已经进行了绑定，直接登录成功就能拿到用户的数据；
             //2.如果用户没有将qq和app进行绑定，那么绑定成功后就会从服务器获取到token，这个token是用来获取用户数据的，很重要。
             //总之：每一个用户都有自己唯一的标识，使用第三方登录，第三方是不知道用户的账号和密码的，那么用户必须先绑定，绑定成功后，服务器返回这个标识，之后服务器通过这个标识才能获取到用户的数据。
         } else {
             NSLog(@"%@",error);
         }
     }];
    

}
-(void)weixinBtn:(UIButton *)btn{
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"%@",user);
             NSLog(@"uid=%@",user.uid);
             NSLog(@"--%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             
             
             NSDictionary *dic = @{@"dsf":@"2",@"nickname":user.nickname,@"head_pic":user.icon,@"dsftoken":[NSString stringWithFormat:@"%@",user.uid]};
             [AFManager postReqURL:THIRDLOGIN reqBody:dic block:^(id infor) {
                 NSLog(@"%@",infor);
                 if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                     [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",TOKEN,infor[@"data"][@"id"]] block:^(id infor) {
                         if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                             [USERDEFAULT setValue:infor[@"token"] forKey:@"token"];
                             [USERDEFAULT synchronize];
                             
                         }
                     } errorblock:^(NSError *error) {
                         
                     }];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [USERDEFAULT setValue:infor[@"data"][@"id"] forKey:@"uid"];
                         [USERDEFAULT setValue:infor[@"data"][@"nickname"] forKey:@"nickname"];
                         [USERDEFAULT setValue:infor[@"data"][@"head_pic"] forKey:@"imgUrl"];
                         [USERDEFAULT setValue:infor[@"data"][@"account"] forKey:@"account"];
                         [USERDEFAULT synchronize];
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
                     });
                 }
                 
             }];

             //在这里面实现app界面的跳转：
             //1.如果用户将qq和app已经进行了绑定，直接登录成功就能拿到用户的数据；
             //2.如果用户没有将qq和app进行绑定，那么绑定成功后就会从服务器获取到token，这个token是用来获取用户数据的，很重要。
             //总之：每一个用户都有自己唯一的标识，使用第三方登录，第三方是不知道用户的账号和密码的，那么用户必须先绑定，绑定成功后，服务器返回这个标识，之后服务器通过这个标识才能获取到用户的数据。
         } else {
             NSLog(@"%@",error);
         }
     }];
}
-(void)weiboBtn:(UIButton *)btn{
    //例如新浪的登录
    
    
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"%@",user);
             NSLog(@"uid=%@",user.uid);
             NSLog(@"--%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             
             
             NSDictionary *dic = @{@"dsf":@"3",@"nickname":user.nickname,@"head_pic":user.icon,@"dsftoken":[NSString stringWithFormat:@"%@",user.uid]};
             [AFManager postReqURL:THIRDLOGIN reqBody:dic block:^(id infor) {
                 NSLog(@"%@",infor);
                 if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                     [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",TOKEN,infor[@"data"][@"id"]] block:^(id infor) {
                         if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                             [USERDEFAULT setValue:infor[@"token"] forKey:@"token"];
                             [USERDEFAULT synchronize];
                             
                         }
                     } errorblock:^(NSError *error) {
                         
                     }];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [USERDEFAULT setValue:infor[@"data"][@"id"] forKey:@"uid"];
                         [USERDEFAULT setValue:infor[@"data"][@"nickname"] forKey:@"nickname"];
                         [USERDEFAULT setValue:infor[@"data"][@"head_pic"] forKey:@"imgUrl"];
                         [USERDEFAULT setValue:infor[@"data"][@"account"] forKey:@"account"];
                         [USERDEFAULT synchronize];
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
                     });
                    
                 }
                 
             }];

             //在这里面实现app界面的跳转：
             //1.如果用户将qq和app已经进行了绑定，直接登录成功就能拿到用户的数据；
             //2.如果用户没有将qq和app进行绑定，那么绑定成功后就会从服务器获取到token，这个token是用来获取用户数据的，很重要。
             //总之：每一个用户都有自己唯一的标识，使用第三方登录，第三方是不知道用户的账号和密码的，那么用户必须先绑定，绑定成功后，服务器返回这个标识，之后服务器通过这个标识才能获取到用户的数据。
         } else {
             NSLog(@"%@",error);
         }
     }];

}
-(void)forgetBtn:(UIButton *)btn{
    forgetViewController *zhuce = [[forgetViewController alloc]init];
    [self.navigationController pushViewController:zhuce animated:YES];
}
-(void)dengluBtn:(UIButton *)btn{
    
    UITextField *text = (id)[self.view viewWithTag:200];
    UITextField *text2 = (id)[self.view viewWithTag:201];
    if ([text.text isEqualToString:@""]) {
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"请输入账号" andSelfVC:self];

    }else if ([text2.text isEqualToString:@""]){
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"请输入密码" andSelfVC:self];
    }else if (![text2.text isEqualToString:@""]&&![text.text isEqualToString:@""]){
        
        NSDictionary *dic = @{@"phone":text.text,@"password":text2.text};
        [AFManager postReqURL:LOGIN reqBody:dic block:^(id infor) {
            NSLog(@"infor====%@",infor);
            if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",TOKEN,infor[@"id"]] block:^(id infors) {
                    if ([[NSString stringWithFormat:@"%@",infors[@"code"]] isEqualToString:@"200"]) {
                        [USERDEFAULT setValue:infors[@"token"] forKey:@"token"];
                        [USERDEFAULT synchronize];
                        
                    }
                } errorblock:^(NSError *error) {
                    
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [USERDEFAULT setValue:infor[@"id"] forKey:@"uid"];
                    [USERDEFAULT setValue:infor[@"nickname"] forKey:@"nickname"];
                    [USERDEFAULT setValue:infor[@"head_pic"] forKey:@"imgUrl"];
                    [USERDEFAULT setValue:infor[@"account"] forKey:@"account"];
                    [USERDEFAULT synchronize];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
                    
                });
                
            }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"201"]){
                [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"用户名错误" andSelfVC:self];
            }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"202"]){
                [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"密码错误" andSelfVC:self];
            }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"203"]){
                [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"已被封号" andSelfVC:self];
            }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"204"]){
                [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"已登录" andSelfVC:self];
            }
            
            
        }];

    }
    
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
