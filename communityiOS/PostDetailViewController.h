//
//  PostDetailViewController.h
//  communityiOS
//
//  Created by tjufe on 15/3/30.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "forumItem.h"

@interface PostDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *PDview;
@property(strong,nonatomic)forumItem *forum_item;
@property (strong,nonatomic) NSString *poster_nickname; //用户昵称
@property (strong,nonatomic) NSString *Phead_portrait_url; //用户头像
@property (strong,nonatomic) NSString *reply_num; //评论数

@property (weak, nonatomic) IBOutlet UITextView *reply_text;
@property (weak, nonatomic) IBOutlet UIImageView *user_head;


-(void)getHeadPortraitUrl:(NSString*)url;
@end
