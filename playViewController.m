//
//  playViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/7.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "playViewController.h"
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "UCloudMediaPlayer.h"
@interface playViewController ()
@property (nonatomic) BOOL barHidden;

@end

@implementation playViewController
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
    self.mediaPlayer = [UCloudMediaPlayer ucloudMediaPlayer];
//    self.mediaPlayer.defaultDecodeMethod = DecodeMethodHard;
//    self.mediaPlayer.defaultScalingMode = MPMovieScalingModeAspectFill;
    [self.mediaPlayer showMediaPlayer:PlayDomain(@"123456") urltype:UrlTypeLive frame:CGRectNull view:self.view completion:^(NSInteger defaultNum, NSArray *data) {
        
        
    }];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 50, HEIGHT-50, 30, 30)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"直播_22"] forState:UIControlStateNormal];
    closeBtn.selected = NO;
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (void)closeBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
