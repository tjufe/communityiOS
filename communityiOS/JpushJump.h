//
//  JpushJump.h
//  communityiOS
//
//  Created by 金钟 on 15/6/8.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JpushJump : NSObject

+(instancetype)sharedJumper;

-(UIViewController *)getCurrentVC;

@end
