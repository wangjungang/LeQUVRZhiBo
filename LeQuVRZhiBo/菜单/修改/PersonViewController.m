//
//  PersonViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/11.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "PersonViewController.h"
#import "personHeadTableViewCell.h"
#import "userNameViewController.h"
#import "qianmingViewController.h"
#import "jobViewController.h"
#import "AFHTTPSessionManager.h"
#import "cityViewController.h"
#import "renzhengViewController.h"
@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *table;
    NSMutableArray *dataSource;
    NSMutableDictionary *dic;
    UIView *bottomView;
    UIView *bottomView3;
    
    UIView *bottomView4;
    NSMutableArray *dataArr;
}


@end

@implementation PersonViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)item{
    if (dataArr.count == 0) {
        NSDictionary *dict = @{@"id":[USERDEFAULT valueForKey:@"uid"],@"nickname":[dic valueForKey:@"userName"],@"sex":[dic valueForKey:@"sex2"],@"auto":[dic valueForKey:@"qianming"],@"birthday":[dic valueForKey:@"age"],@"emotion":[dic valueForKey:@"qinggan2"],@"area":[dic valueForKey:@"city"],@"occup":[dic valueForKey:@"job"]};
        
        [AFManager postReqURL:@"http://139.224.43.42/funlive/index.php/Admin/Apilive/uUpdateIos" reqBody:dict block:^(id infor) {
            NSLog(@"====%@",infor);
            if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                [USERDEFAULT setValue:[dic valueForKey:@"userName"] forKey:@"nickname"];
                [USERDEFAULT synchronize];
                [NSObject wj_selVcWithTitle:@"修改成功" TitleExplain:nil FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:WJNewPresentFromCenter FirstOrSureBlock:^(NSString *userSelStr) {
                    NSLog(@"1");
                   
                    
                } SecondSelOrCancelBlock:^(NSString *userSelStr) {
                    NSLog(@"2");
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
            }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"201"]){
                [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"未修改任何信息" andSelfVC:self];
                
                
            }

        }];
        
    }else{
        NSDictionary *dict = @{@"id":[USERDEFAULT valueForKey:@"uid"],@"nickname":[dic valueForKey:@"userName"],@"sex":[dic valueForKey:@"sex2"],@"auto":[dic valueForKey:@"qianming"],@"birthday":[dic valueForKey:@"age"],@"emotion":[dic valueForKey:@"qinggan2"],@"area":[dic valueForKey:@"city"],@"occup":[dic valueForKey:@"job"]};
        [AFManager upLoadpath2:UPPICTURE reqBody:dict file:dataArr[0] fileName:@"file" fileType:@"image/jpg" block:^(id infor) {
            NSLog(@"====%@",infor);
            if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                
                [USERDEFAULT setValue:[dic valueForKey:@"userName"] forKey:@"nickname"];
                [USERDEFAULT setValue:infor[@"head_pic"] forKey:@"imgUrl"];
                [USERDEFAULT synchronize];
                
                [NSObject wj_selVcWithTitle:@"修改成功" TitleExplain:nil FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:WJNewPresentFromCenter FirstOrSureBlock:^(NSString *userSelStr) {
                    NSLog(@"1");
                    
                    
                } SecondSelOrCancelBlock:^(NSString *userSelStr) {
                    NSLog(@"2");
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
            }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"201"]){
                [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"未修改任何信息" andSelfVC:self];
                
                
            }
            
            //        "http:\/\/139.224.43.42\/zhai\/Uploads\/18b9c171ee7bd29789670f66721b5984.png"
            
        } errorBlock:^(NSError *error) {
            
        }];
        

    }
    
}
-(void)nameField:(id)user{
    [dic setValue:[user userInfo][@"nameField"] forKey:@"userName"];
    [table reloadData];

}
-(void)textView:(id)user{
    [dic setValue:[user userInfo][@"textView"] forKey:@"qianming"];
    [table reloadData];
}
-(void)jobField:(id)user{
    [dic setValue:[user userInfo][@"jobField"] forKey:@"job"];
    [table reloadData];
}
-(void)city2:(id)user{
    [dic setValue:[user userInfo][@"city2"] forKey:@"city"];
    [table reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nameField:) name:@"nameField" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textView:) name:@"textView" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jobField:) name:@"jobField" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(city2:) name:@"city2" object:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(item)];
    self.navigationItem.rightBarButtonItem = item;
    dic = [[NSMutableDictionary alloc]init];
    dataArr = [[NSMutableArray alloc]init];
    AFHTTPSessionManager*manager =[AFHTTPSessionManager manager];
//    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",nil];
    
    [manager GET:[NSString stringWithFormat:GERENZHUYE,[USERDEFAULT valueForKey:@"uid"]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable infor) {
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            if ([infor[@"data"][@"nickname"] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:@"userName"];
                
            }else{
                [dic setValue:infor[@"data"][@"nickname"] forKey:@"userName"];
                
            }
            [dic setValue:infor[@"data"][@"account"] forKey:@"account"];
            if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"sex"]] isEqualToString:@"1"]) {
                [dic setValue:@"男" forKey:@"sex"];
                [dic setValue:@"1" forKey:@"sex2"];

                
            }else{
                [dic setValue:@"女" forKey:@"sex"];
                [dic setValue:@"0" forKey:@"sex2"];

                
            }
            if ([infor[@"data"][@"auto"] isEqual:[NSNull null]]) {
                [dic setValue:@"太懒了，还没有签名" forKey:@"qianming"];
                
            }else{
                [dic setValue:infor[@"data"][@"auto"] forKey:@"qianming"];
                
            }
            if ([infor[@"data"][@"birthday"] isEqual:[NSNull null]]) {
                [dic setValue:@"0" forKey:@"age"];
                
            }else{
                [dic setValue:infor[@"data"][@"birthday"] forKey:@"age"];
                
            }
            if ([infor[@"data"][@"emotion"] isEqual:[NSNull null]]) {
                [dic setValue:@"保密" forKey:@"qinggan"];
                [dic setValue:@"0" forKey:@"qinggan2"];

                
            }else{
                if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"0"]) {
                    [dic setValue:@"保密" forKey:@"qinggan"];
                    [dic setValue:@"0" forKey:@"qinggan2"];
                }else if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"1"]){
                    [dic setValue:@"单身" forKey:@"qinggan"];
                    [dic setValue:@"1" forKey:@"qinggan2"];
                }else if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"2"]){
                    [dic setValue:@"恋爱" forKey:@"qinggan"];
                    [dic setValue:@"2" forKey:@"qinggan2"];
                }else if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"3"]){
                    [dic setValue:@"已婚" forKey:@"qinggan"];
                    [dic setValue:@"3" forKey:@"qinggan2"];
                }else if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"4"]){
                    [dic setValue:@"同性" forKey:@"qinggan"];
                    [dic setValue:@"4" forKey:@"qinggan2"];
                }
                

            }
            if ([infor[@"data"][@"area"] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:@"city"];
                
            }else{
                [dic setValue:infor[@"data"][@"area"] forKey:@"city"];
                
            }
            if ([infor[@"data"][@"occup"] isEqual:[NSNull null]]) {
                [dic setValue:@"暂未添加" forKey:@"job"];
                
            }else{
                [dic setValue:infor[@"data"][@"occup"] forKey:@"job"];
                
            }
            if ([infor[@"data"][@"head_pic"] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:@"head_pic"];
                
            }else{
                [dic setValue:infor[@"data"][@"head_pic"] forKey:@"head_pic"];
                
            }
            NSLog(@"--%@",dic);
            [table reloadData];
        }

        //        NSLog(@"-%@-",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"=====/n%@",error);
        
    }];

    
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
//    table.bounces = NO;
    table.showsVerticalScrollIndicator = NO;
    //    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    [table registerNib:[UINib nibWithNibName:@"personHeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];

    dataSource = [[NSMutableArray alloc]initWithArray:@[@"头像",@"昵称",@"账号",@"性别",@"个性签名",@"年龄",@"情感状况",@"家乡",@"职业",@"实名认证"]];
//    table.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *str = @"str";
        personHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[personHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.lable.text = dataSource[indexPath.row];
        cell.lable.textColor = RGBColor(146, 146, 146);
        cell.avatar.tag = 200;
        cell.avatar.layer.cornerRadius = 25;
        cell.avatar.layer.masksToBounds = YES;
        [cell.avatar setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"head_pic"]] placeholderImage:[UIImage imageNamed:@"直播_09"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *str = @"str2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.textLabel.textColor = RGBColor(146, 146, 146);
        cell.textLabel.text = dataSource[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = RGBColor(146, 146, 146);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = [dic valueForKey:@"userName"];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2) {
            cell.detailTextLabel.text = [dic valueForKey:@"account"];
        }else if (indexPath.row == 3) {
            cell.detailTextLabel.text = [dic valueForKey:@"sex"];
        }else if (indexPath.row == 4) {
            cell.detailTextLabel.text = [dic valueForKey:@"qianming"];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 5) {
            cell.detailTextLabel.text = [dic valueForKey:@"age"];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 6) {
            cell.detailTextLabel.text = [dic valueForKey:@"qinggan"];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 7) {
            cell.detailTextLabel.text = [dic valueForKey:@"city"];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 8) {
            cell.detailTextLabel.text = [dic valueForKey:@"job"];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 9) {
            cell.detailTextLabel.text = @"未认证";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 50;
    }
  
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *image = (id)[self.view viewWithTag:200];
    image.image = myImage;
    NSData * imageData = UIImageJPEGRepresentation(myImage, 0.01);
    [dataArr addObject:imageData];
//    NSDictionary *dict = @{@"id":[USERDEFAULT valueForKey:@"uid"]};
//    [AFManager upLoadpath:UPPICTURE reqBody:dict file:imageData fileName:@"file" fileType:@"image/jpg" block:^(id infor) {
//        NSLog(@"====%@",infor);
//        NSString *inforStr = [infor stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//        NSString *inforStr2 = [inforStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        [dic setValue:inforStr2 forKey:@"head_pic"];
//
//        //        "http:\/\/139.224.43.42\/zhai\/Uploads\/18b9c171ee7bd29789670f66721b5984.png"
//
//    } errorBlock:^(NSError *error) {
//        
//    }];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
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
    if (indexPath.row == 1) {
        userNameViewController *userName = [[userNameViewController alloc]init];
        userName.userName = [dic valueForKey:@"userName"];
        [self.navigationController pushViewController:userName animated:YES];
    }
    if (indexPath.row == 4) {
        qianmingViewController *userName = [[qianmingViewController alloc]init];
        userName.qianming = [dic valueForKey:@"qianming"];
        [self.navigationController pushViewController:userName animated:YES];
    }
    if (indexPath.row == 7) {
       
        cityViewController *city = [[cityViewController alloc]init];
        city.city = @"2";
        [self.navigationController pushViewController:city animated:YES];
    }
    
    if (indexPath.row == 8) {
        jobViewController *userName = [[jobViewController alloc]init];
        userName.job = [dic valueForKey:@"job"];
        [self.navigationController pushViewController:userName animated:YES];
    }
//    if (indexPath.row == 3) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//        UIAlertAction *defaultAction2 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [dic setValue:@"男" forKey:@"sex"];
//            [table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }];
//        [defaultAction2 setValue:[UIColor redColor] forKey:@"titleTextColor"];
//        UIAlertAction *defaultAction3 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [dic setValue:@"女" forKey:@"sex"];
//            [table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }];
//        [defaultAction3 setValue:[UIColor redColor] forKey:@"titleTextColor"];
//        UIAlertAction *defaultAction4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [defaultAction4 setValue:[UIColor colorWithWhite:0.5 alpha:1] forKey:@"titleTextColor"];
//        
//        [alert addAction:defaultAction2];
//        [alert addAction:defaultAction3];
//        [alert addAction:defaultAction4];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    }
    if (indexPath.row == 5) {
        bottomView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        bottomView4.backgroundColor = [UIColor clearColor];
        [self.view addSubview:bottomView4];
        UIView *bottomView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-200)];
        bottomView2.backgroundColor = [UIColor blackColor];
        bottomView2.alpha = 0.3;
        [bottomView4 addSubview:bottomView2];
        [UIView animateWithDuration:0.5 animations:^{
            
            
           UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-200, WIDTH, 200)];
            view.backgroundColor = [UIColor whiteColor];
            [bottomView4 addSubview:view];
            UILabel *centerLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 30)];
            centerLable.text = @"滚动时间,系统自动计算年龄";
            centerLable.textColor = RGBColor(67, 67, 67);
            centerLable.font = [UIFont systemFontOfSize:16];
            centerLable.textAlignment = NSTextAlignmentCenter;
            [view addSubview:centerLable];
            
            UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
            [button2 setTitle:@"取消" forState:UIControlStateNormal];
            [button2 setTitleColor:RGBColor(62, 62, 62)forState:UIControlStateNormal];
            button2.titleLabel.font = [UIFont systemFontOfSize:14];
            [button2 addTarget:self action:@selector(button3:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button2];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-70, 10, 60, 30)];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button setTitleColor:RGBColor(62, 62, 62)forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(button2:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 60, 30)];
            leftLable.text = @"年龄";
            leftLable.textColor = RGBColor(67, 67, 67);
            leftLable.font = [UIFont systemFontOfSize:14];
            leftLable.textAlignment = NSTextAlignmentCenter;
            [view addSubview:leftLable];
            
            UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-70, 50, 60, 30)];
            rightLable.text = [dic valueForKey:@"age"];
            rightLable.tag = 300;
            rightLable.textColor = RGBColor(67, 67, 67);
            rightLable.font = [UIFont systemFontOfSize:14];
            rightLable.textAlignment = NSTextAlignmentCenter;
            [view addSubview:rightLable];
            
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10,90,WIDTH-20,100)];
            datePicker.datePickerMode = UIDatePickerModeDate;

            [ datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
            [view addSubview:datePicker];

        }];

    }
    if (indexPath.row == 6) {
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        bottomView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:bottomView];
        UIView *bottomView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-110)];
        bottomView2.backgroundColor = [UIColor blackColor];
        bottomView2.alpha = 0.3;
        [bottomView addSubview:bottomView2];
        [UIView animateWithDuration:0.5 animations:^{
            
            
            bottomView3 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-110, WIDTH, 110)];
            bottomView3.backgroundColor = [UIColor whiteColor];
            [bottomView addSubview:bottomView3];
            NSArray *arr = @[@"保密",@"单身",@"恋爱中",@"已婚"];
            for (int i=0; i<4; i++) {
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10 + ((WIDTH-50)/4+10)*i, 10, (WIDTH-50)/4, 40)];
                [button setTitle:arr[i] forState:UIControlStateNormal];
                
                if ([[dic valueForKey:@"qinggan"] isEqualToString:arr[i]]) {
                    button.selected = YES;
                    [button setBackgroundColor:RGBColor(195, 75, 100)];
                }else{
                    button.selected = NO;
                    [button setBackgroundColor:RGBColor(207, 207, 207)];
                }
                button.tag = 1000+i;
                [button setTitleColor:RGBColor(62, 62, 62)forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                button.layer.cornerRadius = 5;
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
                [bottomView3 addSubview:button];
            }
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 60, (WIDTH-50)/4, 40)];
            [button setTitle:@"同性" forState:UIControlStateNormal];
            if ([[dic valueForKey:@"qinggan"] isEqualToString:@"同性"]) {
                button.selected = YES;
                [button setBackgroundColor:RGBColor(195, 75, 100)];
            }else{
                button.selected = NO;
                [button setBackgroundColor:RGBColor(207, 207, 207)];
            }
            button.tag = 1004;
            [button setTitleColor:RGBColor(62, 62, 62)forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.layer.cornerRadius = 5;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView3 addSubview:button];
        }];

    }
    if (indexPath.row == 7) {
        
    }
    if (indexPath.row == 9) {
        renzhengViewController *userName = [[renzhengViewController alloc]init];
        [self.navigationController pushViewController:userName animated:YES];
    }
    
}
-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [format stringFromDate:date];
    NSDate *fromdate=[format dateFromString:strDate];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
    NSDate *adate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    double intervalTime = [fromDate timeIntervalSinceReferenceDate] - [localeDate timeIntervalSinceReferenceDate];
    long lTime = labs((long)intervalTime);
    NSInteger iYears = lTime/60/60/24/365;
    NSLog(@"%ld",(long)iYears);
    UILabel *lable = (id)[self.view viewWithTag:300];
    lable.text = [NSString stringWithFormat:@"%ld",(long)iYears];
    
    
}
-(void)button2:(UIButton *)btn{
    
    [UIView animateWithDuration:0.5 animations:^{
        UILabel *lable = (id)[self.view viewWithTag:300];
        [dic setValue:[NSString stringWithFormat:@"%@",lable.text] forKey:@"age"];
        [table reloadData];
        bottomView4.frame = CGRectMake(0, HEIGHT+200, WIDTH, HEIGHT);
    }];
}
-(void)button3:(UIButton *)btn{
    [UIView animateWithDuration:0.5 animations:^{
        bottomView4.frame = CGRectMake(0, HEIGHT+200, WIDTH, HEIGHT);
    }];
}
-(void)button:(UIButton *)btn{

    for (UIButton *button in bottomView3.subviews) {
        if (btn == button) {
            btn.selected = YES;
            [btn setBackgroundColor:RGBColor(195, 75, 100)];
            [dic setValue:button.titleLabel.text forKey:@"qinggan"];
            if ([[NSString stringWithFormat:@"%@",button.titleLabel.text] isEqualToString:@"保密"]) {
                [dic setValue:@"0" forKey:@"qinggan2"];
            }else if ([[NSString stringWithFormat:@"%@",button.titleLabel.text] isEqualToString:@"单身"]){
                [dic setValue:@"1" forKey:@"qinggan2"];
            }else if ([[NSString stringWithFormat:@"%@",button.titleLabel.text] isEqualToString:@"恋爱"]){
                [dic setValue:@"2" forKey:@"qinggan2"];
            }else if ([[NSString stringWithFormat:@"%@",button.titleLabel.text] isEqualToString:@"已婚"]){
                [dic setValue:@"3" forKey:@"qinggan2"];
            }else if ([[NSString stringWithFormat:@"%@",button.titleLabel.text] isEqualToString:@"同性"]){
                [dic setValue:@"4" forKey:@"qinggan2"];
            }

            [table reloadData];
        }else{
            button.selected = NO;
            [button setBackgroundColor:RGBColor(207, 207, 207)];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        bottomView.frame = CGRectMake(0, HEIGHT+200, WIDTH, HEIGHT);
    }];

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
