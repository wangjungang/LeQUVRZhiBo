//
//  Data.h
//
//  Created by 壮 李 on 2016/12/21
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FansListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *levelid;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *autoProperty;
@property (nonatomic, strong) NSString *headPic;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *fansid;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
