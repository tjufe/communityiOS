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
extern NSString *const site_isreply;
extern NSString *const site_ischeck;
extern NSString *const site_isbrowse;


@interface PostEditViewController : UIViewController

@property (strong,nonatomic) UIImage *select_image;//选择上传的图片
@property (strong,nonatomic) NSString *select_image_name;//上传后图片的名字
@property (strong,nonatomic) NSString *select_chain;//上传的外链状态
@property (strong,nonatomic) NSString *select_chain_context;//上传的外链内容
@property (strong,nonatomic) NSString *select_chain_address;//上传的外链地址
@property (strong,nonatomic) NSString *select_open_apply;//上传的是否报名
@property (strong,nonatomic) NSString *select_limit_apply_num;//上传的报名人数限制
@property (strong,nonatomic) NSString *select_post_title;//上传的帖子标题
@property (strong,nonatomic) NSString *select_post_text;//上传的帖子内容
@property (strong,nonatomic) NSString *select_need_check;//上传的帖子是否需要审核
@property (strong,nonatomic) NSString *select_checked;//上传的帖子审核状态



@property (weak, nonatomic) IBOutlet UIButton *chain;
@property (weak, nonatomic) IBOutlet UIButton *push;
@property (weak, nonatomic) IBOutlet UIButton *apply;
@property (weak, nonatomic) IBOutlet UIButton *addpic;

@property (strong,nonatomic) NSArray *forum_list_item;
@property(strong,nonatomic)forumItem *forum_item;
@property(strong,nonatomic)postItem *post_item ;
@property(strong,nonatomic)NSString *ED_FLAG;
-(NSString*)getcell;


@end
