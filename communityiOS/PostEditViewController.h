//
//  PostEditViewController.h
//  communityiOS
//
//  Created by tjufe on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "forumItem.h"
#import "forumSetItem.h"
#import "postItem.h"
extern NSString *const site_addchain;
extern NSString *const site_addapply;
extern NSString *const site_addmainimg;
extern NSString *const site_reply_user;
extern NSString *const site_newpost_user;
extern NSString *const site_isreply;
extern NSString *const site_ischeck;
extern NSString *const site_isbrowse;
bool select_forum_dropdown_isonshowing;//选择板块下拉列表处于正在显示状态

@protocol PostEditViewControllerDelegate <NSObject>

-(void)addpostItem3:(postItem *)PostItem;

@end

@interface PostEditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chain;
@property (weak, nonatomic) IBOutlet UIButton *push;
@property (weak, nonatomic) IBOutlet UIButton *apply;
@property (weak, nonatomic) IBOutlet UIButton *addpic;
@property (strong,nonatomic) NSArray *forum_list_item;
@property(strong,nonatomic)forumItem *forum_item;
@property(strong,nonatomic)postItem *post_item ;
@property(strong,nonatomic)NSString *ED_FLAG;
@property (assign) id<PostEditViewControllerDelegate>delegate;

@end
