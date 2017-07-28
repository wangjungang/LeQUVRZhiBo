//
//  SmallVideoListController.m
//  LeQuVRZhiBo
//
//  Created by 李壮 on 2016/12/28.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "SmallVideoListController.h"
#import "WCSPlayMovieController.h"
//cell
#import "SmallVideoListCell.h"
//model
#import "SmallVideoListBase.h"
#import "SmallVideoListData.h"
//
#import "NSObject+HUD.h"
//
#import "MJRefresh.h"
@interface SmallVideoListController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *videoDataAry;
    NSInteger page;
}
@property (nonatomic,strong)UITableView*litab;
@property (nonatomic,strong)WCSPlayMovieController *playVC;
@end

@implementation SmallVideoListController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout =UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self CustomBackButton];
    self.title=@"视频列表";
    videoDataAry=[NSMutableArray array];
    [self createTable];
}
- (void)createTable
{
    if (!_litab)
    {
        _litab =[[UITableView alloc]initWithFrame:CGRectMake(0, 44, DEVICE_WIDTH, DEVICE_HEIGHT-44) style:UITableViewStylePlain];
        _litab.dataSource=self;
        _litab.delegate=self;
        [self.view addSubview:_litab];
        [_litab registerClass:[SmallVideoListCell class] forCellReuseIdentifier:@"SmallVideoListCell.h"];
        _litab.separatorStyle=UITableViewCellSeparatorStyleNone;
//        [self getDataList];
        [self addInfinte];
    }else
    {
        [_litab reloadData];
    }
}
#pragma mark-
#pragma mark-上拉加载更多
- (void)addInfinte
{
    _litab.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page+=1;
        [self getDataList];
        //        [_litab.mj_footer endRefreshing];
    }];
    [_litab.mj_footer beginRefreshing];
}
//- (void)addPullRefresh
//{
//    _litab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        page = 1;
//        [videoDataAry removeAllObjects];
//        [self getDataList];
//    }];
//    [_litab.mj_header beginRefreshing];
//}
#pragma mark-
#pragma mark-tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return videoDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    SmallVideoListCell*cell=[tableView dequeueReusableCellWithIdentifier:@"SmallVideoListCell.h" forIndexPath:indexPath];
    SmallVideoListData*data;
    if (videoDataAry.count!=0) {
        data=videoDataAry[indexPath.row];
    }
    [cell setCellData:data];
    cell.startBtn.tag=indexPath.row+1000;
    [cell.startBtn addTarget:self action:@selector(startVideo:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"======%ld====",indexPath.row);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SmallVideoListData*data;
    if (videoDataAry.count!=0) {
        data=videoDataAry[indexPath.row];
    }
    return data.rowHeight;
}
//设置编辑风格EditingStyle
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (_isMyself)
    {
        return UITableViewCellEditingStyleDelete;
    }
    //当表视图处于没有未编辑状态时选择左滑删除
    return UITableViewCellEditingStyleNone;
}
//根据不同的editingstyle执行数据删除操作（点击左滑删除按钮的执行的方法）
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        SmallVideoListData*data=videoDataAry[indexPath.row];
        [NSObject wj_selVcWithTitle:@"温馨提示" TitleExplain:@"确定要删除吗？" FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:1 FirstOrSureBlock:^(NSString *userSelStr)
         {
         } SecondSelOrCancelBlock:^(NSString *userSelStr)
         {
             [self deleteCommunity:data.dataIdentifier videoName:data.key];
             
         }];
    }
}
//修改左滑删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)startVideo:(UIButton*)btn
{
    SmallVideoListData*data=videoDataAry[btn.tag-1000];
    [self showMovieAction:[NSString stringWithFormat:@"http://%@",data.dir]];
    
    if (![_userID isEqualToString:[USERDEFAULT valueForKey:@"uid"]])
    {
        [self addPeopleCountVideo:data.dataIdentifier];
    }
}
//播放小视频按钮
- (void)showMovieAction:(NSString*)urlStr {
    NSURL*videoURL=[NSURL URLWithString:urlStr];
    self.navigationController.navigationBar.hidden=YES;
    WCSPlayMovieController *playVC = [[WCSPlayMovieController alloc] init];
    playVC.movieURL = videoURL;
    
    [self displayChildController:playVC];
    
    _playVC = playVC;
    
}
#pragma mark - displayChildController
- (void) displayChildController: (UIViewController*) child {
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    child.view.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    [child didMoveToParentViewController:self];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideContentController:self.playVC];
    self.playVC = nil;
}
- (void) hideContentController: (UIViewController*) child {
    [child willMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
    self.navigationController.navigationBar.hidden=NO;

}
#pragma mark-
#pragma mark-获取数据源
//获取视频列表
- (void)getDataList
{
    [AFManager getReqURL:[NSString stringWithFormat:SMALL_VIDEO_LIST_URL,_userID,page] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            SmallVideoListBase*videoBase=[SmallVideoListBase modelObjectWithDictionary:infor];
            [videoDataAry addObjectsFromArray:videoBase.data];
            [_litab.mj_footer endRefreshing];
        }else if([[infor objectForKey:@"code"]integerValue]==201)
        {
            if (videoDataAry.count==0)
            {
                [NSObject wj_showHUDWithTip:@"该用户暂时没有发过任何视频"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else
            {
                [NSObject wj_showHUDWithTip:@"已经显示全部了"];
                [_litab.mj_footer endRefreshingWithNoMoreData];
            }
        }
       
        [_litab reloadData];
        self.navigationController.navigationBar.hidden=NO;
    } errorblock:^(NSError *error)
    {
        
    }];
}
//删除列表
- (void)deleteCommunity:(NSString*)dataId videoName:(NSString*)videoName
{
    [AFManager getReqURL:[NSString stringWithFormat:DELEGATE_VIDEO_URL,dataId,videoName] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            [NSObject wj_showHUDWithTip:@"删除成功"];
            [videoDataAry removeAllObjects];
            page=1;
            [self.litab.mj_footer beginRefreshing];
        }else if ([[infor objectForKey:@"code"]integerValue]==201)
        {
            [NSObject wj_showHUDWithTip:@"删除失败"];
        }
    } errorblock:^(NSError *error)
    {
        
    }];
}
///观看小视频增加count接口
- (void)addPeopleCountVideo:(NSString*)VideoId
{
    [AFManager getReqURL:[NSString stringWithFormat:ADD_PEOPLE_VIDEO_URL,_userID,VideoId] block:^(id infor)
    {
        
    } errorblock:^(NSError *error)
    {
        
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
