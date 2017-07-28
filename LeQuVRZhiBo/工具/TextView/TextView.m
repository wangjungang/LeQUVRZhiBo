//
//  TextView.m
//  Zhai
//
//  Created by 周文静 on 16/8/8.
//  Copyright © 2016年 lechuangshidai. All rights reserved.
//

#import "TextView.h"

@interface TextView()

@property(strong,nonatomic) UILabel *placeLabel;

@end

@implementation TextView

-(instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        
        //总是能滚动
        //        self.alwaysBounceVertical = YES;
        
        UILabel *placeLabel = [[UILabel alloc]init];
        placeLabel.numberOfLines = 0;
        placeLabel.textColor = [UIColor grayColor];
        self.placeLabel = placeLabel;
        [self addSubview:placeLabel];
        
        self.font = [UIFont systemFontOfSize:14];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
    }
    
    return self;
}

-(void)textChange
{
    self.placeLabel.hidden = self.text.length!=0;
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeLabel.font = self.font;
    
    // 根据最新的文字的大小font,重新计算placelabel的size
    [self setNeedsLayout];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeLabel.text = placeholder;
    
    // 根据最新的文字多少重新计算placelabel的size
    [self setNeedsLayout];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderColor = placeholderColor;
    
    self.placeLabel.textColor = placeholderColor;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeLabel.x = 10;
    self.placeLabel.y = 3;
    self.placeLabel.width = self.width - self.placeLabel.x * 2;
    
    CGSize maxSize = CGSizeMake( self.placeLabel.width, MAXFLOAT);
    
    //    CGSize size = [self.placeLabel.text sizeWithFont:self.placeLabel.font constrainedToSize:maxSize];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    
    CGSize size = [self.placeLabel.text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    self.placeLabel.height = size.height;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
