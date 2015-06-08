//
//  MendRplyTableViewCell.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/27.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MendRplyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *replyerHead;
@property (strong, nonatomic) IBOutlet UILabel *replyerNickName;
@property (strong, nonatomic) IBOutlet UILabel *replyTime;

-(void)setReplyContentText:(NSString *)text;

@end
