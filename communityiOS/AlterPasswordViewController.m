//
//  AlterPasswordViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/4/9.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "AlterPasswordViewController.h"
#import "StatusTool.h"

@interface AlterPasswordViewController ()

@end

@implementation AlterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pwdCheck) name:UITextFieldTextDidEndEditingNotification object:self.tf_NewPsw];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pwdCheck) name:UITextFieldTextDidEndEditingNotification object:self.tf_SecPsw];
}

-(void)pwdCheck{
    if (![self.tf_NewPsw.text isEqualToString:self.tf_SecPsw.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认密码不符合" message:@"请重新输入确认密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新输入", nil];
        [alert show];
        
    }else{
        self.saveBtn.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --保存修改密码
- (IBAction)saveNewPassword:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults valueForKey:@"UserID"];

    
    [StatusTool statusToolCorrectPwdWithPwd:self.tf_OldPsw.text UserID:user_id NewPwd:self.tf_NewPsw.text ConfirmPwd:self.tf_SecPsw.text Success:^(id object) {
        //提交表单，不作处理
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)View_TouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    
}
@end
