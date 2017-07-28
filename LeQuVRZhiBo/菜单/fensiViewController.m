//
//  fensiViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/23.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "fensiViewController.h"
#import "shequTableViewCell.h"
#import "personInfoViewController.h"
#import "MJRefresh.h"
//model
#import "FansListBase.h"
#import "FansListData.h"
@interface fensiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
    NSInteger page;
}

@property (nonatomic,strong)UITableView*litab;
@end

@implementation fensiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self addPullRefresh];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"粉丝";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    self.litab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.litab.delegate = self;
    self.litab.dataSource = self;
    //    table.bounces = NO;
    self.litab.showsVerticalScrollIndicator = NO;
    //    table.separatorColor = [UIColor clearColor];
    self.litab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.litab];
    dataSource = [[NSMutableArray alloc]init];
    self.litab.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];
    [self.litab registerNib:[UINib nibWithNibName:@"shequTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];
    [self addInfinte];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    personInfoViewController *person = [[personInfoViewController alloc]init];
    FansListData*data=dataSource[indexPath.row];
    person.uid = data.fansid;
    [self.navigationController pushViewController:person animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"str";
    shequTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[shequTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    FansListData*data=dataSource[indexPath.row];
    cell.name.text = data.nickname;
    cell.jieshao.text = [NSString stringWithFormat:@"%@",data.autoProperty];
    cell.level.text = [NSString stringWithFormat:@"%@",data.levelid];
    [cell.avatar setImageWithURL:[NSURL URLWithString:data.headPic]];
    cell.avatar.layer.cornerRadius = 25;
    cell.avatar.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//设置table view 为可编辑的
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//设置可编辑的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//设置处理编辑情况
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
}
#pragma mark - 返回按钮／处理按钮的点击事件
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"举报" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了举报");
        
    }];
    deleteRowAction.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    //添加一个更多按钮
    FansListData*data=dataSource[indexPath.row];
    NSArray*nameAry=@[@"关注",@"取消关注"];
    NSInteger index=[data.status integerValue];
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:nameAry[index] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
    {
        if (index==0)
        {
            [self Concern:data.fansid];
        }else
        {
            [self cancleConcern:data.fansid];
        }
    }];
    moreRowAction.backgroundColor = [UIColor redColor];
//    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //将设置好的按钮存放到数组中(按钮对象在数组中的索引从0到最多,在tableViewCell中的显示则是从右到左依次排列)
   
    return @[moreRowAction,deleteRowAction];
}
#pragma mark-
#pragma mark-上拉加载更多
- (void)addInfinte
{
    _litab.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page+=1;
        [self getFansList];
    }];
}
- (void)addPullRefresh
{
    _litab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [dataSource removeAllObjects];
        [self getFansList];
    }];
    [_litab.mj_header beginRefreshing];
}
#pragma mark-
#pragma mark-获取数据源
- (void)getFansList
{
    [AFManager getReqURL: [NSString stringWithFormat:FENSILIST,[USERDEFAULT valueForKey:@"uid"],page] block:^(id infor)
    {
        NSLog(@"%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"])
        {
            FansListBase*base=[FansListBase modelObjectWithDictionary:infor];
            [dataSource addObjectsFromArray:base.data];
            [_litab.mj_footer endRefreshing];
        }else
        {
            [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"没有更多粉丝" andSelfVC:self];
            [_litab.mj_footer endRefreshingWithNoMoreData];
        }
        [self.litab reloadData];
        [self.litab.mj_header endRefreshing];
    } errorblock:^(NSError *error)
    {
        [self.litab.mj_header endRefreshing];
        [self.litab.mj_footer endRefreshing];
    }];
}
//关注接口
- (void)Concern:(NSString*)ID
{
    [AFManager getReqURL:[NSString stringWithFormat:CONCERN_USER_URL,ID,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"])
        {
            [self.litab.mj_header beginRefreshing];
        }
    } errorblock:^(NSError *error) {
        
    }];
}
//取消关注接口
- (void)cancleConcern:(NSString*)ID
{
    [AFManager getReqURL:[NSString stringWithFormat:CANCLE_CONCERN_URL,ID,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor)
     {
         if ([[infor objectForKey:@"code"]integerValue]==200)
         {
             [NSObject wj_showHUDWithTip:@"取消成功"];
             [self.litab.mj_header beginRefreshing];
         }else{
             [NSObject wj_showHUDWithTip:@"取消失败"];
         }
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
