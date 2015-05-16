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


//extern NSString *const TOPIC_PIC_PATH;//图片路径
//extern NSString *const URL_SERVICE;//服务器路径
//extern NSString *const HEAD_PIC_PATH;//头像路径



@protocol PostListViewControllerDelegate <NSObject>

-(void)addpostItem:(postItem *)PostItem;

@end

@interface PostListViewController : UIViewController
@property(strong,nonatomic)postItem *PostItem;
@property(strong,nonatomic)forumItem *forum_item;//viewcontroller页传值
@property(strong,nonatomic) NSString *forum_id;//删除帖子后detail页传值
@property(strong,nonatomic) NSString *community_id;
@property(strong,nonatomic) NSString *filter_flag;
@property(strong,nonatomic) NSArray *forumlist;//版块列表

//@property (strong,nonatomic) NSString *pl_go;//跳页标志

@property (assign) id<PostListViewControllerDelegate>delegate;
@end
