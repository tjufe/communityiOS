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

    //Configure the view for the selected state
}

-(void)setReplyContentText:(NSString *)text{
    
    //绘制label
    UILabel *replyContent = [[UILabel alloc]initWithFrame:CGRectMake(208, 51, 42, 30)];
    replyContent.text = text;
    replyContent.numberOfLines = 10;
    replyContent.lineBreakMode = NSLineBreakByWordWrapping;
    replyContent.font = [UIFont systemFontOfSize:15.0];
    replyContent.textAlignment = NSTextAlignmentLeft;
    //获得当前cell高度
    CGRect frame = [self frame];
    CGSize size = CGSizeMake(200, 1000);
    CGSize labelSize = [replyContent.text sizeWithFont:replyContent.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    if ( [ UIScreen mainScreen ].bounds.size.width < 375) {
        replyContent.frame = CGRectMake(self.frame.size.width-labelSize.width-self.replyerHead.frame.size.width-25, replyContent.frame.origin.y, labelSize.width , labelSize.height);
    }else if([ UIScreen mainScreen ].bounds.size.width == 375){
        replyContent.frame = CGRectMake(self.frame.size.width-labelSize.width-self.replyerHead.frame.size.width + 33, replyContent.frame.origin.y, labelSize.width , labelSize.height);
    }else if([ UIScreen mainScreen ].bounds.size.width == 414){
        replyContent.frame = CGRectMake(self.frame.size.width-labelSize.width-self.replyerHead.frame.size.width + 68, replyContent.frame.origin.y, labelSize.width , labelSize.height);
    }
    //计算出自适应高度
    frame.size.height = labelSize.height + 50;
    self.frame = frame;
    
    //绘制对话泡泡
    UIImage *bubble = [UIImage imageNamed:@"SenderTextNodeBkg"];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    bubbleImageView.frame = CGRectMake(replyContent.frame.origin.x - 10 , replyContent.frame.origin.y - 7,replyContent.frame.size.width +27,replyContent.frame.size.height + 15);
    [self.contentView insertSubview:bubbleImageView atIndex:0];
    [self.contentView addSubview:replyContent];
    
}



@end
