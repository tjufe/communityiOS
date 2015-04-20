//
//  RegistViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "RegistViewController.h"
#import "StatusTool.h"
#import "regItem.h"
#import "PPRevealSideViewController.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UIView *resView;
@property (weak, nonatomic) IBOutlet UIButton *resBtn;
- (IBAction)regAction:(id)sender;


@end

@implementation RegistViewController

NSString *strPhoneNumber;
NSString *strNickname;
NSString *strPassword;
NSString *strSecondPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.resView.layer setCornerRadius:4];
    [self.resBtn.layer setCornerRadius:4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)regAction:(id)sender {
    strPhoneNumber=[_tfPhoneNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strNickname=[_tfNickname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strPassword=[_tfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strSecondPassword=[_tfSecondPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults valueForKey:@"UserID"];
    if([self checkAllowedRegWithPhoneNumber:strPhoneNumber nickName:strNickname password:strPassword secPassword:strSecondPassword]){
        [StatusTool statusToolGetUserRegWithName:strNickname
                                        PassWord:strPassword
                                           Phone:strPhoneNumber
                                           RegID:userID
                                         Success:^(id object) {
                                             [self checkRegResult:object];
                                         }
                                         failurs:^(NSError *error) {
                                             NSLog(@"%@",error);
                                         }];
    }
    
}

- (IBAction)View_TouchDown:(id)sender {
}

- (BOOL) checkAllowedRegWithPhoneNumber:(NSString *)phoneNumber nickName:(NSString *)nickName password:(NSString *)password secPassword:(NSString *)secPassword {
    return [password isEqualToString:secPassword];
}

- (void) checkRegResult:(regItem *)regItem {
    if([regItem.status isEqualToString:@"OK"]){
        [self saveIntoLoc];
        [self doExit];//退出本页
    }else{
        [self showErrMsg:regItem.msg];
    }
}

- (void) doExit {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:view];
    [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
}

#pragma mark --保存在本地hmx
- (void) saveIntoLoc {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:strNickname forKey:@"UserNickname"];
    [defaults setObject:strPhoneNumber forKey:@"PhoneNumber"];
    [defaults setObject:@"普通用户" forKey:@"UserPermission"];
    [defaults setObject:strPassword forKey:@"LoginPassword"];
    [defaults setBool:YES forKey:@"Logged"];
    [defaults synchronize];  //保持同步
}

#pragma mark --显示登录失败报错hmx
- (void) showErrMsg: (NSString *)loginErrorMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:loginErrorMessage delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}

@end
