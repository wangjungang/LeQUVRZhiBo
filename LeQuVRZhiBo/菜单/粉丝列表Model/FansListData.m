//
//  Data.m
//
//  Created by 壮 李 on 2016/12/21
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "FansListData.h"


NSString *const kFansListDataLevelid = @"levelid";
NSString *const kFansListDataId = @"id";
NSString *const kFansListDataNickname = @"nickname";
NSString *const kFansListDataAuto = @"auto";
NSString *const kFansListDataHeadPic = @"head_pic";
NSString *const kFansListDataStatus= @"status";
NSString *const kFansListDataFansid= @"fansid";
@interface FansListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FansListData

@synthesize levelid = _levelid;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize nickname = _nickname;
@synthesize autoProperty = _autoProperty;
@synthesize headPic = _headPic;
@synthesize status = _status;
@synthesize fansid = _fansid;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.levelid = [self objectOrNilForKey:kFansListDataLevelid fromDictionary:dict];
            self.dataIdentifier = [self objectOrNilForKey:kFansListDataId fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kFansListDataNickname fromDictionary:dict];
            self.autoProperty = [self objectOrNilForKey:kFansListDataAuto fromDictionary:dict];
            self.headPic = [self objectOrNilForKey:kFansListDataHeadPic fromDictionary:dict];
            self.status = [self objectOrNilForKey:kFansListDataStatus fromDictionary:dict];
        self.fansid = [self objectOrNilForKey:kFansListDataFansid fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.levelid forKey:kFansListDataLevelid];
    [mutableDict setValue:self.dataIdentifier forKey:kFansListDataId];
    [mutableDict setValue:self.nickname forKey:kFansListDataNickname];
    [mutableDict setValue:self.autoProperty forKey:kFansListDataAuto];
    [mutableDict setValue:self.headPic forKey:kFansListDataHeadPic];
    [mutableDict setValue:self.status forKey:kFansListDataStatus];
    [mutableDict setValue:self.fansid forKey:kFansListDataFansid];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.levelid = [aDecoder decodeObjectForKey:kFansListDataLevelid];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kFansListDataId];
    self.nickname = [aDecoder decodeObjectForKey:kFansListDataNickname];
    self.autoProperty = [aDecoder decodeObjectForKey:kFansListDataAuto];
    self.headPic = [aDecoder decodeObjectForKey:kFansListDataHeadPic];
    self.status = [aDecoder decodeObjectForKey:kFansListDataStatus];
    self.fansid = [aDecoder decodeObjectForKey:kFansListDataFansid];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_levelid forKey:kFansListDataLevelid];
    [aCoder encodeObject:_dataIdentifier forKey:kFansListDataId];
    [aCoder encodeObject:_nickname forKey:kFansListDataNickname];
    [aCoder encodeObject:_autoProperty forKey:kFansListDataAuto];
    [aCoder encodeObject:_headPic forKey:kFansListDataHeadPic];
    [aCoder encodeObject:_status forKey:kFansListDataStatus];
    [aCoder encodeObject:_fansid forKey:kFansListDataFansid];
}

- (id)copyWithZone:(NSZone *)zone
{
    FansListData *copy = [[FansListData alloc] init];
    if (copy)
    {
        copy.levelid =[self.levelid copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.autoProperty = [self.autoProperty copyWithZone:zone];
        copy.headPic = [self.headPic copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
        copy.fansid = [self.fansid copyWithZone:zone];
    }
    return copy;
}


@end
