//
//  ForumTableViewCell.h
//  communityiOS
//
//  Created by 何茂馨 on 15/3/19.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lastNewDate;

@property (weak, nonatomic) IBOutlet UIImageView *forumIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *forumNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNewContentLabel;

@property (weak, nonatomic) UIImage *forumIconImage;
@property (weak, nonatomic) NSString *forumName;
@property (weak, nonatomic) NSString *lastNewContent;
@property (weak,nonatomic) NSString *last_new_date;

@end
