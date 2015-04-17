//
//  AlterNicknameViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/4/9.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "AlterNicknameViewController.h"
#import "StatusTool.h"

@interface AlterNicknameViewController ()

@end

@implementation AlterNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.tf_Nickname];
}

-(void)textChange{
    self.saveBtn.enabled = (self.tf_Nickname.text.length);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --保存修改昵称
- (IBAction)saveNickname:(id)sender {
    //读取本地存储的ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [defaults valueForKey:@"UserID"];
    [defaults setObject:self.tf_Nickname.text forKey:@"UserNickname"];
    
    [StatusTool statusToolCorrectNickNameWithNickName:self.tf_Nickname.text UserID:user_id Success:^(id object) {
        //提交表单，不做处理
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
