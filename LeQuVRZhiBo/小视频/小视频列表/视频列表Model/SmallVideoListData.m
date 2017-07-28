//
//  SmallVideoListData.m
//
//  Created by 婷 张 on 16/12/28
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SmallVideoListData.h"


NSString *const kSmallVideoListDataImg = @"img";
NSString *const kSmallVideoListDataUtime = @"utime";
NSString *const kSmallVideoListDataId = @"id";
NSString *const kSmallVideoListDataUid = @"uid";
NSString *const kSmallVideoListDataNickname = @"nickname";
NSString *const kSmallVideoListDataHeadPic = @"head_pic";
NSString *const kSmallVideoListDataKey = @"key";
NSString *const kSmallVideoListDataDir = @"dir";
NSString *const kSmallVideoListDataContent = @"content";
NSString *const kSmallVideoListDataCount = @"count";
@interface SmallVideoListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SmallVideoListData

@synthesize img = _img;
@synthesize utime = _utime;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize uid = _uid;
@synthesize nickname = _nickname;
@synthesize headPic = _headPic;
@synthesize key = _key;
@synthesize dir = _dir;
@synthesize content = _content;
@synthesize count = _count;

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
            self.img = [self objectOrNilForKey:kSmallVideoListDataImg fromDictionary:dict];
            self.utime = [self objectOrNilForKey:kSmallVideoListDataUtime fromDictionary:dict];
            self.dataIdentifier = [self objectOrNilForKey:kSmallVideoListDataId fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kSmallVideoListDataUid fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kSmallVideoListDataNickname fromDictionary:dict];
            self.headPic = [self objectOrNilForKey:kSmallVideoListDataHeadPic fromDictionary:dict];
            self.key = [self objectOrNilForKey:kSmallVideoListDataKey fromDictionary:dict];
            self.dir = [self objectOrNilForKey:kSmallVideoListDataDir fromDictionary:dict];
            self.content =[self objectOrNilForKey:kSmallVideoListDataContent fromDictionary:dict];
            self.count = [self objectOrNilForKey:kSmallVideoListDataCount fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.img forKey:kSmallVideoListDataImg];
    [mutableDict setValue:self.utime forKey:kSmallVideoListDataUtime];
    [mutableDict setValue:self.dataIdentifier forKey:kSmallVideoListDataId];
    [mutableDict setValue:self.uid forKey:kSmallVideoListDataUid];
    [mutableDict setValue:self.nickname forKey:kSmallVideoListDataNickname];
    [mutableDict setValue:self.headPic forKey:kSmallVideoListDataHeadPic];
    [mutableDict setValue:self.key forKey:kSmallVideoListDataKey];
    [mutableDict setValue:self.dir forKey:kSmallVideoListDataDir];
    [mutableDict setValue:self.content forKey:kSmallVideoListDataContent];
    [mutableDict setValue:self.count forKey:kSmallVideoListDataCount];
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

    self.img = [aDecoder decodeObjectForKey:kSmallVideoListDataImg];
    self.utime = [aDecoder decodeObjectForKey:kSmallVideoListDataUtime];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kSmallVideoListDataId];
    self.uid = [aDecoder decodeObjectForKey:kSmallVideoListDataUid];
    self.nickname = [aDecoder decodeObjectForKey:kSmallVideoListDataNickname];
    self.headPic = [aDecoder decodeObjectForKey:kSmallVideoListDataHeadPic];
    self.key = [aDecoder decodeObjectForKey:kSmallVideoListDataKey];
    self.dir = [aDecoder decodeObjectForKey:kSmallVideoListDataDir];
    self.content = [aDecoder decodeObjectForKey:kSmallVideoListDataContent];
    self.count = [aDecoder decodeObjectForKey:kSmallVideoListDataCount];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_img forKey:kSmallVideoListDataImg];
    [aCoder encodeObject:_utime forKey:kSmallVideoListDataUtime];
    [aCoder encodeObject:_dataIdentifier forKey:kSmallVideoListDataId];
    [aCoder encodeObject:_uid forKey:kSmallVideoListDataUid];
    [aCoder encodeObject:_nickname forKey:kSmallVideoListDataNickname];
    [aCoder encodeObject:_headPic forKey:kSmallVideoListDataHeadPic];
    [aCoder encodeObject:_key forKey:kSmallVideoListDataKey];
    [aCoder encodeObject:_dir forKey:kSmallVideoListDataDir];
    [aCoder encodeObject:_content forKey:kSmallVideoListDataContent];
    [aCoder encodeObject:_count forKey:kSmallVideoListDataCount];
}

- (id)copyWithZone:(NSZone *)zone
{
    SmallVideoListData *copy = [[SmallVideoListData alloc] init];
    
    if (copy)
    {
        copy.img = [self.img copyWithZone:zone];
        copy.utime = [self.utime copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.headPic = [self.headPic copyWithZone:zone];
        copy.key = [self.key copyWithZone:zone];
        copy.dir = [self.dir copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.count = [self.count copyWithZone:zone];
    }
    return copy;
}


@end
