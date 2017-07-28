//
//  dongtaiViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/23.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "dongtaiViewController.h"
#import "dongtaiTableViewCell.h"
#import "dongtai2TableViewCell.h"
#import "fabiaodongtaiViewController.h"
#import "MJRefresh.h"
//社区评论Col
#import "CommunityAnswerController.h"
//社区model
#import "CommunityListBase.h"
#import "CommunityListData.h"

@interface dongtaiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
    NSInteger page;
}
@property (nonatomic,strong)UITableView*litab;
@end

@implementation dongtaiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [self addPullRefresh];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)dongtai{
    fabiaodongtaiViewController *fabu = [[fabiaodongtaiViewController alloc]init];
    [self.navigationController pushViewController:fabu animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"动态";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    if (self.isMyself)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [button setBackgroundImage:[UIImage imageNamed:@"社区_03"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dongtai) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *ietm = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = ietm;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
    [backView setImageWithURL:[NSURL URLWithString:_headUrl] placeholderImage:[UIImage imageNamed:@"load"]];
    [view addSubview:backView];
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, 150, 120, 30)];
    nameLable.text = _nickName;
    nameLable.textColor = [UIColor whiteColor];
    nameLable.font = [UIFont systemFontOfSize:16];
    nameLable.textAlignment = NSTextAlignmentCenter;
    [view addSubview:nameLable];
    UIImageView *backView2 = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-80, 155, 50, 50)];
    [backView2 setImageWithURL:[NSURL URLWithString:_headUrl] placeholderImage:[UIImage imageNamed:@"load"]];
    backView2.layer.cornerRadius = 25;
    backView2.layer.masksToBounds = YES;
    backView2.layer.borderColor = [[UIColor whiteColor]CGColor];
    backView2.layer.borderWidth = 2;
    [view addSubview:backView2];
    
    self.litab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.litab.delegate = self;
    self.litab.dataSource = self;
    //    table.bounces = NO;
    self.litab.showsVerticalScrollIndicator = NO;
    //    table.separatorColor = [UIColor clearColor];
    self.litab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.litab];
    self.litab.tableHeaderView = view;
    dataSource = [[NSMutableArray alloc]init];
    self.litab.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];
    [self.litab registerNib:[UINib nibWithNibName:@"dongtaiTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];
    [self.litab registerNib:[UINib nibWithNibName:@"dongtai2TableViewCell" bundle:nil] forCellReuseIdentifier:@"str2"];
    [self addInfinte];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityListData*data=dataSource[indexPath.row];
    
    if ([data.pic isEqualToString:@""]||!data.pic)
    {
        static NSString *str = @"str";
        dongtaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[dongtaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.avatar.layer.cornerRadius = 25;
        cell.avatar.layer.masksToBounds = YES;
        [cell.avatar setImageWithURL:[NSURL URLWithString:data.headPic] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.name.text =data.nickname;
        cell.jieshao.text = data.content;
        cell.time.text = data.time;
        [cell setIntroductionText:cell.jieshao.text];
        if (_isMyself)
        {
            [cell.button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            cell.button.tag = [data.dataIdentifier intValue]+100;
        }else{
            cell.button.hidden=YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *str = @"str2";
        dongtai2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[dongtai2TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.avatar.layer.cornerRadius = 25;
        cell.avatar.layer.masksToBounds = YES;
        [cell.avatar setImageWithURL:[NSURL URLWithString:data.headPic] placeholderImage:[UIImage imageNamed:@"load"]];
        cell.name.text =data.nickname;
        cell.jieshao.text = data.content;
        cell.time.text = data.time;
        NSArray *pic = [data.pic componentsSeparatedByString:@","];
        if (pic.count == 1) {
            [cell.image setImageWithURL:[NSURL URLWithString:pic[0]]];
            cell.image2.image = [UIImage imageNamed:@""];
        }else{
            [cell.image setImageWithURL:[NSURL URLWithString:pic[0]]];
            [cell.image2 setImageWithURL:[NSURL URLWithString:pic[1]]];
        }
        if (_isMyself)
        {
            [cell.button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            cell.button.tag = [data.dataIdentifier intValue]+100;
        }else
        {
            cell.button.hidden=YES;
        }
        [cell setIntroductionText:cell.jieshao.text];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)delete:(UIButton *)btn{
    [NSObject wj_selVcWithTitle:@"确定删除此条动态？" TitleExplain:nil FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:WJNewPresentFromCenter FirstOrSureBlock:^(NSString *userSelStr)
    {
    } SecondSelOrCancelBlock:^(NSString *userSelStr)
    {
        [self deleteAction:[NSString stringWithFormat:@"%ld",btn.tag-100]];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommunityListData*data=dataSource[indexPath.row];
    if ([data.pic isEqualToString:@""]||!data.pic) {
        UITableViewCell *cell = [self tableView:self.litab cellForRowAtIndexPath:indexPath];
        
        return cell.frame.size.height;
    }else{
        UITableViewCell *cell = [self tableView:self.litab cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityListData*data=dataSource[indexPath.row];
    CommunityAnswerController*communityCon=[CommunityAnswerController new];
    communityCon.data=data;
    [self.navigationController pushViewController:communityCon animated:YES];
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
        page = 1;
        [dataSource removeAllObjects];
        [self getCommunityList];
    }];
    [_litab.mj_header beginRefreshing];
}
#pragma mark-
#pragma mark-获取数据源
//获取动态列表
- (void)getCommunityList
{
    [AFManager getReqURL2:[NSString stringWithFormat:@"%@?uid=%@&page=%ld&num=15",DONGTAILIST,self.uid,page] block:^(id infor)
    {
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"])
        {
           CommunityListBase*base =[CommunityListBase modelObjectWithDictionary:infor];
            [dataSource addObjectsFromArray:base.data];
            [self.litab.mj_footer endRefreshing];
        }else
        {
            [NSObject wj_showHUDWithTip:@"没有更多动态"];
            [_litab.mj_footer endRefreshingWithNoMoreData];
        }
        [self.litab reloadData];
        [self.litab.mj_header endRefreshing];
    } errorblock:^(NSError *error) {
        [self.litab.mj_header endRefreshing];
        [self.litab.mj_footer endRefreshing];
    }];
}
//删除接口
- (void)deleteAction:(NSString*)ID
{
    [AFManager getReqURL:[NSString stringWithFormat:SHANCHUDONGTAI,ID,self.uid] block:^(id infor)
    {
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"])
        {
            [NSObject wj_showHUDWithTip:@"删除成功"];
            [self addPullRefresh];
        }else
        {
            [NSObject wj_showHUDWithTip:@"删除失败"];
        }
    } errorblock:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
