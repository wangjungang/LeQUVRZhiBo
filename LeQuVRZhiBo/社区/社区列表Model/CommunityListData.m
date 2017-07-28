//
//  CommunityListData.m
//
//  Created by 婷 张 on 16/12/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "CommunityListData.h"


NSString *const kCommunityListDataContent = @"content";
NSString *const kCommunityListDataDistance = @"distance";
NSString *const kCommunityListDataId = @"id";
NSString *const kCommunityListDataNickname = @"nickname";
NSString *const kCommunityListDataPic = @"pic";
NSString *const kCommunityListDataTime = @"time";
NSString *const kCommunityListDataHeadPic = @"head_pic";
NSString *const kCommunityListDataLat = @"lat";
NSString *const kCommunityListDataPre = @"pre";
NSString *const kCommunityListDataUid = @"uid";

@interface CommunityListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CommunityListData

@synthesize content = _content;
@synthesize distance = _distance;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize nickname = _nickname;
@synthesize pic = _pic;
@synthesize time = _time;
@synthesize headPic = _headPic;
@synthesize lat = _lat;
@synthesize pre = _pre;
@synthesize uid = _uid;

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
            self.content = [self objectOrNilForKey:kCommunityListDataContent fromDictionary:dict];
            self.distance = [[self objectOrNilForKey:kCommunityListDataDistance fromDictionary:dict] doubleValue];
            self.dataIdentifier = [self objectOrNilForKey:kCommunityListDataId fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kCommunityListDataNickname fromDictionary:dict];
            self.pic = [self objectOrNilForKey:kCommunityListDataPic fromDictionary:dict];
            self.time = [self objectOrNilForKey:kCommunityListDataTime fromDictionary:dict];
            self.headPic = [self objectOrNilForKey:kCommunityListDataHeadPic fromDictionary:dict];
            self.lat = [self objectOrNilForKey:kCommunityListDataLat fromDictionary:dict];
            self.pre = [self objectOrNilForKey:kCommunityListDataPre fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kCommunityListDataUid fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.content forKey:kCommunityListDataContent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.distance] forKey:kCommunityListDataDistance];
    [mutableDict setValue:self.dataIdentifier forKey:kCommunityListDataId];
    [mutableDict setValue:self.nickname forKey:kCommunityListDataNickname];
    [mutableDict setValue:self.pic forKey:kCommunityListDataPic];
    [mutableDict setValue:self.time forKey:kCommunityListDataTime];
    [mutableDict setValue:self.headPic forKey:kCommunityListDataHeadPic];
    [mutableDict setValue:self.lat forKey:kCommunityListDataLat];
    [mutableDict setValue:self.pre forKey:kCommunityListDataPre];
    [mutableDict setValue:self.uid forKey:kCommunityListDataUid];
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

    self.content = [aDecoder decodeObjectForKey:kCommunityListDataContent];
    self.distance = [aDecoder decodeDoubleForKey:kCommunityListDataDistance];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kCommunityListDataId];
    self.nickname = [aDecoder decodeObjectForKey:kCommunityListDataNickname];
    self.pic = [aDecoder decodeObjectForKey:kCommunityListDataPic];
    self.time = [aDecoder decodeObjectForKey:kCommunityListDataTime];
    self.headPic = [aDecoder decodeObjectForKey:kCommunityListDataHeadPic];
    self.lat = [aDecoder decodeObjectForKey:kCommunityListDataLat];
    self.pre = [aDecoder decodeObjectForKey:kCommunityListDataPre];
    self.uid = [aDecoder decodeObjectForKey:kCommunityListDataUid];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_content forKey:kCommunityListDataContent];
    [aCoder encodeDouble:_distance forKey:kCommunityListDataDistance];
    [aCoder encodeObject:_dataIdentifier forKey:kCommunityListDataId];
    [aCoder encodeObject:_nickname forKey:kCommunityListDataNickname];
    [aCoder encodeObject:_pic forKey:kCommunityListDataPic];
    [aCoder encodeObject:_time forKey:kCommunityListDataTime];
    [aCoder encodeObject:_headPic forKey:kCommunityListDataHeadPic];
    [aCoder encodeObject:_lat forKey:kCommunityListDataLat];
    [aCoder encodeObject:_pre forKey:kCommunityListDataPre];
    [aCoder encodeObject:_uid forKey:kCommunityListDataUid];
}

- (id)copyWithZone:(NSZone *)zone
{
    CommunityListData *copy = [[CommunityListData alloc] init];
    
    if (copy) {

        copy.content = [self.content copyWithZone:zone];
        copy.distance = self.distance;
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.pic = [self.pic copyWithZone:zone];
        copy.time = [self.time copyWithZone:zone];
        copy.headPic = [self.headPic copyWithZone:zone];
        copy.lat = [self.lat copyWithZone:zone];
        copy.pre = [self.pre copyWithZone:zone];
        copy.uid = [self.pre copyWithZone:zone];
    }
    
    return copy;
}


@end
