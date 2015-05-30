//
//  EvaluateTableViewCell.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/29.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "EvaluateTableViewCell.h"

@implementation EvaluateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setReplyContentText:(NSString *)text{
    
    CGRect frame = self.frame;
    self.messageLabel.text = text;
    self.messageLabel.numberOfLines = 10;
    CGSize size = CGSizeMake(160, 1000);
    CGSize labelSize = [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.messageLabel.frame = CGRectMake(self.messageLabel.frame.origin.x, self.messageLabel.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height = labelSize.height+50;
    self.frame = frame;
    
}
@end
