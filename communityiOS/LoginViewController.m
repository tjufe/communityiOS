//
//  LoginViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/3/19.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import "LoginViewController.h"
#include "ViewController.h"
#import "PPRevealSideViewController.h"
#import "APIClient.h"
#import "loginItem.h"
#import "StatusTool.h"


@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *uiViewLogin;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *remberSwitch;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong,nonatomic) loginItem *loginItem;
- (IBAction)loginAction;
@end

@implementation LoginViewController

- (IBAction)phoneChanged:(id)sender {
    UITextField *p=(UITextField*) sender;
    if(p.text.length==11){
        [self.loginButton setBackgroundColor:[UIColor redColor]];
        [self.loginButton setEnabled:YES];
    }else{
        [self.loginButton setBackgroundColor:[UIColor grayColor]];
        [self.loginButton setEnabled:NO];
    }
}

-(void)textDidChange:(NSNotification *)notification{
    if(self.phoneTextField.text.length==11){
        [self.loginButton setBackgroundColor:[UIColor redColor]];
        [self.loginButton setEnabled:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.remberSwitch.on forKey:@"didRemeber"];
//    [[NSUserDefaults standardUserDefaults] set];
}

#pragma mark--跳转位置
- (IBAction)exit:(id)sender {
    [self doExit];
}

- (void) doExit {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:view];
    
    [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.loginButton.layer setCornerRadius:4];
    [self.uiViewLogin.layer setCornerRadius:4];
}

-(void)setLoimage:(UIImage *)loimage{

    _LoginImage.image = loimage;
    _LoginImage.layer.masksToBounds = YES ;
    [_LoginImage.layer setCornerRadius:_LoginImage.frame.size.width/2];
    _LoginImage.contentMode = UIViewContentModeScaleAspectFill;
        

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}


- (IBAction)loginAction {
    
    [StatusTool statusToolGetUserLoginWithName:[self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                      PassWord:[self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                       Success:^(id object) {
                                           
                                           NSLog(@"%@",object);
                                           [self checkLoginResult:object];
                                           
                                       } failurs:^(NSError *error) {
                                           NSLog(@"%@",error);
                                       }];
 
}

#pragma mark --检查登录结果hmx
- (void) checkLoginResult: (id)loginResult {
    loginItem *loginItem=loginResult;
    if(loginItem.LoginSucceed){
        [self saveIntoLoc:loginItem];//保存在本地
        [self doExit];//退出本页
    }else{
        [self showErrMsg:loginItem.ErrorMessage];//显示登录失败报错
        [self reduceLoginInfoFormLoc];
    }
}

#pragma mark --清除本地保存的历史登录信息hmx
- (void) reduceLoginInfoFormLoc {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"UserNickname"];
    [defaults setObject:nil forKey:@"PhoneNumber"];
    [defaults setObject:nil forKey:@"HeadPortraitUrl"];
    [defaults setObject:@"" forKey:@"UserPermission"];
    [defaults setObject:nil forKey:@"LoginPassword"];
    [defaults setBool:NO forKey:@"Logged"];
    [defaults synchronize];  //保持同步
}

#pragma mark --保存在本地hmx
- (void) saveIntoLoc: (loginItem *)loginItem {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:loginItem.checkin_community_id forKey:@"CommunityID"];
    [defaults setObject:loginItem.user_id forKey:@"UserID"];
    [defaults setObject:loginItem.user_nickname forKey:@"UserNickname"];
    [defaults setObject:loginItem.phone_number forKey:@"PhoneNumber"];
    [defaults setObject:loginItem.head_portrait_url forKey:@"HeadPortraitUrl"];
    [defaults setObject:loginItem.user_permission forKey:@"UserPermission"];
    [defaults setObject:loginItem.login_password forKey:@"LoginPassword"];
    [defaults setObject:loginItem.account_status forKey:@"AccountStatus"];
    [defaults setObject:loginItem.moderator_of_forum_list forKey:@"moderator_of_forum_list"];
    [defaults setBool:YES forKey:@"Logged"];
    [defaults synchronize];  //保持同步
}

#pragma mark --显示登录失败报错hmx
- (void) showErrMsg: (NSString *)loginErrorMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:loginErrorMessage delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)View_TouchDown:(id)sender {
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
