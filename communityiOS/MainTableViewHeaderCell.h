//
//  MainTableViewHeaderCell.h
//  communityiOS
//
//  Created by 金钟 on 15/5/21.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *forumNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *breakLineImage;
@property (weak, nonatomic) IBOutlet UIImageView *forumIconImageView;

@property (weak, nonatomic) NSString *forumIconURLStr;

@end
