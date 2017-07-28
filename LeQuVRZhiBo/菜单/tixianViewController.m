//
//  tixianViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/18.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "tixianViewController.h"
#import "tixianjiluViewController.h"
#import "tixianCell.h"
@interface tixianViewController ()<UITableViewDataSource,UITableViewDelegate,myTabVdelegate,UITextFieldDelegate>
{
    BOOL zhifu;
}
@property (nonatomic,strong) UITableView *tixiantableview;
@property (nonatomic,strong) UITextField *numberlabel;
@property (nonatomic,strong) NSMutableArray *imagearr;
@property (nonatomic,strong) UIButton *tixianbtn;
@end
static NSString *tixiancell = @"tixiancell";
@implementation tixianViewController
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
    self.navigationItem.title = @"提现";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                         NSForegroundColorAttributeName,
                         [UIFont boldSystemFontOfSize:14],
                         NSFontAttributeName,nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"提现记录" style:UIBarButtonItemStyleDone target:self action:@selector(item:)];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = item;
    [self.view addSubview:self.tixiantableview];
    self.tixiantableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.imagearr = [NSMutableArray arrayWithObjects:@"tixian2",@"tixian1", nil];
    [self.view addSubview:self.tixianbtn];
}
-(void)item:(UIBarButtonItem *)item{
    tixianjiluViewController *tixian = [[tixianjiluViewController alloc]init];
    [self.navigationController pushViewController:tixian animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

-(UITableView *)tixiantableview
{
    if(!_tixiantableview)
    {
        _tixiantableview = [[UITableView alloc] init];
        _tixiantableview.frame = CGRectMake(0, 0, WIDTH, 210);
        _tixiantableview.dataSource = self;
        _tixiantableview.delegate = self;
        _tixiantableview.scrollEnabled = NO;
    }
    return _tixiantableview;
}

-(UIButton *)tixianbtn
{
    if(!_tixianbtn)
    {
        _tixianbtn = [[UIButton alloc] init];
        _tixianbtn.frame = CGRectMake(40, 160, WIDTH-80, 50);
        [_tixianbtn addTarget:self action:@selector(tixianbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _tixianbtn.backgroundColor = RGBColor(203, 70, 111);
        [_tixianbtn setTitle:@"提交申请" forState:UIControlStateNormal];
        _tixianbtn.layer.masksToBounds = YES;
        _tixianbtn.layer.cornerRadius = 18;
    }
    return _tixianbtn;
}


#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tixianCell *cell = [tableView dequeueReusableCellWithIdentifier:tixiancell];
    if (!cell) {
        cell = [[tixianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tixiancell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.zhifuimg.image = [UIImage imageNamed:@"zhifubao"];
        cell.zhifuname.text = @"支付宝";
        cell.zhfuxinx.text = @"将账户余额提现到支付宝账户中";
    }
    if (indexPath.row==1) {
        cell.zhifuimg.image = [UIImage imageNamed:@"weixin"];
        cell.zhifuname.text = @"微信钱包";
        cell.zhfuxinx.text = @"将账户余额提现到微信账号中";
    }
    [cell.choosebtn setImage:[UIImage imageNamed:self.imagearr[indexPath.row]] forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    UILabel *labe1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
    labe1.text = @"转出金额:";
    labe1.adjustsFontSizeToFitWidth = YES;
    labe1.textAlignment = NSTextAlignmentLeft;
    labe1.textColor = [UIColor wjColorFloat:@"616263"];
    self.numberlabel = [[UITextField alloc] init];
    self.numberlabel.frame = CGRectMake(WIDTH-200, 15, 190, 20);
    self.numberlabel.textAlignment = NSTextAlignmentRight;
    self.numberlabel.placeholder = @"请输入星票数量";
    self.numberlabel.textColor = [UIColor wjColorFloat:@"616263"];
    self.numberlabel.delegate = self;
    [headview addSubview:labe1];
    [headview addSubview:self.numberlabel];
    return headview ;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark - 实现方法

-(void)tixianbtnclick
{
    if (zhifu ==YES) {
        NSLog(@"支付宝");
        
       
    }
    else
    {
        NSDate *now = [NSDate date];
        NSLog(@"now date is: %@", now);
 
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        int day = (int)[dateComponent day];
        NSLog(@"微信");
        if (day == 15) {
            NSLog(@"%@--%@",[USERDEFAULT valueForKey:@"uid"],[NSString stringWithFormat:@"%d",[_numberlabel.text intValue]/10]);
            [AFManager getReqURL:[NSString stringWithFormat:@"%@?uid=%@&money=%@",TIXIAN,[USERDEFAULT valueForKey:@"uid"],[NSString stringWithFormat:@"%d",[_numberlabel.text intValue]/10]] block:^(id infor) {
                NSLog(@"%@",infor);
                if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                    [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"提交已申请" andSelfVC:self];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    });
                    
                }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"201"]) {
                    [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"提现失败" andSelfVC:self];
                    
                }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"202"]) {
                    [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"余额不足" andSelfVC:self];
                    
                }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"203"]) {
                    [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"提现金额超出5W" andSelfVC:self];
                    
                }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"204"]) {
                    
                    [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"提现金额超出账户余额50%" andSelfVC:self];
                }
                
            } errorblock:^(NSError *error) {
                
            }];
            

        }else{
        [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"提现只能每月15号" andSelfVC:self];
        }
        
    }
    
}

-(void)myTabVClick:(UITableViewCell *)cell
{
    NSIndexPath *index = [self.tixiantableview indexPathForCell:cell];
    
    if (index.row==0) {
        self.imagearr = [NSMutableArray arrayWithObjects:@"tixian2",@"tixian1", nil];
        [self.tixiantableview reloadData];
        [_tixianbtn setTitle:@"填写支付宝信息" forState:UIControlStateNormal];
        zhifu = YES;
    }
    else
    {
        self.imagearr = [NSMutableArray arrayWithObjects:@"tixian1",@"tixian2", nil];
        [self.tixiantableview reloadData];
        [_tixianbtn setTitle:@"填写微信信息" forState:UIControlStateNormal];
        zhifu = NO;
    }

}
@end
