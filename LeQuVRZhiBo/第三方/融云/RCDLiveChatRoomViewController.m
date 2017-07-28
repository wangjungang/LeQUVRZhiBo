//
//  ChatRoomViewController.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/4/6.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "RCDLiveChatRoomViewController.h"
#import "RCDLiveGiftMessage.h"
#import "RCDLiveTipMessageCell.h"
#import "RCDLiveMessageModel.h"
#import "RCDLive.h"
#import "RCDLiveCollectionViewHeader.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import <RongIMLib/RongIMLib.h>
#import <objc/runtime.h>
#import "RCDLiveTipMessageCell.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "RCDLivePortraitViewCell.h"

#import <RongIMKit/RongIMKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UCloudMediaPlayer.h"
#import "giftView.h"
#import "GiftListData.h"
//连送动画类
#import "PresentView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"
//输入框的高度
#define MinHeight_InputView 50.0f
#define kBounds [UIScreen mainScreen].bounds.size

@interface RCDLiveChatRoomViewController () <
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, RCDLiveMessageCellDelegate, UIGestureRecognizerDelegate,
UIScrollViewDelegate, UINavigationControllerDelegate,RCTKInputBarControlDelegate,RCConnectionStatusChangeDelegate,RCDLiveInputBarDelegate2,giftViewDelegate>

{
    
    NSTimer *timer;
    int num;
    NSString *guanzhu;
    
    
}

@property(nonatomic, strong)RCDLiveCollectionViewHeader *collectionViewHeader;

/**
 *  存储长按返回的消息的model
 */
@property(nonatomic, strong) RCDLiveMessageModel *longPressSelectedModel;

/**
 *  是否需要滚动到底部
 */
@property(nonatomic, assign) BOOL isNeedScrollToButtom;

/**
 *  是否正在加载消息
 */
@property(nonatomic) BOOL isLoading;

/**
 *  会话名称
 */
@property(nonatomic,copy) NSString *navigationTitle;

/**
 *  点击空白区域事件
 */
@property(nonatomic, strong) UITapGestureRecognizer *resetBottomTapGesture;



/**
 *  直播互动文字显示
 */
@property(nonatomic,strong) UIView *titleView ;
@property(nonatomic,strong) GiftListData*giftListDataModel;
/**
 *  播放器view
 */
@property(nonatomic,strong) UIView *liveView;

/**
 *  底部显示未读消息view
 */
@property (nonatomic, strong) UIView *unreadButtonView;
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;

/**
 *  滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数
 */
@property (nonatomic, assign) NSInteger unreadNewMsgCount;

/**
 *  当前融云连接状态
 */
@property (nonatomic, assign) RCConnectionStatus currentConnectionStatus;
/*
 主播信息View、日期、主播号Lb、关注主播按钮;
 */
@property(nonatomic,strong) UIView  *anchorView;
@property(nonatomic,strong) UILabel *dateLb;
@property(nonatomic,strong) UILabel *anchorNumLb;
@property(nonatomic,strong) UIButton *concernBtn;
/*
 
 */
@property (nonatomic, strong) UIScrollView *scrollVIew;
@property (nonatomic, strong) UIView       *leftView;
@property (nonatomic, strong) UIView       *rightView;
@property (nonatomic, strong) UIView       *bottonToolBarView;
/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  鲜花按钮
 */
@property(nonatomic,strong)UIButton *flowerBtn;

/**
 *  评论按钮
 */
@property(nonatomic,strong)UIButton *feedBackBtn;

/**
 *  掌声按钮
 */
@property(nonatomic,strong)UIButton *clapBtn;
@property(nonatomic,strong)UIButton *privateEmailBtn;
@property(nonatomic,strong)giftView *giftView;

@property(nonatomic,strong)UICollectionView *portraitsCollectionView;

@property(nonatomic,strong)NSMutableArray *userList;

@property(strong,nonatomic)UIView *MyView;

@end


/**
 *  小灰条提示cell标示
 */
static NSString *const RCDLiveTipMessageCellIndentifier = @"RCDLiveTipMessageCellIndentifier";



@implementation RCDLiveChatRoomViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self rcinit];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self rcinit];
    }
    return self;
}
- (void)rcinit {

    num = 0;

    self.conversationDataRepository = [[NSMutableArray alloc] init];
    self.userList = [[NSMutableArray alloc] init];
    self.conversationMessageCollectionView = nil;
    self.targetId = nil;
    [self registerNotification];
    self.defaultHistoryMessageCountOfChatRoom = -1;
    [[RCIMClient sharedRCIMClient]setRCConnectionStatusChangeDelegate:self];
}
/**
 *  注册监听Notification
 */
- (void)registerNotification {
    //注册接收消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCDLiveKitDispatchMessageNotification
     object:nil];
}
/**
 *  注册cell
 *
 *  @param cellClass  cell类型
 *  @param identifier cell标示
 */
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.conversationMessageCollectionView registerClass:cellClass
                               forCellWithReuseIdentifier:identifier];
}






- (void)closeBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    //初始化UI
    self.targetId = @"868622";
    self.conversationType = 4;
    
    [self.portraitsCollectionView registerClass:[RCDLivePortraitViewCell class] forCellWithReuseIdentifier:@"portraitcell"];
    __weak RCDLiveChatRoomViewController *weakSelf = self;
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    if (ConversationType_CHATROOM == 4) {
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:@"868622"
         messageCount:weakSelf.defaultHistoryMessageCountOfChatRoom
         success:^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 _liveView=[[UIView alloc]init];
                 _liveView.frame=self.view.frame;
                 [self.view addSubview:_liveView];
                 [self.view sendSubviewToBack:_liveView];
                 weakSelf.mediaPlayer = [UCloudMediaPlayer ucloudMediaPlayer];
                 [weakSelf.mediaPlayer showMediaPlayer:PlayDomain(@"123456") urltype:UrlTypeAuto frame:CGRectNull view:_liveView completion:^(NSInteger defaultNum, NSArray *data)
                 {
                 }];
             });
         }
         error:^(RCErrorCode status) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"--%ld",(long)status);
                 if (status == KICKED_FROM_CHATROOM) {
                     //                         [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomRejected", @"RongCloudKit", nil)];
                 } else {
                     //                         [weakSelf loadErrorAlert:NSLocalizedStringFromTable(@"JoinChatRoomFailed", @"RongCloudKit", nil)];
                 }
             });
         }];
    }
    [self initializedSubViews];
    [self initChatroomMemberInfo];
}
/**
 *  加入聊天室失败的提示
 *
 *  @param title 提示内容
 */
- (void)loadErrorAlert:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addGestureRecognizer:_resetBottomTapGesture];
    [self.conversationMessageCollectionView reloadData];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationTitle = self.navigationItem.title;
}

/**
 *  移除监听
 *
 *  @param animated <#animated description#>
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:@"kRCPlayVoiceFinishNotification"
     object:nil];
    
    [self.conversationMessageCollectionView removeGestureRecognizer:_resetBottomTapGesture];
    [self.conversationMessageCollectionView
     addGestureRecognizer:_resetBottomTapGesture];
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    
}

/**
 *  回收的时候需要消耗播放器和退出聊天室
 */
- (void)dealloc {
    [self quitConversationViewAndClear];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
    
    
}

/**
 *  点击返回的时候消耗播放器和退出聊天室
 *
 *  @param sender sender description
 */


/**
 *  初始化页面控件
 */
- (void)initializedSubViews {
    _scrollVIew=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    _scrollVIew.pagingEnabled=YES;
    _scrollVIew.delegate=self;
    _scrollVIew.contentOffset=CGPointMake(DEVICE_WIDTH, 0);
    _scrollVIew.showsHorizontalScrollIndicator=NO;
    
    _scrollVIew.contentSize=CGSizeMake(DEVICE_WIDTH*2, DEVICE_HEIGHT);
    [self.view addSubview:_scrollVIew];
    _leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [_scrollVIew addSubview:_leftView];
    
    _rightView=[[UIView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [_scrollVIew addSubview:_rightView];
    //聊天区
    if(self.contentView == nil){
        CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-F_I6_SIZE(240), self.view.bounds.size.width,F_I6_SIZE(240));
        self.contentView.backgroundColor = RCDLive_RGBCOLOR(235, 235, 235);
        self.contentView = [[UIView alloc]initWithFrame:contentViewFrame];
        [_rightView addSubview:self.contentView];
    }
    //聊天消息区
    if (nil == self.conversationMessageCollectionView) {
        UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        customFlowLayout.minimumLineSpacing = 0;
        customFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f,5.0f, 0.0f);
        customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGRect _conversationViewFrame = self.contentView.bounds;
        _conversationViewFrame.origin.y = 0;
        _conversationViewFrame.size.height = self.contentView.bounds.size.height - F_I6_SIZE(55);
        _conversationViewFrame.size.width = F_I6_SIZE(240);
        self.conversationMessageCollectionView =
        [[UICollectionView alloc] initWithFrame:_conversationViewFrame
                           collectionViewLayout:customFlowLayout];
        [self.conversationMessageCollectionView
         setBackgroundColor:[UIColor clearColor]];
        self.conversationMessageCollectionView.showsHorizontalScrollIndicator = NO;
        self.conversationMessageCollectionView.showsVerticalScrollIndicator = NO;
        
        self.conversationMessageCollectionView.alwaysBounceVertical = YES;
        self.conversationMessageCollectionView.dataSource = self;
        self.conversationMessageCollectionView.delegate = self;
        [self.contentView addSubview:self.conversationMessageCollectionView];
    }
    //输入区
    if(self.inputBar == nil){
        float inputBarOriginY = self.conversationMessageCollectionView.bounds.size.height+5;
        float inputBarOriginX = self.conversationMessageCollectionView.frame.origin.x;
        float inputBarSizeWidth = self.contentView.frame.size.width;
        float inputBarSizeHeight = MinHeight_InputView;
        self.inputBar = [[RCDLiveInputBar alloc]initWithFrame:CGRectMake(inputBarOriginX, inputBarOriginY,inputBarSizeWidth,inputBarSizeHeight) inViewConroller:self];
        self.inputBar.delegate = self;
        self.inputBar.backgroundColor = [UIColor clearColor];
        self.inputBar.hidden = YES;
        self.inputBar.chatSessionInputBarControl.num = @"1";
        self.inputBar.chatSessionInputBarControl.delegate2 = self;
        [self.contentView addSubview:self.inputBar];
        
        
        //        [self.inputBar.chatSessionInputBarControl.switchButton addTarget:self action:@selector(danmu:) forControlEvents:UIControlEventTouchUpInside];
        //        self.inputBar.chatSessionInputBarControl.switchButton.selected = YES;
    }
    self.collectionViewHeader = [[RCDLiveCollectionViewHeader alloc]
                                 initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, F_I6_SIZE(40))];
    _collectionViewHeader.tag = 1999;
    [self.conversationMessageCollectionView addSubview:_collectionViewHeader];
    [self registerClass:[RCDLiveTipMessageCell class]forCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier];
//        [self changeModel:YES];
    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];
    [_resetBottomTapGesture setDelegate:self];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(DEVICE_WIDTH-F_I6_SIZE(45), DEVICE_HEIGHT-F_I6_SIZE(45), F_I6_SIZE(40), F_I6_SIZE(40));
    UIImageView *backImg = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"直播_22.png"]];
    backImg.frame = CGRectMake(0, 0, F_I6_SIZE(40), F_I6_SIZE(40));
    [_backBtn addSubview:backImg];
    [_backBtn addTarget:self
                 action:@selector(leftBarButtonItemPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    [self.view bringSubviewToFront:_backBtn];
    
    _feedBackBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _feedBackBtn.frame = CGRectMake(10, DEVICE_HEIGHT-F_I6_SIZE(45), F_I6_SIZE(40), F_I6_SIZE(40));
    UIImageView *clapImg = [[UIImageView alloc]
                            initWithImage:[UIImage imageNamed:@"直播_13.png"]];
    clapImg.frame = CGRectMake(0,0, F_I6_SIZE(40), F_I6_SIZE(40));
    [_feedBackBtn addSubview:clapImg];
    [_feedBackBtn addTarget:self
                     action:@selector(showInputBar:)
           forControlEvents:UIControlEventTouchUpInside];
    [_rightView addSubview:_feedBackBtn];
    
    
    _flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _flowerBtn.frame = CGRectMake(F_I6_SIZE(230), DEVICE_HEIGHT-F_I6_SIZE(45), F_I6_SIZE(40), F_I6_SIZE(40));
    UIImageView *clapImg2 = [[UIImageView alloc]
                             initWithImage:[UIImage imageNamed:@"直播_18.png"]];
    clapImg2.frame = CGRectMake(0,0, F_I6_SIZE(40), F_I6_SIZE(40));
    [_flowerBtn addSubview:clapImg2];
    [_flowerBtn addTarget:self
                   action:@selector(flowerButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [_rightView addSubview:_flowerBtn];
    
    _clapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clapBtn.frame = CGRectMake(F_I6_SIZE(275), DEVICE_HEIGHT-F_I6_SIZE(45), F_I6_SIZE(40), F_I6_SIZE(40));
    UIImageView *clapImg3 = [[UIImageView alloc]
                             initWithImage:[UIImage imageNamed:@"直播_20.png"]];
    clapImg3.frame = CGRectMake(0,0, F_I6_SIZE(40), F_I6_SIZE(40));
    [_clapBtn addSubview:clapImg3];
    [_clapBtn addTarget:self
                 action:@selector(clapButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    [_rightView addSubview:_clapBtn];
    
    _privateEmailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _privateEmailBtn.frame = CGRectMake(F_I6_SIZE(185), DEVICE_HEIGHT-F_I6_SIZE(45), F_I6_SIZE(40), F_I6_SIZE(40));
    UIImageView *clapImg4 = [[UIImageView alloc]
                             initWithImage:[UIImage imageNamed:@"直播_16.png"]];
    clapImg4.frame = CGRectMake(0,0, F_I6_SIZE(40), F_I6_SIZE(40));
    [_privateEmailBtn addSubview:clapImg4];
    //    [_privateEmailBtn addTarget:self
    //                 action:@selector(clapButtonPressed:)
    //       forControlEvents:UIControlEventTouchUpInside];
    [_rightView addSubview:_privateEmailBtn];
   
}
- (void)initChatroomMemberInfo{
    
    _bottonToolBarView=[[UIView alloc]initWithFrame:CGRectMake(DEVICE_WIDTH-F_I6_SIZE(260), F_I6_SIZE(70), F_I6_SIZE(250), F_I6_SIZE(30))];
    _dateLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, F_I6_SIZE(250), F_I6_SIZE(15))];
    _dateLb.font=[UIFont systemFontOfSize:12];
    _dateLb.textAlignment=2;
    _anchorNumLb=[[UILabel alloc]initWithFrame:CGRectMake(0, F_I6_SIZE(15), F_I6_SIZE(250), F_I6_SIZE(15))];
    _anchorNumLb.font=[UIFont systemFontOfSize:12];
    _anchorNumLb.textAlignment=2;
    [_bottonToolBarView addSubview:_dateLb];
    [_bottonToolBarView addSubview:_anchorNumLb];
    _anchorNumLb.text=[NSString stringWithFormat:@"主播号：%@",_anchorNum];
    _anchorNumLb.textColor=[UIColor whiteColor];
    _dateLb.textColor=[UIColor whiteColor];
    _dateLb.text=[self getDate];
    [_rightView addSubview:_bottonToolBarView];
    if (_isConcern)
    {
      _anchorView = [[UIView alloc] initWithFrame:CGRectMake(F_I6_SIZE(10), F_I6_SIZE(30), F_I6_SIZE(85), F_I6_SIZE(35))];
    }else{
       _anchorView = [[UIView alloc] initWithFrame:CGRectMake(F_I6_SIZE(10), F_I6_SIZE(30), F_I6_SIZE(125), F_I6_SIZE(35))];
        _concernBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _concernBtn.clipsToBounds=YES;
        _concernBtn.layer.cornerRadius=F_I6_SIZE(12.5);
        _concernBtn.frame=CGRectMake(F_I6_SIZE(84), F_I6_SIZE(5), F_I6_SIZE(40), F_I6_SIZE(25));
        [_concernBtn setTitle:@"关注" forState:0];
        _concernBtn.titleLabel.font=[UIFont systemFontOfSize:F_I6_SIZE(12)];
        [_concernBtn setTitleColor:[UIColor whiteColor] forState:0];
        _concernBtn.backgroundColor=kCOLOR(92, 217, 199, 1);
        [_concernBtn addTarget:self action:@selector(AddConcern) forControlEvents:UIControlEventTouchUpInside];
        [_anchorView addSubview:_concernBtn];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changeAutolayout];
        });
    }
    _anchorView.backgroundColor = [UIColor whiteColor];
    _anchorView.layer.cornerRadius = F_I6_SIZE(35.0/2);
    [_rightView addSubview:_anchorView];
    _anchorView.alpha = 0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, F_I6_SIZE(34), F_I6_SIZE(34))];
    [imageView setImageWithURL:[NSURL URLWithString:self.headerImage] placeholderImage:[UIImage imageNamed:@"直播_06.png"]];
    imageView.layer.cornerRadius = F_I6_SIZE(34/2);
    imageView.layer.masksToBounds = YES;
    [_anchorView addSubview:imageView];
    UILabel *chatroomlabel = [[UILabel alloc] initWithFrame:CGRectMake(F_I6_SIZE(37), 0, F_I6_SIZE(45), F_I6_SIZE(35))];
    chatroomlabel.numberOfLines = 2;
    chatroomlabel.font = [UIFont systemFontOfSize:12.f];
    chatroomlabel.text = [NSString stringWithFormat:@"直播\n100W人"];
    [_anchorView addSubview:chatroomlabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 16;
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat memberHeadListViewY = _anchorView.frame.origin.x + _anchorView.frame.size.width;
    self.portraitsCollectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(memberHeadListViewY,F_I6_SIZE(30),self.view.frame.size.width - memberHeadListViewY,F_I6_SIZE(35)) collectionViewLayout:layout];
    self.portraitsCollectionView.showsHorizontalScrollIndicator=NO;
    [_rightView addSubview:self.portraitsCollectionView];
    self.portraitsCollectionView.delegate = self;
    self.portraitsCollectionView.dataSource = self;
    self.portraitsCollectionView.backgroundColor = [UIColor clearColor];
    
    
    [self.portraitsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}
#pragma mark-
#pragma mark-礼物按钮
-(void)flowerButtonPressed:(id)sender{
    _backBtn.hidden=YES;
    _flowerBtn.hidden=YES;
    _privateEmailBtn.hidden=YES;
    _clapBtn.hidden=YES;
    _feedBackBtn.hidden=YES;
    self.giftView.frame=CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    [UIView animateWithDuration:0.3 animations:^{
        _giftView.frame=CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    }];
}
- (void)tapGesTure:(UITapGestureRecognizer*)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        _giftView.frame=CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT);
    } completion:^(BOOL finished) {
        _backBtn.hidden=NO;
        _flowerBtn.hidden=NO;
        _privateEmailBtn.hidden=NO;
        _clapBtn.hidden=NO;
        _feedBackBtn.hidden=NO;
        _giftView=nil;
        [_giftView removeFromSuperview];
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.giftView.collection]||[touch.view isDescendantOfView:self.giftView.bgView]) {
        return NO;
    }
    return YES;
}
//送礼物
- (void)giveGift
{
    NSString*uid=[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];

    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"0";
    giftMessage.giftText = [NSString stringWithFormat:@"送了一个%@",self.giftListDataModel.gname];
    giftMessage.giftName=self.giftListDataModel.gname;
    giftMessage.giftId=self.giftListDataModel.gid;
    giftMessage.giftPic=self.giftListDataModel.pic;
    giftMessage.giftUid=uid;
    [self sendMessage:giftMessage pushContent:@""];
//    [self.inputBar setInputBarStatus:KBottomBarDefaultStatuss];
//    [self.inputBar setHidden:YES];
}
- (giftView*)giftView
{
    if (!_giftView) {
        _giftView=[[giftView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT)];
        [_giftView.giveBtn addTarget:self action:@selector(giveGift) forControlEvents:UIControlEventTouchUpInside];
        _giftView.delegate=self;
        [_rightView addSubview:_giftView];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesTure:)];
        tap.delegate=self;
        [_giftView addGestureRecognizer:tap];
    }
    return _giftView;
}
#pragma mark-
#pragma mark-giftView协议方法
- (void)giftInfo:(GiftListData *)giftModel
{
    self.giftListDataModel=giftModel;
}
#pragma mark-
#pragma mark-分享按钮
/**
 *
 *
 *  @param sender <#sender description#>
 */
-(void)clapButtonPressed:(id)sender{
   
}
#pragma mark-
#pragma mark-退出按钮
- (void)leftBarButtonItemPressed:(id)sender {
    [self quitConversationViewAndClear];
    [timer invalidate];
    timer = nil;
}
// 清理环境（退出讨论组、移除监听等）
- (void)quitConversationViewAndClear {
    [NSObject cancelPreviousPerformRequestsWithTarget:self.mediaPlayer];
    [self.mediaPlayer.player.view removeFromSuperview];
    [self.mediaPlayer.player shutdown];
    self.mediaPlayer = nil;
    
    if (self.conversationType == ConversationType_CHATROOM) {
        
        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                            success:^{
                                                NSLog(@"退出聊天室成功");
                                                self.conversationMessageCollectionView.dataSource = nil;
                                                self.conversationMessageCollectionView.delegate = nil;
                                                [[NSNotificationCenter defaultCenter] removeObserver:self];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                });
                                            } error:^(RCErrorCode status) {
                                                
                                                NSLog(@"退出聊天室失败");
                                                
                                            }];
    }
}
-(void)showInputBar:(id)sender{
    self.inputBar.hidden = NO;
    [self.inputBar setInputBarStatus:KBottomBarKeyboardStatusss];
}

/**
 *  未读消息View
 *
 *  @return <#return value description#>
 */
- (UIView *)unreadButtonView {
    if (!_unreadButtonView) {
        _unreadButtonView = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 80)/2, self.view.frame.size.height - MinHeight_InputView - 30, 80, 30)];
        _unreadButtonView.userInteractionEnabled = YES;
        _unreadButtonView.backgroundColor = RCDLive_HEXCOLOR(0xffffff);
        _unreadButtonView.alpha = 0.7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabUnreadMsgCountIcon:)];
        [_unreadButtonView addGestureRecognizer:tap];
        _unreadButtonView.hidden = YES;
        [self.view addSubview:_unreadButtonView];
        _unreadButtonView.layer.cornerRadius = 4;
    }
    return _unreadButtonView;
}
/**
 *  底部新消息文字
 *
 *  @return return value description
 */
- (UILabel *)unReadNewMessageLabel {
    if (!_unReadNewMessageLabel) {
        _unReadNewMessageLabel = [[UILabel alloc]initWithFrame:_unreadButtonView.bounds];
        _unReadNewMessageLabel.backgroundColor = [UIColor clearColor];
        _unReadNewMessageLabel.font = [UIFont systemFontOfSize:12.0f];
        _unReadNewMessageLabel.textAlignment = NSTextAlignmentCenter;
        _unReadNewMessageLabel.textColor = RCDLive_HEXCOLOR(0xff4e00);
        [self.unreadButtonView addSubview:_unReadNewMessageLabel];
    }
    return _unReadNewMessageLabel;
    
}
/**
 *  更新底部新消息提示显示状态
 */
- (void)updateUnreadMsgCountLabel{
    if (self.unreadNewMsgCount == 0) {
        self.unreadButtonView.hidden = YES;
    }
    else{
        self.unreadButtonView.hidden = NO;
        self.unReadNewMessageLabel.text = @"底部有新消息";
    }
}

/**
 *  检查是否更新新消息提醒
 */
- (void) checkVisiableCell{
    NSIndexPath *lastPath = [self getLastIndexPathForVisibleItems];
    if (lastPath.row >= self.conversationDataRepository.count - self.unreadNewMsgCount || lastPath == nil || [self isAtTheBottomOfTableView] ) {
        self.unreadNewMsgCount = 0;
        [self updateUnreadMsgCountLabel];
    }
}

/**
 *  获取显示的最后一条消息的indexPath
 *
 *  @return indexPath
 */
- (NSIndexPath *)getLastIndexPathForVisibleItems
{
    NSArray *visiblePaths = [self.conversationMessageCollectionView indexPathsForVisibleItems];
    if (visiblePaths.count == 0) {
        return nil;
    }else if(visiblePaths.count == 1) {
        return (NSIndexPath *)[visiblePaths firstObject];
    }
    NSArray *sortedIndexPaths = [visiblePaths sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    return (NSIndexPath *)[sortedIndexPaths lastObject];
}

/**
 *  点击未读提醒滚动到底部
 *
 *  @param gesture gesture description
 */
- (void)tabUnreadMsgCountIcon:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self scrollToBottomAnimated:YES];
    }
}


/**
 *  顶部插入历史消息
 *
 *  @param model 消息Model
 */
- (void)pushOldMessageModel:(RCDLiveMessageModel *)model {
    if (!(!model.content && model.messageId > 0)
        && !([[model.content class] persistentFlag] & MessagePersistent_ISPERSISTED)) {
        return;
    }
    long ne_wId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        if (ne_wId == __item.messageId) {
            return;
        }
    }
    [self.conversationDataRepository insertObject:model atIndex:0];
}

/**
 *  加载历史消息(暂时没有保存聊天室消息)
 */
- (void)loadMoreHistoryMessage {
    long lastMessageId = -1;
    if (self.conversationDataRepository.count > 0) {
        RCDLiveMessageModel *model = [self.conversationDataRepository objectAtIndex:0];
        lastMessageId = model.messageId;
    }
    
    NSArray *__messageArray =
    [[RCIMClient sharedRCIMClient] getHistoryMessages:_conversationType
                                             targetId:_targetId
                                      oldestMessageId:lastMessageId
                                                count:10];
    for (int i = 0; i < __messageArray.count; i++) {
        RCMessage *rcMsg = [__messageArray objectAtIndex:i];
        RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMsg];
        [self pushOldMessageModel:model];
    }
    [self.conversationMessageCollectionView reloadData];
    if (_conversationDataRepository != nil &&
        _conversationDataRepository.count > 0 &&
        [self.conversationMessageCollectionView numberOfItemsInSection:0] >=
        __messageArray.count - 1) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:__messageArray.count - 1 inSection:0];
        [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath
                                                       atScrollPosition:UICollectionViewScrollPositionTop
                                                               animated:NO];
    }
}
#pragma mark <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if ([scrollView isEqual:self.scrollVIew]) {
//        _scrollVIew.scrollEnabled=YES;
//        _giftView.collection.scrollEnabled=NO;
//    }else if([scrollView isEqual:_giftView.collection]){
//        _scrollVIew.scrollEnabled=NO;
//        _giftView.collection.scrollEnabled=YES;
//    }
}
/**
 *  滚动条滚动时显示正在加载loading
 *
 *  @param scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 是否显示右下未读icon
    if (self.unreadNewMsgCount != 0) {
        [self checkVisiableCell];
    }
    
    if (scrollView.contentOffset.y < -5.0f) {
        [self.collectionViewHeader startAnimating];
    } else {
        [self.collectionViewHeader stopAnimating];
        _isLoading = NO;
    }
}

/**
 *  滚动结束加载消息 （聊天室消息还没存储，所以暂时还没有此功能）
 *
 *  @param scrollView scrollView description
 *  @param decelerate decelerate description
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -15.0f && !_isLoading) {
        _isLoading = YES;
    }
}

/**
 *  消息滚动到底部
 *
 *  @param animated 是否开启动画效果
 */
- (void)scrollToBottomAnimated:(BOOL)animated {
    if ([self.conversationMessageCollectionView numberOfSections] == 0) {
        return;
    }
    NSUInteger finalRow = MAX(0, [self.conversationMessageCollectionView numberOfItemsInSection:0] - 1);
    if (0 == finalRow) {
        return;
    }
    NSIndexPath *finalIndexPath =
    [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.conversationMessageCollectionView scrollToItemAtIndexPath:finalIndexPath
                                                   atScrollPosition:UICollectionViewScrollPositionTop
                                                           animated:animated];
}
#pragma mark <UICollectionViewDataSource>
/**
 *  定义展示的UICollectionViewCell的个数
 *
 *  @return
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        return self.userList.count;
    }
    return self.conversationDataRepository.count;
}
/**
 *  每个UICollectionView展示的内容
 *
 *  @return
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        RCDLivePortraitViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCDLivePortraitViewCell" forIndexPath:indexPath];
        [cell.portaitView setImageWithURL:[NSURL URLWithString:self.userList[indexPath.row][@"avatar"]] placeholderImage:[UIImage imageNamed:@"moren.png"]];
        cell.portaitView.tag = 40000+indexPath.row;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhubo2:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [cell.portaitView addGestureRecognizer:tap];
        return cell;
    }
    //NSLog(@"path row is %d", indexPath.row);
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    RCDLiveMessageBaseCell *cell = nil;
    if ([messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveTipMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier forIndexPath:indexPath];
        __cell.isFullScreenMode = YES;
        [__cell setDataModel:model];
        [__cell setDelegate:self];
        cell = __cell;
    }
    
    return cell;
}
#pragma mark <UICollectionViewDelegateFlowLayout>
/**
 *  cell的大小
 *
 *  @return
 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.portraitsCollectionView]) {
        return CGSizeMake(35,35);
    }
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    if (model.cellSize.height > 0) {
        return model.cellSize;
    }
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCDLiveGiftMessage class]]) {
        model.cellSize = [self sizeForItem:collectionView atIndexPath:indexPath];
    } else {
        return CGSizeZero;
    }
    return model.cellSize;
}
/**
 *  计算不同消息的具体尺寸
 *
 *  @return
 */
- (CGSize)sizeForItem:(UICollectionView *)collectionView
          atIndexPath:(NSIndexPath *)indexPath {
    CGFloat __width = CGRectGetWidth(collectionView.frame);
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    CGFloat __height = 0.0f;
    NSString *localizedMessage;
   if ([messageContent isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveGiftMessage *notification = (RCDLiveGiftMessage *)messageContent;
        if(notification && [notification.type isEqualToString:@"0"]){
            localizedMessage = [NSString stringWithFormat:@"送了一个%@",notification.giftName];
        }else if(notification && [notification.type isEqualToString:@"2"]){
            localizedMessage = [NSString stringWithFormat:@"送了一个%@",notification.giftName];
        }else if(notification && [notification.type isEqualToString:@"3"]){
            localizedMessage = @"发送了一条弹幕";
        }else{
            localizedMessage = [NSString stringWithFormat:@"%@",notification.giftText];
        }
        NSString *name;
        if (messageContent.senderUserInfo) {
            name = [NSString stringWithFormat:@"%@:",messageContent.senderUserInfo.name];
        }
        localizedMessage = [NSString stringWithFormat:@"%@ %@",name,localizedMessage];
    }
    CGSize __labelSize = [RCDLiveTipMessageCell getTipMessageCellSize:localizedMessage];
    __height = __height + __labelSize.height;
    
    return CGSizeMake(__width, __height);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}
/**
 *  将消息加入本地数组
 *
 *  @return
 */
- (void)appendAndDisplayMessage:(RCMessage *)rcMessage {
    if (!rcMessage) {
        return;
    }
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    if([rcMessage.content isMemberOfClass:[RCDLiveGiftMessage class]]){
        model.messageId = -1;
    }
    if ([self appendMessageModel:model]) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:self.conversationDataRepository.count - 1
                            inSection:0];
        if ([self.conversationMessageCollectionView numberOfItemsInSection:0] !=
            self.conversationDataRepository.count - 1) {
            return;
        }
        [self.conversationMessageCollectionView
         insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        if ([self isAtTheBottomOfTableView] || self.isNeedScrollToButtom) {
            [self scrollToBottomAnimated:YES];
            self.isNeedScrollToButtom=NO;
        }
    }
}
/**
 *  如果当前会话没有这个消息id，把消息加入本地数组
 *
 *  @return
 */
- (BOOL)appendMessageModel:(RCDLiveMessageModel *)model {
    long newId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        /*
         * 当id为－1时，不检查是否重复，直接插入
         * 该场景用于插入临时提示。
         */
        if (newId == -1) {
            break;
        }
        if (newId == __item.messageId) {
            return NO;
        }
    }
    if (!model.content) {
        return NO;
    }
    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
    
    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
    //用户可以手动下拉更多消息，查看更多历史消息。
    if (self.conversationDataRepository.count>100) {
        //                NSRange range = NSMakeRange(0, 1);
        RCDLiveMessageModel *message = self.conversationDataRepository[0];
        [[RCIMClient sharedRCIMClient]deleteMessages:@[@(message.messageId)]];
        [self.conversationDataRepository removeObjectAtIndex:0];
        [self.conversationMessageCollectionView reloadData];
    }
    
    [self.conversationDataRepository addObject:model];
    return YES;
}
/**
 *  UIResponder
 *
 *  @return
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [super canPerformAction:action withSender:sender];
}
/**
 *  找出消息的位置
 *
 *  @return
 */
- (NSInteger)findDataIndexFromMessageList:(RCDLiveMessageModel *)model {
    NSInteger index = 0;
    for (int i = 0; i < self.conversationDataRepository.count; i++) {
        RCDLiveMessageModel *msg = (self.conversationDataRepository)[i];
        if (msg.messageId == model.messageId) {
            index = i;
            break;
        }
    }
    return index;
}
/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCDLiveMessageModel *)model;
{
}
/**
 *  打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 *
 *  @param locationMessageCotent 位置消息
 */
- (void)presentLocationViewController:
(RCLocationMessage *)locationMessageContent {
}
/**
 *  关闭提示框
 *
 *  @param theTimer theTimer description
 */
- (void)timerForHideHUD:(NSTimer*)theTimer//弹出框
{
    __weak __typeof(&*self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    });
    [theTimer invalidate];
    theTimer = nil;
}
/*!
 发送消息(除图片消息外的所有消息)
 @param messageContent 消息的内容
 @param pushContent    接收方离线时需要显示的远程推送内容
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 SDK内置的消息类型，如果您将pushContent置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent来定义推送内容，否则将不会进行远程推送。
 如果您需要设置发送的pushData，可以使用RCIM的发送消息接口。
 */
- (void)sendMessage:(RCMessageContent *)messageContent
        pushContent:(NSString *)pushContent {
    if (_targetId == nil) {
        return;
    }
    messageContent.senderUserInfo = [RCDLive sharedRCDLive].currentUserInfo;
    if (messageContent == nil) {
        return;
    }
    
    [[RCDLive sharedRCDLive] sendMessage:self.conversationType
                                targetId:self.targetId
                                 content:messageContent
                             pushContent:pushContent
                                pushData:nil
                                 success:^(long messageId) {
                                     __weak typeof(&*self) __weakself = self;
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         RCMessage *message = [[RCMessage alloc] initWithType:__weakself.conversationType
                                                                                     targetId:__weakself.targetId
                                                                                    direction:MessageDirection_SEND
                                                                                    messageId:messageId
                                                                                      content:messageContent];
                                         if ([message.content isMemberOfClass:[RCDLiveGiftMessage class]] ) {
                                             message.messageId = -1;//插入消息时如果id是-1不判断是否存在
                                         }
                                         [__weakself appendAndDisplayMessage:message];
                                         [__weakself.inputBar clearInputView];
                                         RCDLiveGiftMessage*giftMessage=(RCDLiveGiftMessage*)messageContent;
                                         if ([giftMessage.type isEqualToString:@"0"])
                                         {
                                            [self EvenSendAnimation:giftMessage];
                                         }
                                         
                                     });
                                 } error:^(RCErrorCode nErrorCode, long messageId) {
                                     [[RCIMClient sharedRCIMClient]deleteMessages:@[ @(messageId) ]];
                                 }];
}

/**
 *  接收到消息的回调
 *
 *  @param notification
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    NSLog(@"2obj--%@",notification.object);
    NSLog(@"2user--%@",notification.userInfo);
    __block RCMessage *rcMessage = notification.object;
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    NSDictionary *leftDic = notification.userInfo;
    NSLog(@"2rc--%@",rcMessage.content);
    NSLog(@"2left--%@",leftDic);
    if (leftDic && [leftDic[@"left"] isEqual:@(0)]) {
        self.isNeedScrollToButtom = YES;
    }
    if (model.conversationType == 4 &&
        [model.targetId isEqual:self.targetId]) {
        __weak typeof(&*self) __blockSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rcMessage) {
                [__blockSelf appendAndDisplayMessage:rcMessage];
                UIMenuController *menu = [UIMenuController sharedMenuController];
                menu.menuVisible=NO;
                //如果消息不在最底部，收到消息之后不滚动到底部，加到列表中只记录未读数
                if (![self isAtTheBottomOfTableView]) {
                    self.unreadNewMsgCount ++ ;
                    [self updateUnreadMsgCountLabel];
                }
            }
        });
    }
    if ([rcMessage.content isKindOfClass:[RCDLiveGiftMessage class]]) {
        RCDLiveGiftMessage*giftMessgae=(RCDLiveGiftMessage*)rcMessage.content;
        if ([giftMessgae.type isEqualToString:@"0"]) {
            NSLog(@"%@",giftMessgae.giftName);
            [self EvenSendAnimation:giftMessgae];
        }
       }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  定义展示的UICollectionViewCell的个数
 *
 *  @return
 */
- (void)tap4ResetDefaultBottomBarStatus:
(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
//        collectionViewRect.size.height = self.contentView.bounds.size.height - F_I6_SIZE(55);
//        [self.conversationMessageCollectionView setFrame:collectionViewRect];
        [self.inputBar setInputBarStatus:KBottomBarDefaultStatuss];
        self.inputBar.hidden = YES;
    }
}
/**
 *  判断消息是否在collectionView的底部
 *
 *  @return 是否在底部
 */
- (BOOL)isAtTheBottomOfTableView {
    if (self.conversationMessageCollectionView.contentSize.height <= self.conversationMessageCollectionView.frame.size.height) {
        return YES;
    }
    if(self.conversationMessageCollectionView.contentOffset.y +200 >= (self.conversationMessageCollectionView.contentSize.height - self.conversationMessageCollectionView.frame.size.height)) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 输入框事件
/**
 *  点击键盘回车或者emoji表情面板的发送按钮执行的方法
 b
 *  @param text  输入框的内容
 */
- (void)onTouchSendButton:(NSString *)text{
    RCDLiveGiftMessage *giftMessage = [[RCDLiveGiftMessage alloc]init];
    giftMessage.type = @"5";
    giftMessage.giftText = text;
    [self sendMessage:giftMessage pushContent:@""];
}
//修复ios7下不断下拉加载历史消息偶尔崩溃的bug
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark RCInputBarControlDelegate

/**
 *  根据inputBar 回调来修改页面布局，inputBar frame 变化会触发这个方法
 *
 *  @param frame    输入框即将占用的大小
 *  @param duration 时间
 *  @param curve    曲线
 */
- (void)onInputBarControlContentSizeChanged:(CGRect)frame withAnimationDuration:(CGFloat)duration andAnimationCurve:(UIViewAnimationCurve)curve{
    CGRect collectionViewRect = self.contentView.frame;
    self.contentView.backgroundColor = [UIColor clearColor];
    collectionViewRect.origin.y = self.view.bounds.size.height - frame.size.height - 237 +50;
    
    collectionViewRect.size.height = 237;
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        [self.contentView setFrame:collectionViewRect];
        [UIView commitAnimations];
    }];
    CGRect inputbarRect = self.inputBar.frame;
    
    inputbarRect.origin.y = self.contentView.frame.size.height -50;
    [self.inputBar setFrame:inputbarRect];
    [self.view bringSubviewToFront:self.inputBar];
    [self scrollToBottomAnimated:NO];
}


/**
 *  连接状态改变的回调
 *
 *  @param status <#status description#>
 */
- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}


- (void)praiseHeart{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"fgdfgdfg");
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(self.view.frame.size.width-40 , self.view.frame.size.height-50, 35, 35);
        imageView.image = [UIImage imageNamed:@"heart"];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
        [self.view addSubview:imageView];
        
        
        CGFloat startX = round(random() % 200);
        CGFloat scale = round(random() % 2) + 1.0;
        CGFloat speed = 1 / round(random() % 900) + 0.6;
        int imageName = round(random() % 7);
        
        [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
        [UIView setAnimationDuration:7 * speed];
        
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d.png",imageName]];
        imageView.frame = CGRectMake(kBounds.width - startX, -100, 35 * scale, 35 * scale);
        
        [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    });

    
    
}


- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
}
#pragma mark-
#pragma mark-获取时间
- (NSString*)getDate
{
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy.MM.d";
    NSDate*date=[NSDate date];
    NSString*nowTime=[formatter stringFromDate:date];
    return nowTime;
}
#pragma mark-
#pragma mark-scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.scrollVIew])
    {
        if (scrollView.contentOffset.x>=DEVICE_WIDTH)
        {
            _bottonToolBarView.frame=CGRectMake(DEVICE_WIDTH-F_I6_SIZE(260), F_I6_SIZE(70), F_I6_SIZE(250), F_I6_SIZE(30));
            [_rightView addSubview:_bottonToolBarView];
        }else
        {
            _bottonToolBarView.frame=CGRectMake(DEVICE_WIDTH-F_I6_SIZE(260), F_I6_SIZE(30), F_I6_SIZE(250), F_I6_SIZE(30));
            [_leftView addSubview:_bottonToolBarView];
        }
        [self.view endEditing:YES];
        self.inputBar.hidden=YES;

    }
}
#pragma mark-
#pragma mark-连送动画
- (void)EvenSendAnimation:(RCDLiveGiftMessage*)giftMessage
{
    [AFManager getReqURL:[NSString stringWithFormat:GET_USER_NICK_URL,giftMessage.giftUid] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            GSPChatMessage *msg = [[GSPChatMessage alloc] init];
            msg.text =[NSString stringWithFormat:@"1个【%@】",giftMessage.giftName];
            msg.senderChatID=giftMessage.giftUid;
            msg.senderName=[infor objectForKey:@"nickname"];
            // 礼物模型
            GiftModel *giftModel = [[GiftModel alloc] init];
            giftModel.headImage = [infor objectForKey:@"head_pic"];
            giftModel.name = msg.senderName;
            
            giftModel.giftImage = giftMessage.giftPic;
            giftModel.giftName = msg.text;
            giftModel.giftCount = 1;
            
            AnimOperationManager *manager = [AnimOperationManager sharedManager];
            manager.parentView = _rightView;
            // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
            [manager animWithUserID:[NSString stringWithFormat:@"%@",msg.senderChatID]giftID:giftMessage.giftId model:giftModel finishedBlock:^(BOOL result) {
                
            }];
            
          
        }
    } errorblock:^(NSError *error) {
        
    }];
        // IM 消息
    
}
#pragma mark-
#pragma mark-关注用户按钮
- (void)AddConcern
{
    [self concernUser];
}
#pragma mark-
#pragma mark-关注该主播
//关注用户
- (void)concernUser
{
    [AFManager getReqURL:[NSString stringWithFormat:CONCERN_USER_URL,self.anchorID,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor)
     {
         if ([[infor objectForKey:@"code"]integerValue]==200)
         {
             [NSObject wj_showHUDWithTip:@"关注成功"];
             [self changeAutolayout];
         }else{
             [NSObject wj_showHUDWithTip:@"关注失败"];
         }
     } errorblock:^(NSError *error)
     {
         
     }];
}
#pragma mark-
#pragma mark-改变顶部UI布局
- (void)changeAutolayout
{
    [_concernBtn removeFromSuperview];
    _concernBtn=nil;
    _anchorView.frame=CGRectMake(F_I6_SIZE(10), F_I6_SIZE(30), F_I6_SIZE(85), F_I6_SIZE(35));
    CGFloat memberHeadListViewY = _anchorView.frame.origin.x + _anchorView.frame.size.width;
    self.portraitsCollectionView.frame  = CGRectMake(memberHeadListViewY,F_I6_SIZE(30),self.view.frame.size.width - memberHeadListViewY,F_I6_SIZE(35));
    
}
@end
