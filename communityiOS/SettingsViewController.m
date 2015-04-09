//
//  SettingsViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "SettingsViewController.h"
#import "PPRevealSideViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation SettingsViewController

- (IBAction)exit:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:view];
    
    [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
}
#pragma mark --退出登录
- (IBAction)logout:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.logoutBtn.layer setCornerRadius:4];
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
