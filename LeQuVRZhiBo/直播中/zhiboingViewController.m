//
//  zhiboingViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/7.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "zhiboingViewController.h"
#import "livingViewController.h"
#import "typeViewController.h"
@interface zhiboingViewController ()<UITextFieldDelegate>
{
    NSString *chatId;
    NSString *targetId;
    UIButton *addBtn;
    UITextField *title;
}
@end

@implementation zhiboingViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;

    
}
-(void)type:(id)user{
    [addBtn setTitle:[user userInfo][@"type"] forState:UIControlStateNormal];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(type:) name:@"zhibotype" object:nil];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.image = [UIImage imageNamed:@"未直播"];
    [self.view addSubview:backView];
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-30, HEIGHT-30, 15, 15)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"未直播_10"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    title = [[UITextField alloc]initWithFrame:CGRectMake(0, 150, WIDTH, 40)];
    title.text = @"写个标题吧!";
    title.tag = 200;
    title.delegate = self;
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    UIButton *biaoqianBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2-30-50-20, 200, 15, 15)];
    [biaoqianBtn setBackgroundImage:[UIImage imageNamed:@"未直播_03"] forState:UIControlStateNormal];
    [self.view addSubview:biaoqianBtn];
    
    addBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2-30-50, 200, 50, 15)];
    [addBtn setTitle:@"添加标签" forState:UIControlStateNormal];
    addBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [addBtn addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UIButton *cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2+30, 200, 15, 15)];
    [cityBtn setBackgroundImage:[UIImage imageNamed:@"未直播_05"] forState:UIControlStateNormal];
    [self.view addSubview:cityBtn];
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+30+20, 200, 100, 15)];
    rightLable.text = [USERDEFAULT valueForKey:@"cityName"];
    rightLable.font = [UIFont systemFontOfSize:12];
    rightLable.textColor = [UIColor whiteColor];
    rightLable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:rightLable];
    
    UIButton *liveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 250, WIDTH-60, 40)];
    [liveBtn setTitle:@"马上开播" forState:UIControlStateNormal];
    [liveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [liveBtn setBackgroundColor:[UIColor clearColor]];
    liveBtn.layer.borderWidth = 2;
    liveBtn.layer.borderColor = [[UIColor redColor]CGColor];
    liveBtn.layer.cornerRadius = 20;
    liveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [liveBtn addTarget:self action:@selector(liveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:liveBtn];
    
   
    [AFManager postReqURL:CHATID reqBody:@{@"id":@"110"} block:^(id infor) {
        NSLog(@"-%@-",infor);
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{

    textField.text = @"";
}
-(void)addBtn{
    typeViewController *live = [[typeViewController alloc]init];
    [self.navigationController pushViewController:live animated:YES];
}
-(void)liveBtn{
    
    [AFManager postReqURL:ZHIBOKAISHI reqBody:@{@"uid":@"110",@"type":addBtn.titleLabel.text,@"area":[USERDEFAULT valueForKey:@"cityName"],@"":title.text} block:^(id infor) {
        NSLog(@"-%@-",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            livingViewController *live = [[livingViewController alloc]init];
            live.liveid = infor[@"liveStart"][@"liveid"];
            live.starttime = infor[@"liveStart"][@"starttime"];
            live.chatId = @"868622";
            [self.navigationController pushViewController:live animated:YES];
        }
        
    }];
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
