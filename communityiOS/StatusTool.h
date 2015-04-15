//
//  StatusTool.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/7.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>


//请求板块列表
typedef void(^StatusSuccess)(id object);
typedef void(^StatusFailurs)(NSError * error);

@interface StatusTool : NSObject

//请求加载板块列表
+ (void)statusToolGetForumListWithID:(NSString *)ID  Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//发送用户登录请求
+(void)statusToolGetUserLoginWithName:(NSString *)Name  PassWord:(NSString *)Pwd Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//发送注册请求
+(void)statusToolGetUserRegWithName:(NSString *)Name  PassWord:(NSString *)Pwd Phone:(NSString *)Phone RegID:(NSString *)RegID Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求加载帖子列表
+(void)statusToolGetPostListWithbfID:(NSString *)bfID  bcID:(NSString *)bcID userID:(NSString *)userID filter:(NSString *)filter Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求修改昵称
+(void)statusToolCorrectNickNameWithNickName:(NSString *)newNickname  UserID:(NSString *)ID Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求修改密码
+(void)statusToolCorrectPwdWithPwd:(NSString *)password  UserID:(NSString *)ID  NewPwd:(NSString*)password1 ConfirmPwd:(NSString *) confirmPassword Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

/*请求帖子相关信息
 返回的相应对象模型为postInfoItem
 */
+(void)statusToolGetPostRelatedInfoWithpostID:(NSString *)post_id  poster_ID:(NSString *)poster_id community_ID:(NSString *)community_id forum_ID:(NSString *)forum_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求发送新帖

+(void)statusToolPostNewPostWithcom_id:(NSString *)community_id  forumID:(NSString *)forum_id posterID:(NSString *)poster_id postTitle:(NSString *)post_title postText:(NSString *)post_text Image:(NSString*)main_image_url chainFlag:(NSString *)chain_flag chainName:(NSString *)chain_name chainURL:(NSString *)chain_url pushMember:(NSString*)push_member LimitAppNum:(NSString *)limit_apply_num Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求编辑帖子
+(void)statusToolPostEditWithcomID:(NSString *)community_id forumID:(NSString *)forum_id postTitle:(NSString *)post_title Image:(NSString*)main_image_url chainFlag:(NSString *)chain_flag chainName:(NSString *)chain_name chainURL:(NSString *)chain_url pushMember:(NSString*)push_member userID:(NSString *)user_id postText:(NSString *)post_text  posterID:(NSString *)poster_id LimitAppNum:(NSString *)limit_apply_num  Success:(StatusSuccess)success failurs:(StatusFailurs)failure;


//请求帖子操作
+(void)statusToolPostOperateWithcommunityID:(NSString *)community_id forumID:(NSString *)forum_id postID:(NSString *)post_id userID:(NSString *)user_id Flag:(NSNumber *)flag Success:(StatusSuccess)success failurs:(StatusFailurs)failure;


//删除帖子操作
+(void)statusToolDeletePostWithpostID:(NSString *)post_id deleteUserID:
    (NSString *)delete_user_id communityID:(NSString *)community_id fourmID:
    (NSString *)forum_id Success:(StatusSuccess)success failurs:
    (StatusFailurs)failure;

//Request_ReplyContent

+(void)statusToolReplyContentWithID:(NSString *)ID Success:(StatusSuccess)success failurs:(StatusFailurs)failure;



//Request_PostReply
+(void)statusToolPostReplyWithReplyText:(NSString *)reply_text communityID:(NSString*)community_id forumID:(NSString*)forum_id postID:(NSString *)post_id userID:(NSString *)user_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//刷新数据库，更新上传图片
+(void)statusToolRefreshUserImageWithUserID:(NSString *)user_id ImageGUID:(NSString *)image_guid Success:(StatusSuccess)success failurs:(StatusFailurs)failure;




@end
