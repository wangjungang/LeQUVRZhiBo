//
//  ZanListData.m
//
//  Created by 壮 李 on 2016/12/20
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "ZanListData.h"


NSString *const kZanListDataDid = @"did";
NSString *const kZanListDataId = @"id";
NSString *const kZanListDataStatus = @"status";
NSString *const kZanListDataUid = @"uid";
NSString *const kZanListDataNickname = @"nickname";


@interface ZanListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ZanListData

@synthesize did = _did;
@synthesize dataIdentifier = _dataIdentifier;
@synthesize status = _status;
@synthesize uid = _uid;
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
            self.did = [self objectOrNilForKey:kZanListDataDid fromDictionary:dict];
            self.dataIdentifier = [self objectOrNilForKey:kZanListDataId fromDictionary:dict];
            self.status = [self objectOrNilForKey:kZanListDataStatus fromDictionary:dict];
            self.uid = [self objectOrNilForKey:kZanListDataUid fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kZanListDataNickname fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.did forKey:kZanListDataDid];
    [mutableDict setValue:self.dataIdentifier forKey:kZanListDataId];
    [mutableDict setValue:self.status forKey:kZanListDataStatus];
    [mutableDict setValue:self.uid forKey:kZanListDataUid];
    [mutableDict setValue:self.nickname forKey:kZanListDataNickname];

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

    self.did = [aDecoder decodeObjectForKey:kZanListDataDid];
    self.dataIdentifier = [aDecoder decodeObjectForKey:kZanListDataId];
    self.status = [aDecoder decodeObjectForKey:kZanListDataStatus];
    self.uid = [aDecoder decodeObjectForKey:kZanListDataUid];
    self.nickname = [aDecoder decodeObjectForKey:kZanListDataNickname];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_did forKey:kZanListDataDid];
    [aCoder encodeObject:_dataIdentifier forKey:kZanListDataId];
    [aCoder encodeObject:_status forKey:kZanListDataStatus];
    [aCoder encodeObject:_uid forKey:kZanListDataUid];
    [aCoder encodeObject:_nickname forKey:kZanListDataNickname];
}

- (id)copyWithZone:(NSZone *)zone
{
    ZanListData *copy = [[ZanListData alloc] init];
    
    if (copy) {

        copy.did = [self.did copyWithZone:zone];
        copy.dataIdentifier = [self.dataIdentifier copyWithZone:zone];
        copy.status = [self.status copyWithZone:zone];
        copy.uid = [self.uid copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
    }
    
    return copy;
}


@end
