//
//  SmallVideoListBase.m
//
//  Created by 婷 张 on 16/12/28
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SmallVideoListBase.h"
#import "SmallVideoListData.h"


NSString *const kSmallVideoListBaseMsg = @"msg";
NSString *const kSmallVideoListBaseData = @"data";
NSString *const kSmallVideoListBaseCode = @"code";


@interface SmallVideoListBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SmallVideoListBase

@synthesize msg = _msg;
@synthesize data = _data;
@synthesize code = _code;


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
            self.msg = [self objectOrNilForKey:kSmallVideoListBaseMsg fromDictionary:dict];
    NSObject *receivedSmallVideoListData = [dict objectForKey:kSmallVideoListBaseData];
    NSMutableArray *parsedSmallVideoListData = [NSMutableArray array];
    if ([receivedSmallVideoListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSmallVideoListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSmallVideoListData addObject:[SmallVideoListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSmallVideoListData isKindOfClass:[NSDictionary class]]) {
       [parsedSmallVideoListData addObject:[SmallVideoListData modelObjectWithDictionary:(NSDictionary *)receivedSmallVideoListData]];
    }

    self.data = [NSArray arrayWithArray:parsedSmallVideoListData];
            self.code = [[self objectOrNilForKey:kSmallVideoListBaseCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.msg forKey:kSmallVideoListBaseMsg];
    NSMutableArray *tempArrayForData = [NSMutableArray array];
    for (NSObject *subArrayObject in self.data) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForData addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForData addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kSmallVideoListBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kSmallVideoListBaseCode];

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

    self.msg = [aDecoder decodeObjectForKey:kSmallVideoListBaseMsg];
    self.data = [aDecoder decodeObjectForKey:kSmallVideoListBaseData];
    self.code = [aDecoder decodeDoubleForKey:kSmallVideoListBaseCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_msg forKey:kSmallVideoListBaseMsg];
    [aCoder encodeObject:_data forKey:kSmallVideoListBaseData];
    [aCoder encodeDouble:_code forKey:kSmallVideoListBaseCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    SmallVideoListBase *copy = [[SmallVideoListBase alloc] init];
    
    if (copy) {

        copy.msg = [self.msg copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
