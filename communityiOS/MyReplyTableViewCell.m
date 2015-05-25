//
//  MyReplyTableViewCell.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/23.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "MyReplyTableViewCell.h"

@implementation MyReplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setReplyContentText:(NSString *)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.replyContent.text = text;
    //设置label的最大行数
    self.replyContent.numberOfLines = 10;
    CGSize size = CGSizeMake(254, 1000);
    CGSize labelSize = [self.replyContent.text sizeWithFont:self.replyContent.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.replyContent.frame = CGRectMake(self.replyContent.frame.origin.x, self.replyContent.frame.origin.y, labelSize.width, labelSize.height);
    //计算出自适应高度
    frame.size.height = labelSize.height + 50;
    self.frame = frame;
    
    
}

@end
