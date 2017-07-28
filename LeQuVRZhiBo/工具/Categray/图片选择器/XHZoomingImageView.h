//
//  XHZoomingImageView.h
//  XHImageViewer
//
//  Created by 李壮 on 14-2-17.
//  Copyright (c) 2014年 李壮，
//

#import <UIKit/UIKit.h>

@interface XHZoomingImageView : UIView

//@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) BOOL isViewing;
@end
