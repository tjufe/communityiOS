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
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
