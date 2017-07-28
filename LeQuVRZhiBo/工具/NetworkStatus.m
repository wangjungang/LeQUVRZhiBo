//
//  NetworkStatus.m
//  YeWenOwner
//
//  Created by HOSO MAC 1 on 16/9/19.
//  Copyright © 2016年 HOSO Mac2. All rights reserved.
//

#import "NetworkStatus.h"

@implementation NetworkStatus
static NetworkStatus*network;
+ (instancetype)instanceView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network=[[NetworkStatus alloc]init];
    });
    return network;
}
#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.networkStatus = [aDecoder decodeObjectForKey:@"networkStatus"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_networkStatus forKey:@"networkStatus"];
}
-(void)save
{
//    [NSKeyedArchiver archiveRootObject:self toFile:NETWORK_PATH];
}
@end
