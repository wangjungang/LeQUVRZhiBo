//
//  chongzhilistViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/16.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "chongzhilistViewController.h"
#import "tixianjiluTableViewCell.h"

@interface chongzhilistViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *table;
    NSMutableArray *dataSource;
}


@end

@implementation chongzhilistViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [AFManager getReqURL:[NSString stringWithFormat:@"%@?id=%@",CHONGZHILIST,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
        NSLog(@"%@",infor);
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            [dataSource removeAllObjects];
            [dataSource addObject:@""];
            [dataSource addObjectsFromArray:infor[@"data"]];
            [table reloadData];
        }
    } errorblock:^(NSError *error) {
        
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"充值记录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CustomBackButton];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    dataSource = [[NSMutableArray alloc]initWithArray:@[@""]];
    [table registerNib:[UINib nibWithNibName:@"tixianjiluTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"str";
    tixianjiluTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[tixianjiluTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    if (indexPath.row == 0) {
        cell.lable2.font = [UIFont systemFontOfSize:14];
        cell.lable3.font = [UIFont systemFontOfSize:14];
    }else{
        
        cell.lable1.text = @"充值";
        cell.lable2.text = dataSource[indexPath.row][@"money"];
        cell.lable3.text = dataSource[indexPath.row][@"time"];
        cell.lable1.textColor = RGBColor(69, 69, 69);
        cell.lable2.textColor = RGBColor(69, 69, 69);
        cell.lable3.textColor = RGBColor(69, 69, 69);
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
