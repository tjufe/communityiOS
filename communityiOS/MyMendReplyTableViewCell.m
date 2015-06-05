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
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.replyContent.text = text;
    //设置label的最大行数
    self.replyContent.numberOfLines = 10;
    CGSize size = CGSizeMake(200, 1000);
    CGSize labelSize = [self.replyContent.text sizeWithFont:self.replyContent.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    if (labelSize.width < 190) {
        self.replyContent.textAlignment = UITextAlignmentRight;
        self.replyContent.frame = CGRectMake(self.frame.size.width - labelSize.width - self.replyerHead.frame.size.width+15 , self.replyContent.frame.origin.y, labelSize.width, labelSize.height);
        
        NSLog(@"%f",self.replyContent.frame.size.width);
        NSLog(@"%f",self.replyContent.frame.origin.x);
        NSLog(@"%f",self.frame.size.width - labelSize.width - self.replyerHead.frame.size.width );
        NSLog(@"%f",labelSize.width );
    }else{
        self.replyContent.textAlignment = UITextAlignmentLeft;
        self.replyContent.frame = CGRectMake(self.replyContent.frame.origin.x , self.replyContent.frame.origin.y, labelSize.width, labelSize.height);
        
        NSLog(@"%f",self.replyContent.frame.size.width);
        NSLog(@"%f",self.replyContent.frame.origin.x);
        NSLog(@"%f",self.frame.size.width - labelSize.width - self.replyerHead.frame.size.width );
        NSLog(@"%f",labelSize.width );


    }
   
    //计算出自适应高度
    frame.size.height = labelSize.height + 50;
    self.frame = frame;
    
    //绘制对话泡泡
    UIImage *bubble = [UIImage imageNamed:@"SenderTextNodeBkg"];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    bubbleImageView.frame = CGRectMake(self.replyContent.frame.origin.x - 7, self.replyContent.frame.origin.y - 7, labelSize.width+15 , labelSize.height + 20);
    [self.contentView insertSubview:bubbleImageView atIndex:0];
    
}



@end
