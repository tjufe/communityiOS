//
//  ReplyitemTableViewCell.h
//  communityiOS
//
//  Created by 金钟 on 15/4/14.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyitemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *reply_head;
@property (weak, nonatomic) IBOutlet UILabel *Rnickname;
@property (weak, nonatomic) IBOutlet UILabel *Rtext;

@property (weak, nonatomic) IBOutlet UILabel *Rdate;

@end
