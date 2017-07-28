//
//  Data.m
//
//  Created by 壮 李 on 2016/12/14
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "GiftListData.h"


NSString *const kDataTime = @"time";
NSString *const kDataPrice = @"price";
NSString *const kDataGid = @"gid";
NSString *const kDataType = @"type";
NSString *const kDataGname = @"gname";
NSString *const kDataPic = @"pic";

@interface GiftListData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation GiftListData

@synthesize time = _time;
@synthesize price = _price;
@synthesize gid = _gid;
@synthesize type = _type;
@synthesize gname = _gname;
@synthesize pic = _pic;


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
            self.time = [self objectOrNilForKey:kDataTime fromDictionary:dict];
            self.price = [self objectOrNilForKey:kDataPrice fromDictionary:dict];
            self.gid = [self objectOrNilForKey:kDataGid fromDictionary:dict];
            self.type = [self objectOrNilForKey:kDataType fromDictionary:dict];
            self.gname = [self objectOrNilForKey:kDataGname fromDictionary:dict];
            self.pic = [self objectOrNilForKey:kDataPic fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.time forKey:kDataTime];
    [mutableDict setValue:self.price forKey:kDataPrice];
    [mutableDict setValue:self.gid forKey:kDataGid];
    [mutableDict setValue:self.type forKey:kDataType];
    [mutableDict setValue:self.gname forKey:kDataGname];
    [mutableDict setValue:self.pic forKey:kDataPic];

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

    self.time = [aDecoder decodeObjectForKey:kDataTime];
    self.price = [aDecoder decodeObjectForKey:kDataPrice];
    self.gid = [aDecoder decodeObjectForKey:kDataGid];
    self.type = [aDecoder decodeObjectForKey:kDataType];
    self.gname = [aDecoder decodeObjectForKey:kDataGname];
    self.pic = [aDecoder decodeObjectForKey:kDataPic];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_time forKey:kDataTime];
    [aCoder encodeObject:_price forKey:kDataPrice];
    [aCoder encodeObject:_gid forKey:kDataGid];
    [aCoder encodeObject:_type forKey:kDataType];
    [aCoder encodeObject:_gname forKey:kDataGname];
    [aCoder encodeObject:_pic forKey:kDataPic];
}

- (id)copyWithZone:(NSZone *)zone
{
    GiftListData *copy = [[GiftListData alloc] init];
    
    if (copy) {

        copy.time = [self.time copyWithZone:zone];
        copy.price = [self.price copyWithZone:zone];
        copy.gid = [self.gid copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.gname = [self.gname copyWithZone:zone];
        copy.pic = [self.pic copyWithZone:zone];
    }
    
    return copy;
}


@end
