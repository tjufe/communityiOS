//
//  loginItem.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "loginItem.h"
#import "KZPropertyMapper.h"

@implementation loginItem

+(loginItem *)createItemWitparametes:(NSDictionary*)dic
{
    loginItem *item = [loginItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[loginItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
               @"status" : @"status",
               @"msg" : @"msg",
               @"data" : @{
                           @"LoginSucceed":@"LoginSucceed",
                           @"ErrorMessage":@"ErrorMessage",
                           @"userLoginInfo":@{
                                 @"user_id": @"user_id",
                                 @"regist_date":@"regist_date",
                                 @"user_nickname":@"user_nickname",
                                 @"phone_number": @"phone_number",
                                 @"login_password":@"login_password",
                                 @"head_portrait_url":@"head_portrait_url",
                                 @"checkin_community_id":@"checkin_community_id",
                                 @"account_status":@"account_status",
                                 @"auth":@"auth",
                                 @"moderator_of_forum_list":@"moderator_of_forum_list",
                                 @"user_permission":@"user_permission"
                              },
                           
                       },
             };
}

@end
