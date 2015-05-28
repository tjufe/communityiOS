//
//  PostTableViewCell.h
//  communityiOS
//
//  Created by tjufe on 15/3/19.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *PostLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UIImageView *postImg;
@property (weak, nonatomic) IBOutlet UIImageView *setTop;
@property (weak, nonatomic) IBOutlet UILabel *poster_nic;
@property (weak, nonatomic) IBOutlet UILabel *post_reply_num;
@property (weak, nonatomic) IBOutlet UILabel *dot_reply;
@property (weak, nonatomic) IBOutlet UILabel *dot_apply;
@property (weak, nonatomic) IBOutlet UIImageView *img_reply;
@property (weak, nonatomic) IBOutlet UIImageView *img_apply;
@property (weak, nonatomic) IBOutlet UILabel *post_apply_num;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *postLabelLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *img_finish;

@end
