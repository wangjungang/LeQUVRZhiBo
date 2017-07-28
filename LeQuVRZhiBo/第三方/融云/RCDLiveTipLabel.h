//
//  RCMessageTipLabel.h
//  iOS-IMKit
//
//  Created by Gang Li on 10/27/14.
//  Copyright (c) 2014 RongCloud. All rights reserved.
//

#ifndef __RCDLiveTipLabel
#define __RCDLiveTipLabel
#import <UIKit/UIKit.h>
#import "RCDLiveAttributedLabel.h"

/*!
 灰条提示Label
 */
@interface RCDLiveTipLabel : UILabel

/*!
 边缘间隙
 */
@property(nonatomic, assign) UIEdgeInsets marginInsets;

/*!
 初始化灰条提示Label对象
 
 @return 灰条提示Label对象
 */
+ (instancetype)greyTipLabel;

@end
#endif