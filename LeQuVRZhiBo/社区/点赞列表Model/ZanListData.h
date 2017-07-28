//
//  ZanListData.h
//
//  Created by 壮 李 on 2016/12/20
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZanListData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *did;
@property (nonatomic, strong) NSString *dataIdentifier;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *nickname;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
