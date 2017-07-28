//
//  giftView.m
//  zhibotest
//
//  Created by 李壮 on 2016/12/7.
//  Copyright © 2016年 李壮. All rights reserved.
//

#import "giftView.h"
#import "GitCollectionCell.h"
//model
#import "GiftListBase.h"
#import "GiftListData.h"

@interface giftView ()<UICollectionViewDelegate,UICollectionViewDataSource,GitCollectionCellDelegate>
{
    NSInteger selectIndex;
    NSInteger lastIndex;
    BOOL      btnStatus;
    NSMutableArray*giftListAry;
}
@end

@implementation giftView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-F_I6_SIZE(260), DEVICE_WIDTH, F_I6_SIZE(260))];
        _bgView.backgroundColor =[UIColor blackColor];
        _bgView.alpha=0.6;
        [self addSubview:_bgView];
        
        self.payBtn.backgroundColor=[UIColor redColor];
        self.giveBtn.backgroundColor=[UIColor purpleColor];
        self.giveBtn.enabled=NO;
        giftListAry=[NSMutableArray array];
        selectIndex=0;
        lastIndex=1;
        btnStatus=1;
        [self getData];
    }
    return self;
}
- (void)initCollection
{
    if (!_collection) {
        UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        layout.itemSize=CGSizeMake(DEVICE_WIDTH, F_I6_SIZE(100));
        _collection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, F_I6_SIZE(220)) collectionViewLayout:layout];
        _collection.dataSource=self;
        _collection.delegate=self;
        _collection.backgroundColor=[UIColor clearColor];
        [_bgView addSubview:_collection];
        [_collection registerClass:[GitCollectionCell class] forCellWithReuseIdentifier:@"GitCollectionCell"];
    }else{
        [_collection reloadData];
    }
}
- (UIButton*)payBtn
{
    if (!_payBtn) {
        _payBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame=CGRectMake(DEVICE_WIDTH-F_I6_SIZE(135), F_I6_SIZE(225), F_I6_SIZE(60), F_I6_SIZE(20));
        _payBtn.titleLabel.font=[UIFont systemFontOfSize:F_I6_SIZE(12)];
        _payBtn.clipsToBounds=YES;
        _payBtn.layer.cornerRadius=F_I6_SIZE(3);
        [_payBtn setTitle:@"充值>" forState:0];
        [_bgView addSubview:_payBtn];
    }
    return _payBtn;
}
- (UIButton*)giveBtn
{
    if (!_giveBtn) {
        _giveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _giveBtn.frame=CGRectMake(DEVICE_WIDTH-F_I6_SIZE(70), F_I6_SIZE(225), F_I6_SIZE(60), F_I6_SIZE(20));
        _giveBtn.titleLabel.font=[UIFont systemFontOfSize:F_I6_SIZE(12)];
        _giveBtn.clipsToBounds=YES;
        _giveBtn.layer.cornerRadius=F_I6_SIZE(3);
        [_giveBtn setTitle:@"赠送" forState:0];
        [_bgView addSubview:_giveBtn];
    }
    return _giveBtn;
}
//-(UICollectionView*)collection
//{
//    if (!_collection) {
//       
//    }
//    return _collection;
//}
#pragma mark-
#pragma mark-collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return giftListAry.count;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GitCollectionCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"GitCollectionCell" forIndexPath:indexPath];
    [cell btnIndex:indexPath data:giftListAry[indexPath.item]];
    [cell.btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn5 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (selectIndex!=0)
//    {
        [cell setBtnStatus:selectIndex status:btnStatus];
//    }
    cell.delegate=self;
//    cell.myBlock=^(NSInteger btnIndex){
//       
//    };
    return cell;
}
- (void)sendBtnIndex:(NSInteger)btnIndex
{
    NSInteger item=btnIndex/1000;
    NSInteger indexgitf=btnIndex-item*1000;
    NSArray*array=giftListAry[item];
    GiftListData*data=array[indexgitf-1];
    [_delegate giftInfo:data];
}
- (void)btnClick:(UIButton*)btn
{
    if (selectIndex==btn.tag)
    {
        btnStatus=YES;
        self.giveBtn.enabled=NO;
        selectIndex=0;
    }
    else
    {
        btnStatus=NO;
        self.giveBtn.enabled=YES;
        selectIndex=btn.tag;
    }
    [_collection reloadData];
}
#pragma mark-
#pragma mark-数据源方法
- (void)getData
{
    [AFManager getReqURL:GET_GIFT_LIST_URL block:^(id infor)
    {
        if ([[infor objectForKey:@"code"]integerValue]==200)
        {
            GiftListBase*base=[GiftListBase modelObjectWithDictionary:infor];
            NSInteger currentCount=0;
            while (currentCount<base.data.count)
            {
                NSInteger pageNum =(base.data.count-currentCount>5 )?5:base.data.count-currentCount;
                NSArray *newItems =[base.data subarrayWithRange:NSMakeRange(currentCount, pageNum)];
                currentCount+=pageNum;
                [giftListAry addObject:newItems];
            }
            [self initCollection];
        }
    } errorblock:^(NSError *error)
    {
        
    }];
}
@end
