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

#define NUMBERS @"0123456789\n"

@interface RegistViewController ()<UITextFieldDelegate>
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
    //验证两次密码输入是否正确
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pwdCheckAlert) name:UITextFieldTextDidEndEditingNotification object:self.tfSecondPassword];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pwdCheck) name:UITextFieldTextDidChangeNotification object:self.tfSecondPassword];
     //验证第一次密码是否少于6位
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ifPwdCorrect) name:UITextFieldTextDidEndEditingNotification object:self.tfPassword];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ifPhoneCorrect) name:UITextFieldTextDidEndEditingNotification object:self.tfPhoneNumber];
}

#pragma mark-
#pragma mark-----------------------监听的回调方法----------------------
-(void)pwdCheckAlert{
    if (![self.tfPassword.text isEqualToString:self.tfSecondPassword.text ]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示 " message:@"确认密码与密码不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)pwdCheck{
    self.resBtn.enabled = ([self.tfPassword.text isEqualToString:self.tfSecondPassword.text]&&![self.tfPhoneNumber.text isEqualToString:@""]);
}

-(void)ifPwdCorrect{
    if (self.tfPassword.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不应少于6位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)ifPhoneCorrect{
    if (self.tfPhoneNumber.text.length != 11 && ![self.tfPhoneNumber.text isEqualToString:@""] ) {
        self.resBtn.enabled = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入11位有效手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        self.resBtn.enabled = YES ;
    }
}


#pragma mark-
#pragma mark---------------------textfield delegate------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.tfNickname) {
        [self.tfNickname resignFirstResponder];
        [self.tfPassword becomeFirstResponder];
    }
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == self.tfPhoneNumber)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            return NO;
        }
    }
    
    //其他的类型不需要检测，直接写入
    return YES;
}


#pragma mark-


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)regAction:(id)sender {
    if ([self.tfNickname.text isEqualToString:@""]||[self.tfPhoneNumber.text isEqualToString:@""]||[self.tfPassword.text isEqualToString:@""]||[self.tfSecondPassword.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请完善个人信息"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }
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
     [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:loginErrorMessage delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
