//
//  wanshanViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/17.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "wanshanViewController.h"
#import "cityViewController.h"
#import "AFHTTPSessionManager.h"
@interface wanshanViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIImageView *imageView;
    UITextField *field;
    NSString *sex;
    UILabel *cityLable;
    NSMutableArray *array;
}
@property(nonatomic,copy)NSString *uploadImageUrl;

@end

@implementation wanshanViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    
}
-(void)city:(id)user{
    cityLable.text = [user userInfo][@"city"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"填写信息";
    [self CustomBackButton];
    sex = @"1";
    array = [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(city:) name:@"city" object:nil];

    NSDictionary *dict2 = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict2;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11"]forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width - 30, 30)];
    leftLable.text = @"头像";
    leftLable.textColor = RGBColor(69, 69, 69);
    leftLable.font = [UIFont systemFontOfSize:14];
    leftLable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:leftLable];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-80/2, 30, 80, 80)];
    imageView.image = [UIImage imageNamed:@"填写信息_03"];
    imageView.layer.cornerRadius = 40;
    imageView.layer.masksToBounds = YES;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(image)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, 2)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView];
    
    UILabel *leftLable2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 130, self.view.frame.size.width - 30, 30)];
    leftLable2.text = @"昵称";
    leftLable2.textColor = RGBColor(69, 69, 69);
    leftLable2.font = [UIFont systemFontOfSize:14];
    leftLable2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:leftLable2];
    
    field = [[UITextField alloc]initWithFrame:CGRectMake(10, 160, WIDTH-100, 40) ];
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.font = [UIFont systemFontOfSize:12];
    field.placeholder = @"输入您想要的昵称";
    
    field.delegate = self;
    [self.view addSubview:field];
    
    UIButton *dengluBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-80, 165, 70, 30)];
    [dengluBtn setTitle:@"完成" forState:UIControlStateNormal];
    [dengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dengluBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [dengluBtn setBackgroundColor:RGBColor(203, 70, 111)];
    dengluBtn.layer.cornerRadius = 5;
    [dengluBtn addTarget:self action:@selector(dengluBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dengluBtn];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0 , 210, self.view.frame.size.width, 2)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView2];
    
    UILabel *leftLable3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 210, self.view.frame.size.width - 30, 30)];
    leftLable3.text = @"性别";
    leftLable3.textColor = RGBColor(69, 69, 69);
    leftLable3.font = [UIFont systemFontOfSize:14];
    leftLable3.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:leftLable3];
    
    UILabel *nanLable = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-20-60-70, 265, 60, 30)];
    nanLable.text = @"男";
    nanLable.textColor = RGBColor(69, 69, 69);
    nanLable.font = [UIFont systemFontOfSize:14];
    nanLable.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:nanLable];
    
    UIButton *nanBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2-20-60, 250, 60, 60)];
    nanBtn.selected = YES;
    nanBtn.tag = 100;
    [nanBtn setBackgroundImage:[UIImage imageNamed:@"填写信息_07"] forState:UIControlStateNormal];
    [nanBtn setBackgroundImage:[UIImage imageNamed:@"e-"] forState:UIControlStateSelected];
    [nanBtn addTarget:self action:@selector(nan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nanBtn];
    
    UILabel *nvLable = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+20+60+10, 265, 60, 30)];
    nvLable.text = @"女";
    nvLable.textColor = RGBColor(69, 69, 69);
    nvLable.font = [UIFont systemFontOfSize:14];
    nvLable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:nvLable];
    
    UIButton *nvBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH/2+20, 250, 60, 60)];
    nvBtn.selected = NO;
    nvBtn.tag = 200;
    [nvBtn setBackgroundImage:[UIImage imageNamed:@"ee"] forState:UIControlStateNormal];
    [nvBtn setBackgroundImage:[UIImage imageNamed:@"填写信息_09"] forState:UIControlStateSelected];
    [nvBtn addTarget:self action:@selector(nv:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nvBtn];
    
    UILabel *centerLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 320, WIDTH, 30)];
    centerLable.text = @"性别一旦确定不能更改哦";
    centerLable.textColor = RGBColor(69, 69, 69);
    centerLable.font = [UIFont systemFontOfSize:12];
    centerLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:centerLable];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0 , 350, self.view.frame.size.width, 2)];
    lineView3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView3];
    
    UILabel *leftLable4 = [[UILabel alloc]initWithFrame:CGRectMake(15, 360, self.view.frame.size.width - 30, 30)];
    leftLable4.text = @"位置";
    leftLable4.textColor = RGBColor(69, 69, 69);
    leftLable4.font = [UIFont systemFontOfSize:14];
    leftLable4.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:leftLable4];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0 , 390, self.view.frame.size.width, 40)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2)];
    [bottomView addGestureRecognizer:tap2];
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width, 1)];
    lineView4.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [bottomView addSubview:lineView4];
    
    UILabel *leftLable5 = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 30, 30)];
    leftLable5.text = @"地区";
    leftLable5.textColor = RGBColor(69, 69, 69);
    leftLable5.font = [UIFont systemFontOfSize:12];
    leftLable5.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:leftLable5];
    
    cityLable = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-100, 5, 80, 30)];
    cityLable.text = @"北京";
    cityLable.tag = 500;
    cityLable.textColor = RGBColor(69, 69, 69);
    cityLable.font = [UIFont systemFontOfSize:12];
    cityLable.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:cityLable];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0 , 39, self.view.frame.size.width, 1)];
    lineView5.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [bottomView addSubview:lineView5];
    
    UIView *lineView6 = [[UIView alloc]initWithFrame:CGRectMake(0 , 450, self.view.frame.size.width, 2)];
    lineView6.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:lineView6];
}
-(void)tap2{
    cityViewController *city = [[cityViewController alloc]init];
    city.city = @"1";
    [self.navigationController pushViewController:city animated:YES];
}
-(void)nan:(UIButton *)btn{
    UIButton *nan = (id)[self.view viewWithTag:100];
    UIButton *nv = (id)[self.view viewWithTag:200];

    nan.selected = YES;
    sex = @"1";
    nv.selected = NO;

    
}
-(void)nv:(UIButton *)btn{
    UIButton *nan = (id)[self.view viewWithTag:100];
    UIButton *nv = (id)[self.view viewWithTag:200];
    sex = @"0";
    nv.selected = YES;
    nan.selected = NO;
  
}
-(void)dengluBtn:(UIButton *)btn{
    
    [AFManager postReqURL:ZHUCE reqBody:@{@"phone":self.phone,@"password":self.password,@"repass":self.repassword} block:^(id infor) {
        NSLog(@"---%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            NSDictionary *dic = @{@"id":infor[@"id"],@"nickname":field.text,@"sex":sex,@"area":cityLable.text};
            
            AFHTTPSessionManager* sessinManager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:UPPICTURE]];
            sessinManager.responseSerializer=[AFJSONResponseSerializer serializer];
            sessinManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
            //增加这几行代码；
            AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
            [securityPolicy setAllowInvalidCertificates:YES];
            
            //这里进行设置；
            [sessinManager setSecurityPolicy:securityPolicy];
            sessinManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [sessinManager POST:UPPICTURE parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
             {
                 /*
                  在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                  要解决此问题，
                  可以在上传时使用当前的系统时间作为文件名
                  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                  设置时间格式
                  formatter.dateFormat = @"yyyyMMddHHmmss";
                  NSString *str = [formatter stringFromDate:[NSDate date]];
                  */
                 
                 [formData appendPartWithFileData:array[0] name:@"file" fileName:@"file.png" mimeType:@"image/jpg"];
                 /******** 2.通过路径上传沙盒或系统相册里的图片 *****/
                 //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:@"file" fileName:@"1234.png" mimeType:@"application/octet-stream" error:nil];
                 
                 
             } progress:^(NSProgress * _Nonnull uploadProgress)
             {
                 
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                 NSLog(@"---%@",dic);

                 if ([[NSString stringWithFormat:@"%@",dic[@"code"]] isEqualToString:@"200"]) {
                     [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",TOKEN,dic[@"id"]] block:^(id inforss) {
                         if ([[NSString stringWithFormat:@"%@",inforss[@"code"]] isEqualToString:@"200"]) {
                             [USERDEFAULT setValue:inforss[@"token"] forKey:@"token"];
                             [USERDEFAULT synchronize];
                             
                         }
                     } errorblock:^(NSError *error) {
                         
                     }];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [USERDEFAULT setValue:dic[@"id"] forKey:@"uid"];
                         [USERDEFAULT setValue:dic[@"nickname"] forKey:@"nickname"];
                         [USERDEFAULT setValue:dic[@"imgUrl"] forKey:@"imgUrl"];
                         [USERDEFAULT setValue:dic[@"account"] forKey:@"account"];
                         [USERDEFAULT synchronize];
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
                         
                     });

                 }
                 

                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {

             }];

            
        }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"201"]){
            [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"用户已被注册" andSelfVC:self];
        }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"202"]){
            [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"密码输入不一致" andSelfVC:self];
        }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"203"]){
            [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"注册失败" andSelfVC:self];
        }
        
    }];





}
-(void)image{
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
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alertController animated: YES completion: nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageView.image = myImage;
     NSData *data=UIImageJPEGRepresentation(myImage, 0.01);
    [array addObject:data];
    //    NSData * imageData = UIImageJPEGRepresentation(myImage, 0.01);
   
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
