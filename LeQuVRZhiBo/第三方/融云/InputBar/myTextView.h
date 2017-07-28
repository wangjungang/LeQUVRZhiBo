//
//  myTextView.h
//  GoldLiving
//
//  Created by lhb on 16/9/27.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myTextView : UITextView{
    UIColor *_contentColor;
    BOOL _editing;
}
@property(strong, nonatomic) NSString *placeholder;
@property(strong, nonatomic) UIColor *placeholderColor;
@end
