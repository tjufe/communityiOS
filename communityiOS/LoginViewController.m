//
//  LoginViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/3/19.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

- (IBAction)exit:(id)sender {
     [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.loimage = [UIImage imageNamed:@"ic_default_avater@2x"];
    
    
    
    
    
    // Do any additional setup after loading the view.
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
