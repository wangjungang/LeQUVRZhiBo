//
//  myPicturesViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/14.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "myPicturesViewController.h"
#import "myPictureCollectionViewCell.h"
#import "TZImagePickerController.h"

#import "XHImageViewer.h"
#import "XHBottomToolBar.h"
#import "MyPhotosCell.h"
#import "HUPhotoBrowser.h"
@interface myPicturesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,XHImageViewerDelegate>
{
    UICollectionView *collectionView;
    NSMutableArray *dataArr;
    NSInteger       indexs;
    NSArray        *imageAry;
    BOOL            isLastPhoto;
    MBProgressHUD  *MB;
    NSMutableArray *imageViewAry;
}
@property (nonatomic, strong) XHImageViewer *imageViewer;
@property (nonatomic, strong) XHBottomToolBar *bottomToolBar;
@end

@implementation myPicturesViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    indexs=0;
    imageAry =[NSArray array];
    dataArr = [NSMutableArray array];
    imageViewAry=[NSMutableArray array];
    self.navigationItem.title = @"我的相册";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize=CGSizeMake((DEVICE_WIDTH-40)/3, (DEVICE_WIDTH-40)/3);
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[MyPhotosCell class] forCellWithReuseIdentifier:@"MyPhotosCell"];
    [self getPhotosList];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionViews layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
    return UIEdgeInsetsMake(10, 10, 0, 10);
}
-(void)collectionView:(UICollectionView *)collectionViews didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collection cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MyPhotosCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MyPhotosCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageView.image=[UIImage imageNamed:@"添加"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addpic)];
        [cell.imageView addGestureRecognizer:tap];
    }else
    {
        [cell.imageView setImageWithURL:[NSURL URLWithString:dataArr[indexPath.row]]];
        cell.imageView.tag=indexPath.row+1000;
        UITapGestureRecognizer*tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabImage:)];
        [cell.imageView addGestureRecognizer:tap1];
    }
    return cell;
}
- (void)tabImage:(UITapGestureRecognizer*)tap
{
    UIImageView*imageView=(UIImageView*)tap.view;
    [HUPhotoBrowser showFromImageView:imageView withURLStrings:dataArr atIndex:imageView.tag-1000];
}
-(NSInteger)collectionView:(UICollectionView *)collectionViews numberOfItemsInSection:(NSInteger)section{
    return dataArr.count;
}
-(void)addpic{

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
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto)
         {
             imageAry=[NSArray array];
             imageAry=photos;
             if (photos.count!=0)
             {
                 [self upLoadImage:photos[indexs]];
             }
         }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];

    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self upLoadImage:myImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark-
#pragma mark-上传图片
- (void)upLoadImage:(UIImage*)myImage
{
    NSData *data=UIImageJPEGRepresentation(myImage, 0.01);
    NSDictionary *dict = @{@"id":[USERDEFAULT valueForKey:@"uid"]};
    [AFManager upLoadpath2:UPIOS reqBody:dict file:data fileName:@"file" fileType:@"image/jpg" block:^(id infor)
     {
         if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"])
         {
             indexs+=1;
             if (indexs<imageAry.count)
             {
                 [self upLoadImage:imageAry[indexs]];
             }else
             {
                 indexs=0;
                 imageAry=[NSArray array];
                 [dataArr removeAllObjects];
                 [collectionView reloadData];
                 [self getPhotosList];
             }
         }
     } errorBlock:^(NSError *error)
    {
         
     }];
}
//获取列表接口
- (void)getPhotosList
{
    [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",XIANGCE,[USERDEFAULT valueForKey:@"uid"]] block:^(id inforss)
     {
         if ([[NSString stringWithFormat:@"%@",inforss[@"code"]] isEqualToString:@"200"])
         {
             [imageViewAry removeAllObjects];
             [dataArr removeAllObjects];
             [dataArr addObject:@""];
             [dataArr addObjectsFromArray:inforss[@"data"]];
             [collectionView reloadData];
         }else
         {
             [imageViewAry removeAllObjects];
             [dataArr removeAllObjects];
             [dataArr addObject:@""];
             [collectionView reloadData];
         }
     } errorblock:^(NSError *error)
     {
         
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
