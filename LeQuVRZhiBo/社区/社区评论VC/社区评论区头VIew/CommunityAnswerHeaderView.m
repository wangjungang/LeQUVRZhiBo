//
//  CommunityAnswerHeaderView.m
//  LeQuVRZhiBo
//
//  Created by 李壮 on 2016/12/16.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "CommunityAnswerHeaderView.h"
#import "NSString+Extend.h"
#import "ZanListData.h"
#define  imageWidth (DEVICE_WIDTH-F_I6_SIZE(60))/3.0

@interface CommunityAnswerHeaderView ()
{
    UILabel*lineLb;
    CGFloat viewInitHeight;
}
@end


@implementation CommunityAnswerHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.heardImage=[[UIImageView alloc]initWithFrame:CGRectMake(F_I6_SIZE(10), F_I6_SIZE(10), F_I6_SIZE(45), F_I6_SIZE(45))];
        self.heardImage.clipsToBounds=YES;
        self.heardImage.layer.cornerRadius=F_I6_SIZE(45/2.0);
        [self addSubview:self.heardImage];
        
        self.nickNameLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(60), F_I6_SIZE(10), DEVICE_WIDTH-F_I6_SIZE(60), F_I6_SIZE(18))];
        self.nickNameLb.font=[UIFont systemFontOfSize:F_I6_SIZE(18)];
        [self addSubview:_nickNameLb];
        
        self.contentLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(60), F_I6_SIZE(30), DEVICE_WIDTH-F_I6_SIZE(70), 0)];
        self.contentLb.numberOfLines=0;
        self.contentLb.font=[UIFont systemFontOfSize:F_I6_SIZE(12)];
        [self addSubview:_contentLb];
        
        self.timeLb=[[UILabel alloc]init];
        self.timeLb.textColor=[UIColor grayColor];
        self.timeLb.font=[UIFont systemFontOfSize:F_I6_SIZE(12)];
        [self addSubview:self.timeLb];
        
        self.zanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.zanBtn setImage:[UIImage imageNamed:@"社区-动态_12.png"] forState:0];
        self.zanBtn.titleLabel.font =[UIFont systemFontOfSize:F_I6_SIZE(13)];
        [self.zanBtn setTitleColor:[UIColor grayColor] forState:0];
        [self.zanBtn setTitle:@" 赞" forState:0];
        [self addSubview:self.zanBtn];
        
        self.answerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.answerBtn setImage:[UIImage imageNamed:@"社区-动态_14.png"] forState:0];
        self.answerBtn.titleLabel.font =[UIFont systemFontOfSize:F_I6_SIZE(13)];
        [self.answerBtn setTitleColor:[UIColor grayColor] forState:0];
        [self.answerBtn setTitle:@" 评论" forState:0];
        [self addSubview:self.answerBtn];
        
        self.zanImage =[[UIImageView alloc]initWithFrame:CGRectMake(F_I6_SIZE(10), F_I6_SIZE(10), F_I6_SIZE(15), F_I6_SIZE(15))];
        self.zanImage.image =[UIImage imageNamed:@"社区-动态_12.png"];
        [self addSubview:self.zanImage];
        self.zanImage.hidden=YES;
        self.zanLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(30), F_I6_SIZE(10), DEVICE_WIDTH-F_I6_SIZE(40), 0)];
        self.zanLb.numberOfLines=0;
        self.zanLb.font =[UIFont systemFontOfSize:F_I6_SIZE(14)];
        self.zanLb.textColor=[UIColor grayColor];
        [self addSubview:self.zanLb];
        lineLb =[[UILabel alloc]init];
        lineLb.backgroundColor =kCOLOR(210, 210, 210, 0.3);
        [self addSubview:lineLb];
    }
    return self;
}
- (void)setContentData:(CommunityListData*)data
{
    [self.heardImage setImageWithURL:[NSURL URLWithString:data.headPic] placeholderImage:[UIImage imageNamed:@"load"]];
    self.nickNameLb.text=data.nickname;
    self.contentLb.text=data.content;
    CGFloat contentTextHeight=[data.content getHeightWithFontSize:F_I6_SIZE(12) andConstrainedWidth:DEVICE_WIDTH-F_I6_SIZE(80)];
    self.contentLb.frame=CGRectMake(F_I6_SIZE(60), F_I6_SIZE(30), DEVICE_WIDTH-F_I6_SIZE(70), contentTextHeight);
    self.timeLb.text=data.time;
    if ([data.pic isEqualToString:@""]||!data.pic)
    {
        self.timeLb.frame=CGRectMake(F_I6_SIZE(60), contentTextHeight+F_I6_SIZE(35), DEVICE_WIDTH-F_I6_SIZE(100), F_I6_SIZE(15));
        self.answerBtn.frame=CGRectMake(DEVICE_WIDTH-F_I6_SIZE(70), contentTextHeight+F_I6_SIZE(35), F_I6_SIZE(60), F_I6_SIZE(20));
        self.zanBtn.frame=CGRectMake(DEVICE_WIDTH-F_I6_SIZE(130), contentTextHeight+F_I6_SIZE(35), F_I6_SIZE(50), F_I6_SIZE(20));
        self.frame=CGRectMake(0, 0, DEVICE_WIDTH, F_I6_SIZE(60)+contentTextHeight);
        viewInitHeight=F_I6_SIZE(60)+contentTextHeight;
    }else
    {
        _imageViews=[NSMutableArray array];
        NSArray*array=[data.pic componentsSeparatedByString:@","];
        CGFloat viewHeight= contentTextHeight+F_I6_SIZE(30)>=F_I6_SIZE(55)?contentTextHeight+F_I6_SIZE(35):F_I6_SIZE(60);
        for (NSInteger i=0; i<array.count; i++) {
            NSString *picUrl=array[i];
            UIImageView*imageView=[[UIImageView alloc]init];
            imageView.frame=CGRectMake(F_I6_SIZE(15)+(imageWidth+F_I6_SIZE(15))*i, viewHeight, imageWidth, imageWidth);
            [imageView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"load"]];
            [self addSubview:imageView];
            UITapGestureRecognizer *gesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapHandle:)];
            imageView.userInteractionEnabled = YES;
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView addGestureRecognizer:gesture];
            [_imageViews addObject:imageView];
        }
        self.answerBtn.frame=CGRectMake(DEVICE_WIDTH-F_I6_SIZE(70), viewHeight+imageWidth+F_I6_SIZE(5), F_I6_SIZE(60), F_I6_SIZE(20));
        self.zanBtn.frame=CGRectMake(DEVICE_WIDTH-F_I6_SIZE(130), viewHeight+imageWidth+F_I6_SIZE(5), F_I6_SIZE(50), F_I6_SIZE(20));
        self.timeLb.frame=CGRectMake(F_I6_SIZE(60), viewHeight+imageWidth+F_I6_SIZE(5), DEVICE_WIDTH-F_I6_SIZE(100), F_I6_SIZE(15));
        self.frame=CGRectMake(0, 0, DEVICE_WIDTH, viewHeight+imageWidth+F_I6_SIZE(30));
        viewInitHeight=viewHeight+imageWidth+F_I6_SIZE(30);

    }
    lineLb.frame=CGRectMake(0, self.zanBtn.frame.origin.y+F_I6_SIZE(22), DEVICE_WIDTH, 1);
}
- (void)setZanLbContent:(NSMutableArray*)array
{
    NSString*text;
    for (NSInteger i=0; i<array.count; i++)
    {
        self.zanImage.hidden=NO;
        ZanListData*data=array[i];
        if (text==nil)
        {
            text=data.nickname;
        }else
        {
            text=[NSString stringWithFormat:@"%@、%@",text,data.nickname];
        }
    }
    CGFloat height=[text getHeightWithFontSize:F_I6_SIZE(14) andConstrainedWidth:DEVICE_WIDTH-F_I6_SIZE(40)];
    self.zanLb.frame=CGRectMake(F_I6_SIZE(30), viewInitHeight, DEVICE_WIDTH-F_I6_SIZE(40), height);
    self.zanLb.text=text;
    self.zanImage.frame=CGRectMake(F_I6_SIZE(10), viewInitHeight, F_I6_SIZE(15), F_I6_SIZE(15));
    height=height>F_I6_SIZE(15)?height:F_I6_SIZE(15);
    self.frame=CGRectMake(0, 0, DEVICE_WIDTH, self.zanLb.frame.origin.y+height+F_I6_SIZE(5));
}
- (void)tapHandle:(UITapGestureRecognizer *)tap
{
    _imageViewer = [[XHImageViewer alloc]
                    initWithImageViewerWillDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView)
                    {
                        NSInteger index = [_imageViews indexOfObject:selectedView];
                        NSLog(@"willDismissBlock index : %ld", (long)index);
                    }
                    didDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer,
                                                      UIImageView *selectedView) {
                        NSInteger index = [_imageViews indexOfObject:selectedView];
                        NSLog(@"didDismissBlock index : %ld", (long)index);
                    }
                    didChangeToImageViewBlock:^(XHImageViewer *imageViewer,
                                                UIImageView *selectedView) {
                        NSInteger index = [_imageViews indexOfObject:selectedView];
                        [self.bottomToolBar.unLikeButton setTitle:[NSString stringWithFormat:@"%ld/%ld", index + 1, (long)_imageViews.count] forState:UIControlStateNormal];
                        
                    }];
    _imageViewer.delegate = self;
    _imageViewer.disableTouchDismiss = NO;
    [_imageViewer showWithImageViews:_imageViews
                        selectedView:(UIImageView *)tap.view];
    
    NSInteger index = [_imageViews indexOfObject:(UIImageView *)tap.view];
    [self.bottomToolBar.unLikeButton setTitle:[NSString stringWithFormat:@"%ld/%ld", index + 1, ( long)_imageViews.count] forState:UIControlStateNormal];
}
- (XHBottomToolBar *)bottomToolBar {
    if (!_bottomToolBar) {
        _bottomToolBar = [[XHBottomToolBar alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 44)];
    }
    return _bottomToolBar;
}
#pragma mark - XHImageViewerDelegate

- (UIView *)customBottomToolBarOfImageViewer:(XHImageViewer *)imageViewer {
    return self.bottomToolBar;
}
@end
