//
//  SmallVideoController.m
//  LeQuVRZhiBo
//
//  Created by 李壮 on 2016/12/23.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "SmallVideoController.h"
#import "WCSCaptureViewController.h"
#import "WKMovieRecorder.h"
#import "WKVideoConverter.h"
#import "UIImageView+PlayGIF.h"
#import "WCSPlayMovieController.h"
#import "NSString+Extend.h"

#import "NSObject+MBProgressHUD.h"
#import "NSObject+HUD.h"
//七牛

#import <QiniuSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface SmallVideoController ()<UITextViewDelegate>
{
    UITextView*TF;
    UILabel*placeLb;
    UIButton*imageView;
    MBProgressHUD*HUD;
    NSString *localvideoPath;
    NSString *localVideoName;
    BOOL      isUploadSuccess;
    NSString *imageUrl;
}
@property (strong, nonatomic)  UIButton *previewButton;//预览按钮
@property (strong, nonatomic)  UIImageView *preImageView;//播放gif

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) WKVideoConverter *converter;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, strong) NSURL *gifURL;

@property (nonatomic, strong) WCSPlayMovieController *playVC;
@end

@implementation SmallVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    isUploadSuccess=NO;
    self.view.backgroundColor =[UIColor whiteColor];
    UIImageView*navImage= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 64)];
    navImage.image=[UIImage imageNamed:@"11"];
    [self.view addSubview:navImage];
    [self createUI];
}
- (void)createUI
{
    TF=[[UITextView alloc]initWithFrame:CGRectMake(10, 70, DEVICE_WIDTH-20, F_I6_SIZE(150))];
    TF.font=[UIFont systemFontOfSize:15];
    TF.delegate=self;
    [self.view addSubview:TF];
    placeLb =[[UILabel alloc]initWithFrame:CGRectMake(10, 74, DEVICE_WIDTH, F_I6_SIZE(20))];
    placeLb.textColor=[UIColor grayColor];
    placeLb.font =[UIFont systemFontOfSize:15];
    placeLb.text=@"输入您想说的话";
    [self.view addSubview:placeLb];
    
    imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    imageView.frame=CGRectMake(10, 70+F_I6_SIZE(150), F_I6_SIZE(90), F_I6_SIZE(90));
    [imageView setBackgroundImage:[UIImage imageNamed:@"上传_13.png"] forState:0];
    imageView.userInteractionEnabled = YES;
    [imageView addTarget:self action:@selector(VideoBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageView];
    
    
    UIButton *finishBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame=CGRectMake(F_I6_SIZE(40), 70+F_I6_SIZE(250), DEVICE_WIDTH-F_I6_SIZE(80), F_I6_SIZE(45));
    finishBtn.backgroundColor =kCOLOR(224, 42, 93, 1);
    [finishBtn setTitle:@"上传" forState:0];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:0];
    finishBtn.clipsToBounds=YES;
    [finishBtn addTarget:self action:@selector(upLoadVideo) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.layer.cornerRadius=F_I6_SIZE(22.5);
    [self.view addSubview:finishBtn];
    
    UIButton *cancleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame=CGRectMake(F_I6_SIZE(40), 70+F_I6_SIZE(310), DEVICE_WIDTH-F_I6_SIZE(80), F_I6_SIZE(45));
    cancleBtn.backgroundColor =kCOLOR(193, 193, 193, 1);
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:0];
    cancleBtn.clipsToBounds=YES;
    [cancleBtn addTarget:self action:@selector(dismissBtn) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.layer.cornerRadius=F_I6_SIZE(22.5);
    [self.view addSubview:cancleBtn];
}
#pragma mark-
#pragma mark-textView协议方法
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        placeLb.text=@"";
    }else
    {
        placeLb.text=@"输入您想说的话";
    }
}
//录制小视频按钮
- (void)VideoBtn
{
    WCSCaptureViewController*wcs=[WCSCaptureViewController new];
    wcs.myBlock=^(NSDictionary*dic){
        _movieInfo=dic;
        [self setupUI];
    };
    [self presentViewController:wcs animated:YES completion:nil];
}
//上传视频按钮
- (void)upLoadVideo
{
    if ([TF.text deleteSpace].length>0&&![localvideoPath isEqualToString:@""]&&isUploadSuccess)
    {
        [self sendTalk];
    }else{
        [NSObject wj_showHUDWithTip:@"内容不能为空"];
    }
}
//取消按钮
- (void)dismissBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - setup
- (void)setupUI
{
    _previewButton.userInteractionEnabled = NO;
    
    //1.生成文件名
//    NSDateFormatter *df = [NSDateFormatter new];
//    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
//    NSString *name = [df stringFromDate:[NSDate date]];
    NSString *name = [NSString stringWithFormat:@"%ld%@", (long)[[NSDate date] timeIntervalSince1970],[USERDEFAULT valueForKey:@"uid"]];
    NSString *gifName = [name stringByAppendingPathExtension:@".gif"];
    NSString *videoName = [name stringByAppendingPathExtension:@"mp4"];
    
    //2.拷贝视频
    [self copyVideoWithMovieName:videoName];
    
    //3.生成gif
    self.preImageView.contentMode = UIViewContentModeScaleAspectFill;
    _preImageView.layer.masksToBounds = YES;
    _preImageView.image = self.movieInfo[WKRecorderFirstFrame];
    [self generateAndShowGifWithName:gifName];
    imageView.hidden=YES;
    [self upLoadImage:_preImageView.image];
}
- (NSString *)generateMoviePathWithFileName:(NSString *)name
{
    NSString *documetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *moviePath = [documetPath stringByAppendingPathComponent:name];
    
    return moviePath;
}

- (void)copyVideoWithMovieName:(NSString *)movieName
{
    //1.生成视屏URL
    NSMutableString *videoName = [movieName mutableCopy];
    NSURL *videoURL = _movieInfo[WKRecorderMovieURL];
    
    [videoName stringByAppendingPathExtension:@".mp4"];
    
    [videoName replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, videoName.length)];
    
    NSString *videoPath = [self generateMoviePathWithFileName:videoName];
    NSURL *newVideoURL = [NSURL fileURLWithPath:videoPath];
    NSError *error = nil;
    localvideoPath=videoPath;
    localVideoName=videoName;
    [[NSFileManager defaultManager] copyItemAtURL:videoURL toURL:newVideoURL error:&error];
    
    
    if (error) {
        
//        NSLog(@"%@", [error localizedDescription]);
        
    }else{
        self.videoURL = newVideoURL;
    }
//    NSLog(@"视频路径%@---视频名字%@",localvideoPath,localVideoName);
    [self getTokenVideoName:videoName VideoPath:videoPath];

}

- (void)generateAndShowGifWithName:(NSString *)gifName
{
    NSString *gifPath = [self generateMoviePathWithFileName:gifName];
    NSURL *newVideoURL = [NSURL fileURLWithPath:gifPath];
    
    WKVideoConverter *converter = [[WKVideoConverter alloc] init];
    
    
    [converter convertVideoToGifImageWithURL:self.videoURL destinationUrl:newVideoURL finishBlock:^{//播放gif
        _previewButton.userInteractionEnabled = YES;
        _preImageView.gifPath = gifPath;
        [_preImageView startGIF];
    }];
    
    _converter = converter;
}
//播放小视频按钮
- (void)showMovieAction {
    WCSPlayMovieController *playVC = [[WCSPlayMovieController alloc] init];
    playVC.movieURL = self.videoURL;
    
    [self displayChildController:playVC];
    
    _playVC = playVC;
}

#pragma mark - displayChildController
- (void) displayChildController: (UIViewController*) child {
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    child.view.frame = self.view.frame;
    [child didMoveToParentViewController:self];
}

- (void) hideContentController: (UIViewController*) child {
    [child willMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideContentController:self.playVC];
    self.playVC = nil;
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImageView*)preImageView
{
    if (!_preImageView)
    {
        _preImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 70+F_I6_SIZE(150), F_I6_SIZE(90), F_I6_SIZE(90))];
        _preImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMovieAction)];
        [_preImageView addGestureRecognizer:tap];
        [self.view addSubview:_preImageView];
    }
    return _preImageView;
}

#pragma mark-
#pragma mark-获取七牛云token
- (void)getTokenVideoName:(NSString*)videoName VideoPath:(NSString*)VIdeoPath
{
    HUD=[NSObject showHUDView:self.view MBText:@"正在上传"];
    [AFManager getReqURL:GET_QINIU_TOKEN_URL block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            NSString*token=[infor objectForKey:@"data"];
            [self uploadVideoToken:token VideoName:videoName VideoPath:VIdeoPath];
        }
    } errorblock:^(NSError *error)
    {
        
    }];
}
//上传视频到七牛
- (void)uploadVideoToken:(NSString*)qiNiutoken VideoName:(NSString*)videoName VideoPath:(NSString*)VIdeoPath
{
//    //国内https上传
    BOOL isHttps = TRUE;
    QNZone * httpsZone = [[QNAutoZone alloc] initWithHttps:isHttps dns:nil];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = httpsZone;
    }];
    //重用uploadManager。一般地，只需要创建一个uploadManager对象
    NSString * token = qiNiutoken;
    NSString * key = videoName;
    NSString * filePath = VIdeoPath;
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    [upManager putFile:filePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if(info.ok)
        {
            isUploadSuccess=YES;
            [NSObject wj_showHUDWithTip:@"视频上传成功"];
        }
        else
        {
            [NSObject wj_showHUDWithTip:@"视频上传失败"];
            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
        }
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
        [HUD hide:YES];
    }
                option:nil];
}
#pragma mark-
#pragma mark-处理数据
- (void)sendTalk
{
    [AFManager getReqURL:[NSString stringWithFormat:SEND_TALK_URL,localVideoName,[USERDEFAULT valueForKey:@"uid"],imageUrl,TF.text] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            [NSObject wj_showHUDWithTip:@"发表成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            [NSObject wj_showHUDWithTip:@"发表失败"];
        }
    } errorblock:^(NSError *error)
    {
        [NSObject wj_showHUDWithTip:@"发表失败"];
    }];
}
#pragma mark-
#pragma mark-上传图片
- (void)upLoadImage:(UIImage*)myImage
{
    NSData *data=UIImageJPEGRepresentation(myImage, 0.01);
    NSDictionary *dict = @{};
    [AFManager upLoadpath2:UPLOAD_VIDEO_IMAGE_URL reqBody:dict file:data fileName:@"file" fileType:@"image/jpg" block:^(id infor)
     {
         if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"])
         {
             imageUrl=[infor objectForKey:@"data"];
         }
     } errorBlock:^(NSError *error)
     {
     }];
}
#pragma mark - Navigation
@end
