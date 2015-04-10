//
//  loginItem.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface loginItem : NSObject

@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;
@property (nonatomic)BOOL LoginSucceed;
@property (nonatomic,strong)NSString *ErrorMessage;
@property (nonatomic,strong)NSDictionary *userLoginInfo;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *regist_date;
@property (nonatomic,strong)NSString *user_nickname;
@property (nonatomic,strong)NSString *phone_number;
@property (nonatomic,strong)NSString *login_password;
@property (nonatomic,strong)NSString *head_portrait_url;
@property (nonatomic,strong)NSString *checkin_community_id;
@property (nonatomic,strong)NSString *account_status;
@property (nonatomic,strong)NSString *auth;
@property (nonatomic,strong)NSArray *moderator_of_forum_list;
@property (nonatomic,strong)NSString *user_permission;


+(loginItem *)createItemWitparametes:(NSDictionary*)dic;

@end
