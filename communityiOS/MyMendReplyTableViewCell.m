//
//  MyMendReplyTableViewCell.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/27.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "MyMendReplyTableViewCell.h"

@implementation MyMendReplyTableViewCell

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
    
    int offset = self.replyerNickName.frame.size.width - labelSize.width;
    CGRect backFrame;
    if (offset > 0) {
        backFrame = CGRectMake(self.replyerNickName.frame.origin.x - 2, self.replyerNickName.frame.origin.y-2, self.replyerNickName.frame.size.width+2, labelSize.height + self.replyerNickName.frame.size.height -5);
    }else{
        backFrame = CGRectMake(self.replyerNickName.frame.origin.x, self.replyerNickName.frame.origin.y-2, labelSize.width+2, labelSize.height + self.replyerNickName.frame.size.height -5);
    }
    self.backBubble.layer.cornerRadius = 10;
    self.backBubble.frame = backFrame;
    
}



@end
