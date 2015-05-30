//
//  NewPostEditViewController.h
//  communityiOS
//
//  Created by 金钟 on 15/5/22.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "forumItem.h"
#import "postItem.h"

@interface NewPostEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;


@property(strong,nonatomic)forumItem *forum_item;
@property (strong,nonatomic)postItem *post_item;
@property(strong,nonatomic)NSString *ED_FLAG;

@end
