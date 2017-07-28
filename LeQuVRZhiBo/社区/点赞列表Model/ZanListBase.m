//
//  ZanListBase.m
//
//  Created by 壮 李 on 2016/12/20
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "ZanListBase.h"
#import "ZanListData.h"


NSString *const kZanListBaseData = @"data";
NSString *const kZanListBaseCode = @"code";


@interface ZanListBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ZanListBase

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
    NSObject *receivedZanListData = [dict objectForKey:kZanListBaseData];
    NSMutableArray *parsedZanListData = [NSMutableArray array];
    if ([receivedZanListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedZanListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedZanListData addObject:[ZanListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedZanListData isKindOfClass:[NSDictionary class]]) {
       [parsedZanListData addObject:[ZanListData modelObjectWithDictionary:(NSDictionary *)receivedZanListData]];
    }

    self.data = [NSArray arrayWithArray:parsedZanListData];
            self.code = [[self objectOrNilForKey:kZanListBaseCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kZanListBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kZanListBaseCode];

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

    self.data = [aDecoder decodeObjectForKey:kZanListBaseData];
    self.code = [aDecoder decodeDoubleForKey:kZanListBaseCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_data forKey:kZanListBaseData];
    [aCoder encodeDouble:_code forKey:kZanListBaseCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    ZanListBase *copy = [[ZanListBase alloc] init];
    
    if (copy) {

        copy.data = [self.data copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
