//
//  PostDetailViewController.h
//  communityiOS
//
//  Created by tjufe on 15/3/30.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "forumItem.h"
#import "postItem.h"
#import "forumSetItem.h"

int pop_code;//用于跳转标志


@interface PostDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *PDview;
@property (weak, nonatomic) IBOutlet UILabel *forumTitle;
- (IBAction)ReplyNumOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btReplyNum;
@property(strong,nonatomic)forumItem *forum_item;
@property (weak, nonatomic) IBOutlet UILabel *replyNum;
@property (weak, nonatomic) IBOutlet UIImageView *replyImage;
@property(strong,nonatomic) NSArray *forumList;//版块列表
@property (nonatomic,strong) NSString *postIDFromOutside;//从轮播图或者推送传来的post_id

@end
