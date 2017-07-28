//
//  fankuiViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/22.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "fankuiViewController.h"

@interface fankuiViewController ()<UITextViewDelegate>
{
    UITextView *textView;
}


@end

@implementation fankuiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
-(void)item{
    NSDictionary *dic = @{@"uid":[USERDEFAULT valueForKey:@"uid"],@"message":textView.text};
    [AFManager postReqURL:FANKUI reqBody:dic block:^(id infor) {
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            [NSObject wj_selVcWithTitle:@"反馈已提交" TitleExplain:nil FirstSel:nil SecondSel:nil SelfVc:self PresentStyle:WJNewPresentFromCenter FirstOrSureBlock:^(NSString *userSelStr) {
                NSLog(@"1");
                
            } SecondSelOrCancelBlock:^(NSString *userSelStr) {
                NSLog(@"2");
                [self.navigationController popViewControllerAnimated:YES];

            }];
        }
    }];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(item)];
    self.navigationItem.rightBarButtonItem = item;
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 100)];
    textView.delegate = self;
    textView.text = @"请填写反馈意见";
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = [UIColor redColor];
    textView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:textView];
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
