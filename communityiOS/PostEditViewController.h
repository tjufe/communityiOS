//
//  PostEditViewController.h
//  communityiOS
//
//  Created by tjufe on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *chain;
@property (weak, nonatomic) IBOutlet UIButton *push;
@property (weak, nonatomic) IBOutlet UIButton *apply;

-(NSString*)getcell;

@end
