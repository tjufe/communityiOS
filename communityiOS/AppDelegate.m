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


@interface AppDelegate ()
@property (strong, nonatomic) NSDictionary *inactiveRemoteNotificationInfo;
@property (assign, nonatomic) BOOL shouldRefreshUserInfo;
@property (assign, nonatomic) BOOL shouldJumpToPostDetail;
@property (assign, nonatomic) BOOL shouldJumpToPostMendDetail;
@property (assign, nonatomic) BOOL shouldJumpToPostMendReply;
@property (assign, nonatomic) BOOL shouldAlertRefuse;


@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:self.window.rootViewController];
//    self.window.rootViewController= nav;
    
//    新建PPRevealSideViewController,并设置根视图（主页面的导航视图）
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
    
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];

    
    return YES;
}


#pragma mark-
#pragma mark-----------------------JPush------------------------------------------


//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
//    
//}
//
//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    // 取得 APNs 标准信息内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
//    
//    // 取得自定义字段内容
//    NSString *extras = [userInfo valueForKey:@"extras"]; //自定义参数，key是自己定义的
//    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,extras);
//    
//    // Required
//    [APService handleRemoteNotification:userInfo];
//}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if (application.applicationState == UIApplicationStateActive) {
        [self handleActiveRemoteNotification:userInfo shouldShowAlert:YES];
    }else{

//        NSDictionary *extras = [userInfo valueForKey:@"extras"];
//        NSString *type = [userInfo valueForKey:@"notifyType"];
//        self.shouldJumpToPostDetail = ([type isEqualToString:NOTIFY_TYPE_NEW_POST]);
//        self.shouldJumpToPostMendDetail = ([type isEqualToString:NOTIFY_TYPE_NEW_REPAIR_REPLY]);
//        self.shouldJumpToPostMendReply = ([type isEqualToString:NOTIFY_TYPE_NEW_REPAIR_REPLY]);
//        self.shouldAlertRefuse = ([type isEqualToString:NOTIFY_TYPE_REFUSE]);
        [self handleActiveRemoteNotification:userInfo shouldShowAlert:YES];
        [self handleInactiveRemoteNotification:userInfo];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)handleActiveRemoteNotification:(NSDictionary *)userInfo shouldShowAlert:(BOOL)showAlert{
    
    NSLog(@"%@",userInfo);
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *type = [userInfo valueForKey:@"notifyType"];
    
    if ([type isEqualToString:NOTIFY_TYPE_NEW_POST]) {
//        if (!self.shouldJumpToPostDetail) {
        
            NSString *post_id = [[NSString alloc] initWithString:userInfo[@"postID"]];
//            PostDetailViewController *postVc = [PostDetailViewController createFromStoryboardName:@"PostDetailStoryboard" withIdentifier:@"postDetail"];
//            postVc.postIDFromOutside = post_id;
//            UINavigationController *nav = [[UINavigationController alloc]init];
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.window.rootViewController];
//        [self.window.rootViewController.navigationController pushViewController:nav animated:YES];
//            [self.window.rootViewController.navigationController pushViewController:postVc animated:YES];
//        [self.window.rootViewController.revealSideViewController.navigationController pushViewController:postVc animated:YES];
//            [nav pushViewController:postVc animated:YES];
//        }
//        self.shouldJumpToPostDetail = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"JumpToPostDetail" object:post_id];
        
    }if ([type isEqualToString:NOTIFY_TYPE_NEW_REPAIR_POST]) {
//        if (!self.shouldJumpToPostMendDetail) {
            NSString *post_id = [[NSString alloc]initWithString:userInfo[@"postID"]];
            PostMendDetailViewController *postMendVC = [PostMendDetailViewController createFromStoryboardName:@"PostMendDetail" withIdentifier:@"postMendDetail"];
            postMendVC.postIDFromOutside = post_id;
            [self.window.rootViewController.navigationController pushViewController:postMendVC animated:YES];
//        }
//        self.shouldJumpToPostMendDetail = NO;
    }if ([type isEqualToString:NOTIFY_TYPE_NEW_REPAIR_REPLY]) {
//        if (!self.shouldJumpToPostMendReply) {
            NSString *post_id = [[NSString alloc]initWithString:userInfo[@"postID"]];
            PostMendDetailViewController *postMendVC = [PostMendDetailViewController createFromStoryboardName:@"PostMendDetail" withIdentifier:@"postMendDetail"];
            postMendVC.postIDFromOutside = post_id;
            [self.window.rootViewController.navigationController pushViewController:postMendVC animated:YES];
//        }
//        self.shouldJumpToPostMendReply = NO;
    }if ([type isEqualToString:NOTIFY_TYPE_REFUSE]) {
//        if (!self.shouldAlertRefuse) {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                          message:@"您的实名认证请求被驳回"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];  
            
            [alert show];
//        }
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
