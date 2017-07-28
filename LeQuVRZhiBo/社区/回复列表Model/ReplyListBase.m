//
//  ReplyListBase.m
//
//  Created by 壮 李 on 2016/12/19
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "ReplyListBase.h"
#import "ReplyListData.h"


NSString *const kReplyListBasePages = @"pages";
NSString *const kReplyListBaseData = @"data";
NSString *const kReplyListBaseCode = @"code";


@interface ReplyListBase ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ReplyListBase

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
            self.pages = [[self objectOrNilForKey:kReplyListBasePages fromDictionary:dict] doubleValue];
    NSObject *receivedReplyListData = [dict objectForKey:kReplyListBaseData];
    NSMutableArray *parsedReplyListData = [NSMutableArray array];
    if ([receivedReplyListData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedReplyListData) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedReplyListData addObject:[ReplyListData modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedReplyListData isKindOfClass:[NSDictionary class]]) {
       [parsedReplyListData addObject:[ReplyListData modelObjectWithDictionary:(NSDictionary *)receivedReplyListData]];
    }

    self.data = [NSArray arrayWithArray:parsedReplyListData];
            self.code = [[self objectOrNilForKey:kReplyListBaseCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pages] forKey:kReplyListBasePages];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForData] forKey:kReplyListBaseData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kReplyListBaseCode];

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

    self.pages = [aDecoder decodeDoubleForKey:kReplyListBasePages];
    self.data = [aDecoder decodeObjectForKey:kReplyListBaseData];
    self.code = [aDecoder decodeDoubleForKey:kReplyListBaseCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_pages forKey:kReplyListBasePages];
    [aCoder encodeObject:_data forKey:kReplyListBaseData];
    [aCoder encodeDouble:_code forKey:kReplyListBaseCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    ReplyListBase *copy = [[ReplyListBase alloc] init];
    
    if (copy) {

        copy.pages = self.pages;
        copy.data = [self.data copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
