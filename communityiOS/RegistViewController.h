//
//  RegistViewController.h
//  communityiOS
//
//  Created by 何茂馨 on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfNickname;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfSecondPassword;
- (IBAction)View_TouchDown:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tfSMSCode;
@property (weak, nonatomic) IBOutlet UILabel *ltime;

@end
