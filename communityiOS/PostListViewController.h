//
//  PostListViewController.h
//  communityiOS
//
//  Created by tjufe on 15/3/19.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "postItem.h"
#import "forumItem.h"

extern NSString *const site_newpost_user;


@protocol PostListViewControllerDelegate <NSObject>

-(void)addpostItem:(postItem *)PostItem;

@end

@interface PostListViewController : UIViewController
@property(strong,nonatomic)postItem *PostItem;
@property(strong,nonatomic)forumItem *forum_item;//viewcontroller页传值
@property(strong,nonatomic) NSString *forum_id;//删除帖子后detail页传值
@property(strong,nonatomic) NSString *community_id;
//@property (strong,nonatomic) NSString *PL_EDIT;
@property (assign) id<PostListViewControllerDelegate>delegate;
@end
