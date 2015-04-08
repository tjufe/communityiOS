//
//  ImageTableViewCell.m
//  communityiOS
//
//  Created by tjufe on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "DialogView.h"

@implementation ImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onClick:(id)sender {
     DialogView *dg = [[DialogView alloc]initWithFrame:CGRectMake(30, 60, 260, 400)];
    [self.contentView addSubview:dg];
    
    
}

@end
