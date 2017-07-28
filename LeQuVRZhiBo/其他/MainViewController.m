//
//  MainViewController.m
//  SinaWeibo
//
//  Created by user on 15/10/13.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import "MainViewController.h"

#import "ZTNavigationController.h"
#import "ZTTabBar.h"
#import "zhiboViewController.h"
#import "shequViewController.h"
#import "lepaihangViewController.h"
#import "xiaoxiViewController.h"
#import "zhiboingViewController.h"
#import "cehuaViewController.h"
//小视频
#import "SmallVideoController.h"
@interface MainViewController () <ZTTabBarDelegate>
{
    UIView *bottomView;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *tabView = [[UIView alloc]init];
    tabView.backgroundColor = [UIColor blackColor];
    tabView.frame = self.tabBar.bounds;
    [[UITabBar appearance] insertSubview:tabView atIndex:0];
    ZTTabBar *tabBar = [[ZTTabBar alloc] init];
    tabBar.delegate = self;
    // KVC：如果要修系统的某些属性，但被设为readOnly，就是用KVC，即setValue：forKey：。
    [self setValue:tabBar forKey:@"tabBar"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBColor(123, 123, 123)} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBColor(197, 75, 100)} forState:UIControlStateSelected];
//    childVc.view.backgroundColor = RandomColor; // 这句代码会自动加载主页，消息，发现，我四个控制器的view，但是view要在我们用的时候去提前加载
    
        // 为子控制器包装导航控制器
        ZTNavigationController *navigationVc = [[ZTNavigationController alloc] initWithRootViewController:childVc];
        // 添加子控制器
        [self addChildViewController:navigationVc];
//    }
    

    
}

#pragma ZTTabBarDelegate
/**
 *  加号按钮点击
 */
- (void)tabBarDidClickPlusButton:(ZTTabBar *)tabBar
{
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    UIView *bottomView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-150)];
    bottomView2.backgroundColor = [UIColor blackColor];
    bottomView2.alpha = 0.3;
    [bottomView addSubview:bottomView2];
    [UIView animateWithDuration:0.5 animations:^{
        
        
        UIView *bottomView3 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-150, WIDTH, 150)];
        bottomView3.backgroundColor = [UIColor whiteColor];
        [bottomView addSubview:bottomView3];
        
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/4-47/2, 30, 47, 36)];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"底部按钮_03"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView3 addSubview:leftBtn];
        
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/4*3-39/2, 30, 39, 36)];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"底部按钮_05"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView3 addSubview:rightBtn];
        
        UIButton *centerBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2-20/2, 90, 20, 20)];
        [centerBtn setBackgroundImage:[UIImage imageNamed:@"底部按钮_10"] forState:UIControlStateNormal];
        [centerBtn addTarget:self action:@selector(centerBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView3 addSubview:centerBtn];
    }];
    

}
-(void)leftBtn:(UIButton *)btn{
    bottomView.frame = CGRectMake(0, HEIGHT+200, WIDTH, HEIGHT);
    if (self.selectedIndex == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"left" object:nil userInfo:@{@"left":@"0"}];

    }else if (self.selectedIndex == 1){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"left" object:nil userInfo:@{@"left":@"1"}];

    }else if (self.selectedIndex == 2){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"left" object:nil userInfo:@{@"left":@"2"}];

    }else if (self.selectedIndex == 3){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"left" object:nil userInfo:@{@"left":@"3"}];

    }
    
}
-(void)rightBtn:(UIButton *)btn{
    if (self.selectedIndex == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"right" object:nil userInfo:@{@"right":@"0"}];
        
    }else if (self.selectedIndex == 1){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"right" object:nil userInfo:@{@"right":@"1"}];
        
    }else if (self.selectedIndex == 2){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"right" object:nil userInfo:@{@"right":@"2"}];
        
    }else if (self.selectedIndex == 3){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"right" object:nil userInfo:@{@"right":@"3"}];
        
    }
    bottomView.frame = CGRectMake(0, HEIGHT+200, WIDTH, HEIGHT);

    
}
-(void)centerBtn:(UIButton *)btn{
    
    bottomView.frame = CGRectMake(0, HEIGHT+200, WIDTH, HEIGHT);
}

@end
