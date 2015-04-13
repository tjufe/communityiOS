//
//  PosterTableViewCell.h
//  communityiOS
//
//  Created by tjufe on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PosterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postDate;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *poster_nickname;
@property (weak, nonatomic) IBOutlet UIImageView *checkin_user;

@end
