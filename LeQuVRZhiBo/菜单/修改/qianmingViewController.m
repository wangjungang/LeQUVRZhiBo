//
//  qianmingViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/16.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "qianmingViewController.h"

@interface qianmingViewController ()<UITextViewDelegate>
{
    UITextView *textView;
}
@end

@implementation qianmingViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)item{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"textView" object:nil userInfo:@{@"textView":textView.text}];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个性签名";
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self CustomBackButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(item)];
    self.navigationItem.rightBarButtonItem = item;
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 100)];
    textView.text = self.qianming;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor redColor];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
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
