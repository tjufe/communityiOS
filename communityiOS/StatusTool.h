//
//  StatusTool.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/7.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostInfo.h"


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
+(void)statusToolGetPostListWithbfID:(NSString *)bfID  bcID:(NSString *)bcID userID:(NSString *)userID filter:(NSString *)filter page:(NSNumber *)page rows:(NSNumber *)rows Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求待审核帖子列表
+(void)statusToolGetUncheckPostListWithbfID:(NSArray *)bfID  bcID:(NSString *)bcID page:(NSNumber *)page rows:(NSNumber *)rows Success:(StatusSuccess)success failurs:(StatusFailurs)failure;


//请求修改昵称
+(void)statusToolCorrectNickNameWithNickName:(NSString *)newNickname  UserID:(NSString *)ID Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求修改密码
+(void)statusToolCorrectPwdWithPwd:(NSString *)password  UserID:(NSString *)ID  NewPwd:(NSString*)password1 ConfirmPwd:(NSString *) confirmPassword Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

/*请求帖子相关信息
 返回的相应对象模型为postInfoItem
 */
+(void)statusToolGetPostRelatedInfoWithpostID:(NSString *)post_id  poster_ID:(NSString *)poster_id community_ID:(NSString *)community_id forum_ID:(NSString *)forum_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求编辑帖子
+(void)statusToolEditPostWithcID:(NSString *)communityID fID:(NSString *)forumID postID:(NSString *)post_id PosterID:(NSString *)posterID postTitle:(NSString *)post_title postText:(NSString *)post_text imgURL:(NSString *)img_url chain:(NSString *)chain chainName:(NSString *)chain_name chainURL:(NSString *)chain_url apply:(NSString *)apply limApplyNum:(NSString*)limit_apply_num needCheck:(NSString *)need_check Checked:(NSString *)checked Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求帖子操作
+(void)statusToolPostOperateWithcommunityID:(NSString *)community_id forumID:(NSString *)forum_id postID:(NSString *)post_id userID:(NSString *)user_id Flag:(NSNumber *)flag Success:(StatusSuccess)success failurs:(StatusFailurs)failure;


//删除帖子操作
+(void)statusToolDeletePostWithpostID:(NSString *)post_id deleteUserID:
    (NSString *)delete_user_id communityID:(NSString *)community_id fourmID:
    (NSString *)forum_id Success:(StatusSuccess)success failurs:
    (StatusFailurs)failure;

//请求回复列表
+(void)statusToolGetReplyListWithPostID:(NSString *)postID Page:(NSNumber *)page Rows:(NSNumber *)rows  Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求发送回复
+(void)statusToolPostReplyWithReplyText:(NSString *)reply_text CommunityID:(NSString*)community_id ForumID:(NSString*)forum_id PostID:(NSString*)post_id UserID:(NSString*)user_id Date:(NSString *)date ReplyID:(NSString*)reply_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//刷新数据库，更新上传图片
+(void)statusToolRefreshUserImageWithUserID:(NSString *)user_id ImageGUID:(NSString *)image_guid Success:(StatusSuccess)success failurs:(StatusFailurs)failure;


//发帖子
+(void)statusToolNewPostWithcID:(NSString *)communityID fID:(NSString *)forumID PosterID:(NSString *)posterID postTitle:(NSString *)post_title postText:(NSString *)post_text imgURL:(NSString *)img_url chain:(NSString *)chain chainName:(NSString *)chain_name chainURL:(NSString *)chain_url apply:(NSString *)apply limApplyNum:(NSString*)limit_apply_num needCheck:(NSString *)need_check Checked:(NSString *)checked Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求实名认证
+(void)statusToolUserAuthWithRealName:(NSString *)realname HostName:(NSString *)name ID:(NSString *)user_id HouseNumber:(NSString *)house Phone:(NSString *)phone Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//查看用户是否报名
+(void)statusToolIfApplyWithcommunity_id:(NSString *)community_id forum_id:(NSString *)forum_id post_id:(NSString *)post_id user_id:(NSString *)user_id  Success:(StatusSuccess)success failurs:(StatusFailurs)failure;
//用户报名操作
+(void)statusToolPostApplyWithcommunity_id:(NSString *)community_id forum_id:(NSString *)forum_id post_id:(NSString *)post_id user_id:(NSString *)user_id limit_apply_num:(NSString *)limit_apply_num  Success:(StatusSuccess)success failurs:(StatusFailurs)failure;
//结束报名操作
+(void)statusToolEndApplyWithcommunity_id:(NSString *)community_id forum_id:(NSString *)forum_id post_id:(NSString *)post_id user_id:(NSString *)user_id  Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//hmx05181051 加载轮播图
+(void)statusToolGetSlideListWithCommunityID:(NSString *)community_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//请求删除回复
+(void)statusToolPostDeleteReplyWithUserID:(NSString *)user_id Reply_id:(NSString *)post_reply_id PostID:(NSString*)post_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//post_id加载帖子详情
+(void)statusToolGetPostInfoWithPostID:(NSString *)post_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//hmx05221712 加载报修类型
+(void)statusToolLoadRepairTypeWithCommunityID:(NSString *)community_id ForumID:(NSString *)forum_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//发报修帖子 hmx201505251232
+(void)statusToolNewPostWithPostInfo:(PostInfo *)postInfo Success:(StatusSuccess)success failurs:(StatusFailurs)failure;


//发送报修的评价
+(void)statusToolPostMendScoreWithPostID:(NSString *)post_id User_ID:(NSString*)user_id Score:(NSString*)score Evaluate:(NSString *)evaluate Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//下载到评价的类型
+(void)statusToolGetScoreTypeWithCommunityID:(NSString *)community_id ForumID:(NSString *)forum_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//修改报修帖子 lx20150527
+(void)statusToolEditPostWithPostInfo:(PostInfo *)postInfo Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//获取手机验证码
+(void)statusToolGetSMSCodeWithPhoneNumber:(NSString *)phone_number Success:(StatusSuccess)success failurs:(StatusFailurs)failure;

//获取手机验证码
+(void)statusToolFindPasswordWithPhone:(NSString *)phone Id:(NSString *)user_id Password:(NSString *)password ConfirmPassword:(NSString *)confirm_password Success:(StatusSuccess)success failurs:(StatusFailurs)failure;


@end
