//
//  PostReplyViewController.h
//  communityiOS
//
//  Created by 金钟 on 15/4/8.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postItem.h"


@interface PostReplyViewController : UIViewController

@property (strong ,nonatomic) NSArray *replyList;
@property(strong ,nonatomic) postItem *postItem;
@end
