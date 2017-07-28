//
//  CommunityListBase.m
//
//  Created by 婷 张 on 16/12/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "CommunityListBase.h"
#import "CommunityListData.h"


NSString *const kCommunityListBasePages = @"pages";
NSString *const kCommunityListBaseData = @"data";
NSString *const kCommunityListBaseCode = @"code";


@interface CommunityListBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CommunityListBase

@synthesize pages = _pages;
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
            self.pages = [[self objectOrNilForKey:kCommunityListBasePages fromDictionary:dict] doubleValue];
    NSObject *receivedCommunityListData = [dict objectForKey:kCommunityListBaseData];
    NSMutableArray *parsedCommunityListData = [NSMutableArray array];
    if ([receivedCommunityListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedCommunityListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedCommunityListData addObject:[CommunityListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedCommunityListData isKindOfClass:[NSDictionary class]]) {
       [parsedCommunityListData addObject:[CommunityListData modelObjectWithDictionary:(NSDictionary *)receivedCommunityListData]];
    }

    self.data = [NSArray arrayWithArray:parsedCommunityListData];
            self.code = [[self objectOrNilForKey:kCommunityListBaseCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pages] forKey:kCommunityListBasePages];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kCommunityListBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kCommunityListBaseCode];

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

    self.pages = [aDecoder decodeDoubleForKey:kCommunityListBasePages];
    self.data = [aDecoder decodeObjectForKey:kCommunityListBaseData];
    self.code = [aDecoder decodeDoubleForKey:kCommunityListBaseCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_pages forKey:kCommunityListBasePages];
    [aCoder encodeObject:_data forKey:kCommunityListBaseData];
    [aCoder encodeDouble:_code forKey:kCommunityListBaseCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    CommunityListBase *copy = [[CommunityListBase alloc] init];
    
    if (copy) {

        copy.pages = self.pages;
        copy.data = [self.data copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
