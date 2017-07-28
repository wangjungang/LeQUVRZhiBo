//
//  XHBottomToolBar.m
//  XHImageViewer
//
//  Created by 李壮 on 14-2-17.
//  Copyright (c) 2014年 李壮，
//

#import "XHBottomToolBar.h"

@interface XHBottomToolBar ()

@end

@implementation XHBottomToolBar

//- (UIButton *)likeButton {
//    if (!_likeButton) {
//        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _likeButton.frame = CGRectMake(10, 0, 80, CGRectGetHeight(self.bounds));
//        [_likeButton setTitle:@"赞100" forState:UIControlStateNormal];
//        [self addSubview:_likeButton];
//    }
//    return _likeButton;
//}

- (UIButton *)unLikeButton {
    if (!_unLikeButton) {
        _unLikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unLikeButton.frame = CGRectMake(DEVICE_WIDTH/2-40, 0, 80, CGRectGetHeight(self.bounds));
        [self addSubview:_unLikeButton];
    }
    return _unLikeButton;
}

//- (UIButton *)shareButton {
//    if (!_shareButton) {
//        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_shareButton setTitle:@"收藏" forState:UIControlStateNormal];
//        _shareButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 90, 0, 80, CGRectGetHeight(self.bounds));
//        [self addSubview:_shareButton];
//    }
//    return _shareButton;
//}

- (UIButton *)delegateButton {
    if (!_delegateButton) {
        _delegateButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_delegateButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_delegateButton setBackgroundImage:[UIImage imageNamed:@"BIN@3x.png"] forState:UIControlStateNormal];
        _delegateButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 60, 10, 15, 20);
        [self addSubview:_delegateButton];
    }
    return _shareButton;
}
#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

@end
