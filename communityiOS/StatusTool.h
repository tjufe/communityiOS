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

//请求修改昵称
+(void)statusToolCorrectNickNameWithNickName:(NSString *)newNickname  UserID:(NSString *)ID Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

//请求修改密码
+(void)statusToolCorrectPwdWithPwd:(NSString *)password  UserID:(NSString *)ID  NewPwd:(NSString*)password1 ConfirmPwd:(NSString *) confirmPassword Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

/*请求帖子相关信息
 返回的相应对象模型为postInfoItem
 */
+(void)statusToolGetPostRelatedInfoWithpostID:(NSString *)post_id  poster_ID:(NSString *)poster_id community_ID:(NSString *)community_id forum_ID:(NSString *)forum_id Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

//请求发送新帖
+(void)statusToolPostNewPostWithcom_id:(NSString *)community_id  forumID:(NSString *)forum_id posterID:(NSString *)poster_id postTitle:(NSString *)post_title postText:(NSString *)post_text Image:(NSString*)main_image_url chainFlag:(NSString *)chain_flag chainName:(NSString *)chain_name chainURL:(NSString *)chain_url pushMember:(NSString*)push_member Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

//请求编辑帖子
+(void)statusToolPostEditWithcomID:(NSString *)community_id forumID:(NSString *)forum_id postTitle:(NSString *)post_title Image:(NSString*)main_image_url chainFlag:(NSString *)chain_flag chainName:(NSString *)chain_name chainURL:(NSString *)chain_url pushFlag:(NSString*)push_flag userID:(NSString *)user_id postText:(NSString *)post_text editFlag:(NSString *)edit_flag posterID:(NSString *)poster_id Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

//请求帖子操作
+(void)statusToolPostOperateWithcommunityID:(NSString *)community_id forumID:(NSString *)forum_id postID:(NSString *)post_id userID:(NSString *)user_id Flag:(NSNumber *)flag Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

//wangyao
//请求发帖人昵称，回帖人数，报名人数，阅读人数
//+(void)statusToolPostInfoWithcommunityID:(NSString *)community_id forumID:(NSString *)forum_id postID:(NSString *)post_id poster_id:(NSString *)poster_id Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

@end
