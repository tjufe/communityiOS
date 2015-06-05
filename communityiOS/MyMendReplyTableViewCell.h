//
//  MyMendReplyTableViewCell.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/27.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMendReplyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *replyerHead;
@property (strong, nonatomic) IBOutlet UILabel *replyerNickName;
@property (strong, nonatomic) IBOutlet UILabel *replyTime;
@property (strong, nonatomic) IBOutlet UILabel *replyContent;
@property (strong, nonatomic) IBOutlet UIView *backBubble;

-(void)setReplyContentText:(NSString *)text;
-(void)setBubble:(CGRect)frame;
@end
