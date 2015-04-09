//
//  StatusTool.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/7.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "StatusTool.h"
#import "HttpTool.h"
#import "forumListItem.h"
#import "forumItem.h"
#import "loginItem.h"
#import "regItem.h"
#import "postItem.h"
#import "postListItem.h"

@implementation StatusTool

//请求板块列表
+ (void)statusToolGetForumListWithID:(NSString *)ID  Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:ID forKey:@"community_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"loadForumList" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        forumListItem *forumlist_item = [forumListItem createItemWitparametes:dic];
        NSMutableArray *ListArray = [NSMutableArray array];
        
        for(NSDictionary *dic in forumlist_item.ForumList){
            [ListArray addObject:[forumItem createItemWitparametes:dic]];
        }
        success(ListArray);
        
    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
    
}

//发送用户登录请求
+(void)statusToolGetUserLoginWithName:(NSString *)Name  PassWord:(NSString *)Pwd Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:Name forKey:@"phone_number"];
    [firstDic setValue:Pwd forKey:@"login_password"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"UserLogin" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        regItem *reg_item = [regItem createItemWitparametes:dic];
        success(reg_item);

    } failure:^(NSError *error) {
        if (failure == nil) return;
         failure(error);
    }];
   
}
//发送注册请求
+(void)statusToolGetUserRegWithName:(NSString *)Name  PassWord:(NSString *)Pwd Phone:(NSString *)Phone RegID:(NSString *)RegID Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:Name forKey:@"name"];
    [firstDic setValue:Pwd forKey:@"password"];
    [firstDic setValue:Phone forKey:@"phone"];
    [firstDic setValue:RegID forKey:@"id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"UserReg" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         NSData *data = [[NSData alloc] initWithData:responseObject];
                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                         
                         loginItem *login_item = [loginItem createItemWitparametes:dic];
                         success(login_item);
                         
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];
    
}
//请求加载帖子列表
+(void)statusToolGetPostListWithbfID:(NSString *)bfID  bcID:(NSString *)bcID userID:(NSString *)userID filter:(NSString *)filter Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:bfID forKey:@"belong_forum_id"];
    [firstDic setValue:bcID forKey:@"belong_community_id"];
    [firstDic setValue:userID forKey:@"user_id"];
    [firstDic setValue:filter forKey:@"filter"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"LoadPostList" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         NSData *data = [[NSData alloc] initWithData:responseObject];
                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                         postListItem *post_list_item = [postListItem createItemWitparametes:dic];
                         NSMutableArray *ListArray = [NSMutableArray array];
                         
                         for(NSDictionary *dic in post_list_item.PostList){
                             [ListArray addObject:[postItem createItemWitparametes:dic]];
                         }
                         success(ListArray);
                         
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];
   
    
}
@end
