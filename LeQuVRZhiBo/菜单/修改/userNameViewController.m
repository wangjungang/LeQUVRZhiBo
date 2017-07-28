//
//  userNameViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/16.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "userNameViewController.h"

@interface userNameViewController ()<UITextFieldDelegate>
{
    UITextField *nameField;
}
@end

@implementation userNameViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)item{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"nameField" object:nil userInfo:@{@"nameField":nameField.text}];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"昵称";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self CustomBackButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(item)];
    self.navigationItem.rightBarButtonItem = item;
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 40)];
    nameField.text = self.userName;
    nameField.textColor = [UIColor redColor];
    nameField.font = [UIFont systemFontOfSize:14];
    nameField.backgroundColor = [UIColor whiteColor];
    nameField.delegate = self;
    nameField.layer.cornerRadius = 5;
    [self.view addSubview:nameField];
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
