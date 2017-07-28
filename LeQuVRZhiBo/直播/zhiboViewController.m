//
//  zhiboViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/7.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "zhiboViewController.h"
#import "shouyeTableViewCell.h"
#import "VRViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "dengluViewController.h"
#import "zhuceViewController.h"
#import "moreViewController.h"
#import "outViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "RCDLiveChatRoomViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "searchViewController.h"
#import "MyPhotosCell.h"
#import "gengduoViewController.h"
@interface zhiboViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,RCIMUserInfoDataSource>
{
    UIScrollView *headScrollView;
    UIPageControl *pageControl;
    UITableView *table;
    NSMutableArray *dataSource;
    
    NSString *latitude;
    NSString *lon;
}
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (nonatomic,strong) RCUserInfo  *userInfo2;
@end

@implementation zhiboViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[imageAryObjet instance].imageViews removeAllObjects];

    //判断的手机的定位功能是否开启
    //开启定位:设置 > 隐私 > 位置 > 定位服务
    if([CLLocationManager
        locationServicesEnabled]) {
        //启动位置更新
        //开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [self.locationManager startUpdatingLocation];
        
        NSLog(@"定位已开启");
        
        
    }
    else{
        [NSObject wj_alterSingleVCWithOneTitle:@"无法获取你的位置信息" andTwoTitle:@"请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务,并允许乐趣VR直播使用定位服务" andSelfVC:self];
    }
    
    if ([latitude isEqualToString:@"40.1117510000"]&&[lon isEqualToString:@"116.3005280000"]) {
        [USERDEFAULT setValue:latitude forKey:@"latitude"];
        [USERDEFAULT setValue:lon forKey:@"lon"];
        [USERDEFAULT setValue:@"北京 海淀区" forKey:@"cityName"];
        [USERDEFAULT synchronize];
    }
    [AFManager getReqURL:[NSString stringWithFormat:SHOUYEZHUBO,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            NSLog(@"%@",infor[@"data"]);
            [dataSource removeAllObjects];
            [dataSource addObjectsFromArray:infor[@"data"]];
            [table reloadData];
            
        }
    } errorblock:^(NSError *error) {
        
    }];
}
#pragma mark 代理方法
/** 当完成位置更新的时候调用 --> 次方法会频繁调用*/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations.lastObject;
    NSLog(@"latitude: %f, longitude: %f",location.coordinate.latitude, location.coordinate.longitude);
    latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *array, NSError *error){
        
        CLPlacemark *placemark = [array objectAtIndex:0];
        //        NSLog(@"%@-%@-%@-%@-%@-%@",placemark.addressDictionary[@"Name"],placemark.addressDictionary[@"Country"],placemark.addressDictionary[@"SubLocality"],placemark.addressDictionary[@"SubThoroughfare"],placemark.addressDictionary[@"State"],placemark.addressDictionary[@"Thoroughfare"]);
        NSString *name = [NSString stringWithFormat:@"%@ %@",placemark.addressDictionary[@"State"],placemark.addressDictionary[@"City"]];
        [USERDEFAULT setValue:name forKey:@"cityName"];
         [USERDEFAULT synchronize];
    }];
    [USERDEFAULT setValue:latitude forKey:@"latitude"];
    [USERDEFAULT setValue:lon forKey:@"lon"];
    [USERDEFAULT synchronize];

    //停止位置更新
    [manager stopUpdatingLocation];
}


#pragma mark   ===========  定位失败时调用  ===========
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    //    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //访问用户拒绝的位置服务
            errorString = @"Access to Location Services denied by user";
            break;
        case kCLErrorLocationUnknown:
            //位置数据不可用
            errorString = @"Location data unavailable";
            break;
        default:
            //发生了一个未知的错误
            errorString = @"An unknown error has occurred";
            break;
    }
    
    [NSObject wj_alterSingleVCWithOneTitle:@"无法获取你的位置信息" andTwoTitle:@"请到手机系统的[设置]->[乐趣VR直播]->[位置]中设置允许乐趣VR直播访问位置信息" andSelfVC:self];
}

-(void)item:(UIBarButtonItem *)item{
     [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    [UIView animateWithDuration:1 animations:^{
//        cehuaView *cehua = [[cehuaView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        [self.view addSubview:cehua];
//        self.navigationController.navigationBarHidden = YES;
//        self.tabBarController.tabBar.hidden = YES;
//    }];
    
}

-(void)item2:(UIBarButtonItem *)item{
   
    searchViewController *search = [[searchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"left" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"right" object:nil];
}
-(void)left:(id)user{
    if ([[user userInfo][@"left"] isEqualToString:@"0"]) {
        zhiboingViewController *zhiboing = [[zhiboingViewController alloc] init];
        [self.navigationController pushViewController:zhiboing animated:YES];
    }
    
}
-(void)right:(id)user{
    if ([[user userInfo][@"right"] isEqualToString:@"0"]) {
        [self presentViewController:[SmallVideoController new] animated:YES completion:nil];
        
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[RCIM sharedRCIM]setUserInfoDataSource:self];

    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11"]forBarMetrics:UIBarMetricsDefault];
    latitude = @"40.1117510000";
    lon = @"116.3005280000";
    //1. 创建CLLocationManager对象
    _locationManager = [CLLocationManager new];
    
    //2.当用户使用的使用授权 --> 能看见APP界面的时候就是使用期间
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //3. 设置代理 --> 获取用户位置
    _locationManager.delegate = self;
    
    //4.设置定位精度
    _locationManager.desiredAccuracy= kCLLocationAccuracyBest;
    
    //5.至少移动10再通知委托处理更新
    _locationManager.distanceFilter= 10.0f;
    
    //6. 调用开始定位方法
    [_locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(left:) name:@"left" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(right:) name:@"right" object:nil];

    self.navigationItem.title = @"乐趣VR直播";
//    self.navigationController.view.backgroundColor = RGBColor(148, 78, 193);
    NSDictionary *dict2 = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict2;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Shape94"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(item2:)];
    self.navigationItem.rightBarButtonItem = item;
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(item:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    int space = 40;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width - 40 - 3 * space) / 4 + 5 +160+30)];
    headView.backgroundColor = [UIColor whiteColor];
    headScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    headScrollView.contentOffset = CGPointMake(0, 0);
    headScrollView.pagingEnabled = YES;
    headScrollView.delegate = self;
    headScrollView.showsHorizontalScrollIndicator = NO;
    headScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, 0);
    [headView addSubview:headScrollView];
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 140, 100, 2)];
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [headView addSubview:pageControl];
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, 150)];
//        [imageView setImageWithURL:[NSURL URLWithString:dic[@"banner"][i][@"image"]] placeholderImage:[UIImage imageNamed:@"load.png"]];
        imageView.image = [UIImage imageNamed:@"tu"];
        imageView.tag = 500+i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        [headScrollView addSubview:imageView];
    }

    
    NSArray *arr = @[@"热门",@"VR",@"户外",@"更多"];
    NSArray *arr2 = @[@"椭圆4",@"椭圆4-1",@"椭圆4-2",@"椭圆4-3"];
    for (int i=0; i<4; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20 + (self.view.frame.size.width - 40 - 3 * space) / 4 * i + space * i, 160, (self.view.frame.size.width - 40 - 3 * space) / 4, (self.view.frame.size.width - 40 - 3 * space) / 4)];
        button.tag = 100 + i;
        [button setBackgroundImage:[UIImage imageNamed:arr2[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:button];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20 + (self.view.frame.size.width - 40 - 3 * space) / 4 * i + space * i, (self.view.frame.size.width - 40 - 3 * space) / 4 + 5 +155, (self.view.frame.size.width - 40 - 3 * space) / 4, 30)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = arr[i];
        lable.font = [UIFont systemFontOfSize:12];
        [headView addSubview:lable];
    }
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:table];
    dataSource = [[NSMutableArray alloc]init];
    table.tableHeaderView = headView;
    table.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];
    [table registerNib:[UINib nibWithNibName:@"shouyeTableViewCell" bundle:nil] forCellReuseIdentifier:@"str"];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    int i=scrollView.contentOffset.x/self.view.frame.size.width;
    pageControl.currentPage = i;

}
#pragma mark-
#pragma mark-tableview协议方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"str";
    shouyeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[shouyeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    [cell.avatar setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"head_pic"]]];
    cell.avatar.layer.cornerRadius = 25;
    cell.avatar.layer.masksToBounds = YES;
    [cell.pic setImageWithURL:[NSURL URLWithString:dataSource[indexPath.row][@"head_pic"]]];
    cell.username.text =dataSource[indexPath.row][@"nickname"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSource count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 265;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectConcern:indexPath];
}
-(void)pressBtn:(UIButton *)btn{
    if (btn.tag == 100) {
        moreViewController *more = [[moreViewController alloc]init];
        [self.navigationController pushViewController:more animated:YES];
        
    }else if (btn.tag == 101){
        VRViewController *VR = [[VRViewController alloc]init];

        [self.navigationController pushViewController:VR animated:YES];
    }else if (btn.tag == 102){
        outViewController *outView = [[outViewController alloc]init];
        [self.navigationController pushViewController:outView animated:YES];
    }else if (btn.tag == 103){
        gengduoViewController *outView = [[gengduoViewController alloc]init];
        [self.navigationController pushViewController:outView animated:YES];
    }



}
-(void)pressView:(UIButton *)btn{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//融云给用户设置头像
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
    [AFManager getReqURL:[NSString stringWithFormat:GET_USER_NICK_URL,userId] block:^(id infor)
     {
         if ([[infor objectForKey:@"code"]integerValue]==200)
         {
              _userInfo2=[[RCUserInfo alloc]initWithUserId:userId name:[infor objectForKey:@"nickname"]  portrait:[infor objectForKey:@"head_pic"] ];
              if (_userInfo2) {
                  completion(_userInfo2);
              }else
              {
                  completion(nil);
              }
         }
     } errorblock:^(NSError *error) {
         
     }];
        });
}
#pragma mark-
#pragma mark-打开直播前查询是否关注过该主播
- (void)selectConcern:(NSIndexPath*)indexPath
{
    NSString*uid=dataSource[indexPath.row][@"id"];
    [AFManager getReqURL:[NSString stringWithFormat:IS_CONCERN_URL,uid,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor)
    {
        RCDLiveChatRoomViewController *play = [[RCDLiveChatRoomViewController alloc]init];
        play.headerImage=dataSource[indexPath.row][@"head_pic"];
        play.anchorNickName=dataSource[indexPath.row][@"nickname"];
        play.anchorID=[NSString stringWithFormat:@"%@",dataSource[indexPath.row][@"id"]];
        play.anchorNum=[NSString stringWithFormat:@"%@",dataSource[indexPath.row][@"account"]];
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            play.isConcern=YES;
        }else if([[infor objectForKey:@"code"]integerValue]==201)
        {
            play.isConcern=NO;
        }
        [self.navigationController pushViewController:play animated:YES
         ];
    } errorblock:^(NSError *error)
    {
        
    }];
    
    
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
