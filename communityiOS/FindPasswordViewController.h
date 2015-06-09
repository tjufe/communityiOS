//
//  FindPasswordViewController.h
//  communityiOS
//
//  Created by tjufe on 15/6/5.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *etPhone;
@property (weak, nonatomic) IBOutlet UITextField *etNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *etConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *etSMS;

- (IBAction)SMSOnclick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btSendSMS;
@property (weak, nonatomic) IBOutlet UIButton *btFindPSure;
@property (weak, nonatomic) IBOutlet UIView *FindPView;
@property (weak, nonatomic) IBOutlet UILabel *Ltime;

- (IBAction)FindPOnClick:(id)sender;

@end
