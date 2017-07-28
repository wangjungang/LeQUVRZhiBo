//
//  RCLikeMessage.m
//  RongChatRoomDemo
//
//  Created by 杜立召 on 16/5/17.
//  Copyright © 2016年 rongcloud. All rights reserved.
//

#import "RCDLiveGiftMessage.h"

@implementation RCDLiveGiftMessage

/*
 * 对于聊天室中发送频繁的消息比如点赞 鲜花 之类的消息一定要设置成状态消息
 */
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_STATUS;
}

- (void)decodeWithData:(NSData *)data {
    __autoreleasing NSError *__error = nil;
    if (!data) {
        return;
    }
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&__error];
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:dictionary];
    if (!__error && dict) {
        self.type = [dict objectForKey:@"type"];
        self.typeNum = [dict objectForKey:@"typeNum"];
        self.giftName = [dict objectForKey:@"giftName"];
        self.giftText = [dict objectForKey:@"giftText"];
        self.giftUid = [dict objectForKey:@"giftUid"];
        self.giftPic = [dict objectForKey:@"giftPic"];
        self.giftId = [dict objectForKey:@"giftId"];

        NSDictionary *userinfoDic = [dict objectForKey:@"user"];
        [self decodeUserInfo:userinfoDic];
    } else {
        self.rawJSONData = data;
    }
}

- (NSData *)encode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.type) {
        [dict setObject:self.type forKey:@"type"];
    }
    if (self.typeNum) {
        [dict setObject:self.typeNum forKey:@"typeNum"];
    }
    if (self.giftName) {
        [dict setObject:self.giftName forKey:@"giftName"];
    }
    if (self.giftText) {
        [dict setObject:self.giftText forKey:@"giftText"];
    }
    if (self.giftUid) {
        [dict setObject:self.giftUid forKey:@"giftUid"];
    }
    if (self.giftPic) {
        [dict setObject:self.giftPic forKey:@"giftPic"];
    }
    if (self.giftId) {
        [dict setObject:self.giftId forKey:@"giftId"];
    }
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dict setObject:__dic forKey:@"user"];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
    return jsonData;
}

+ (NSString *)getObjectName {
    return RCDLiveGiftMessageIdentifier;
}

#if !__has_feature(objc_arc)
- (void)dealloc {
    [super dealloc];
}
#endif //__has_feature(objc_arc)

@end

