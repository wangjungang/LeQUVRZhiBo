//
//  ReplyListData.m
//
//  Created by 壮 李 on 2016/12/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "ReplyListData.h"


NSString *const kReplyListDataDid = @"did";
NSString *const kReplyListDataId = @"id";
NSString *const kReplyListDataContent = @"content";
NSString *const kReplyListDataUid = @"uid";
NSString *const kReplyListDataTime = @"time";
NSString *const kReplyListDataNickname = @"nickname";
NSString *const kReplyListDataHeadpic = @"head_pic";
@interface ReplyListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ReplyListData

@synthesize did = _did;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize content = _content;
@synthesize uid = _uid;
@synthesize time = _time;
@synthesize headPic = _headPic;
@synthesize nickname = _nickname;


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
            self.did = [self objectOrNilForKey:kReplyListDataDid fromDictionary:dict];
            self.dataIdentifier = [self objectOrNilForKey:kReplyListDataId fromDictionary:dict];
            self.content = [self objectOrNilForKey:kReplyListDataContent fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kReplyListDataUid fromDictionary:dict];
            self.time = [self objectOrNilForKey:kReplyListDataTime fromDictionary:dict];
            self.nickname =[self objectOrNilForKey:kReplyListDataNickname fromDictionary:dict];
            self.headPic =[ self objectOrNilForKey:kReplyListDataHeadpic fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.did forKey:kReplyListDataDid];
    [mutableDict setValue:self.dataIdentifier forKey:kReplyListDataId];
    [mutableDict setValue:self.content forKey:kReplyListDataContent];
    [mutableDict setValue:self.uid forKey:kReplyListDataUid];
    [mutableDict setValue:self.time forKey:kReplyListDataTime];
    [mutableDict setValue:self.nickname forKey:kReplyListDataNickname];
    [mutableDict setValue:self.headPic forKey:kReplyListDataHeadpic];
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

    self.did = [aDecoder decodeObjectForKey:kReplyListDataDid];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kReplyListDataId];
    self.content = [aDecoder decodeObjectForKey:kReplyListDataContent];
    self.uid = [aDecoder decodeObjectForKey:kReplyListDataUid];
    self.time = [aDecoder decodeObjectForKey:kReplyListDataTime];
    self.headPic =[aDecoder decodeObjectForKey:kReplyListDataHeadpic];
    self.nickname =[aDecoder decodeObjectForKey:kReplyListDataNickname];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_did forKey:kReplyListDataDid];
    [aCoder encodeObject:_dataIdentifier forKey:kReplyListDataId];
    [aCoder encodeObject:_content forKey:kReplyListDataContent];
    [aCoder encodeObject:_uid forKey:kReplyListDataUid];
    [aCoder encodeObject:_time forKey:kReplyListDataTime];
    [aCoder encodeObject:_headPic forKey:kReplyListDataHeadpic];
    [aCoder encodeObject:_nickname forKey:kReplyListDataNickname];
}

- (id)copyWithZone:(NSZone *)zone
{
    ReplyListData *copy = [[ReplyListData alloc] init];
    
    if (copy) {

        copy.did = [self.did copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.time = [self.time copyWithZone:zone];
        copy.headPic = [self.headPic copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
    }
    
    return copy;
}


@end
