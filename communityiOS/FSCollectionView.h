//
//  FSCollectionview.h
//  communityiOS
//
//  Created by tjufe on 15/4/3.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>
#import "PostEditViewController.h"




@interface FSCollectionview : UICollectionView<UIAlertViewDelegate>

@property (strong,nonatomic)NSIndexPath *index;
@property(strong,nonatomic)UITableView *tb;

@property (strong,nonatomic) NSMutableArray *select_forum;


@property (strong,nonatomic) NSString *select_forum_name;//选择的版块名称
@property (strong,nonatomic) NSString *select_forum_id;//选择的版块id
@property (strong,nonatomic) NSIndexPath *select_row;//选择的索引号
@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
@property (strong,nonatomic) NSArray *moderator;//版主版号
@property (strong,nonatomic) NSArray *forum_list_item;
//@property (strong,nonatomic) UIAlertView *alert;

@property (weak, nonatomic) UIButton *Addpic;
@property (weak, nonatomic) UIButton *Chain;
@property (weak, nonatomic) UIButton *Apply;

@property (strong, nonatomic) NSString *ISMAINIMG1;
@property (strong, nonatomic) NSString *ISAPPLY1;
@property (strong, nonatomic) NSString *ISCHAIN1;
@property (strong, nonatomic) NSString *ISCHECK1;

//@property (strong,nonatomic) PostEditViewController *PEVC;
//@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
//@property (strong,nonatomic) UIAlertView *alert;





-(NSMutableArray *)GetSelectedResult;
-(id)getcelltext:(NSIndexPath *)indexPath:(UITableView*)tableview;
//
//@property(strong,nonatomic)NSString *i;

@end
