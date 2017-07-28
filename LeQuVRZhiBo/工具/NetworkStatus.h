//
//  NetworkStatus.h
//  YeWenOwner
//
//  Created by HOSO MAC 1 on 16/9/19.
//  Copyright © 2016年 HOSO Mac2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkStatus : NSObject<NSCoding>
@property (nonatomic,strong)NSString *networkStatus;
@property (nonatomic,copy)void(^(NetworkStatusChangeBlock))(BOOL isNetwork);
+ (instancetype)instanceView;
- (void)save;
@end
