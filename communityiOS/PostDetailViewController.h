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
@property (weak, nonatomic) IBOutlet UITextView *reply_text;
@property (weak, nonatomic) IBOutlet UIImageView *user_head;
@property (weak, nonatomic) IBOutlet UILabel *reply_num;


-(void)getHeadPortraitUrl:(NSString*)url;
@end
