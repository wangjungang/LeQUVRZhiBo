//
//  fabiaodongtaiViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/24.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "fabiaodongtaiViewController.h"
#import "AFHTTPSessionManager.h"
#import "imageViewController.h"
#import "TZImagePickerController.h"
#define  IMAGE_HEIGHT   (DEVICE_WIDTH-80)/3.0f
@interface fabiaodongtaiViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
{
    UITextView *textView;
    UIButton *imageView;
    NSMutableArray *urlArr;
    UILabel *cityLable;
    UIImageView *_lastImage;
    NSMutableArray *totalImage;
    NSMutableArray *totalImageView;
    NSInteger index;
}
@end
@implementation fabiaodongtaiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)cancle:(UIBarButtonItem *)btn{
   
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tap:(UITapGestureRecognizer *)tap{
    
    if (totalImage.count<3) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //处理点击拍照
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
            
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //处理点击从相册选取
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3-totalImage.count delegate:self];
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto)
             {
                 [totalImage addObjectsFromArray:photos];
                 if (photos.count!=0)
                 {
                     [self upLoadImage:photos[index]];
                 }
             }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController: alertController animated: YES completion: nil];
    }else{
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"最多只能上传3张图片" andSelfVC:self];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [totalImage addObject:myImage];
    [self upLoadImage:myImage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    index=0;
    urlArr = [NSMutableArray array];
    totalImage=[NSMutableArray array];
    totalImageView=[NSMutableArray array];
    self.navigationItem.title = @"发表";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle:)];
    self.navigationItem.leftBarButtonItem = item;
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 100)];
    textView.delegate = self;
    textView.text = @"请填写发表内容";
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor redColor];
    [self.view addSubview:textView];
    
    imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    imageView.frame=CGRectMake(20, 120, IMAGE_HEIGHT, IMAGE_HEIGHT);
    [imageView setBackgroundImage:[UIImage imageNamed:@"额"] forState:0];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 130+IMAGE_HEIGHT, WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView];
    
    UIView *cityView= [[UIView alloc]initWithFrame:CGRectMake(0, 131+IMAGE_HEIGHT, WIDTH, 40)];
    cityView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cityView];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 8, 14, 18)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"发表_10"] forState:UIControlStateNormal];
    [cityView addSubview:leftBtn];
    
    cityLable = [[UILabel alloc]initWithFrame:CGRectMake(33, 5, 130+IMAGE_HEIGHT, 30)];
    cityLable.text = [USERDEFAULT valueForKey:@"cityName"];
    cityLable.textColor = RGBColor(69, 69, 69);
    cityLable.font = [UIFont systemFontOfSize:12];
    cityLable.textAlignment = NSTextAlignmentLeft;
    [cityView addSubview:cityLable];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 171+IMAGE_HEIGHT, WIDTH, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView2];
    UIButton *fabiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 190+IMAGE_HEIGHT, WIDTH-60, 40)];
    [fabiaoBtn setTitle:@"发表" forState:UIControlStateNormal];
    [fabiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    fabiaoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [fabiaoBtn setBackgroundColor:RGBColor(203, 70, 111)];
    fabiaoBtn.layer.cornerRadius = 20;
    [fabiaoBtn addTarget:self action:@selector(fabiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fabiaoBtn];
}
#pragma mark -
#pragma mark 创建ImageView
- (void)createImage:(UIImage*)photh
{
    UIImageView *image;
    if (!_lastImage)
    {
        image=[[UIImageView alloc]init];
        image.frame=CGRectMake(20, 120, IMAGE_HEIGHT, IMAGE_HEIGHT);
    }else{
        image=[[UIImageView alloc]init];
        image.frame=CGRectMake(_lastImage.frame.origin.x+IMAGE_HEIGHT+20, 120, IMAGE_HEIGHT, IMAGE_HEIGHT);
    }
    image.image=photh;
    _lastImage=image;
    [self.view addSubview:image];
    [totalImageView addObject:_lastImage];
    if (totalImage.count>=3)
    {
        imageView.hidden=YES;
    }else
    {
        imageView.hidden=NO;
        imageView.frame=CGRectMake(_lastImage.frame.origin.x+IMAGE_HEIGHT+20, 120, IMAGE_HEIGHT, IMAGE_HEIGHT);
    }
    UITapGestureRecognizer*tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    _lastImage.userInteractionEnabled=YES;
    [_lastImage addGestureRecognizer:tap];
}
- (void)tapImage:(UITapGestureRecognizer*)tap
{
    imageViewController *vc=[imageViewController new];
    UIImageView *image=(UIImageView*)tap.view;
    NSInteger selectIndex=[totalImageView indexOfObject:(UIImageView*)tap.view];
    NSMutableArray*array=[NSMutableArray array];
    [array addObjectsFromArray:totalImage];
    vc.imageArray=array;
    vc.selectedIndex = selectIndex;
    vc.image = image.image;
    
    vc.callBack=^(NSMutableArray*delectIndexAry){
        NSMutableArray *totalImagesAry=[NSMutableArray array];
        [totalImagesAry addObjectsFromArray:totalImage];
        NSLog(@"%ld-----%ld",totalImagesAry.count,totalImage.count);

        [totalImage removeAllObjects];
        [totalImageView removeAllObjects];
        _lastImage=nil;
        [_lastImage removeFromSuperview];
        for (id instance in self.view.subviews)
        {
            if ([instance isKindOfClass:[UIImageView class]])
            {
                [instance removeFromSuperview];
            }
        }
        NSMutableArray *imageAry1=[NSMutableArray array];
        [imageAry1 addObjectsFromArray:urlArr];
        [urlArr removeAllObjects];
        for (UIImage *delecteIndex in delectIndexAry)
        {
            NSInteger SurplusIndex=[totalImagesAry indexOfObject:delecteIndex];
            NSLog(@"%ld-----%ld",totalImagesAry.count,imageAry1.count);
            [urlArr addObject:[imageAry1 objectAtIndex:SurplusIndex]];
            [totalImage addObject:[totalImagesAry objectAtIndex:SurplusIndex]];
            [self createImage:delecteIndex];
            NSLog(@"========第%ld======%@=====%ld",SurplusIndex,urlArr[0],totalImagesAry.count);
        }
        if (delectIndexAry.count==0)
        {
            imageView.hidden=NO;
            imageView.frame=CGRectMake(20, 120, IMAGE_HEIGHT, IMAGE_HEIGHT);
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)fabiaoBtn:(UIButton *)btn{

      if (urlArr.count>0) {
          
          if (urlArr.count == 1) {
              NSDictionary *reqBodyDic = @{@"uid":[USERDEFAULT valueForKey:@"uid"],@"content":textView.text,@"area":cityLable.text,@"pic":urlArr[0]};
              [AFManager postReqURL:FABUDONGTAI2 reqBody:reqBodyDic block:^(id infor) {
                  NSLog(@"%@-",infor);
                  if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                      [NSObject wj_selVcWithTitle:@"发布成功" TitleExplain:nil FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:WJNewPresentFromCenter FirstOrSureBlock:^(NSString *userSelStr) {
                          NSLog(@"1");
                          
                      } SecondSelOrCancelBlock:^(NSString *userSelStr) {
                          NSLog(@"2");
                          [self.navigationController popViewControllerAnimated:YES];
                          
                      }];
                  }

              }];
              
          }else{
              NSMutableString *string =[[NSMutableString alloc]initWithString:urlArr[0]];
              for (int j=1; j<urlArr.count; j++) {
                  [string appendFormat:@"%@", [NSString stringWithFormat:@",%@",urlArr[j]]];
              }
              NSDictionary *reqBodyDic = @{@"uid":[USERDEFAULT valueForKey:@"uid"],@"content":textView.text,@"area":cityLable.text,@"pic":string};
              [AFManager postReqURL:FABUDONGTAI2 reqBody:reqBodyDic block:^(id infor) {
                  NSLog(@"-%@",infor);
                  if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                      [NSObject wj_selVcWithTitle:@"发布成功" TitleExplain:nil FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:WJNewPresentFromCenter FirstOrSureBlock:^(NSString *userSelStr) {
                          NSLog(@"1");
                          
                      } SecondSelOrCancelBlock:^(NSString *userSelStr) {
                          NSLog(@"2");
                          [self.navigationController popViewControllerAnimated:YES];
                          
                      }];
                  }

              }];
          
          }
        }else{
            NSDictionary *dic = @{@"uid":[USERDEFAULT valueForKey:@"uid"],@"content":textView.text,@"area":cityLable.text,@"pic":@""};
            [AFManager postReqURL:FABUDONGTAI2 reqBody:dic block:^(id infor) {
                NSLog(@"%@--",infor);
                if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                    [NSObject wj_selVcWithTitle:@"发布成功" TitleExplain:nil FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:WJNewPresentFromCenter FirstOrSureBlock:^(NSString *userSelStr) {
                        NSLog(@"1");
                        
                    } SecondSelOrCancelBlock:^(NSString *userSelStr) {
                        NSLog(@"2");
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
            }];
        }
}
-(void)textViewDidBeginEditing:(UITextView *)textViews{
    textViews.text = @"";
    
}
-(BOOL)textView:(UITextView *)textViews shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark-
#pragma mark-上传图片
- (void)upLoadImage:(UIImage*)myImage
{
    NSData *data=UIImageJPEGRepresentation(myImage, 0.01);
    NSDictionary *dict = @{@"id":[USERDEFAULT valueForKey:@"uid"]};
    [AFManager upLoadpath2:FABUDONGTAI reqBody:dict file:data fileName:@"file" fileType:@"image/jpg" block:^(id infor)
    {
        NSString *inforStr = [infor[@"dynImgurl"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSString *inforStr2 = [inforStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [urlArr addObject:inforStr2];
        index=[totalImage indexOfObject:myImage];
        index+=1;
        if (index<totalImage.count) {
            [self upLoadImage:totalImage[index]];
            [self createImage:myImage];
        }else
        {
            index=0;
            [self createImage:myImage];
        }
    } errorBlock:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
