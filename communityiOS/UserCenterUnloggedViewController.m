//
//  UserCenterUnloggedViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "UserCenterUnloggedViewController.h"
#import "LoginNavigationController.h"
#import "UIViewController+Create.h"
#import "PPRevealSideViewController.h"

@interface UserCenterUnloggedViewController ()

@end

@implementation UserCenterUnloggedViewController

- (IBAction)go2Login:(id)sender {
    LoginNavigationController *vc=[LoginNavigationController createFromStoryboardName:@"Login" withIdentifier:@"loginACT"];
    
//    [self presentModalViewController:vc animated:YES];
    
    [self.revealSideViewController popViewControllerWithNewCenterController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
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
