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
    
    //绘制label
    UILabel *replyContent = [[UILabel alloc]init];
    replyContent.text = text;
    replyContent.numberOfLines = 10;
    replyContent.lineBreakMode = NSLineBreakByWordWrapping;
    replyContent.font = [UIFont systemFontOfSize:15.0];
    replyContent.textAlignment = NSTextAlignmentLeft;
    //获得当前cell高度
    CGRect frame = [self frame];
    CGSize size = CGSizeMake(200, 1000);
    CGSize labelSize = [replyContent.text sizeWithFont:replyContent.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    replyContent.frame = CGRectMake(65, 51, labelSize.width, labelSize.height);
    //计算出自适应高度
    frame.size.height = labelSize.height + 50;
    self.frame = frame;
    
    //绘制对话泡泡
    UIImage *bubble = [UIImage imageNamed:@"ReceiverVoiceNodeDownloading"];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    bubbleImageView.frame = CGRectMake(replyContent.frame.origin.x - 15,replyContent.frame.origin.y - 7, labelSize.width + 20, labelSize.height + 20);
    [self.contentView insertSubview:bubbleImageView atIndex:0];
    [self.contentView addSubview:replyContent];
   
}



@end
