//
//  MainTableViewHeaderCell.m
//  communityiOS
//
//  Created by 金钟 on 15/5/21.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "MainTableViewHeaderCell.h"
#import "UIImageView+WebCache.h"

@implementation MainTableViewHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setForumIconURLStr:(NSString *)forumIconURLStr{
    [self.forumIconImageView sd_setImageWithURL:[NSURL URLWithString:[forumIconURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.forumIconImageView.image = image;
    }];

}
@end
