//
//  UIAlertView+Blocks.h
//  communityiOS
//
//  Created by 金钟 on 15/6/8.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef void (^DismissBlock)(int buttonIndex);
typedef void (^CancelBlock)();


@interface UIAlertView (Blocks) <UIAlertViewDelegate>


+ (UIAlertView*) showAlertViewWithTitle:(NSString*) title
                                message:(NSString*) message
                      cancelButtonTitle:(NSString*) cancelButtonTitle
                      otherButtonTitles:(NSArray*) otherButtons
                              onDismiss:(DismissBlock) dismissed
                               onCancel:(CancelBlock) cancelled;


@end

