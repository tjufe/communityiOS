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
    CGSize size = CGSizeMake(200, 1000);
    CGSize labelSize = [self.replyContent.text sizeWithFont:self.replyContent.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.replyContent.frame = CGRectMake(self.contentView.frame.size.width - labelSize.width - self.replyerHead.frame.size.width - 30, self.replyContent.frame.origin.y, labelSize.width, labelSize.height);
    //计算出自适应高度
    frame.size.height = labelSize.height + 50;
    self.frame = frame;
    
//    int s_offset = self.replyerNickName.frame.size.width - self.replyContent.frame.size.width;
//    CGRect s_backFrame ;
//    if (s_offset > 0) {
//        s_backFrame = CGRectMake(self.replyContent.frame.origin.x -15, self.replyContent.frame.origin.y-6, self.replyerNickName.frame.size.width, labelSize.height  );
//    }else{
//        s_backFrame = CGRectMake(self.replyContent.frame.origin.x-15, self.replyContent.frame.origin.y-6, self.replyContent.frame.size.width, labelSize.height );
//    }
   // NSLineBreakByClipping
    UIImage *bubble = [UIImage imageNamed:@"SenderTextNodeBkg"];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    bubbleImageView.frame = CGRectMake(self.replyContent.frame.origin.x - 26, self.replyContent.frame.origin.y - 7, labelSize.width + 50, labelSize.height + 20);
    [self.contentView insertSubview:bubbleImageView atIndex:0];
    
}



@end
