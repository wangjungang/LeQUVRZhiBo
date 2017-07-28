//
//  safeViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/28.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "safeViewController.h"
#import "safeCell.h"
@interface safeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *safetableview;
@property (nonatomic,strong) UIImageView *safeimg;
@property (nonatomic,strong) UILabel *safelabel;
@end
static NSString *safecell = @"safecell";
static NSString *safecell2 = @"safecell2";
@implementation safeViewController
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
    self.title = @"账号与安全";
    [self CustomBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.safetableview];
    self.safetype = @"di";
    self.safetableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters


-(UITableView *)safetableview
{
    if(!_safetableview)
    {
        _safetableview = [[UITableView alloc] init];
        _safetableview.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        _safetableview.dataSource = self;
        _safetableview.delegate = self;
        _safetableview.scrollEnabled = NO;
    }
    return _safetableview;
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:safecell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:safecell];
        }
        cell.textLabel.text = @"通过以下设置可以提高安全等级";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor wjColorFloat:@"CCCDCE"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        safeCell *cell = [tableView dequeueReusableCellWithIdentifier:safecell2];
        if (!cell) {
            cell = [[safeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:safecell2];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        headview.layer.masksToBounds = YES;
        headview.layer.borderWidth = 0.4;
        headview.layer.borderColor = [UIColor wjColorFloat:@"f4f5f6"].CGColor;
        headview.backgroundColor = [UIColor wjColorFloat:@"F4F5F6"];
        self.safeimg = [[UIImageView alloc] init];
        self.safeimg.frame = CGRectMake(WIDTH/2-50, HEIGHT/8-30, 100, 100);
        self.safelabel = [[UILabel alloc] init];
        self.safelabel.frame = CGRectMake(WIDTH/2-110, HEIGHT/4+20, 220, 30);
        self.safelabel.textAlignment = NSTextAlignmentCenter;
        self.safelabel.font = [UIFont systemFontOfSize:22];
        [headview addSubview:self.safelabel];
        [headview addSubview:self.safeimg];
        if ([self.safetype isEqualToString:@"di"]) {
            self.safeimg.image = [UIImage imageNamed:@"账号与安全3"];
            self.safelabel.text = @"安全等级：低";
            self.safelabel.textColor = [UIColor wjColorFloat:@"F24647"];
        }
        if ([self.safetype isEqualToString:@"zhong"]) {
            self.safeimg.image = [UIImage imageNamed:@"账号与安全2"];
            self.safelabel.text = @"安全等级：中";
            self.safelabel.textColor = [UIColor wjColorFloat:@"F2696B"];
        }
        if ([self.safetype isEqualToString:@"gao"]) {
            self.safeimg.image = [UIImage imageNamed:@"账号与安全1"];
            self.safelabel.text = @"安全等级：高";
            self.safelabel.textColor = [UIColor wjColorFloat:@"9ED857"];
        }
        return headview ;
    }
    else
    {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return HEIGHT/2-60;
    }else
    {
        return 17/2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        NSLog(@"绑定手机号");
    }
}

@end
