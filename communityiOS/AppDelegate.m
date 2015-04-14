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
#import "UIViewController+Create.h"
#import "APService.h"


#import "DemoViewController.h"


@interface AppDelegate ()
@property (strong, nonatomic) NSDictionary *inactiveRemoteNotificationInfo;
@property (assign, nonatomic) BOOL shouldRefreshUserInfo;
@property (assign, nonatomic) BOOL shouldJumpToPostDetail;
@property (assign, nonatomic) BOOL shouldJumpToPostReply;



@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:self.window.rootViewController];
//    self.window.rootViewController=nav;
    
//    //新建PPRevealSideViewController,并设置根视图（主页面的导航视图）
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
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
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



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (application.applicationState == UIApplicationStateActive) {
        [self handleActiveRemoteNotification:userInfo shouldShowAlert:YES];
    }else{
        NSString *type = userInfo[@"type"];
        self.shouldJumpToPostDetail = ([type isEqualToString:@"000"]);
        self.shouldJumpToPostReply = ([type isEqualToString:@"001"]);
        
        [self handleInactiveRemoteNotification:userInfo];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)handleActiveRemoteNotification:(NSDictionary *)userInfo shouldShowAlert:(BOOL)showAlert{
    
    NSString *type = userInfo[@"type"];
    if ([type isEqualToString:@"000"]) {
        if (self.shouldJumpToPostDetail) {
            NSString *post_id = [[NSString alloc] initWithString:userInfo[@"post_id"]];
            PostDetailViewController *postVc = [PostDetailViewController createFromStoryboardName:@"PostDetailStoryboard" withIdentifier:@"postDetail"];
//            postVc.post_id = post_id;
            [self.window.rootViewController.navigationController pushViewController:postVc animated:YES];
        }
        self.shouldJumpToPostDetail = NO;
    }
    if ([type isEqualToString:@"001"]) {
        if (self.shouldJumpToPostReply) {
            
          //这里是向PostReplyVewController跳转
        
        }
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
