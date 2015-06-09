//
//  AuthViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/4/22.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "AuthViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "StatusTool.h"

@interface AuthViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *roomField;
@property (strong, nonatomic) IBOutlet UITextField *hostField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIView *inputView;
- (IBAction)saveAction:(id)sender;
- (IBAction)ViewTouchDown:(id)sender;

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    self.inputView.layer.masksToBounds = YES;
    self.inputView.layer.cornerRadius = 6.0;
    self.inputView.layer.borderWidth = 1.0;
    self.inputView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.saveBtn.layer.masksToBounds = YES;
    self.saveBtn.layer.cornerRadius = 6.0;
    self.saveBtn.layer.borderColor = [[UIColor redColor] CGColor];
    self.saveBtn.layer.borderWidth = 1.0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strPhoneNumber = [defaults valueForKey:@"PhoneNumber"];
    self.phoneField.text = strPhoneNumber;
    self.roomField.text = [defaults valueForKey:@"RoomNumber"];
    self.hostField.text = [defaults valueForKey:@"HostName"];
    self.nameField.text = [defaults valueForKey:@"RealName"];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.roomField) {
        [self.hostField becomeFirstResponder];
    }else if (textField == self.hostField){
        [self.phoneField becomeFirstResponder];
    }
    return true;
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

- (IBAction)saveAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [NSString stringWithString:[defaults valueForKey:@"UserID"]];
    [defaults setObject:self.hostField.text forKey:@"HostName"];
    [defaults setObject:self.nameField.text forKey:@"RealName"];
    [defaults setObject:self.roomField.text forKey:@"RoomNumber"];
    [defaults synchronize];
    [StatusTool statusToolUserAuthWithRealName:self.nameField.text HostName:self.hostField.text ID:user_id HouseNumber:self.roomField.text Phone:self.phoneField.text Success:^(id object) {
        //提交表单，不做处理
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)ViewTouchDown:(id)sender {
    
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
