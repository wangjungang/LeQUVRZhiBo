//
//  upView.h
//  LeQuVRZhiBo
//
//  Created by lhb on 16/12/7.
//  Copyright © 2016年 lhb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol selectIndex <NSObject>
-(void)selectIndexNum:(NSString *)string;
@end
@interface upView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) id<selectIndex> delegate;

@end
