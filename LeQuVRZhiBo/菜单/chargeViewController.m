//
//  chargeViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/14.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "chargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

#import "WXApi.h"
#import "chongzhilistViewController.h"
@interface chargeViewController ()
{
    NSString *payType;
    NSString *moneyType;
    UILabel *moneyLable;

}
@end

@implementation chargeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",YUE,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
        NSLog(@"%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
           moneyLable.text = infor[@"balance_xp"];
            
        }
    } errorblock:^(NSError *error) {
        
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)item:(UIBarButtonItem *)item{
    chongzhilistViewController *tixian = [[chongzhilistViewController alloc]init];
    [self.navigationController pushViewController:tixian animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    payType = @"0";
    moneyType = @"5";
    self.navigationItem.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                         NSForegroundColorAttributeName,
                         [UIFont boldSystemFontOfSize:14],
                         NSFontAttributeName,nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"充值记录" style:UIBarButtonItemStyleDone target:self action:@selector(item:)];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    UILabel *yueLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, WIDTH, 40)];
    yueLable.text = @"星票余额";
    yueLable.font = [UIFont systemFontOfSize:18];
    yueLable.textAlignment = NSTextAlignmentCenter;
    yueLable.textColor = RGBColor(69, 69, 69);
    [self.view addSubview:yueLable];
    
    moneyLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, WIDTH, 40)];
    moneyLable.text = @"0";
    moneyLable.font = [UIFont systemFontOfSize:18];
    moneyLable.textAlignment = NSTextAlignmentCenter;
    moneyLable.textColor = RGBColor(69, 69, 69);
    [self.view addSubview:moneyLable];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0 , 140, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView];
    NSArray *arr = @[@"50星票",@"200星票",@"980星票",@"2960星票",@"5980星票",@"9800星票"];
    NSArray *arr2 = @[@"5元",@"20元",@"98元",@"296元",@"598元",@"980元"];
    for (int i=0; i<2; i++) {
        for (int j=0; j<3; j++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10+((WIDTH-40)/3+10)*j , 150+65*i, (WIDTH-40)/3, 55)];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.borderWidth = 1;
            view.tag = 500+j+3*i;
            if (i==0&&j==0) {
                view.layer.borderColor = [[UIColor redColor]CGColor];

            }else{
                view.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1]CGColor];

            }
            view.layer.cornerRadius = 5;
            [self.view addSubview:view];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(money:)];
            [view addGestureRecognizer:tap];
            UILabel *moneyLable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (WIDTH-40)/3, 30)];
            moneyLable2.text = arr[3*i+j];
            moneyLable2.font = [UIFont systemFontOfSize:14];
            moneyLable2.textAlignment = NSTextAlignmentCenter;
            if (i==0&&j==0) {
                moneyLable2.textColor = [UIColor redColor];
                
            }else{
                moneyLable2.textColor = RGBColor(69, 69, 69);
                
            }
            [view addSubview:moneyLable2];
            
            UILabel *moneyLable22 = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, (WIDTH-40)/3, 25)];
            moneyLable22.text = arr2[3*i+j];
            moneyLable22.font = [UIFont systemFontOfSize:12];
            moneyLable22.textAlignment = NSTextAlignmentCenter;
            if (i==0&&j==0) {
                moneyLable22.textColor = [UIColor redColor];
                
            }else{
                moneyLable22.textColor = RGBColor(69, 69, 69);
                
            }
            [view addSubview:moneyLable22];
        }
    }
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0 , 285, self.view.frame.size.width, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView2];
    NSArray *arr3 = @[@"支付宝",@"微信"];
    for (int j=0; j<2; j++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0 , 286+50*j, WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];

        view.layer.cornerRadius = 5;
        view.tag = 200+j;
        [self.view addSubview:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhifu:)];
        [view addGestureRecognizer:tap];
        UILabel *moneyLable3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        moneyLable3.text = arr3[j];
        moneyLable3.font = [UIFont systemFontOfSize:14];
        moneyLable3.textAlignment = NSTextAlignmentLeft;
        moneyLable3.textColor = RGBColor(69, 69, 69);
        [view addSubview:moneyLable3];
        
        UIButton *moneyBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-30, 15, 20, 20)];
        if (j==0) {
            moneyBtn.selected = YES;
        }else{
            moneyBtn.selected = NO;

        }
        moneyBtn.tag = 300+j;
        [moneyBtn setBackgroundImage:[UIImage imageNamed:@"tixian1"] forState:UIControlStateNormal];
        [moneyBtn setBackgroundImage:[UIImage imageNamed:@"tixian2"] forState:UIControlStateSelected];

        [view addSubview:moneyBtn];
        
       
    }
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0 , 334, self.view.frame.size.width, 1)];
    lineView3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView3];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0 , 384, self.view.frame.size.width, 1)];
    lineView4.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView4];
    
    UIButton *chargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 400, WIDTH-40, 40)];
    [chargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [chargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chargeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [chargeBtn setBackgroundColor:RGBColor(203, 70, 111)];
    chargeBtn.layer.cornerRadius = 20;
    [chargeBtn addTarget:self action:@selector(dengluBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chargeBtn];

}
-(void)money:(UITapGestureRecognizer *)tap{
    
    for (int i=0; i<6; i++) {
        UIView *view = (id)[self.view viewWithTag:500+i];
        if (tap.view.tag == 500+i) {
            if (i==0) {
                moneyType = [NSString stringWithFormat:@"%d",5];

            }else if (i==1){
                moneyType = [NSString stringWithFormat:@"%d",20];

            }else if (i==2){
                moneyType = [NSString stringWithFormat:@"%d",98];

            }else if (i==3){
                moneyType = [NSString stringWithFormat:@"%d",296];

            }else if (i==4){
                moneyType = [NSString stringWithFormat:@"%d",598];

            }else if (i==5){
                moneyType = [NSString stringWithFormat:@"%d",980];

            }
            view.layer.borderColor = [[UIColor redColor]CGColor];
            for (UILabel *lable in view.subviews) {
                lable.textColor = [UIColor redColor];
            }
        }else{
            view.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1]CGColor];
            for (UILabel *lable in view.subviews) {
                lable.textColor = RGBColor(69, 69, 69);
            }
        }
    }
    
}
-(void)zhifu:(UITapGestureRecognizer *)tap{
    UIButton *btn = (id)[self.view viewWithTag:300];
    UIButton *btn2 = (id)[self.view viewWithTag:301];
    if (tap.view.tag == 200) {
        btn.selected = YES;
        btn2.selected = NO;
        payType = @"0";
    }else{
        btn2.selected = YES;
        btn.selected = NO;
        payType = @"1";
    }

}
-(void)zhifubaopaywithorderid:(NSString *)orderid withName:(NSString *)name withMoney:(NSString *)money withNotify:(NSString *)notify{
    NSString *appScheme = @"lequzhiboApy";
    NSString *partner = @"2088521193226283";//商户ID
    NSString *seller = @"15001373238m@sina.cn";
    NSString *privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAO1KWw9SIZI1oxhKlHqDY7hlZ7Jy8+dSTXMFkT0BmOMnysapWzSk7xU50SVGSS86y0DMV8gYVHBiQvd53L/tPpqj+CBFg10/iPIqTQrysUQP0R25r/8VE0O4p+DErUZ3H0vNIWae61ckrI0FvMIaXK1YPfh7TtgEOZ1pBTv25lG9AgMBAAECgYAyqiKhNc8XMb6eDCaBthYPpA8tCeBL7sW8nl6xYOrs7W0dV8GyjtjBdnPSepxbqjkFn9vKTG+TA1f7ERjyHcy0vLM6m/wxU3wCAE8BpXfw5Gsjs4jFEmuGwMJh8uv4YP9DMMQdcQ2GgOALQeVjP8TTSmrKfTbYLEFr09BKW8sEPQJBAPsbh6IxY0fWSL485KHi2YZdhOakPgDnmRLI3xT5Y/hxBWKNAp6N6bd72KWpSzhXyTvxo8aw9477zbarkMnTvrcCQQDx6ejD+ux9e2u1MAB5Ir+2Eneku6XxrH7vsDth/NIjzGc8ngvombxFIf47lZMlRQgg8Y2xpZcTUQT3jr0oi/8rAkAn76XvprkqeKsTDm4yTPjZhNAZOm/eBvdyZF4OYOeEYL1Bgjmza9CK7Ph0yGr9KAEKNpEcjZKhu+xoq/qYDsQbAkAmf/F5by+/8Kp9lXwdyzfzhBDieLK6OZeiEcwBljjjVZ6AeS6v//eEkRpi5TUb01at14OTaCUY/+XoeCEGmPEtAkA9MmAA3z980Et6mDjbEARoaKDCubeVZYDYG0SvA7+NLbU8DkRMEuzmu1gMasNG5auIUWcYUdTxVOdDkztKjPiC";
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [NSString stringWithFormat:@"%@",orderid] ;//订单ID（由商家自行制定）
    order.productName = name ; //商品标题
    //     order.productDescription = @"测试" ; //商品描述
    order.amount = [NSString stringWithFormat:@"%@", money];
    order.notifyURL =  notify;//回调地址
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    order.service = @"mobile.securitypay.pay";//固定值
    NSString *orderSpec = [order description];
    
    id <DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        NSLog(@"******%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
            
            if ([resultDic[@"resultStatus"] isEqualToString:@"4000"]) {
                
                
                
            }
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"chongzhichenggong" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if ([resultDic[@"resultStatus"] isEqualToString:@"8000"]) {
                
                if ([resultDic[@"resultStatus"] isEqualToString:@"6002"]) {
                    
                }
            }
            
        }];
    }
    
}
-(void)WeiXinPay:(NSDictionary *)dic
{
    
    NSString * timeStamp=dic[@"timestamp"];
    PayReq * req=[[PayReq alloc]init];
    req.partnerId=[dic objectForKey:@"partnerid"];
    req.prepayId=[dic objectForKey:@"prepayid"];
    req.nonceStr=[dic objectForKey:@"noncestr"];
    req.timeStamp=[timeStamp intValue];
    req.package=@"Sign=WXPay";
    req.sign=[dic objectForKey:@"sign"];
    [WXApi sendReq:req];
    //日志输出
    NSLog(@"appid=%@\npartnerid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
}
- (void)onResp:(BaseResp *)resp
{
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    switch (resp.errCode) {
        case WXSuccess:
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            break;
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            break;
    }
}

-(void)dengluBtn:(UIButton *)btn{
    [AFManager getReqURL:[NSString stringWithFormat:@"%@?uid=%@&money=%@&type=%@",ORDER,[USERDEFAULT valueForKey:@"uid"],@"0.01",payType] block:^(id infor) {
        NSLog(@"-%@-",infor);
//        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            if ([payType isEqualToString:@"0"]) {
                [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",ZHIFUBAO,infor[@"data"][@"id"]] block:^(id infor) {
                    NSLog(@"-%@-",infor);
                    [self zhifubaopaywithorderid:infor[@"data"][@"biz_content"][@"out_trade_no"] withName:infor[@"data"][@"biz_content"][@"subject"] withMoney:infor[@"data"][@"biz_content"][@"total_amount"] withNotify:infor[@"data"][@"notify_url"]];
                    
                    
                } errorblock:^(NSError *error) {
                    
                }];
            }else{
                [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",WEIXINZHIFU,infor[@"data"][@"id"]] block:^(id infor) {
                    NSLog(@"-%@-",infor);
                    if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                        [self WeiXinPay:infor[@"data"]];
                    }

                    
                } errorblock:^(NSError *error) {
                    
                }];
            }
            
            
//        }
    } errorblock:^(NSError *error) {
        
    }];

    
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
