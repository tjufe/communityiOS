//
//  FindPasswordViewController.m
//  communityiOS
//
//  Created by tjufe on 15/6/5.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "StatusTool.h"
#import "findPassword.h"
#import "regItem.h"
#import "PPRevealSideViewController.h"
#import "getSMSCodeItem.h"
#import "MBProgressHUD.h"

#define NUMBERS @"0123456789\n"

@interface FindPasswordViewController ()<UITextFieldDelegate>
@property (strong,nonatomic) NSString *SMS_code;
@property (nonatomic, strong) NSTimer *timer;//验证码定时器

@end
int total_sec1 = 60;
NSString *strPhone;
NSString *strNewPassword;
NSString *strConfirmPassword;
@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.FindPView.layer setCornerRadius:4];
    [self.btFindPSure.layer setCornerRadius:4];
     //验证两次密码输入是否正确
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pwdCheckAlert) name:UITextFieldTextDidEndEditingNotification object:self.etConfirmPassword];
    //正确之后使能确定按钮
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pwdCheck) name:UITextFieldTextDidChangeNotification object:self.etConfirmPassword];
    //验证第一次密码是否少于6位
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ifPwdCorrect) name:UITextFieldTextDidEndEditingNotification object:self.etNewPassword];
    //验证手机号正确
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ifPhoneCorrect) name:UITextFieldTextDidEndEditingNotification object:self.etPhone];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:(BOOL)animated];
    total_sec1 = 60;
}

#pragma mark-----------------------监听的回调方法----------------------
-(void)pwdCheckAlert{
    if (![self.etNewPassword.text isEqualToString:self.etConfirmPassword.text ]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示 " message:@"确认密码与密码不匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)pwdCheck{
    self.btFindPSure.enabled = ([self.etNewPassword.text isEqualToString:self.etConfirmPassword.text]&&![self.etPhone.text isEqualToString:@""]);
}
-(void)ifPwdCorrect{
    if (self.etNewPassword.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不应少于6位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)ifPhoneCorrect{
    if (self.etPhone.text.length != 11 && ![self.etPhone.text isEqualToString:@""] ) {
        self.btFindPSure.enabled = NO;
        //       self.sms_btn.enabled = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入11位有效手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        self.btFindPSure.enabled = YES ;
        //       self.sms_btn.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---------------------textfield delegate------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (textField == self.tfNickname) {
//        [self.tfNickname resignFirstResponder];
//        [self.tfPassword becomeFirstResponder];
//    }
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    if(textField == self.etPhone)
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


#pragma mark-----发送获取验证码
-(void)getSMS{
    [StatusTool statusToolGetSMSCodeWithPhoneNumber:self.etPhone.text Success:^(id object) {
        getSMSCodeItem *item = (getSMSCodeItem *)object;
        self.SMS_code = item.code;
    } failurs:^(NSError *error) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络不给力，请稍后重试！";
        hud.dimBackground = YES;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        }completionBlock:^{
            [hud removeFromSuperview];
        }];
        
    }];
}

-(void)addTimer{
    [self.etPhone resignFirstResponder];
    self.btSendSMS.enabled = NO;
    self.btSendSMS.hidden = YES;
    self.Ltime.hidden = NO;
    self.Ltime.text = [NSString stringWithFormat:@"%d秒后重试",total_sec1];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    
}
-(void)changeTime{
    if(total_sec1 == 0){
        total_sec1 = 60;
        self.btSendSMS.hidden = NO;
        self.btSendSMS.enabled = YES;
        self.Ltime.text = @"";
        self.Ltime.hidden = YES;
        //取消定时器
        [self.timer invalidate];
        self.timer = nil;
    }else{
        total_sec1=total_sec1-1;
        self.Ltime.text = [NSString stringWithFormat:@"%d秒后重试",total_sec1];
        
    }
}

- (IBAction)SMSOnclick:(id)sender {
    NSCharacterSet  *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[self.etPhone.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [self.etPhone.text isEqualToString:filtered];
    if (self.etPhone.text.length != 11 || [self.etPhone.text isEqualToString:@""] || !basicTest) {
        self.btFindPSure.enabled = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入11位有效手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        [self getSMS];
        [self addTimer];
        
    }
}

- (IBAction)FindPOnClick:(id)sender {
    if ([self.etPhone.text isEqualToString:@""]||[self.etNewPassword.text isEqualToString:@""]||[self.etConfirmPassword.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请完善个人信息"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    strPhone=[_etPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strNewPassword=[_etNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strConfirmPassword=[_etConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults valueForKey:@"UserID"];
    if([self.etSMS.text isEqualToString:@""]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入验证码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
    }else if(![self.etSMS.text isEqualToString:self.SMS_code]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"验证码错误，请重新输入"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        [alert show];
    }else{
    
        if([self checkAllowedRegWithPhoneNumber:strPhone password:strNewPassword secPassword:strConfirmPassword]){
            [StatusTool statusToolFindPasswordWithPhone:strPhone Id:userID Password:strNewPassword ConfirmPassword:strConfirmPassword Success:^(id object) {
                findPassword *error_message = (findPassword *)object;
                if([error_message.ErrorMessage isEqualToString:@""]){
                    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:hud];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"修改成功！";
                    hud.dimBackground = YES;
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    }completionBlock:^{
                        [hud removeFromSuperview];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }else{
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:error_message.ErrorMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            } failurs:^(NSError *error) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"修改失败，请查看网络..."
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }];
        }
        
    }
   
}
- (BOOL) checkAllowedRegWithPhoneNumber:(NSString *)phone password:(NSString *)password secPassword:(NSString *)secPassword {
    return [password isEqualToString:secPassword];
    
}
@end
