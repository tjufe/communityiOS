//
//  ViewController.h
//  communityiOS
//
//  Created by 何茂馨 on 15/3/18.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController 
@property (weak, nonatomic) IBOutlet UIButton *newpost;
@property (weak, nonatomic) IBOutlet UIButton *btnNickname;

@property(nonatomic,strong)NSString *name;

+(NSArray *)getForumList;
@end

