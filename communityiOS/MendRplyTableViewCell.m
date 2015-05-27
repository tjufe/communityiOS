//
//  MendRplyTableViewCell.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/27.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "MendRplyTableViewCell.h"

@implementation MendRplyTableViewCell

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
    self.replyContent.frame = CGRectMake(self.replyContent.frame.origin.x, self.replyContent.frame.origin.y+5, labelSize.width, labelSize.height);
    //计算出自适应高度
    frame.size.height = labelSize.height + 50;
    self.frame = frame;
    
//    int offset = self.replyerNickName.frame.size.width - self.replyContent.frame.size.width;
//    CGRect backFrame ;
//    if (offset > 0) {
//        backFrame = CGRectMake(self.replyContent.frame.origin.x -15, self.replyContent.frame.origin.y-6, self.replyerNickName.frame.size.width, labelSize.height + self.replyerNickName.frame.size.height );
//    }else{
//        backFrame = CGRectMake(self.replyContent.frame.origin.x-15, self.replyContent.frame.origin.y-6, self.replyContent.frame.size.width, labelSize.height + self.replyerNickName.frame.size.height);
//    }
    
    UIImage *bubble = [UIImage imageNamed:@"ReceiverVoiceNodeDownloading"];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    bubbleImageView.frame = CGRectMake(self.replyContent.frame.origin.x - 15, self.replyContent.frame.origin.y - 7, labelSize.width + 50, labelSize.height + 20);
    [self.contentView insertSubview:bubbleImageView atIndex:0];
   
}



@end
