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

#define UserNameKey @"name"
#define PwdKey @"pwd"
#define RmbPwdKey @"rmb_pwd"


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
    UITextField *t=notification.object;
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

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:view];
    
    [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loimage = [UIImage imageNamed:@"ic_default_avater@2x"];
    
    //读取上次存储的数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.phoneTextField.text = [defaults valueForKey:UserNameKey];
    self.passwordTextField.text = [defaults valueForKey:PwdKey];
    
    
    // Do any additional setup after loading the view.
    BOOL didRemeber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"didRemeber" ] boolValue];
    [self.remberSwitch setOn:didRemeber];
    [self.loginButton.layer setMasksToBounds:YES];
//    [self.loginButton.layer setCornerRadius:self.loginButton.frame.size.height/2]; //设置矩形四个圆角半径

    [self.loginButton.layer setCornerRadius:4];
    [self.uiViewLogin.layer setCornerRadius:4];
    
//    [self.loginButton setBackgroundColor:[UIColor grayColor]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
//    NSLog(@"^^^^%@",self.remberSwitch.on);
}
-(void)setLoimage:(UIImage *)loimage{

    _LoginImage.image = loimage;
    _LoginImage.layer.masksToBounds = YES ;
    [_LoginImage.layer setCornerRadius:_LoginImage.frame.size.width/2];
    _LoginImage.contentMode = UIViewContentModeScaleAspectFill;
    
//    self.loimage = [UIImage imageNamed:@"ic_default_avater@2x"];
    

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
    UIViewController *mainVc = segue.destinationViewController;

}


- (IBAction)loginAction {
    //存储数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.phoneTextField.text forKey:UserNameKey];
    [defaults setObject:self.passwordTextField.text forKey:PwdKey];
    [defaults synchronize];
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:self.phoneTextField.text forKey:@"phone_number"];
    [firstDic setObject:self.passwordTextField.text  forKey:@"login_password"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"UserLogin" forKey:@"method"];
    //   _weak_typeof(&*self)weakSelf = self ;
    [[APIClient sharedClient] POST:@""
                  parameters:thirdDic
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           NSData *data = [[NSData alloc] initWithData:responseObject];
                           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               self.loginItem = [loginItem createItemWitparametes:dic];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          UIAlertView *av =[[UIAlertView alloc] initWithTitle:@"Error Retrieving Login Data"
                                             message:[NSString stringWithFormat:@"%@",error]
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                               
                          [av show];
                               
      }];
    //关闭当前视图控制器
    [self.navigationController popViewControllerAnimated:YES];
    //代理传值
    if ([self.delegate respondsToSelector:@selector(addUser:didAddUser:)]) {
        NSString * checkin_community_id= [[NSString alloc]initWithString:self.loginItem.checkin_community_id];
        [self.delegate addUser:self didAddUser:checkin_community_id];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.loginItem.checkin_community_id forKey:@"userid"];
    ViewController *view = [ViewController create];
    view.name = 
}

@end
