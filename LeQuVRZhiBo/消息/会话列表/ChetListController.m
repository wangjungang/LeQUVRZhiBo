//
//  ChetListController.m
//  Medical
//
//  Created by 李壮 on 2016/11/30.
//  Copyright © 2016年 张婷. All rights reserved.
//

#import "ChetListController.h"
#import "RongChetController.h"
@interface ChetListController ()

@end

@implementation ChetListController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden=NO;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"left" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"right" object:nil];
}
-(void)left:(id)user{
    if ([[user userInfo][@"left"] isEqualToString:@"3"]) {
        zhiboingViewController *zhiboing = [[zhiboingViewController alloc] init];
        [self.navigationController pushViewController:zhiboing animated:YES];
    }
   
}
-(void)right:(id)user{
    if ([[user userInfo][@"right"] isEqualToString:@"3"]) {
        [self presentViewController:[SmallVideoController new] animated:YES completion:nil];

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(left:) name:@"left" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(right:) name:@"right" object:nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict2;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11"]forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    [self.conversationListTableView reloadData];
    self.conversationListTableView.separatorColor = [UIColor clearColor];
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
    self.emptyConversationView = [[UIView alloc]init];
}
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RongChetController *conversationVC = [[RongChetController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title =model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
//    RCIM*cim=[RCIM sharedRCIM];
//    cim.receiveMessageDelegate=self;
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
