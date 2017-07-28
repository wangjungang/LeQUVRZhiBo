//
//  livingViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/3.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "livingViewController.h"
#import "AppDelegate.h"
#import "FilterManager.h"
#import "sys/utsname.h"
#import "NSString+UCloudCameraCode.h"
#import "CameraServer.h"
#import "upView.h"
#import "zhiboViewController.h"
#import "shequViewController.h"
#import "lepaihangViewController.h"
#import "xiaoxiViewController.h"
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
//输入框的高度
#define MinHeight_InputView 50.0f
#define kBounds [UIScreen mainScreen].bounds.size

#define SysVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#ifndef LESS_IOS8
#define LESS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
#endif


#ifndef GREATER_IOS9
#define GREATER_IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#endif

@interface livingViewController ()<selectIndex,
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, RCDLiveMessageCellDelegate, UIGestureRecognizerDelegate,
UIScrollViewDelegate, UINavigationControllerDelegate,RCTKInputBarControlDelegate,RCConnectionStatusChangeDelegate,RCDLiveInputBarDelegate2>
{
    
    //    UCloudGPUImageView *_frontImageView;
    //    NSArray *originalFilters;
    BOOL meiyan;
    
}
@property (strong, nonatomic) FilterManager   *filterManager;

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



@property(nonatomic,strong)UICollectionView *portraitsCollectionView;

@property(nonatomic,strong)NSMutableArray *userList;

@property(strong,nonatomic)UIView *MyView;

@end

/**
 *  小灰条提示cell标示
 */
static NSString *const RCDLiveTipMessageCellIndentifier = @"RCDLiveTipMessageCellIndentifier";
@implementation livingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upview:) name:@"upview" object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    meiyan = YES;
    if ([[CameraServer server] lowThan5]) {
        //5以下支持4：3
        [[CameraServer server] setHeight:640];
        [[CameraServer server] setWidth:480];
    } else {
        //5以上的支持16：9
        [[CameraServer server] setHeight:640];
        [[CameraServer server] setWidth:360];
    }
    
    [[CameraServer server] setFps:15];
    [[CameraServer server] setSupportFilter:YES];
    
    
    self.filterManager = [[FilterManager alloc] init];
    
    //如果需要设置显示图像的frame，iOS8以下请在此先设置，直接使用getCameraView方法获取view进行设置是无作用的，iOS8以上两者都可设置frame
    //        [[CameraServer server] initializeCameraViewFrame:CGRectMake(10, 10, 240, 230)];
    [[CameraServer server] setSecretKey:AccessKey];
    [[CameraServer server] setBitrate:UCloudVideoBitrateLow];
    
    NSString *path = RecordDomain(self.liveid);
    __weak livingViewController *weakSelf = self;
    
    
    [[CameraServer server] configureCameraWithOutputUrl:path filter:[self.filterManager filters] messageCallBack:^(UCloudCameraCode code, NSInteger arg1, NSInteger arg2, id data) {
        
        [weakSelf handlerMessageCallBackWithCode:code arg1:arg1 arg2:arg2 data:data weakSelf:weakSelf];
        
    } deviceBlock:^(AVCaptureDevice *dev) {
        
//        [self handlerDeviceBlock:dev weakSelf:weakSelf];
        
    } cameraData:^CMSampleBufferRef(CMSampleBufferRef buffer) {
        //如果不需要裸流，不建议在这里执行操作，将增加额外的功耗
        return nil;
    }];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self initializedSubViews];
    
    //初始化UI
//    self.liveid = @"868622";
    self.conversationType = 4;
    
    [self.portraitsCollectionView registerClass:[RCDLivePortraitViewCell class] forCellWithReuseIdentifier:@"portraitcell"];
    __weak livingViewController *weakSelf2 = self;
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    if (ConversationType_CHATROOM == 4) {
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:self.chatId
         messageCount:weakSelf2.defaultHistoryMessageCountOfChatRoom
         success:^{
             NSLog(@"成功");
             dispatch_async(dispatch_get_main_queue(), ^{
                 //                 weakSelf.mediaPlayer = [UCloudMediaPlayer ucloudMediaPlayer];
                 //                 [weakSelf.mediaPlayer showMediaPlayer:PlayDomain(@"123456") urltype:UrlTypeAuto frame:CGRectNull view:self.view completion:^(NSInteger defaultNum, NSArray *data) {
                 //
                 //
                 //                 }];
                 //
                 //                 UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 50, HEIGHT-50, 30, 30)];
                 //                 [closeBtn setBackgroundImage:[UIImage imageNamed:@"直播_22"] forState:UIControlStateNormal];
                 //                 closeBtn.selected = NO;
                 //                 [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
                 //                 [weakSelf.view addSubview:closeBtn];
                 //
                 
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
    
    
    

}



-(void)createBtn{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-50, self.view.frame.size.width, 30)];
    view.backgroundColor = [UIColor clearColor];
    [[[CameraServer server] getCameraView] addSubview:view];
    [[[CameraServer server] getCameraView] bringSubviewToFront:view];
    
    UIButton *chatBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 30, 30)];
    [chatBtn setBackgroundImage:[UIImage imageNamed:@"直播_13"] forState:UIControlStateNormal];
    chatBtn.selected = NO;
    [chatBtn addTarget:self action:@selector(showInputBar:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:chatBtn];
    
    UIButton *sixinBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 170, 0, 30, 30)];
    [sixinBtn setBackgroundImage:[UIImage imageNamed:@"直播_16"] forState:UIControlStateNormal];
    sixinBtn.selected = NO;
    [sixinBtn addTarget:self action:@selector(sixinBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sixinBtn];
    
    UIButton *musicBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 130, 0, 30, 30)];
    [musicBtn setBackgroundImage:[UIImage imageNamed:@"直播-正在直播_07"] forState:UIControlStateNormal];
    musicBtn.selected = NO;
    [musicBtn addTarget:self action:@selector(musicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:musicBtn];
    
    UIButton *upBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 90, 0, 30, 30)];
    [upBtn setBackgroundImage:[UIImage imageNamed:@"直播-正在直播_09"] forState:UIControlStateNormal];
    upBtn.selected = NO;
    [upBtn addTarget:self action:@selector(upBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:upBtn];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 50, 0, 30, 30)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"直播_22"] forState:UIControlStateNormal];
    closeBtn.selected = NO;
    [closeBtn addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    
    
}

- (void)handlerMessageCallBackWithCode:(UCloudCameraCode)code arg1:(NSInteger)arg1 arg2:(NSInteger)arg2 data:(id)data weakSelf:(livingViewController *)weakSelf
{
    
    
    
    if (code == UCloudCamera_Permission)
    {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"相机授权" message:@"没有权限访问您的相机，请在“设置－隐私－相机”中允许使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alterView show];
    }
    else if (code == UCloudCamera_Micphone)
    {
        [[[UIAlertView alloc] initWithTitle:@"麦克风授权" message:@"没有权限访问您的麦克风，请在“设置－隐私－麦克风”中允许使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
    }
    else if (code == UCloudCamera_SecretkeyNil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"密钥为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (code == UCloudCamera_AuthFail)
    {
        NSDictionary *dic = data;
        NSError *error = dic[@"error"];
        NSLog(@"errcode:%@\n msg:%@\n errdesc:%@", dic[@"retcode"], dic[@"message"], error.description);
    }
    else if (code == UCloudCamera_PreviewOK)
    {
        
        [weakSelf startPreview];
    }
    else if (code == UCloudCamera_PublishOk)
    {
        [[CameraServer server] cameraStart];
        
        
        //        [weakSelf.filterManager setCurrentValue:weakSelf.filterValues];
    }
    else if (code == UCloudCamera_StartPublish)
    {
    }
    else if (code == UCloudCamera_OUTPUT_ERROR)
    {
    }
    else if (code == UCloudCamera_BUFFER_OVERFLOW)
    {
        
    }
}

- (void) startPreview
{
    [self.view addSubview:[[CameraServer server] getCameraView]];
    [self.view sendSubviewToBack:[[CameraServer server] getCameraView]];
    [self createBtn];

}

- (void)sixinBtn:(UIButton *)btn
{
    
}
- (void)musicBtn:(UIButton *)btn
{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView *upView = (id)[self.view viewWithTag:200];
    [UIView animateWithDuration:0.1 animations:^{
        [upView removeFromSuperview];
    }];
    
}
-(void)upview:(id)user{
    UIView *upView = (id)[self.view viewWithTag:200];
    [UIView animateWithDuration:0.5 animations:^{
        [upView removeFromSuperview];
    }];
    if ([[user userInfo][@"index"] isEqualToString:@"0"]) {
        
    }else if ([[user userInfo][@"index"] isEqualToString:@"1"]) {
        [[CameraServer server] changeCamera];
        
    }else if ([[user userInfo][@"index"] isEqualToString:@"2"]) {
        if (!meiyan) {
            meiyan = YES;
            [[CameraServer server] openFilter];
        }else{
            meiyan = NO;
            [[CameraServer server] closeFilter];
        }
    }else if ([[user userInfo][@"index"] isEqualToString:@"3"]) {
        
    }

}
-(void)selectIndexNum:(NSString *)string{
    UIView *upView = (id)[self.view viewWithTag:200];
    [UIView animateWithDuration:0.5 animations:^{
        [upView removeFromSuperview];
    }];
    if ([string isEqualToString:@"0"]) {
        
    }else if ([string isEqualToString:@"1"]) {
        [[CameraServer server] changeCamera];

    }else if ([string isEqualToString:@"2"]) {
        if (!meiyan) {
            meiyan = YES;
            [[CameraServer server] openFilter];
        }else{
            meiyan = NO;
            [[CameraServer server] closeFilter];
        }
    }else if ([string isEqualToString:@"3"]) {
        
    }

}
- (void)upBtn:(UIButton *)btn
{
    [UIView animateWithDuration:0.5 animations:^{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - 90+15-40, HEIGHT-50-165, 80, 165)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 200;
        [self.view addSubview:view];
        
        UIImageView *upIamge = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 165)];
        upIamge.image = [UIImage imageNamed:@"直播-正在直播_03"];
        upIamge.layer.cornerRadius = 5;
        [view addSubview:upIamge];
        
        upView *upViews = [[upView alloc]initWithFrame:CGRectMake(0, 0, 80, 160)];
        upViews.delegate = self;
        upViews.userInteractionEnabled = YES;
        upViews.backgroundColor = [UIColor whiteColor];
        upViews.layer.cornerRadius = 5;
        [view addSubview:upViews];

        
        
    }];
    
}
- (void)closeBtn:(UIButton *)btn
{
    [AFManager postReqURL:JIESHUZHIBO reqBody:@{@"uid":[USERDEFAULT valueForKey:@"uid"],@"liveid":self.liveid,@"starttime":self.starttime} block:^(id infor) {
        NSLog(@"%@////",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            [self quitConversationViewAndClear];
           
            [UIApplication sharedApplication].idleTimerDisabled = NO;
            
        }
    }];
    
}

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
    
    
    self.conversationDataRepository = [[NSMutableArray alloc] init];
    self.userList = [[NSMutableArray alloc] init];
    self.conversationMessageCollectionView = nil;
    self.chatId = nil;
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
- (void)leftBarButtonItemPressed:(id)sender {
    [AFManager postReqURL:JIESHUZHIBO reqBody:@{@"uid":[USERDEFAULT valueForKey:@"uid"],@"liveid":self.liveid,@"starttime":self.starttime} block:^(id infor) {
        NSLog(@"%@////",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            [self quitConversationViewAndClear];

        }
    }];
    
}

// 清理环境（退出讨论组、移除监听等）
- (void)quitConversationViewAndClear {
    if (self.conversationType == ConversationType_CHATROOM) {
        
        [[RCIMClient sharedRCIMClient] quitChatRoom:self.chatId
                                            success:^{
                                                NSLog(@"退出聊天室成功");
                                                self.conversationMessageCollectionView.dataSource = nil;
                                                self.conversationMessageCollectionView.delegate = nil;
                                                [[NSNotificationCenter defaultCenter] removeObserver:self];
                                                [[CameraServer server] shutdown:^{
                                                    for (UIViewController *viewcontroller in self.navigationController.viewControllers) {
                                                        if ([viewcontroller isKindOfClass:[zhiboViewController class]]||[viewcontroller isKindOfClass:[lepaihangViewController class]]||[viewcontroller isKindOfClass:[shequViewController class]]||[viewcontroller isKindOfClass:[xiaoxiViewController class]]) {
                                                            [self.navigationController popToViewController:viewcontroller animated:YES];
                                                        }
                                                    }
                                                    
                                                }];
                                               
                                            } error:^(RCErrorCode status) {
                                                
                                                NSLog(@"退出聊天室失败");
                                                
                                            }];
    }
}

/**
 *  初始化页面控件
 */
- (void)initializedSubViews {
    //聊天区
    if(self.contentView == nil){
        CGRect contentViewFrame = CGRectMake(0, self.view.bounds.size.height-237, self.view.bounds.size.width,237);
        self.contentView.backgroundColor = RCDLive_RGBCOLOR(235, 235, 235);
        self.contentView = [[UIView alloc]initWithFrame:contentViewFrame];
        [[[CameraServer server] getCameraView] addSubview:self.contentView];
    }
    //聊天消息区
    if (nil == self.conversationMessageCollectionView) {
        UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        customFlowLayout.minimumLineSpacing = 0;
        customFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f,5.0f, 0.0f);
        customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGRect _conversationViewFrame = self.contentView.bounds;
        _conversationViewFrame.origin.y = 0;
        _conversationViewFrame.size.height = self.contentView.bounds.size.height - 55;
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
                                 initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
    _collectionViewHeader.tag = 1999;
    [self.conversationMessageCollectionView addSubview:_collectionViewHeader];
    [self registerClass:[RCDLiveTipMessageCell class]forCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier];
    //    [self changeModel:YES];
    _resetBottomTapGesture =[[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(tap4ResetDefaultBottomBarStatus:)];
    [_resetBottomTapGesture setDelegate:self];
    
    
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
                                             targetId:self.chatId
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
        if(notification && [notification.type isEqualToString:@"1"]){
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
    if (self.chatId == nil) {
        return;
    }
    messageContent.senderUserInfo = [RCDLive sharedRCDLive].currentUserInfo;
    if (messageContent == nil) {
        return;
    }
    
    [[RCDLive sharedRCDLive] sendMessage:self.conversationType
                                targetId:self.chatId
                                 content:messageContent
                             pushContent:pushContent
                                pushData:nil
                                 success:^(long messageId) {
                                     __weak typeof(&*self) __weakself = self;
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         RCMessage *message = [[RCMessage alloc] initWithType:__weakself.conversationType
                                                                                     targetId:__weakself.chatId
                                                                                    direction:MessageDirection_SEND
                                                                                    messageId:messageId
                                                                                      content:messageContent];
                                         if ([message.content isMemberOfClass:[RCDLiveGiftMessage class]] ) {
                                             message.messageId = -1;//插入消息时如果id是-1不判断是否存在
                                         }
                                         [__weakself appendAndDisplayMessage:message];
                                         [__weakself.inputBar clearInputView];
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
        [model.targetId isEqual:self.chatId]) {
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
        NSLog(@"自定义消息");
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
        CGRect collectionViewRect = self.conversationMessageCollectionView.frame;
        collectionViewRect.size.height = self.contentView.bounds.size.height - 0;
        [self.conversationMessageCollectionView setFrame:collectionViewRect];
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
    [self.inputBar setInputBarStatus:KBottomBarDefaultStatuss];
    [self.inputBar setHidden:YES];
    
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
 *  @param curve
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
        NSLog(@"%.2f - %.2f -- %d",startX,scale,imageName);
        
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









@end
