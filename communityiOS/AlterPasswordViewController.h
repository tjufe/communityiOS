//
//  AlterPasswordViewController.h
//  communityiOS
//
//  Created by 何茂馨 on 15/4/9.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlterPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tf_OldPsw;
@property (weak, nonatomic) IBOutlet UITextField *tf_NewPsw;
@property (weak, nonatomic) IBOutlet UITextField *tf_SecPsw;
- (IBAction)View_TouchDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtn;

@end
