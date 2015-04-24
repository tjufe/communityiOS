//
//  UserCenterLoggedViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//


#import "LoginNavigationController.h"
#import "UIViewController+Create.h"
#import "UserCenterLoggedViewController.h"
#import "PPRevealSideViewController.h"
#import "UIImageView+WebCache.h"
#import "APIClient.h"

@interface UserCenterLoggedViewController ()

@end

@implementation UserCenterLoggedViewController

- (IBAction)go2settings:(id)sender {
    UINavigationController *vc=[UINavigationController createFromStoryboardName:@"Settings" withIdentifier:@"Settings"];
    
    //    [self presentModalViewController:vc animated:YES];
    
    [self.revealSideViewController popViewControllerWithNewCenterController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI {
    _imgAvatar.layer.masksToBounds=YES;
    [_imgAvatar.layer setCornerRadius:_imgAvatar.frame.size.width/2];
    _imgAvatar.contentMode = UIViewContentModeScaleAspectFill;//取图片的中部分
    UIImage *placeholderImage = [UIImage imageNamed:@"icon_acatar_default_r"];
    _imgAvatar.image = placeholderImage;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [defaults valueForKey:@"PhoneNumber"];
    if(phoneNumber!=nil){
        NSString *userNickname = [defaults valueForKey:@"UserNickname"];
        NSString *headPortraitUrl = [defaults valueForKey:@"HeadPortraitUrl"];
        _labelNickname.text = userNickname;
        
        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:headPortraitUrl] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image!=nil){
                _imgAvatar.image = image;
            }
        }];
    }
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
