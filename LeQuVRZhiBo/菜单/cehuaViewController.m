//
//  cehuaViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/10.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "cehuaViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "wodePindaoViewController.h"
#import "PersonViewController.h"
#import "setViewController.h"
#import "myLivingViewController.h"
#import "myPicturesViewController.h"
#import "myShouyiViewController.h"
#import "chargeViewController.h"
#import "mySpecialViewController.h"
#import "cehuaTableViewCell.h"
#import "dengjiViewController.h"
#import "fankuiViewController.h"
#import "fensiViewController.h"
#import "guanzhuViewController.h"
#import "dongtaiViewController.h"
//小视频列表
#import "SmallVideoListController.h"
@interface cehuaViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table;
    NSMutableArray *dataSource;
    NSMutableArray *dataSource2;
    UIImageView *avatar;
    UILabel *headLable;

}


@end

@implementation cehuaViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [avatar setImageWithURL:[NSURL URLWithString:[USERDEFAULT valueForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"load"]];
    headLable.text = [USERDEFAULT valueForKey:@"nickname"];

    UILabel *lable = (id)[self.view viewWithTag:2200];
    UILabel *lable2 = (id)[self.view viewWithTag:2201];
    UILabel *lable3 = (id)[self.view viewWithTag:2202];

    [AFManager getReqURL:[NSString stringWithFormat:GUANZHURENSHU,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
        NSLog(@"%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            lable.text = infor[@"gbCount"];
            
        }else{
            lable.text = @"0";
        }
    } errorblock:^(NSError *error) {
        
    }];
    
    [AFManager getReqURL:[NSString stringWithFormat:BEIGUANZHURENSHU,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
        NSLog(@"%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            lable2.text = infor[@"bgbCount"];
            
        }else{
            lable2.text = @"0";
        }
    } errorblock:^(NSError *error) {
        
    }];
    
    [AFManager getReqURL:[NSString stringWithFormat:DONGTAISHULIANG,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
        NSLog(@"%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            lable3.text = infor[@"dynCount"];
            
        }else{
            lable3.text = @"0";
        }
    } errorblock:^(NSError *error) {
        
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;

    
}
-(void)avatar{
    UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
    UINavigationController *vc =   nav.viewControllers[0];
    PersonViewController *person = [[PersonViewController alloc]init];
    [vc pushViewController:person animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
    

}
-(void)jindu{
    UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
    UINavigationController *vc =   nav.viewControllers[0];
    dengjiViewController *person = [[dengjiViewController alloc]init];
    [vc pushViewController:person animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}
-(void)buttonTap:(UITapGestureRecognizer *)tap{
    if (tap.view.tag == 8000) {
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        guanzhuViewController *person = [[guanzhuViewController alloc]init];
        [vc pushViewController:person animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }else if (tap.view.tag == 8001){
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        fensiViewController *person = [[fensiViewController alloc]init];
        [vc pushViewController:person animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }else{
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        dongtaiViewController *person = [[dongtaiViewController alloc]init];
        person.uid=[USERDEFAULT valueForKey:@"uid"];
        person.headUrl=[USERDEFAULT valueForKey:@"imgUrl"];
        person.nickName=[USERDEFAULT valueForKey:@"nickname"];
        person.isMyself=YES;
        [vc pushViewController:person animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11"]forBarMetrics:UIBarMetricsDefault];
    dataSource2 = [[NSMutableArray alloc]initWithArray:@[@"个人_20",@"个人_22",@"个人_24",@"个人_26",@"个人_28"]];
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CEHUWIDTH, HEIGHT)];
    backView.image = [UIImage imageNamed:@"个人背景"];
    [self.view addSubview:backView];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CEHUWIDTH, 180)];
    headView.backgroundColor = [UIColor clearColor];
    avatar = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 70, 70)];
    avatar.layer.cornerRadius = 35;
    avatar.layer.masksToBounds = YES;
    avatar.userInteractionEnabled = YES;
    [headView addSubview:avatar];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatar)];
    [avatar addGestureRecognizer:tap];
    headLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, CEHUWIDTH-20, 30)];
    
    headLable.font = [UIFont systemFontOfSize:14];
    headLable.textColor = [UIColor whiteColor];
    headLable.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:headLable];
    
    UILabel *headLable2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, CEHUWIDTH-120, 30)];
    headLable2.text = @"这个人太懒了，还没有签名";
    headLable2.textColor = [UIColor whiteColor];
    headLable2.font = [UIFont systemFontOfSize:12];
    headLable2.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:headLable2];
    
    UIView *jinduView = [[UIView alloc]initWithFrame:CGRectMake(100, 75, CEHUWIDTH-120, 15)];
    jinduView.backgroundColor = RGBColor(1, 5, 34);
    jinduView.layer.cornerRadius = 7.5;
    [headView addSubview:jinduView];
    
    UIView *jinduView2 = [[UIView alloc]initWithFrame:CGRectMake(1, 1, CEHUWIDTH-200, 13)];
    jinduView2.backgroundColor = RGBColor(118, 200, 200);
    jinduView2.layer.cornerRadius = 6.5;
    [jinduView addSubview:jinduView2];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jindu)];
    [jinduView addGestureRecognizer:tap2];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CEHUWIDTH-40, 15, 20, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"个人_03"] forState:UIControlStateNormal];
    //[headView addSubview:rightBtn];
    
    
    UIView *headlineView = [[UIView alloc]initWithFrame:CGRectMake(0, 109, CEHUWIDTH, 1)];
    headlineView.backgroundColor = RGBColor(89, 108, 165);
    [headView addSubview:headlineView];
    NSArray *arr = @[@"关注",@"粉丝",@"动态"];
    for (int i=0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0+CEHUWIDTH/3*i, 110 , CEHUWIDTH/3, 70)];
        view.tag = 8000+i;
        view.backgroundColor = [UIColor clearColor];
        [headView addSubview:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonTap:)];
        [view addGestureRecognizer:tap];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, CEHUWIDTH/3, 30)];
        lable.text = @"0";
        lable.tag = 2200+i;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:16];
        lable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lable];
        
        UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, CEHUWIDTH/3, 30)];
        lable2.text = arr[i];
        lable2.textColor = [UIColor whiteColor];
        lable2.font = [UIFont systemFontOfSize:14];
        lable2.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lable2];
        
    }
    for (int i=1; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((CEHUWIDTH/3-1)*i, 110, 1, 70)];
        view.backgroundColor = RGBColor(89, 108, 165);
        [headView addSubview:view];

    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 178, CEHUWIDTH, 1)];
    view.backgroundColor = RGBColor(89, 108, 165);
    [headView addSubview:view];
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CEHUWIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
//    table.bounces = NO;
    table.showsVerticalScrollIndicator = NO;
    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    dataSource = [[NSMutableArray alloc]initWithArray:@[@"我的小视频",@"我的相册",@"充值中心",@"我的收益"]];
    table.backgroundColor = [UIColor clearColor];
    [table registerNib:[UINib nibWithNibName:@"cehuaTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];
    table.tableHeaderView = headView;
    UIView *bottomlineView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-41, CEHUWIDTH, 1)];
    bottomlineView.backgroundColor = RGBColor(89, 108, 165);
    [self.view addSubview:bottomlineView];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-40, CEHUWIDTH, 40)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    NSArray *arr2 = @[@"设置",@"意见反馈"];
    NSArray *arr3 = @[@"个人_31",@"个人_34"];
    for (int i=0; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0+CEHUWIDTH/2*i, 0 , CEHUWIDTH/2, 40)];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 9000+i;
        [bottomView addSubview:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomView:)];
        [view addGestureRecognizer:tap];
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(CEHUWIDTH/4-40, 10, 20, 20)];
        [leftBtn setBackgroundImage:[UIImage imageNamed:arr3[i]] forState:UIControlStateNormal];
        [view addSubview:leftBtn];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(CEHUWIDTH/4-10, 5, CEHUWIDTH/4, 30)];
        lable.text = arr2[i];
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:14];
        lable.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lable];
        
    }
    UIView *bottomlineView2 = [[UIView alloc]initWithFrame:CGRectMake(CEHUWIDTH/2, HEIGHT-40, 1, 40)];
    bottomlineView2.backgroundColor = RGBColor(89, 108, 165);
    [self.view addSubview:bottomlineView2];
    
}
-(void)bottomView:(UITapGestureRecognizer *)tap{
    if (tap.view.tag == 9000) {
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        setViewController *set = [[setViewController alloc]init];
        [vc pushViewController:set animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }else{
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        fankuiViewController *set = [[fankuiViewController alloc]init];
        [vc pushViewController:set animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }
   

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"str";
    cehuaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[cehuaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.lable.text = dataSource[indexPath.row];
    cell.image.image = [UIImage imageNamed:dataSource2[indexPath.row]];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
//        UINavigationController *vc =   nav.viewControllers[0];
//        wodePindaoViewController *wode = [[wodePindaoViewController alloc]init];
//        [vc pushViewController:wode animated:NO];
//        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
//        }];
//    }else
    
    /*if (indexPath.row == 0) {
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        myLivingViewController *wode = [[myLivingViewController alloc]init];
        [vc pushViewController:wode animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }else
     */
    if (indexPath.row ==1) {
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        myPicturesViewController *wode = [[myPicturesViewController alloc]init];
        [vc pushViewController:wode animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }else if (indexPath.row == 2) {
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        chargeViewController *wode = [[chargeViewController alloc]init];
        [vc pushViewController:wode animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }
    /*else if (indexPath.row == 3) {
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        mySpecialViewController *wode = [[mySpecialViewController alloc]init];
        [vc pushViewController:wode animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
    }
     */else if (indexPath.row == 3) {
        UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
        UINavigationController *vc =   nav.viewControllers[0];
        myShouyiViewController *wode = [[myShouyiViewController alloc]init];
        [vc pushViewController:wode animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
     }else if (indexPath.row==0)
     {
         UITabBarController * nav  = (UITabBarController*)self.mm_drawerController.centerViewController;
         UINavigationController *vc =   nav.viewControllers[0];
         SmallVideoListController*smallVideo=[SmallVideoListController new];
         smallVideo.isMyself=YES;
         smallVideo.userID=[USERDEFAULT valueForKey:@"uid"];
         [vc pushViewController:smallVideo animated:NO];
         [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished)
         {
             //        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
         }];
     }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
