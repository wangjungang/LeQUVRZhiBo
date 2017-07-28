//
//  RCDLiveTipMessageCell.m
//  RongIMKit
//
//  Created by xugang on 15/1/29.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDLiveTipMessageCell.h"
#import "RCDLiveTipLabel.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDLiveGiftMessage.h"
@interface RCDLiveTipMessageCell ()<RCDLiveAttributedLabelDelegate>
{
    UIView *view;
}
@end

@implementation RCDLiveTipMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tipMessageLabel = [RCDLiveTipLabel greyTipLabel];
        self.tipMessageLabel.textAlignment = NSTextAlignmentLeft;
//        self.tipMessageLabel.delegate = self;
        self.tipMessageLabel.userInteractionEnabled = YES;
        [self.baseContentView addSubview:self.tipMessageLabel];
        self.tipMessageLabel.font = [UIFont systemFontOfSize:16.f];;
        self.tipMessageLabel.marginInsets = UIEdgeInsetsMake(0.5f, 0.5f, 0.5f, 0.5f);
        
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 6, 25, 15)];
        view = [[UIView alloc]init];
        view.backgroundColor = [UIColor orangeColor];
        [self.baseContentView addSubview:view];
        
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 2, 10, 10)];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
        [view addSubview:leftBtn];
        
        self.dengji = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 10, 15)];
        self.dengji.text = @"1";
        self.dengji.font = [UIFont systemFontOfSize:12];
        self.dengji.textAlignment = NSTextAlignmentCenter;
        [view addSubview:self.dengji];
        
        
    }
    return self;
}

- (void)setDataModel:(RCDLiveMessageModel *)model {
    [super setDataModel:model];

    RCMessageContent *content = model.content;
    if ([content isMemberOfClass:[RCDLiveGiftMessage class]]){
        RCDLiveGiftMessage *notification = (RCDLiveGiftMessage *)content;
        NSString *name;
        if (content.senderUserInfo) {
            name = [NSString stringWithFormat:@"%@:",content.senderUserInfo.name];
        }
        NSString *localizedMessage = @"";
        if(notification && [notification.type isEqualToString:@"1"]){
            localizedMessage = [NSString stringWithFormat:@"送了一个%@",notification.giftName];
        }else if(notification && [notification.type isEqualToString:@"2"]){
            localizedMessage = [NSString stringWithFormat:@"送了一个%@",notification.giftName];
        }else if(notification && [notification.type isEqualToString:@"3"]){
            localizedMessage = @"发送了一条弹幕";
        }else{
            localizedMessage = [NSString stringWithFormat:@"%@",notification.giftText];
        }

        
        NSString *str =[NSString stringWithFormat:@"%@ %@",name,localizedMessage];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0x3ceff)) range:[str rangeOfString:name]];
        [attributedString addAttribute:NSForegroundColorAttributeName value:(RCDLive_HEXCOLOR(0xf719ff)) range:[str rangeOfString:localizedMessage]];
        self.tipMessageLabel.attributedText = attributedString.copy;
    }

    NSString *__text = self.tipMessageLabel.text;
    CGSize __labelSize = [RCDLiveTipMessageCell getTipMessageCellSize:__text];
    self.tipMessageLabel.frame = CGRectMake(35,0, __labelSize.width, __labelSize.height);
    view.frame = CGRectMake(10, self.tipMessageLabel.frame.origin.y+6, 25, 15);

   
}



- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *urlString=[url absoluteString];
    if (![urlString hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
    if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
        [self.delegate didTapUrlInMessageCell:urlString model:self.model];
        return;
    }
}

/**
 Tells the delegate that the user did select a link to an address.
 
 @param label The label whose link was selected.
 @param addressComponents The components of the address for the selected link.
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithAddress:(NSDictionary *)addressComponents
{
    
}

/**
 Tells the delegate that the user did select a link to a phone number.
 
 @param label The label whose link was selected.
 @param phoneNumber The phone number for the selected link.
 */
- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *number = [@"tel://" stringByAppendingString:phoneNumber];
    if ([self.delegate respondsToSelector:@selector(didTapPhoneNumberInMessageCell:model:)]) {
        [self.delegate didTapPhoneNumberInMessageCell:number model:self.model];
        return;
    }
}

-(void)attributedLabel:(RCDLiveAttributedLabel *)label didTapLabel:(NSString *)content
{
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

+ (CGSize)getTipMessageCellSize:(NSString *)content{
    CGFloat maxMessageLabelWidth = F_I6_SIZE(240)-20-25;
    CGSize __textSize = CGSizeZero;
    if (RCDLive_IOS_FSystenVersion < 7.0) {
        __textSize = RCDLive_RC_MULTILINE_TEXTSIZE_LIOS7(content, [UIFont systemFontOfSize:16.0f], CGSizeMake(maxMessageLabelWidth, MAXFLOAT), NSLineBreakByTruncatingTail);
    }else {
        __textSize = RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(content, [UIFont systemFontOfSize:16.0f], CGSizeMake(maxMessageLabelWidth, MAXFLOAT));
    }
    __textSize = CGSizeMake(ceilf(__textSize.width)+10 , ceilf(__textSize.height)+6);
    return __textSize;
}
@end
