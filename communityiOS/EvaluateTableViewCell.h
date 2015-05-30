//
//  EvaluateTableViewCell.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/29.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
-(void)setReplyContentText:(NSString *)text;

@end
