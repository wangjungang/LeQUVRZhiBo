//
//  CommunityAnswerController.m
//  LeQuVRZhiBo
//
//  Created by 李壮 on 2016/12/16.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "CommunityAnswerController.h"
//区头View
#import "CommunityAnswerHeaderView.h"
#import "CommunityAnswerCell.h"
#import "RCDLiveInputBar.h"
#import "NSObject+MBProgressHUD.h"
//回复model
#import "ReplyListBase.h"
#import "ReplyListData.h"
//点赞model
#import "ZanListBase.h"
#import "ZanListData.h"
#import "MJRefresh.h"
//输入框的高度
#define MinHeight_InputView 50.0f

@interface CommunityAnswerController ()<UITableViewDelegate,UITableViewDataSource,RCTKInputBarControlDelegate,RCDLiveInputBarDelegate2>
{
    NSMutableArray*replyDataAry;
    NSMutableArray*zanListAry;
    NSString *replyId;
    NSString *replyNickname;
    BOOL      isReply;
    NSInteger page;
}
@property (nonatomic,strong)RCDLiveInputBar*inputBar;
@property (nonatomic,strong)UITableView*litab;
@property (nonatomic,strong)UILabel*zanLb;
@property (nonatomic,strong)CommunityAnswerHeaderView*headerView;

@end

@implementation CommunityAnswerController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"社区";
    [self CustomBackButton];
    self.view.backgroundColor =[UIColor whiteColor];
    replyDataAry=[NSMutableArray array];
    zanListAry = [NSMutableArray array];
    [self createTable];
    [self createinputView];
}

#pragma mark-
#pragma mark-初始化表
- (void)createTable
{
    if (!_litab) {
        _litab =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
        _litab.dataSource=self;
        _litab.delegate=self;
        _litab.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_litab];
        [_litab registerClass:[CommunityAnswerCell class] forCellReuseIdentifier:@"CommunityAnswerCell.h"];
//        [self getCommunityList];
        [self addPullRefresh];
        [self addInfinte];
        [self addZanList];
    }else{
        [_litab reloadData];
    }
}
//回复按钮
- (void)answerBtn
{
    isReply=NO;
    self.inputBar.hidden=NO;
    [self.inputBar setInputBarStatus:KBottomBarKeyboardStatusss];
    [self.inputBar.chatSessionInputBarControl.inputTextView becomeFirstResponder];
}
//点赞按钮
- (void)zanBtn
{
    [self addZan];
}
#pragma mark-
#pragma mark-输入框
- (void)createinputView
{
    if(self.inputBar == nil){
        float inputBarOriginY = DEVICE_HEIGHT;
        float inputBarOriginX = 0;
        float inputBarSizeWidth = self.view.frame.size.width;
        float inputBarSizeHeight = MinHeight_InputView;
        self.inputBar = [[RCDLiveInputBar alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight) inViewConroller:self];
        self.inputBar.delegate = self;
        self.inputBar.hidden = YES;
        self.inputBar.chatSessionInputBarControl.num = @"1";
        self.inputBar.chatSessionInputBarControl.delegate2 = self;
        [self.view addSubview:self.inputBar];
        [self.view bringSubviewToFront:self.inputBar];
    }
}
//输入框点击发送按钮
- (void)onTouchSendButton:(NSString *)text
{
    if (isReply)
    {   text=[NSString stringWithFormat:@"%@回复%@：%@",[USERDEFAULT valueForKey:@"nickname"],replyNickname,text];
        [self replyCommunity:text cid:replyId];
    }else
    {
        [self sendCommunityContent:text];
    }
    self.inputBar.hidden=YES;
    [self.inputBar.chatSessionInputBarControl.inputTextView resignFirstResponder];
}
//输入框位置
- (void)onInputBarControlContentSizeChanged:(CGRect)frame
                      withAnimationDuration:(CGFloat)duration
                          andAnimationCurve:(UIViewAnimationCurve)curve
{
    CGRect collectionViewRect = self.litab.frame;
    collectionViewRect.size.height = DEVICE_HEIGHT -57- (DEVICE_HEIGHT-frame.origin.y);
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        [self.litab setFrame:collectionViewRect];
        [UIView commitAnimations];
    }];
    CGRect inputbarRect = self.inputBar.frame;
    
    inputbarRect.origin.y = self.litab.frame.origin.y+self.litab.frame.size.height;
    [self.inputBar setFrame:inputbarRect];
}
#pragma mark-
#pragma mark-tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return replyDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CommunityAnswerCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CommunityAnswerCell.h" forIndexPath:indexPath];
    if (replyDataAry.count>0)
    {
        [cell setContentData:replyDataAry[indexPath.row]];
    }
    cell.answerBtn.tag=indexPath.row*1000+1;
//    cell.deleteBtn.tag=indexPath.row*10000+10;
    [cell.answerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//     [cell.deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyListData*data;
    if (replyDataAry.count>0) {
        data=replyDataAry[indexPath.row];
        return data.rowHeight;
    }
    return 0;
}
//设置编辑风格EditingStyle
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    ReplyListData*data;
    if (replyDataAry.count>0)
    {
        data=replyDataAry[indexPath.row];
        if ([data.uid isEqualToString:[USERDEFAULT valueForKey:@"uid"]])
        {
            return UITableViewCellEditingStyleDelete;
        }
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
        ReplyListData*data=replyDataAry[indexPath.row];
        [NSObject wj_selVcWithTitle:@"温馨提示" TitleExplain:@"确定要删除吗？" FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:1 FirstOrSureBlock:^(NSString *userSelStr)
         {
         } SecondSelOrCancelBlock:^(NSString *userSelStr)
         {
             [self deleteCommunity:data.dataIdentifier];
             
         }];
    }
}
//修改左滑删除按钮的title
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)btnClick:(UIButton*)btn
{
    NSInteger indexRow;
    if (btn.tag%1000==1)
    {
        isReply=YES;
        indexRow=btn.tag/1000;
        self.inputBar.hidden=NO;
        [self.inputBar setInputBarStatus:KBottomBarKeyboardStatusss];
        [self.inputBar.chatSessionInputBarControl.inputTextView becomeFirstResponder];
        ReplyListData*data=replyDataAry[indexRow];
        replyId=data.dataIdentifier;
        replyNickname=data.nickname;
    }
//    else
//    {
//        indexRow=btn.tag/10000;
//        
//    }
   
}
#pragma mark-
#pragma mark-返回按钮
- (void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [replyDataAry removeAllObjects];
        [self getCommunityList];
    }];
    [_litab.mj_header beginRefreshing];
}
#pragma mark-
#pragma mark-获取评论列表
- (void)getCommunityList
{
    [AFManager getReqURL:[NSString stringWithFormat:GET_COMMUNITY_LIST_URL,_data.dataIdentifier,page] block:^(id infor)
     {
         if ([[infor objectForKey:@"code"]integerValue]==200)
         {
             ReplyListBase*replyListBase=[ReplyListBase modelObjectWithDictionary:infor];
//             page=replyListBase.data.count<15?page-1:page;
//             [replyDataAry addObjectsFromArray:replyListBase.data];
             for (ReplyListData*data in replyListBase.data)
             {
                 __block BOOL isExist = NO;
                 [replyDataAry enumerateObjectsUsingBlock:^(ReplyListData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj.dataIdentifier isEqualToString:data.dataIdentifier]) {//数组中已经存在该对象
                         *stop = YES;
                         isExist = YES;
                     }
                 }];
                 if (!isExist) {//如果不存在就添加进去
                     [replyDataAry addObject:data];
                 }
             };
             [self.litab reloadData];
         }else if ([[infor objectForKey:@"code"]integerValue]==201)
         {
             [NSObject wj_showHUDWithTip:@"已经加载全部了"];
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
//发表评论
- (void)sendCommunityContent:(NSString*)content
{
//    content=[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [AFManager postReqURL:SEND_COMMUNITY_URL reqBody:@{@"did":self.data.dataIdentifier,@"content":content,@"uid":[USERDEFAULT valueForKey:@"uid"]} block:^(id infor)
     {
         if ([[infor objectForKey:@"code"]integerValue]==200)
         {
             [NSObject wj_showHUDWithTip:@"评论成功"];
//             [replyDataAry removeAllObjects];
//             [self getCommunityList];
             [_litab.mj_header beginRefreshing];
         }else
         {
             [NSObject wj_showHUDWithTip:@"评论失败"];
         }
     }];
}
//回复评论
- (void)replyCommunity:(NSString*)content cid:(NSString*)cid
{
    [AFManager postReqURL:REPLY_COMMUNITY_URL reqBody:@{@"content":content,@"uid":[USERDEFAULT valueForKey:@"uid"],@"cid":cid,@"did":self.data.dataIdentifier} block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            [NSObject wj_showHUDWithTip:@"回复成功"];
            [_litab.mj_header beginRefreshing];

        }else
        {
            [NSObject wj_showHUDWithTip:@"回复失败"];
        }
    }];
}
//点赞列表接口
- (void)addZanList
{
    [AFManager getReqURL:[NSString stringWithFormat:ADD_ZAN_LIST_URL,self.data.dataIdentifier] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            ZanListBase*base=[ZanListBase modelObjectWithDictionary:infor];
            [zanListAry removeAllObjects];
            [zanListAry addObjectsFromArray:base.data];
            [self.headerView setZanLbContent:zanListAry];
            _litab.tableHeaderView=self.headerView;
        }else
        {
            _litab.tableHeaderView=self.headerView;
        }
    } errorblock:^(NSError *error)
    {
        
    }];
}
//点赞
- (void)addZan
{
    [AFManager getReqURL:[NSString stringWithFormat:ADD_ZAN_URL,[USERDEFAULT valueForKey:@"uid"],self.data.dataIdentifier] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            [NSObject wj_showHUDWithTip:@"点赞成功"];
            [zanListAry removeAllObjects];
            [self addZanList];
            [self zanAnimation];
        }else if([[infor objectForKey:@"code"]integerValue]==201)
        {
            [NSObject wj_showHUDWithTip:@"您已经点过赞了！"];
        }else
        {
            [NSObject wj_showHUDWithTip:@"点赞失败"];
        }
    } errorblock:^(NSError *error)
    {
        
    }];

}
//删除评论或回复
- (void)deleteCommunity:(NSString*)ID
{
    [AFManager getReqURL:[NSString stringWithFormat:DELETE_COMMUNITY_URL,ID,[USERDEFAULT valueForKey:@"uid"],self.data.dataIdentifier] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
//            [replyDataAry removeAllObjects];
//            [self getCommunityList];
            [NSObject wj_showHUDWithTip:@"删除成功"];
            [_litab.mj_header beginRefreshing];
        }else
        {
            [NSObject wj_showHUDWithTip:@"删除失败"];
        }
    } errorblock:^(NSError *error) {
        
    }];
}
- (void)zanAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        self.zanLb.bounds=CGRectMake(0, 0, 20, 20);
    } completion:^(BOOL finished)
    {
        [self.zanLb removeFromSuperview];
        self.zanLb=nil;
    }];
}
- (UILabel*)zanLb
{
    if (!_zanLb)
    {
        _zanLb=[[UILabel alloc]initWithFrame:CGRectMake(_headerView.zanBtn.frame.origin.x+F_I6_SIZE(40), _headerView.zanBtn.frame.origin.y, 0, 0)];
        _zanLb.text=@"+1";
        _zanLb.textColor=[UIColor redColor];
        [self.view addSubview:_zanLb];
        [self.view bringSubviewToFront:_zanLb];
    }
    return _zanLb;
}
- (CommunityAnswerHeaderView*)headerView
{
    if (!_headerView)
    {
        _headerView=[[CommunityAnswerHeaderView alloc]init];
        [_headerView setContentData:self.data];
        [_headerView.answerBtn addTarget:self action:@selector(answerBtn) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.zanBtn addTarget:self action:@selector(zanBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
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
