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
extern NSString *const site_newpost_user;

@interface PostEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *chain;
@property (weak, nonatomic) IBOutlet UIButton *push;
@property (weak, nonatomic) IBOutlet UIButton *apply;

@property (strong,nonatomic) NSArray *forum_list_item;
@property(strong,nonatomic)forumItem *forum_item;
@property(strong,nonatomic)postItem *post_item ;
@property(strong,nonatomic)NSString *ED_FLAG;
-(NSString*)getcell;

@end
