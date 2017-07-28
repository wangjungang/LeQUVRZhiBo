//
//  myTextView.m
//  GoldLiving
//
//  Created by lhb on 16/9/27.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "myTextView.h"
@interface myTextView()

@property (nonatomic,weak) UILabel *placeholderLabel; //这里先拿出这个label以方便我们后面的使用

@end
@implementation myTextView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentColor = [UIColor blackColor];
        _placeholderColor = [UIColor lightGrayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self.placeholder selector:@selector(startEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self.placeholder selector:@selector(finishEditing:) name:UITextViewTextDidEndEditingNotification object:self];
        
    }
    return self;
}

- (void)_firstBaselineOffsetFromTop {
}
- (void)_baselineOffsetFromBottom {
}
#pragma mark - super

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    _contentColor = textColor;
}

- (NSString *)text {
    if ([super.text isEqualToString:_placeholder] && super.textColor == _placeholderColor) {
        return @"";
    }
    return [super text];
}

- (void)setText:(NSString *)string {
    if (string == nil || string.length == 0) {
        return;
    }
    super.textColor = _contentColor;
    [super setText:string];
}


#pragma mark - setting

- (void)setPlaceholder:(NSString *)string {
    _placeholder = string;
    [self finishEditing:nil];
}


#pragma mark - notification

- (void)startEditing:(NSNotification *)notification {
    super.textColor = _contentColor;
    super.text = @"";
}

- (void)finishEditing:(NSNotification *)notification {
    super.textColor = _placeholderColor;
    super.text = _placeholder;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
