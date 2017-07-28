//
//  personInfoViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/24.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "personInfoViewController.h"
#import "AFHTTPSessionManager.h"
#import "RongChetController.h"
#import "NSObject+HUD.h"
//动态VC
#import "dongtaiViewController.h"
#import "SmallVideoListController.h"
@interface personInfoViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
   // UIScrollView *myScrollView;
   // UIImageView *gundongImage;
    UITableView *table;
    NSMutableArray *dataSource;
    NSMutableArray *dataSource3;
    NSMutableDictionary *dic;

   // UITableView *table2;
   // NSMutableArray *dataSource2;
    
    UILabel *songchuLable;
    UIImageView *imageview;
    UILabel *nameLable;
    UILabel *guanzhuLable;
    UILabel *fensiLable;
    UILabel *jieshaoLable;
    NSString *headImageUrl;
}
@end

@implementation personInfoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11"]forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    dic = [[NSMutableDictionary alloc]init];
    [self createUI];
    NSLog(@"%@",self.uid);
}
-(void)createUI{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    view.backgroundColor = RGBColor(195, 75, 100);
    //左侧button
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(20, 30, ReturnWidth, ReturnHeight);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickedCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    
    songchuLable = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, self.view.frame.size.width - 60, 30)];
    songchuLable.text = @"";
    songchuLable.font = [UIFont systemFontOfSize:16];
    songchuLable.textAlignment = NSTextAlignmentCenter;
    songchuLable.textColor = [UIColor whiteColor];
    [view addSubview:songchuLable];
    
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-30, 60, 60, 60)];
    imageview.image = [UIImage imageNamed:@""];
    imageview.layer.cornerRadius = 30;
    imageview.layer.masksToBounds = YES;
    [view addSubview:imageview];
    
    nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, WIDTH, 30)];
    nameLable.text = @"";
    nameLable.font = [UIFont systemFontOfSize:16];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.textColor = [UIColor whiteColor];
    [view addSubview:nameLable];
    
    guanzhuLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, WIDTH/2-20, 20)];
    guanzhuLable.text = @"关注 0";
    guanzhuLable.font = [UIFont systemFontOfSize:12];
    guanzhuLable.textAlignment = NSTextAlignmentRight;
    guanzhuLable.textColor = [UIColor whiteColor];
    [view addSubview:guanzhuLable];
    
    fensiLable = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2+20, 150, WIDTH/2-20, 20)];
    fensiLable.text = @"粉丝 0";
    fensiLable.font = [UIFont systemFontOfSize:12];
    fensiLable.textAlignment = NSTextAlignmentLeft;
    fensiLable.textColor = [UIColor whiteColor];
    [view addSubview:fensiLable];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2, 150, 1, 20)];
    lineView.backgroundColor = [UIColor whiteColor];
    [view addSubview:lineView];
    
    jieshaoLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 170, WIDTH-40, 30)];
    jieshaoLable.text = @"";
    jieshaoLable.font = [UIFont systemFontOfSize:12];
    jieshaoLable.textAlignment = NSTextAlignmentCenter;
    jieshaoLable.textColor = [UIColor whiteColor];
    [view addSubview:jieshaoLable];
    /*
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 52)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 2)];
    view3.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view2 addSubview:view3];
    gundongImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, (self.view.frame.size.width)/2, 2)];
    gundongImage.image = [UIImage imageNamed:@"orange.png"];
    [view2 addSubview:gundongImage];
    NSArray *arr2 = @[@"主页",@"直播"];
    for (int i=0; i<2; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 * i, 0, (self.view.frame.size.width)/2, 50)];
        [button setTitle:arr2[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:RGBColor(69, 69, 69) forState:UIControlStateNormal];
        button.tag = 200 +i;
        if (i==0) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }
        [button addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:button];
    }
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-1, 20, 2, 10)];
    lineview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view2 addSubview:lineview];

    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 252, self.view.frame.size.width, self.view.frame.size.height-252-50)];
    myScrollView.contentOffset = CGPointMake(0, 0);
    myScrollView.backgroundColor = [UIColor whiteColor];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    myScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
    myScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:myScrollView];
*/
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
//    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    table.tableHeaderView = view;
    dataSource = [[NSMutableArray alloc]initWithArray:@[@"贡献榜",@"年龄",@"婚姻状态",@"家乡",@"职业",@"账号",@"个性签名",@"小视频"]];
    dataSource3 = [[NSMutableArray alloc]initWithArray:@[@"",@"",@"",@"",@"",@"",@"",@""]];
/*
    UIView *shipinView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH, 0, self.view.frame.size.width, 40)];
    shipinView.backgroundColor = [UIColor whiteColor];
    [myScrollView addSubview:shipinView];
    
    UILabel *huifangLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 150, 30)];
    huifangLable.text = @"0个最新回放";
    huifangLable.textColor = RGBColor(69, 69, 69);
    huifangLable.font = [UIFont systemFontOfSize:12];
    huifangLable.textAlignment = NSTextAlignmentLeft;
    [shipinView addSubview:huifangLable];
    NSArray *arr = @[@"最新",@"最热"];
    for (int i=1; i<3; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-60*i, 0, 60, 39)];
        [button setTitle:arr[i-1] forState:UIControlStateNormal];
        [button setTitleColor:RGBColor(69, 69, 69) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        [shipinView addSubview:button];
    }
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, self.view.frame.size.width, 1)];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [shipinView addSubview:lineView2];
    table2 = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 40, self.view.frame.size.width, myScrollView.frame.size.height-40) style:UITableViewStylePlain];
    table2.delegate = self;
    table2.dataSource = self;
    table2.showsVerticalScrollIndicator = NO;
    table2.separatorColor = [UIColor clearColor];
    table2.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [myScrollView addSubview:table2];
    dataSource2 = [[NSMutableArray alloc]init];
//    [table2 registerNib:[UINib nibWithNibName:@"shouyeTableViewCell" bundle:nil] forCellReuseIdentifier:@"str2"];
  */
    
    UIView *bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    bottomview.backgroundColor = [UIColor whiteColor];
    bottomview.layer.borderWidth = 1;
    bottomview.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1]CGColor];
    [self.view addSubview:bottomview];
    NSArray *arr3 = @[@"关注",@"私信",@"动态"];
    NSArray *arr4 = @[@"7",@"8",@"33"];
    for (int i=0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3*i, 0, self.view.frame.size.width/3, 50)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 2000+i;
        view.userInteractionEnabled = YES;
        [bottomview addSubview:view];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [view addGestureRecognizer:tap];
        UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6+5, 10, self.view.frame.size.width/6-5, 30)];
        lable2.textColor = [UIColor orangeColor];
        lable2.textAlignment = NSTextAlignmentLeft;
        lable2.text = arr3[i];
        lable2.tag=1024+i;
        lable2.font = [UIFont systemFontOfSize:14];
        [view addSubview:lable2];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/6-20, 15, 20, 20)];
        [button setImage:[UIImage imageNamed:arr4[i]] forState:UIControlStateNormal];
        [view addSubview:button];
    }
    for (int i=1; i<3; i++) {
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/3*i, 20, 2, 10)];
        lineview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [bottomview addSubview:lineview];
    }
    [self getUserData];
    [self getIsConcern];
    [self getFansCount];
    [self getConcernCount];
}


-(void)button:(UIButton *)btn{

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == table) {
        static NSString *str = @"str";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:str];
        }
        cell.textLabel.text = dataSource[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = RGBColor(69, 69, 69);
        cell.textLabel.textAlignment = NSTextAlignmentLeft;

        if (indexPath.row == 0) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

        }else{
            cell.detailTextLabel.text = dataSource3[indexPath.row];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = RGBColor(69, 69, 69);
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *str = @"str2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        if (indexPath.row == 7) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //if (tableView == table) {
        return dataSource.count;
   // }
    //return [dataSource2 count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == table) {
        return 44;
    }
    return 265;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 7) {
        SmallVideoListController *list = [[SmallVideoListController alloc]init];
        list.userID = self.uid;
        [self.navigationController pushViewController:list animated:YES];
    }
}
/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == myScrollView) {
        [UIView animateWithDuration:0.2 animations:^{
            int i = myScrollView.contentOffset.x / self.view.frame.size.width;
            
            
            UIButton *button1 = (id)[self.view viewWithTag:200];
            UIButton *button2 = (id)[self.view viewWithTag:201];
            
            
            if (i==0) {
                gundongImage.frame = CGRectMake(0, 50, (self.view.frame.size.width)/2, 2);
                
                [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [button2 setTitleColor:RGBColor(69, 69, 69) forState:UIControlStateNormal];
                
            }
            if (i==1) {
                gundongImage.frame = CGRectMake((self.view.frame.size.width)/2, 50, (self.view.frame.size.width)/2, 2);
                
                [button1 setTitleColor:RGBColor(69, 69, 69) forState:UIControlStateNormal];
                [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
            }
        }];
        
    }
    
}

-(void)pressBtn:(UIButton *)btn{
    UIButton *button = (UIButton *)btn;
    for (int i=0; i<2; i++) {
        UIButton *button2 = (id)[self.view viewWithTag:200+i];
        if (button == button2) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [button2 setTitleColor:RGBColor(69, 69, 69) forState:UIControlStateNormal];
        }
    }
    switch (button.tag) {
        case 200:{
            
            [UIView animateWithDuration:0.2 animations:^{
                myScrollView.contentOffset = CGPointMake(0, 0);
                gundongImage.frame = CGRectMake(0, 50, (self.view.frame.size.width)/2, 2);
            }];
        }
            break;
        case 201:{
            
            [UIView animateWithDuration:0.2 animations:^{
                myScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
                gundongImage.frame = CGRectMake((self.view.frame.size.width)/2, 50, (self.view.frame.size.width)/2, 2);
            }];
        }
        default:
            break;
    }
    
}
 */
#pragma mark-
#pragma mark-关注私信动态按钮方法
-(void)pressView:(UITapGestureRecognizer *)tap{
    UIView*view=tap.view;
    switch (view.tag)
    {
        case 2000:
        {
            UILabel*lable =(UILabel*)[self.view viewWithTag:1024];
            if ([lable.text isEqualToString:@"关注"])
            {
                [self concernUser];
            }else
            {
                [self cancleConcern];
            }
        }
            break;
        case 2001:
        {
            RongChetController *conversationVC = [[RongChetController alloc]init];
            conversationVC.conversationType = ConversationType_PRIVATE;
            conversationVC.targetId =self.uid ;
            conversationVC.title =nameLable.text;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
            break;
        case 2002:
        {
            dongtaiViewController *person = [[dongtaiViewController alloc]init];
            person.uid=self.uid;
            person.headUrl=headImageUrl;
            person.nickName=nameLable.text;
            person.isMyself=NO;
            [self.navigationController pushViewController:person animated:NO];
        }
            break;
        default:
            break;
    }
}
//pop
-(void)clickedCancelBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-
#pragma mark-获取数据源
//获取用户信息
- (void)getUserData
{
    [AFManager getReqURL2:[NSString stringWithFormat:GERENZHUYE,self.uid] block:^(id infor)
    {
        NSLog(@"11--%@",infor);
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            songchuLable.text = @"";
            [imageview setImageWithURL:[NSURL URLWithString:infor[@"data"][@"head_pic"]] placeholderImage:[UIImage imageNamed:@""]];
            nameLable.text = infor[@"data"][@"nickname"];
            headImageUrl=infor[@"data"][@"head_pic"];
            jieshaoLable.text = @"";
            
            if ([infor[@"data"][@"nickname"] isEqual:[NSNull null]]) {
                [dic setValue:@"" forKey:@"userName"];
            }else{
                [dic setValue:infor[@"data"][@"nickname"] forKey:@"userName"];
            }
            [dic setValue:infor[@"data"][@"account"] forKey:@"account"];
            if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"sex"]] isEqualToString:@"1"]) {
                [dic setValue:@"男" forKey:@"sex"];
            }else{
                [dic setValue:@"女" forKey:@"sex"];
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
                
                
            }else{
                if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"0"]) {
                    [dic setValue:@"保密" forKey:@"qinggan"];
                }else if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"1"]){
                    [dic setValue:@"单身" forKey:@"qinggan"];
                }else if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"2"]){
                    [dic setValue:@"恋爱" forKey:@"qinggan"];
                }else if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"3"]){
                    [dic setValue:@"已婚" forKey:@"qinggan"];
                }else if ([[NSString stringWithFormat:@"%@",infor[@"data"][@"emotion"]] isEqualToString:@"4"]){
                    [dic setValue:@"同性" forKey:@"qinggan"];
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
       
            dataSource3 = [[NSMutableArray alloc]initWithArray:@[@"",[dic valueForKey:@"age"],[dic valueForKey:@"qinggan"],[dic valueForKey:@"city"],[dic valueForKey:@"job"],[dic valueForKey:@"account"],[dic valueForKey:@"qianming"],@""]];
            [table reloadData];
        }
    } errorblock:^(NSError *error)
    {
        
    }];
}
//是否关注过该用户
- (void)getIsConcern
{
    UILabel*lable =(UILabel*)[self.view viewWithTag:1024];
    [AFManager getReqURL:[NSString stringWithFormat:IS_CONCERN_URL,self.uid,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
          lable.text=@"取关";
        }else if ([[infor objectForKey:@"code"]integerValue]==201)
        {
          lable.text=@"关注";
        }
    } errorblock:^(NSError *error)
    {
        
    }];
}
//关注人数
- (void)getConcernCount
{
    [AFManager getReqURL:[NSString stringWithFormat:GET_CONCERN_URL,self.uid] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            guanzhuLable.text = [NSString stringWithFormat:@"关注：%@",[infor objectForKey:@"gbCount"]];
        }else if ([[infor objectForKey:@"code"]integerValue]==201)
        {
            guanzhuLable.text = @"暂未关注任何人";
        }
    } errorblock:^(NSError *error)
    {
        
    }];
}
//获取粉丝人数
- (void)getFansCount
{
    [AFManager getReqURL:[NSString stringWithFormat:GET_CONCERN_FANS_URL,self.uid] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            fensiLable.text = [NSString stringWithFormat:@"粉丝：%@",[infor objectForKey:@"bgbCount"]];
        }else if([[infor objectForKey:@"code"]integerValue]==201)
        {
            fensiLable.text = @"暂未有粉丝";
        }
    } errorblock:^(NSError *error) {
        
    }];
}
//关注用户
- (void)concernUser
{
    [AFManager getReqURL:[NSString stringWithFormat:CONCERN_USER_URL,self.uid,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            [NSObject wj_showHUDWithTip:@"关注成功"];
            [self getFansCount];
            [self getIsConcern];
        }else{
            [NSObject wj_showHUDWithTip:@"关注失败"];
        }
    } errorblock:^(NSError *error)
    {
        
    }];
}
//取消关注
- (void)cancleConcern
{
    [AFManager getReqURL:[NSString stringWithFormat:CANCLE_CONCERN_URL,self.uid,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            [NSObject wj_showHUDWithTip:@"取消成功"];
            [self getFansCount];
            [self getIsConcern];
        }else{
            [NSObject wj_showHUDWithTip:@"取消失败"];
        }
    } errorblock:^(NSError *error)
    {
        
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
