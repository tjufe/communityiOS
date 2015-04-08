//
//  StatusTool.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/7.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>


//请求板块列表
typedef void(^ForumListSuccess)(id object);
typedef void(^ForumListFailurs)(NSError * error);

@interface StatusTool : NSObject

//请求加载板块列表
+ (void)statusToolGetForumListWithID:(NSString *)ID  Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

//发送用户登录请求
+(void)statusToolGetUserLoginWithName:(NSString *)Name  PassWord:(NSString *)Pwd Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

//发送注册请求
+(void)statusToolGetUserRegWithName:(NSString *)Name  PassWord:(NSString *)Pwd Phone:(NSString *)Phone RegID:(NSString *)RegID Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

//请求加载帖子列表
+(void)statusToolGetPostListWithbfID:(NSString *)bfID  bcID:(NSString *)bcID userID:(NSString *)userID filter:(NSString *)filter Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

@end
