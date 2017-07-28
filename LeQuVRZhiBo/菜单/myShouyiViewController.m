//
//  myShouyiViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/14.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "myShouyiViewController.h"
#import "tixianViewController.h"
#import "myshouyiView.h"
@interface myShouyiViewController ()
@property (nonatomic,strong) myshouyiView *myview;
@end

@implementation myShouyiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",SHOUYI,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
        NSLog(@"%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            _myview.shouyinumber1.text = infor[@"balance"];
            _myview.shouyinumber2.text = infor[@"earn"];
        
        }
    } errorblock:^(NSError *error) {
        
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的收益";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                          NSForegroundColorAttributeName,
                          [UIFont boldSystemFontOfSize:14],
                          NSFontAttributeName,nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"提现" style:UIBarButtonItemStyleDone target:self action:@selector(item:)];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    self.view.backgroundColor = [UIColor wjColorFloat:@"e88169"];
    [self.view addSubview:self.myview];
}
-(void)item:(UIBarButtonItem *)item{
    tixianViewController *tixian = [[tixianViewController alloc]init];
    [self.navigationController pushViewController:tixian animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

-(myshouyiView *)myview
{
    if(!_myview)
    {
        _myview = [[myshouyiView alloc] init];
        _myview.frame = CGRectMake(20, 60, WIDTH-40, HEIGHT-180);
        _myview.backgroundColor = [UIColor wjColorFloat:@"FBF4F1"];
        _myview.layer.masksToBounds = YES;
        _myview.layer.cornerRadius = 20;
        _myview.layer.borderWidth = 5;
        _myview.layer.borderColor = [UIColor wjColorFloat:@"F4C1B4"].CGColor;
        

        
    }
    return _myview;
}

@end
