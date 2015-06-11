//
//  AppDelegate.m
//  communityiOS
//
//  Created by 何茂馨 on 15/3/18.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import "AppDelegate.h"
#import "PPRevealSideViewController.h"
#import "PostDetailViewController.h"
#import "PostMendDetailViewController.h"
#import "UIViewController+Create.h"
#import "APService.h"
#import "PostReplyViewController.h"
#import "JpushConfig.h"
#import "DemoViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "UIAlertView+Blocks.h"
#import "StatusTool.h"
#import "postItem.h"
#import "APIClient.h"
#import "APIAddress.h"
#import "AFHTTPRequestOperationManager.h"
#import "AddressGetter.h"


@interface AppDelegate ()
@property (strong, nonatomic) NSDictionary *inactiveRemoteNotificationInfo;
@property (assign, nonatomic) BOOL shouldRefreshUserInfo;
@property (assign, nonatomic) BOOL shouldJumpToPostDetail;
@property (assign, nonatomic) BOOL shouldJumpToPostMendDetail;
@property (assign, nonatomic) BOOL shouldJumpToPostMendReply;
@property (assign, nonatomic) BOOL shouldAlertRefuse;
@property (strong, nonatomic) postItem *post_item;


@end


@implementation AppDelegate


+(NSString *)getServerAddress {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"^^^^^%@",[NSString stringWithFormat:@"http://%@",myDelegate.address ]);
    return [NSString stringWithFormat:@"http://%@",myDelegate.address ];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:self.window.rootViewController];
    PPRevealSideViewController *sideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    self.window.rootViewController = sideViewController;

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}

#pragma mark-
#pragma mark-----------------------JPush------------------------------------------

-(void)Jump2PostdetailWithPostID:(NSString *)post_id{
    if (post_id.length > 0) {
        PostDetailViewController *pdVc = [PostDetailViewController createFromStoryboardName:@"PostDetailStoryboard" withIdentifier:@"postDetail"];
        pdVc.postIDFromOutside = post_id;
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 20, 10, 20);
        [btn setImage:[UIImage imageNamed:@"back"] forState: UIControlStateNormal];
        [btn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pdVc];
        UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithCustomView:btn];
        pdVc.navigationItem.leftBarButtonItem =leftBtn;
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.window.rootViewController presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

-(void)GoBack{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)jump2PostMenddetailWithPostID:(NSString *)post_id{
    if (post_id.length > 0) {
        PostMendDetailViewController *pmdVc = [PostMendDetailViewController createFromStoryboardName:@"PostMendDetail" withIdentifier:@"postMendDetail"];
        pmdVc.postIDFromOutside = post_id;
        pmdVc.postitem = self.post_item;
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 20, 10, 20);
        [btn setImage:[UIImage imageNamed:@"back"] forState: UIControlStateNormal];
        [btn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pmdVc];
        UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithCustomView:btn];
        pmdVc.navigationItem.leftBarButtonItem =leftBtn;
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.window.rootViewController presentViewController:nav animated:YES completion:^{
            
        }];
    }
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (application.applicationState == UIApplicationStateActive) {
        [self handleActiveRemoteNotification:userInfo shouldShowAlert:YES];
    }else{
        [self handleActiveRemoteNotification:userInfo shouldShowAlert:YES];
        [self handleInactiveRemoteNotification:userInfo];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)handleActiveRemoteNotification:(NSDictionary *)userInfo shouldShowAlert:(BOOL)showAlert{
    
    NSLog(@"%@",userInfo);
    NSString *type = [userInfo valueForKey:@"notifyType"];
    NSString *alert = userInfo[@"aps"][@"alert"];
    NSString *post_id;
    if (![type isEqualToString:NOTIFY_TYPE_REFUSE]) {
        post_id = [[NSString alloc]initWithString:userInfo[@"postID"]];
        [StatusTool statusToolGetPostInfoWithPostID:post_id Success:^(id object) {
            
            self.post_item = (postItem *)object;
            
        } failurs:^(NSError *error) {
            //
        }];
    }

    if (showAlert) {
        [UIAlertView showAlertViewWithTitle:@"提示" message:alert cancelButtonTitle:@"取消"otherButtonTitles:@[@"确定前往"] onDismiss:^(int buttonIndex) {
            if (buttonIndex == 0) {
                
                if ([type isEqualToString:NOTIFY_TYPE_NEW_POST]) {
                    //        if (!self.shouldJumpToPostDetail) {
                    
                    NSString *post_id = [[NSString alloc] initWithString:userInfo[@"postID"]];
                    [self Jump2PostdetailWithPostID:post_id];
                    
                }if ([type isEqualToString:NOTIFY_TYPE_NEW_REPAIR_POST]) {
                    //        if (!self.shouldJumpToPostMendDetail) {
                    NSString *post_id = [[NSString alloc]initWithString:userInfo[@"postID"]];
                    [self jump2PostMenddetailWithPostID:post_id];
                    //        }
                    //        self.shouldJumpToPostMendDetail = NO;
                }if ([type isEqualToString:NOTIFY_TYPE_NEW_REPAIR_REPLY]) {
                    //        if (!self.shouldJumpToPostMendReply) {
                   
                    [self jump2PostMenddetailWithPostID:post_id];
                    //        }
                    //        self.shouldJumpToPostMendReply = NO;
                }if ([type isEqualToString:NOTIFY_TYPE_REFUSE]){
                    //        if (!self.shouldAlertRefuse) {
                    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                  message:@"您的实名认证请求被驳回"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil];
                    
                    [alert show];
                    //        }
                }

            }else{
                
                
            }
            
        } onCancel:^{
            
        }];
        [APService resetBadge];
    }
}
    

/**
 *  保存通知的数据、或者处理非激活状态下的数据。
 */
- (void)handleInactiveRemoteNotification:(NSDictionary *)userInfo{
    self.inactiveRemoteNotificationInfo = userInfo;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark-

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
