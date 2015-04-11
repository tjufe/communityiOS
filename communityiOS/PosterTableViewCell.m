//
//  PosterTableViewCell.m
//  communityiOS
//
//  Created by tjufe on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "PosterTableViewCell.h"

@implementation PosterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPosterImage:(UIImageView *)posterImage{
   
       posterImage.layer.masksToBounds = YES;
        [posterImage.layer setCornerRadius:posterImage.layer.frame.size.height/4];
        
  

}

@end
