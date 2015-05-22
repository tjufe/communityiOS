//
//  ApplyTableViewCell.h
//  communityiOS
//
//  Created by 何茂馨 on 15/5/14.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAColourfulProgressView.h"
@interface ApplyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet EAColourfulProgressView *pvApply;
@property (weak, nonatomic) IBOutlet UILabel *applyNum;
@property (weak, nonatomic) IBOutlet UILabel *limitApplyNum;




@property (weak, nonatomic) IBOutlet UIButton *btApply;


@end
