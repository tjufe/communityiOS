//
//  FSCollectionview.h
//  communityiOS
//
//  Created by tjufe on 15/4/3.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostEditViewController.h"


@interface FSCollectionview : UICollectionView
@property (weak,nonatomic)NSIndexPath *index;
@property(weak,nonatomic)UITableView *tb;

@property (strong,nonatomic) NSMutableArray *forum_id;
@property (strong,nonatomic) NSMutableArray *forum_name;


-(id)getcelltext:(NSIndexPath *)indexPath:(UITableView*)tableview;
//
//@property(strong,nonatomic)NSString *i;

@end
