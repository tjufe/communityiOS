//
//  PostListViewController.h
//  communityiOS
//
//  Created by tjufe on 15/3/19.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postItem.h"
#import "forumItem.h"

@protocol PostListViewControllerDelegate <NSObject>

-(void)addpostItem:(postItem *)PostItem;

@end

@interface PostListViewController : UIViewController
@property(strong,nonatomic)postItem *PostItem;
@property(strong,nonatomic)forumItem *forum_item;
@property (assign) id<PostListViewControllerDelegate>delegate;
@end
