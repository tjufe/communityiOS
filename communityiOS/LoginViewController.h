//
//  LoginViewController.h
//  communityiOS
//
//  Created by 何茂馨 on 15/3/19.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import <UIKit/UIKit.h>

@class loginItem,LoginViewController;
@protocol LoginViewControllerDelegate <NSObject>
@optional
-(void)addUser:(LoginViewController *)addVc didAddUser:(NSString *)login_id;
@end

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *LoginImage;
@property (strong, nonatomic) UIImage* loimage;
- (IBAction)View_TouchDown:(id)sender;
@property (nonatomic,assign) id<LoginViewControllerDelegate>delegate;
@end
