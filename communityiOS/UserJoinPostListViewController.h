//
//  UserJoinPostListViewController.h
//  communityiOS
//
//  Created by tjufe on 15/5/8.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postItem.h"


@protocol UserJoinPostListViewControllerDelegate <NSObject>

-(void)addpostItem2:(postItem *)PostItem;

@end


@interface UserJoinPostListViewController : UIViewController
@property (assign) id<UserJoinPostListViewControllerDelegate>delegate;

@end
