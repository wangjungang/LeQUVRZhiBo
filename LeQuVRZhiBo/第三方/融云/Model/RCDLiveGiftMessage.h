//
//  RCLikeMessage.h
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/5/17.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMLib/RongIMLib.h>

#define RCDLiveGiftMessageIdentifier @"RC:GiftMsg"
/* 点赞消息
 *
 * 对于聊天室中发送频率较高，不需要存储的消息要使用状态消息，自定义消息继承RCMessageContent 
 * 然后persistentFlag 方法返回 MessagePersistent_STATUS
 */
@interface RCDLiveGiftMessage : RCMessageContent

/*
 
 type 5普通消息
 type 0连发礼物
 */
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *typeNum;//礼物标示
@property(nonatomic, strong) NSString *giftName;//礼物名字
@property(nonatomic, strong) NSString *giftText;//要传的文字
@property(nonatomic, strong) NSString *giftUid;//发礼物的人
@property(nonatomic, strong) NSString *giftId;//礼物id;
@property(nonatomic, strong) NSString *giftPic;//礼物图片url
@end
