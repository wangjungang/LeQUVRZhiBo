//
//  CommunityListData.h
//
//  Created by 婷 张 on 16/12/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CommunityListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double distance;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *headPic;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *pre;
@property (nonatomic, strong) NSString *uid;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
