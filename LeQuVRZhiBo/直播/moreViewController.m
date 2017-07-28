//
//  moreViewController.m
//  LeQuVRZhiBo
//
//  Created by lhb on 16/11/15.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import "moreViewController.h"
#import "nearCollectionViewCell.h"
#import "hotTableViewCell.h"
#import "shouyeTableViewCell.h"

@interface moreViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
    UIView *titleView;
    UIScrollView *scrollview;
    UIView *lineView;
    UICollectionView *collectionView;
    NSMutableArray *dataArr;
    
    UIScrollView *headScrollView;
    UIPageControl *pageControl;
    UITableView *table;
    NSMutableArray *dataArr2;
    
    UITableView *table2;
    NSMutableArray *dataArr3;
    
    NSString *latitude;
    NSString *lon;
}

@end

@implementation moreViewController

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

-(void)item2:(UIBarButtonItem *)item{
    
    
}
-(void)button:(UIButton *)btn{
    UIButton *button = (id)[self.view viewWithTag:200];
    UIButton *button2 = (id)[self.view viewWithTag:201];
    UIButton *button3 = (id)[self.view viewWithTag:202];

    if (btn.tag == 200) {
        [UIView animateWithDuration:0.5 animations:^{
            scrollview.contentOffset = CGPointMake(0, 0);
            titleView.frame = CGRectMake(WIDTH-240, 20, 200, 44);
            lineView.frame = CGRectMake(12, 40, titleView.frame.size.width/3-24, 2);
            button.selected = YES;
            button2.selected = NO;
            button3.selected = NO;
            [dataArr removeAllObjects];
            [AFManager getReqURL:[NSString stringWithFormat:NEARZHUBO,[USERDEFAULT valueForKey:@"uid"],latitude,lon] block:^(id infor) {
                NSLog(@"%@",infor);
                if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                    NSLog(@"--%@--",infor[@"data"]);
                    [dataArr addObjectsFromArray:infor[@"data"]];
                    [collectionView reloadData];
                    
                }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"202"]){
                    [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"暂时没有主播数据" andSelfVC:self];
                }
            } errorblock:^(NSError *error) {
                
            }];
        }];
        
         
        
    }else if (btn.tag == 201){
        [UIView animateWithDuration:0.5 animations:^{
            scrollview.contentOffset = CGPointMake(WIDTH, 0);
            titleView.frame = CGRectMake(WIDTH/2-200/2, 20, 200, 44);
            lineView.frame = CGRectMake(12+titleView.frame.size.width/3, 40, titleView.frame.size.width/3-24, 2);
            button2.selected = YES;
            button.selected = NO;
            button3.selected = NO;
            [dataArr2 removeAllObjects];
            [AFManager getReqURL:[NSString stringWithFormat:HOTZHUBO,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
                if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
                    NSLog(@"%@",infor[@"data"]);
                    [dataArr2 addObjectsFromArray:infor[@"data"]];
                    [table reloadData];
                    
                }
            } errorblock:^(NSError *error) {
                
            }];
        }];
       
    }else if (btn.tag == 202){
        [UIView animateWithDuration:0.5 animations:^{
            scrollview.contentOffset = CGPointMake(WIDTH*2, 0);
            titleView.frame = CGRectMake(40, 20, 200, 44);
            lineView.frame = CGRectMake(12+titleView.frame.size.width/3*2, 40, titleView.frame.size.width/3-24, 2);
            button3.selected = YES;
            button2.selected = NO;
            button.selected = NO;
//            [AFManager getReqURL:[NSString stringWithFormat:SHOUYEZHUBO,[USERDEFAULT valueForKey:@"uid"]] block:^(id infor) {
//                if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
//                    NSLog(@"%@",infor[@"data"]);
//                    [dataArr3 addObjectsFromArray:infor[@"data"]];
//                    [table2 reloadData];
//                    
//                }
//            } errorblock:^(NSError *error) {
//                
//            }];
        }];
        
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    latitude = [USERDEFAULT valueForKey:@"latitude"];
    lon = [USERDEFAULT valueForKey:@"lon"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"11"]forBarMetrics:UIBarMetricsDefault];
    dataArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    [self.view addSubview:topView];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    backView.image = [UIImage imageNamed:@"11"];
    [topView addSubview:backView];
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH-240, 20, 200, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    [topView addSubview:titleView];
    NSArray *arr = @[@"附近",@"热门",@"关注"];
    for (int i=0; i<3; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(titleView.frame.size.width/3*i, 0, titleView.frame.size.width/3, 44)];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        if (i==0) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        [button setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.tag =200+i;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
    }
    lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 40, titleView.frame.size.width/3-24, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:lineView];
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 32, 13, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-30, 35, 15, 15)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"Shape94"] forState:UIControlStateNormal];
     [rightBtn addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.contentOffset = CGPointMake(0, 64);
    scrollview.contentSize = CGSizeMake(WIDTH*3, 64);
    [self.view addSubview:scrollview];
    //附近
    [self near];
    //热门
    [self hot];
    //关注
    [self guanzhu];
    
    
    
}
-(void)near{
    //筛选
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    secView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:secView];
    UIButton *leftBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, 12.5, 15, 15)];
    [leftBtn2 setBackgroundImage:[UIImage imageNamed:@"附近_03"] forState:UIControlStateNormal];
    [secView addSubview:leftBtn2];
    UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(33, 0, 100, 40)];
    leftLable.text = @"正在直播";
    leftLable.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    leftLable.font = [UIFont systemFontOfSize:12];
    leftLable.textAlignment = NSTextAlignmentLeft;
    [secView addSubview:leftLable];
    
    UIButton *rightBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH-60, 10, 60, 20)];
    [rightBtn2 setTitle:@"筛选" forState:UIControlStateNormal];
    [rightBtn2 setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
    rightBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn2 addTarget:self action:@selector(shaixuan:) forControlEvents:UIControlEventTouchUpInside];
    [secView addSubview:rightBtn2];
    //附近
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, WIDTH, scrollview.frame.size.height-40) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    //    collectionView.bounces = NO;
    [scrollview addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:@"nearCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"str"];
    NSLog(@"%@ %@",latitude,lon);
    [AFManager getReqURL:[NSString stringWithFormat:NEARZHUBO,[USERDEFAULT valueForKey:@"uid"],latitude,lon] block:^(id infor) {
        NSLog(@"%@",infor);

        if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"200"]) {
            NSLog(@"-%@-",infor[@"data"]);
            [dataArr addObjectsFromArray:infor[@"data"]];
            [collectionView reloadData];
            
        }else if ([[NSString stringWithFormat:@"%@",infor[@"code"]] isEqualToString:@"202"]){
            [NSObject wj_alterSingleVCWithOneTitle:@"提示" andTwoTitle:@"暂时没有主播数据" andSelfVC:self];
        }
    } errorblock:^(NSError *error) {
        
    }];
}
-(void)hot{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH, 0, self.view.frame.size.width, 150)];
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
        imageView.image = [UIImage imageNamed:@"热门_02"];
        imageView.tag = 500+i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressView:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        [headScrollView addSubview:imageView];
    }
    table = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH, 0, self.view.frame.size.width, scrollview.frame.size.height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.separatorColor = [UIColor clearColor];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [scrollview addSubview:table];
    dataArr2 = [[NSMutableArray alloc]init];
    table.tableHeaderView = headView;
    table.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];
    [table registerNib:[UINib nibWithNibName:@"hotTableViewCell" bundle:nil] forCellReuseIdentifier:@"str2"];
    if (dataArr2.count == 0) {
        [self nodata];
    }

}
-(void)nodata{
   
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollViews{
    if (scrollViews == headScrollView) {
        int i=scrollViews.contentOffset.x/self.view.frame.size.width;
        pageControl.currentPage = i;
    }
    if (scrollViews == scrollview) {
        int i=scrollview.contentOffset.x/self.view.frame.size.width;
        UIButton *button = (id)[self.view viewWithTag:200];
        UIButton *button2 = (id)[self.view viewWithTag:201];
        UIButton *button3 = (id)[self.view viewWithTag:202];
        if (i==0) {
   
            [UIView animateWithDuration:0.5 animations:^{
                titleView.frame = CGRectMake(WIDTH-240, 20, 200, 44);
                lineView.frame = CGRectMake(12, 40, titleView.frame.size.width/3-24, 2);
                button.selected = YES;
                button2.selected = NO;
                button3.selected = NO;
            }];
            
            
        }else if (i==1){
            [UIView animateWithDuration:0.5 animations:^{
                titleView.frame = CGRectMake(WIDTH/2-200/2, 20, 200, 44);
                lineView.frame = CGRectMake(12+titleView.frame.size.width/3, 40, titleView.frame.size.width/3-24, 2);
                button2.selected = YES;
                button.selected = NO;
                button3.selected = NO;
            }];
        
        }else if (i==2){
            [UIView animateWithDuration:0.5 animations:^{
                titleView.frame = CGRectMake(40, 20, 200, 44);
                lineView.frame = CGRectMake(12+titleView.frame.size.width/3*2, 40, titleView.frame.size.width/3-24, 2);
                button3.selected = YES;
                button2.selected = NO;
                button.selected = NO;
            }];
        }
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == table) {
        static NSString *str = @"str2";
        hotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[hotTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [cell.avatar setImageWithURL:[NSURL URLWithString:dataArr2[indexPath.row][@"head_pic"]]];
        cell.avatar.layer.cornerRadius = 25;
        cell.avatar.layer.masksToBounds = YES;
        [cell.pic setImageWithURL:[NSURL URLWithString:dataArr2[indexPath.row][@"head_pic"]]];
        cell.username.text =dataArr2[indexPath.row][@"nickname"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *str = @"str3";
        shouyeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[shouyeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [cell.avatar setImageWithURL:[NSURL URLWithString:dataArr3[indexPath.row][@"head_pic"]]];
        cell.avatar.layer.cornerRadius = 25;
        cell.avatar.layer.masksToBounds = YES;
        [cell.pic setImageWithURL:[NSURL URLWithString:dataArr3[indexPath.row][@"head_pic"]]];
        cell.username.text =dataArr3[indexPath.row][@"nickname"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == table) {
        return dataArr2.count;
    }else{
        return [dataArr3 count];
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == table) {
        return 270;
    }
    return 265;
}

-(void)pressView:(UITapGestureRecognizer *)tap{
    
}
-(void)guanzhu{
    table2 = [[UITableView alloc]initWithFrame:CGRectMake(WIDTH*2, 0, self.view.frame.size.width, scrollview.frame.size.height) style:UITableViewStylePlain];
    table2.delegate = self;
    table2.dataSource = self;
    table2.showsVerticalScrollIndicator = NO;
    table2.separatorColor = [UIColor clearColor];
    table2.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [scrollview addSubview:table2];
    dataArr3 = [[NSMutableArray alloc]init];
    table2.backgroundColor = [UIColor colorWithRed:237/255.f green:237/255.f blue:237/255.f alpha:1];
    [table2 registerNib:[UINib nibWithNibName:@"shouyeTableViewCell" bundle:nil] forCellReuseIdentifier:@"str3"];


}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionViews layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
 
    return UIEdgeInsetsMake(5, 10, 10, 10);
    
}
-(void)collectionView:(UICollectionView *)collectionViews didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collection cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *str = @"str";
    nearCollectionViewCell *cell = [collection dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    [cell.avatar setImageWithURL:[NSURL URLWithString:dataArr[indexPath.row][@"head_pic"]]];
    cell.juli.text =[NSString stringWithFormat:@"%@米",dataArr[indexPath.row][@"distance"]];
    return cell;
  
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionViews numberOfItemsInSection:(NSInteger)section{
    
    return dataArr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionViews layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((WIDTH-40)/3, (WIDTH-40)/3+30);
    
}

-(void)left:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)right:(UIButton *)btn{
    
}
-(void)shaixuan:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"看全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [defaultAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    UIAlertAction *defaultAction2 = [UIAlertAction actionWithTitle:@"只看男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [defaultAction2 setValue:[UIColor redColor] forKey:@"titleTextColor"];
    UIAlertAction *defaultAction3 = [UIAlertAction actionWithTitle:@"只看女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [defaultAction3 setValue:[UIColor redColor] forKey:@"titleTextColor"];
    UIAlertAction *defaultAction4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [defaultAction4 setValue:[UIColor colorWithWhite:0.5 alpha:1] forKey:@"titleTextColor"];

    [alert addAction:defaultAction];
    [alert addAction:defaultAction2];
    [alert addAction:defaultAction3];
    [alert addAction:defaultAction4];
 
    [self presentViewController:alert animated:YES completion:nil];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
