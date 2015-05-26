//
//  PostReplyViewController.h
//  communityiOS
//
//  Created by 金钟 on 15/4/8.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postItem.h"
#import "forumSetItem.h"
#import "forumItem.h"


@interface PostReplyViewController : UIViewController<UITextFieldDelegate>

@property (strong ,nonatomic) NSArray *replyList;
@property(strong ,nonatomic) postItem *postItem;
@property (strong,nonatomic) forumItem *forum_item;
@property (strong,nonatomic) forumSetItem *forum_set_item;


@end
