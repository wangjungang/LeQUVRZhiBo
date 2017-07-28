//
//  GitCollectionCell.m
//  zhibotest
//
//  Created by 李壮 on 2016/12/7.
//  Copyright © 2016年 李壮. All rights reserved.
//

#import "GitCollectionCell.h"
#define WIDTH_VIEW (DEVICE_WIDTH-F_I6_SIZE(40)-F_I6_SIZE(40)*5)/4.0
@implementation GitCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        for (NSInteger i=0; i<5; i++)
        {
            UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(F_I6_SIZE(20)+i*(WIDTH_VIEW+F_I6_SIZE(40)), F_I6_SIZE(10), F_I6_SIZE(40), F_I6_SIZE(40))];
            imageView.tag=i+10000000;
            imageView.hidden=YES;
            [self.contentView addSubview:imageView];
            
            UILabel*titleLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(20)+i*(WIDTH_VIEW+F_I6_SIZE(40)), F_I6_SIZE(50), F_I6_SIZE(40), F_I6_SIZE(20))];
            titleLb.textColor=[UIColor whiteColor];
            titleLb.tag=i+1000000;
            titleLb.hidden=YES;
            [self.contentView addSubview:titleLb];
            titleLb.textAlignment=1;
            titleLb.font=[UIFont systemFontOfSize:F_I6_SIZE(12)];
            
            UILabel*numLb=[[UILabel alloc]initWithFrame:CGRectMake(F_I6_SIZE(40)+i*(WIDTH_VIEW+F_I6_SIZE(40)), F_I6_SIZE(70), F_I6_SIZE(40), F_I6_SIZE(12))];
            numLb.font=[UIFont systemFontOfSize:F_I6_SIZE(12)];
            numLb.tag=i+10000;
            numLb.textColor=[UIColor whiteColor];
            numLb.hidden=YES;
            [self.contentView addSubview:numLb];
            
            UIImageView*golbImage=[[UIImageView alloc]initWithFrame:CGRectMake(F_I6_SIZE(30)+i*(WIDTH_VIEW+F_I6_SIZE(40)), F_I6_SIZE(72), F_I6_SIZE(10), F_I6_SIZE(10))];
            golbImage.image=[UIImage imageNamed:@"设置-帮助与反馈_03.png"];
            golbImage.clipsToBounds=YES;
            golbImage.layer.cornerRadius=5;
            golbImage.hidden=YES;
            golbImage.tag=i+100;
            [self.contentView addSubview:golbImage];
            
        }
        _btn1=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn2=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn3=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn4=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn5=[UIButton buttonWithType:UIButtonTypeCustom];
        
        _btn6=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn7=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn8=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn9=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn10=[UIButton buttonWithType:UIButtonTypeCustom];


        [self.contentView addSubview:_btn1];
        [self.contentView addSubview:_btn2];
        [self.contentView addSubview:_btn3];
        [self.contentView addSubview:_btn4];
        [self.contentView addSubview:_btn5];
        [self.contentView addSubview:_btn6];
        [self.contentView addSubview:_btn7];
        [self.contentView addSubview:_btn8];
        [self.contentView addSubview:_btn9];
        [self.contentView addSubview:_btn10];


        _btn1.frame=CGRectMake(F_I6_SIZE(20), F_I6_SIZE(0), F_I6_SIZE(40), F_I6_SIZE(40));
        _btn2.frame=CGRectMake(F_I6_SIZE(20)+(WIDTH_VIEW)+F_I6_SIZE(40), F_I6_SIZE(0), F_I6_SIZE(40), F_I6_SIZE(40));
        _btn3.frame=CGRectMake(F_I6_SIZE(20)+2*((WIDTH_VIEW)+F_I6_SIZE(40)), F_I6_SIZE(0), F_I6_SIZE(40), F_I6_SIZE(40));
        _btn4.frame=CGRectMake(F_I6_SIZE(20)+3*((WIDTH_VIEW)+F_I6_SIZE(40)), F_I6_SIZE(0), F_I6_SIZE(40), F_I6_SIZE(40));
        _btn5.frame=CGRectMake(F_I6_SIZE(20)+4*((WIDTH_VIEW)+F_I6_SIZE(40)), F_I6_SIZE(0), F_I6_SIZE(40), F_I6_SIZE(40));
        
        _btn6.frame=CGRectMake(F_I6_SIZE(65)+0*(WIDTH_VIEW+F_I6_SIZE(40)), F_I6_SIZE(10), F_I6_SIZE(15), F_I6_SIZE(15));
        _btn7.frame=CGRectMake(F_I6_SIZE(65)+1*(WIDTH_VIEW+F_I6_SIZE(40)), F_I6_SIZE(10), F_I6_SIZE(15), F_I6_SIZE(15));
        _btn8.frame=CGRectMake(F_I6_SIZE(65)+2*(WIDTH_VIEW+F_I6_SIZE(40)), F_I6_SIZE(10), F_I6_SIZE(15), F_I6_SIZE(15));
        _btn9.frame=CGRectMake(F_I6_SIZE(65)+3*((WIDTH_VIEW)+F_I6_SIZE(40)), F_I6_SIZE(10), F_I6_SIZE(15), F_I6_SIZE(15));
        _btn10.frame=CGRectMake(F_I6_SIZE(65)+4*((WIDTH_VIEW)+F_I6_SIZE(40)), F_I6_SIZE(10), F_I6_SIZE(15), F_I6_SIZE(15));
        
        
//        [_btn1 setTitle:@"1" forState:UIControlStateNormal];
//        [_btn1 setTitle:@"2" forState:UIControlStateSelected];
//        
//        [_btn2 setTitle:@"1" forState:UIControlStateNormal];
//        [_btn2 setTitle:@"2" forState:UIControlStateSelected];
//        
//        [_btn3 setTitle:@"1" forState:UIControlStateNormal];
//        [_btn3 setTitle:@"2" forState:UIControlStateSelected];
//        
//        [_btn4 setTitle:@"1" forState:UIControlStateNormal];
//        [_btn4 setTitle:@"2" forState:UIControlStateSelected];
//        
//        [_btn5 setTitle:@"1" forState:UIControlStateNormal];
//        [_btn5 setTitle:@"2" forState:UIControlStateSelected];
        
        [_btn6 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_06.png"] forState:UIControlStateNormal];
        [_btn6 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_03.png"] forState:UIControlStateSelected];
        
        [_btn7 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_06.png"] forState:UIControlStateNormal];
        [_btn7 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_03.png"] forState:UIControlStateSelected];
        
        [_btn8 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_06.png"] forState:UIControlStateNormal];
        [_btn8 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_03.png"] forState:UIControlStateSelected];
        
        [_btn9 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_06.png"] forState:UIControlStateNormal];
        [_btn9 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_03.png"] forState:UIControlStateSelected];
        
        [_btn10 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_06.png"] forState:UIControlStateNormal];
        [_btn10 setBackgroundImage:[UIImage imageNamed:@"直播-礼物---副本_03.png"] forState:UIControlStateSelected];
        

    }
    return self;
}
- (void)btnIndex:(NSIndexPath*)indexPath data:(NSArray*)data 
{
    _btn1.tag=indexPath.item*1000+1;
    _btn2.tag=indexPath.item*1000+2;
    _btn3.tag=indexPath.item*1000+3;
    _btn4.tag=indexPath.item*1000+4;
    _btn5.tag=indexPath.item*1000+5;
    
    _btn6.tag=_btn1.tag+110;
    _btn7.tag=_btn2.tag+110;
    _btn8.tag=_btn3.tag+110;
    _btn9.tag=_btn4.tag+110;
    _btn10.tag=_btn5.tag+110;

    _btn1.hidden=data.count<1;
    _btn2.hidden=data.count<2;
    _btn3.hidden=data.count<3;
    _btn4.hidden=data.count<4;
    _btn5.hidden=data.count<5;
    
    _btn6.hidden=data.count<1;
    _btn7.hidden=data.count<2;
    _btn8.hidden=data.count<3;
    _btn9.hidden=data.count<4;
    _btn10.hidden=data.count<5;
    for (NSInteger i=0; i<5; i++)
    {
        UIImageView*image=(UIImageView*)[self.contentView viewWithTag:i+10000000];
        image.hidden=YES;
        UILabel*numLb=(UILabel*)[self.contentView viewWithTag:i+10000];
        numLb.hidden=YES;
        UIImageView*golbImage=(UIImageView*)[self.contentView viewWithTag:i+100];
        golbImage.hidden=YES;
        UILabel*titleLb=(UILabel*)[self.contentView viewWithTag:i+1000000];
        titleLb.hidden=YES;
    }
    for (NSInteger i=0; i<data.count; i++)
    {
        GiftListData*giftData=data[i];
        UIImageView*image=(UIImageView*)[self.contentView viewWithTag:i+10000000];
        [image setImageWithURL:[NSURL URLWithString:giftData.pic]];
        image.hidden=NO;
        UILabel*numLb=(UILabel*)[self.contentView viewWithTag:i+10];
        numLb.text=[NSString stringWithFormat:@"%@",giftData.price];
        numLb.hidden=NO;
        UIImageView*golbImage=(UIImageView*)[self.contentView viewWithTag:i+100];
        golbImage.hidden=NO;
        UILabel*titleLb=(UILabel*)[self.contentView viewWithTag:i+1000000];
        titleLb.text=giftData.gname;
        titleLb.hidden=NO;
    }
   
}

- (void)setBtnStatus:(NSInteger)index status:(BOOL)btnStatus
{
    self.btnIndex=index;
    UIButton*btn=(UIButton*)[self.contentView viewWithTag:index+110];
    if (btnStatus)
    {
//        _btn1.selected=NO;
//        _btn2.selected=NO;
//        _btn3.selected=NO;
//        _btn4.selected=NO;
//        _btn5.selected=NO;
        _btn6.selected=NO;
        _btn7.selected=NO;
        _btn8.selected=NO;
        _btn9.selected=NO;
        _btn10.selected=NO;
    }else
    {
//        _btn1.selected=NO;
//        _btn2.selected=NO;
//        _btn3.selected=NO;
//        _btn4.selected=NO;
//        _btn5.selected=NO;
        _btn6.selected=NO;
        _btn7.selected=NO;
        _btn8.selected=NO;
        _btn9.selected=NO;
        _btn10.selected=NO;
        btn.selected=YES;
//        self.myBlock(self.btnIndex);
        [_delegate sendBtnIndex:self.btnIndex];
            
        
    }
}
//- (void)btnClick:(UIButton*)btn
//{
//    if (!_selectBtn)
//    {
//        
//    }else
//    {
//        _selectBtn.selected=NO;
//    }
//    _selectBtn=btn;
//    btn.selected=YES;
//    NSLog(@"================%ld==============",btn.tag);
//}
@end
