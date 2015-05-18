//
//  ForumTableViewCell.m
//  communityiOS
//
//  Created by 何茂馨 on 15/3/19.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import "ForumTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ForumTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setForumIconImage:(NSString *)forumIconImage {
    //lx 20150508
    [_forumIconImageView sd_setImageWithURL:[NSURL URLWithString:[forumIconImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _forumIconImageView.image = image;
    }];
    _forumIconImageView.contentMode=UIViewContentModeScaleAspectFill;
}

- (void)setForumName:(NSString *)forumName {
    _forumNameLabel.text=forumName;
}

- (void)setLastNewContent:(NSString *)lastNewContent {
    _lastNewContentLabel.text=lastNewContent;
}

//lx 20150513
-(void)setLast_new_date:(NSString *)last_new_date{
    _lastNewDate.text = last_new_date;
}
@end
