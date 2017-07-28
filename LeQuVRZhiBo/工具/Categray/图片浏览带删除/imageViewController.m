//
//  imageViewController.m
//  类似微信发朋友圈图片
//
//  Created by CuiJianZhou on 16/2/2.
//  Copyright © 2016年 CJZ. All rights reserved.
//

#import "imageViewController.h"


CGFloat const gestureMinimumTranslation = 10.0 ;

typedef enum : NSInteger {
    
    kCameraMoveDirectionNone,
    
    kCameraMoveDirectionUp,
    
    kCameraMoveDirectionDown,
    
    kCameraMoveDirectionRight,
    
    kCameraMoveDirectionLeft
    
} CameraMoveDirection ;

@interface imageViewController ()<UIScrollViewDelegate>{
    NSMutableArray  *delecteIndexAry;
//    CameraMoveDirection direction;
}

//@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIButton *cancleBtn,*sureBtn;
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,assign)BOOL     isDelecte;
@end

@implementation imageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.imageArray.count < self.imageCount) {
        
        [self.imageArray addObject:self.image];
    }
    NSDictionary *dic = @{@"array":self.imageArray};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"byValue" object:nil userInfo:dic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    delecteIndexAry=[NSMutableArray array];
    // Do any additional setup after loading the view.
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, ReturnWidth, ReturnHeight);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickedCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    
    UIButton *delegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delegateBtn.frame = CGRectMake(0, 0, ReturnWidth, ReturnHeight);
    [delegateBtn setBackgroundImage:[UIImage imageNamed:@"laji.png"] forState:UIControlStateNormal];
    [delegateBtn addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:delegateBtn];
    
    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-40-64, DEVICE_WIDTH, 40)];
    _titleLb.textColor=[UIColor whiteColor];
    _titleLb.backgroundColor =[UIColor blackColor];
    _titleLb.textAlignment=1;
    _titleLb.font=[UIFont boldSystemFontOfSize:15];
//    [self.view addSubview:_titleLb];

    [self changeData];
}
- (void)clickedCancelBtn
{
    if (_isDelecte==YES)
    {
        _callBack(delecteIndexAry);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ======= 删除图片的方法

- (void)deleteImage {
    
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"要删除这张照片吗？  " message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction*action =[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        _isDelecte=YES;
        [self.imageArray removeObjectAtIndex:self.selectedIndex];
        [delecteIndexAry removeAllObjects];
        for (UIImage *image in self.imageArray) {
            [delecteIndexAry addObject:image];
        }
        if (self.selectedIndex == self.imageArray.count) {
            self.selectedIndex--;
        }
        [self changeData];
    }];
    UIAlertAction*cancle =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:action];
    [alertVC addAction:cancle];
    [self presentViewController:alertVC animated:YES completion:nil];
   
}
#pragma mark ===== 保存图片 ========

//- (void)saveImage:(id)sender {
//    
//    [self saveImageToPhotos:self.imageArray[self.selectedIndex]];
//}

/**
 *  保存图片
 */
-(void)saveImageToPhotos:(UIImage *)image{
    
    UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
    
}

/**
 * 保存成功或者失败的回调
 */
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD show:YES];

    if (error != NULL){
         HUD.labelText = @"保存图片失败";
    } else{
         HUD.labelText = @"保存图片成功";
    }
    
    [HUD hide:YES afterDelay:2.0];
    
}
- (void)changeData {
    
    if (!self.imageArray.count) {
        if (_isDelecte==YES) {
            _callBack(delecteIndexAry);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //  设置索引文本
    self.titleLb.text = [NSString stringWithFormat:@"%ld/%zd",self.selectedIndex + 1,self.imageArray.count];
    self.title=[NSString stringWithFormat:@"%ld/%zd",self.selectedIndex + 1,self.imageArray.count];
    if (!_scrollView) {
        _scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, DEVICE_WIDTH, DEVICE_HEIGHT-64
                                                                   )];
        _scrollView.delegate=self;
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        [self.view addSubview:_scrollView];
    }
    for (UIImageView*image in _scrollView.subviews) {
        [image removeFromSuperview];
    }
    for (NSInteger i=0; i<self.imageArray.count; i++)
    {
        UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(i*DEVICE_WIDTH, 0, DEVICE_WIDTH, _scrollView.frame.size.height)];
        image.image=self.imageArray[i];
        [_scrollView addSubview:image];
    }
    _scrollView.contentSize=CGSizeMake(_imageArray.count*DEVICE_WIDTH, _scrollView.frame.size.height);
    _scrollView.contentOffset=CGPointMake(self.selectedIndex*DEVICE_WIDTH, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex=(_scrollView.contentOffset.x / _scrollView.frame.size.width);
    self.titleLb.text = [NSString stringWithFormat:@"%ld/%zd",self.selectedIndex + 1,self.imageArray.count];
    self.title=self.titleLb.text;
}
@end
