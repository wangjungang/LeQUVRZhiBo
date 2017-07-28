//
//  Data.h
//
//  Created by 壮 李 on 2016/12/14
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GiftListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *gid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *gname;
@property (nonatomic, strong) NSString *pic;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
