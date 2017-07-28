//
//  ReplyListData.h
//
//  Created by 壮 李 on 2016/12/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ReplyListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *did;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *headPic;
@property (nonatomic, assign) CGFloat rowHeight;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
