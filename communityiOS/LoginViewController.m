//
//  LoginViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/3/19.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *remberSwitch;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
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

- (IBAction)exit:(id)sender {
     [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.loimage = [UIImage imageNamed:@"ic_default_avater@2x"];
    
    
    
    
    
    // Do any additional setup after loading the view.
    BOOL didRemeber=[[[NSUserDefaults standardUserDefaults] objectForKey:@"didRemeber" ] boolValue];
    [self.remberSwitch setOn:didRemeber];
    [self.loginButton.layer setMasksToBounds:YES];
    [self.loginButton.layer setCornerRadius:self.loginButton.frame.size.height/2]; //设置矩形四个圆角半径

    [self.loginButton setBackgroundColor:[UIColor grayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
