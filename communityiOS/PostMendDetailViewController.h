//
//  PostMendDetailViewController.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/26.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "forumItem.h"
#import "postItem.h"
#import "forumSetItem.h"
int mend_pop_code;//用于跳转标志
@interface PostMendDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *PDview;
@property (weak, nonatomic) IBOutlet UILabel *forumTitle;
@property (weak, nonatomic) IBOutlet UIButton *btReplyNum;
@property(strong,nonatomic)forumItem *forum_item;
@property (weak, nonatomic) IBOutlet UILabel *replyNum;
@property (weak, nonatomic) IBOutlet UIImageView *replyImage;
@property(strong,nonatomic) NSArray *forumList;//版块列表
//@property (strong,nonatomic) NSString *poster_nickname; //用户昵称
//@property (strong,nonatomic) NSString *Phead_portrait_url; //用户头像
//@property (strong,nonatomic) NSString *reply_num; //评论数
@property(strong,nonatomic) postItem *postitem;//版块列表
@property (nonatomic,strong) NSString *postIDFromOutside;//从轮播图或者推送传来的post_id

@end
