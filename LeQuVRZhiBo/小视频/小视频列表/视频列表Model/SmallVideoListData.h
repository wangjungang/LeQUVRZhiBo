//
//  SmallVideoListData.h
//
//  Created by 婷 张 on 16/12/28
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SmallVideoListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *utime;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *headPic;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *dir;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, assign) CGFloat   rowHeight;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
