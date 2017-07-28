//
//  shequViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/7.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "shequViewController.h"
#import "shequ2TableViewCell.h"
#import "shequ3TableViewCell.h"
#import "personInfoViewController.h"
//社区评论Col
#import "CommunityAnswerController.h"
//社区model
#import "CommunityListBase.h"
#import "CommunityListData.h"
#import "MJRefresh.h"
@interface shequViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    UITableView *table;
    NSMutableArray *dataSource;
    NSInteger page;
}
@property (nonatomic,strong)UITableView*litab;

@end

@implementation shequViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=NO;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden=NO;
    [self addPullRefresh];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"left" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"right" object:nil];
}
-(void)left:(id)user{
    if ([[user userInfo][@"left"] isEqualToString:@"1"]) {
        zhiboingViewController *zhiboing = [[zhiboingViewController alloc] init];
        [self.navigationController pushViewController:zhiboing animated:YES];
    }
    
}
-(void)right:(id)user{
    if ([[user userInfo][@"right"] isEqualToString:@"1"]) {
        [self presentViewController:[SmallVideoController new] animated:YES completion:nil];
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"社区";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(left:) name:@"left" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(right:) name:@"right" object:nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict2;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11"]forBarMetrics:UIBarMetricsDefault];
    self.litab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.litab.delegate = self;
    self.litab.dataSource = self;
    //    table.bounces = NO;
    self.litab.showsVerticalScrollIndicator = NO;
    //    table.separatorColor = [UIColor clearColor];
    self.litab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.litab];
    dataSource = [[NSMutableArray alloc]init];
    self.litab.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];
    [self.litab registerNib:[UINib nibWithNibName:@"shequ2TableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];
    [self.litab registerNib:[UINib nibWithNibName:@"shequ3TableViewCell" bundle:nil] forCellReuseIdentifier:@"str2"];
    [self addInfinte];
    
}
#pragma mark-
#pragma mark-上拉加载更多
- (void)addInfinte
{
    _litab.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page+=1;
        [self getCommunityList];
//        [_litab.mj_footer endRefreshing];

    }];
}
- (void)addPullRefresh
{
    _litab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [dataSource removeAllObjects];
        [self getCommunityList];

    }];
    [_litab.mj_header beginRefreshing];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityListData*data;
    if (dataSource.count>0)
    {
       data=dataSource[indexPath.row];
    }
    if ([data.pic isEqualToString:@""]||!data.pic)
    {
        static NSString *str = @"str";
        shequ2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[shequ2TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.name.text = data.nickname;
        cell.avatar.layer.cornerRadius = 25;
        cell.avatar.layer.masksToBounds = YES;
        [cell.avatar setImageWithURL:[NSURL URLWithString:data.headPic] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.avatar.userInteractionEnabled = YES;
        cell.avatar.tag = 500+indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pic:)];
        [cell.avatar addGestureRecognizer:tap];
        cell.time.text = data.time;
        
        cell.jieshao.text = data.content;
        [cell setIntroductionText:cell.jieshao.text];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *str = @"str2";
        shequ3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[shequ3TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.name.text = data.nickname;
        cell.avatar.layer.cornerRadius = 25;
        cell.avatar.layer.masksToBounds = YES;
        cell.avatar.userInteractionEnabled = YES;
        cell.avatar.tag = 500+indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pic:)];
        [cell.avatar addGestureRecognizer:tap];
        [cell.avatar setImageWithURL:[NSURL URLWithString:data.headPic] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.jieshao.text = data.content;
        cell.time.text = data.time;
        NSArray*array=[data.pic componentsSeparatedByString:@","];
        [cell.image setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@"load"]];
        if (array.count>1)
        {
            [cell.image2 setImageWithURL:[NSURL URLWithString:array[1]] placeholderImage:[UIImage imageNamed:@"load"]];
        }else
        {
            cell.image2.hidden=YES;
        }
        [cell setIntroductionText:cell.jieshao.text];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(void)pic:(UITapGestureRecognizer *)tap{
    personInfoViewController *person = [[personInfoViewController alloc]init];
    CommunityListData*data=dataSource[tap.view.tag-500];
    person.uid = data.uid;
    [self.navigationController pushViewController:person animated:YES];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityListData*data;
    if (dataSource.count>0)
    {
        data=dataSource[indexPath.row];
    }
    if ([data.pic isEqualToString:@""]) {
        UITableViewCell *cell = [self tableView:_litab cellForRowAtIndexPath:indexPath];
        
        return cell.frame.size.height;
    }else{
        UITableViewCell *cell = [self tableView:_litab cellForRowAtIndexPath:indexPath];
        
        return cell.frame.size.height;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityListData*data=dataSource[indexPath.row];
    CommunityAnswerController*communityCon=[CommunityAnswerController new];
    communityCon.data=data;
    [self.navigationController pushViewController:communityCon animated:YES];
}
#pragma mark-
#pragma mark-获取社区附近列表
- (void)getCommunityList
{
    [AFManager getReqURL:[NSString stringWithFormat:SHEQU,[USERDEFAULT valueForKey:@"uid"],[USERDEFAULT valueForKey:@"latitude"],[USERDEFAULT valueForKey:@"lon"],page] block:^(id infor) {
        
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            if (page == 0) {
                [dataSource removeAllObjects];
                [_litab.mj_footer resetNoMoreData];
            }
            CommunityListBase*bsse=[CommunityListBase modelObjectWithDictionary:infor];
            if ([bsse.data count]<15) {
                [_litab.mj_footer endRefreshingWithNoMoreData];
            }
            [dataSource addObjectsFromArray:bsse.data];
            [_litab reloadData];
            
        }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"202"]) {
            [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"暂时没有动态" andSelfVC:self];
            if (page == 0) {
                [dataSource removeAllObjects];
            }
            [_litab.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_litab.mj_footer endRefreshing];
        }
        [_litab.mj_header endRefreshing];
    } errorblock:^(NSError *error)
    {
        [_litab.mj_header endRefreshing];
        [_litab.mj_footer endRefreshing];
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
