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
#import "postInfoItem.h"
#import "deletepostItem.h"
#import "uncheckPostListItem.h"

#import "SlideInfoList.h"
#import "SlideInfoItem.h"

#import "replyInfoListItem.h"

#import "ifApplyItem.h"
#import "postApplyItem.h"



@implementation StatusTool


//请求板块列表
+ (void)statusToolGetForumListWithID:(NSString *)ID  Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
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
+(void)statusToolGetUserLoginWithName:(NSString *)Name  PassWord:(NSString *)Pwd Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:Name forKey:@"phone_number"];
    [firstDic setObject:Pwd forKey:@"login_password"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"UserLogin" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                         loginItem *login_item = [loginItem createItemWitparametes:dic];
                         success(login_item);

    } failure:^(NSError *error) {
        if (failure == nil) return;
         failure(error);
    }];
   
}
//发送注册请求
+(void)statusToolGetUserRegWithName:(NSString *)Name  PassWord:(NSString *)Pwd Phone:(NSString *)Phone RegID:(NSString *)RegID Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:Name forKey:@"name"];
    [firstDic setObject:Pwd forKey:@"password"];
    [firstDic setObject:Phone forKey:@"phone"];
    [firstDic setObject:RegID forKey:@"id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"UserReg" forKey:@"method"];
    
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
//请求加载帖子列表
+(void)statusToolGetPostListWithbfID:(NSString *)bfID  bcID:(NSString *)bcID userID:(NSString *)userID filter:(NSString *)filter page:(NSNumber *)page rows:(NSNumber *)rows Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:bfID forKey:@"belong_forum_id"];
    [firstDic setObject:bcID forKey:@"belong_community_id"];
    [firstDic setObject:userID forKey:@"user_id"];
    [firstDic setObject:filter forKey:@"filter"];
    [firstDic setObject:page forKey:@"page"];
    [firstDic setObject:rows forKey:@"rows"];
    
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
//                         NSMutableArray *ListArray = [NSMutableArray array];
//                         
//                         for(NSDictionary *dic in post_list_item.PostList){
//                             [ListArray addObject:[postItem createItemWitparametes:dic]];
//                         }
                         success(post_list_item);
                         
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];
 
}

//请求待审核帖子列表-----by lx 20150504
+(void)statusToolGetUncheckPostListWithbfID:(NSArray *)bfID  bcID:(NSString *)bcID page:(NSNumber *)page rows:(NSNumber *)rows Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:bfID forKey:@"forum_id"];
    [firstDic setObject:bcID forKey:@"community_id"];
    [firstDic setObject:page forKey:@"page"];
    [firstDic setObject:rows forKey:@"rows"];

    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"LoadUncheckPostList" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         NSData *data = [[NSData alloc] initWithData:responseObject];
                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                         uncheckPostListItem *uncheck_post_list_item = [uncheckPostListItem createItemWitparametes:dic];
                         //                         NSMutableArray *ListArray = [NSMutableArray array];
                         //
                         //                         for(NSDictionary *dic in post_list_item.PostList){
                         //                             [ListArray addObject:[postItem createItemWitparametes:dic]];
                         //                         }
                         success(uncheck_post_list_item);
                         
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];
    
}


//请求修改昵称
+(void)statusToolCorrectNickNameWithNickName:(NSString *)newNickname  UserID:(NSString *)ID Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:newNickname forKey:@"newNickname"];
    [firstDic setObject:ID forKey:@"id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"AlterNickname" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         // no response
                         
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                    }];
    
}

//请求修改密码
+(void)statusToolCorrectPwdWithPwd:(NSString *)password  UserID:(NSString *)ID  NewPwd:(NSString*)password1 ConfirmPwd:(NSString *) confirmPassword Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:password forKey:@"password"];
    [firstDic setObject:ID forKey:@"id"];
    [firstDic setObject:password1 forKey:@"password1"];
    [firstDic setObject:confirmPassword forKey:@"confirmPassword"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"AlterPassword" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         // no response
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];
  
}

/*请求帖子相关信息
 返回的相应对象模型为postInfoItem
 */
+(void)statusToolGetPostRelatedInfoWithpostID:(NSString *)post_id  poster_ID:(NSString *)poster_id community_ID:(NSString *)community_id forum_ID:(NSString *)forum_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:post_id forKey:@"post_id"];
    [firstDic setObject:poster_id forKey:@"poster_id"];
    [firstDic setObject:community_id forKey:@"community_id"];
    [firstDic setObject:forum_id forKey:@"forum_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"PostInfo" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         NSData *data = [[NSData alloc] initWithData:responseObject];
                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                         postInfoItem *postinfo_item = [postInfoItem createItemWitparametes:dic];
                         success(postinfo_item);
                         
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];
}

//请求发送新帖
+(void)statusToolPostNewPostWithcom_id:(NSString *)community_id  forumID:(NSString *)forum_id posterID:(NSString *)poster_id postTitle:(NSString *)post_title postText:(NSString *)post_text Image:(NSString*)main_image_url chainFlag:(NSString *)chain_flag chainName:(NSString *)chain_name chainURL:(NSString *)chain_url pushMember:(NSString*)push_member Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:community_id forKey:@"community_id"];
    [firstDic setObject:forum_id forKey:@"forum_id"];
    [firstDic setObject:poster_id forKey:@"poster_id"];
    [firstDic setObject:post_title forKey:@"post_title"];
    [firstDic setObject:post_text forKey:@"post_text"];
    [firstDic setObject:main_image_url forKey:@"main_image_url"];
    [firstDic setObject:chain_flag forKey:@"chain_flag"];
    [firstDic setObject:chain_name forKey:@"chain_name"];
    [firstDic setObject:chain_url forKey:@"chain_url"];
    [firstDic setObject:push_member forKey:@"push_member"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"NewPost" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic  success:^(id responseObject) {
        // no response
        
    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
}
//请求编辑帖子
+(void)statusToolPostEditWithcomID:(NSString *)community_id forumID:(NSString *)forum_id postTitle:(NSString *)post_title Image:(NSString*)main_image_url chainFlag:(NSString *)chain_flag chainName:(NSString *)chain_name chainURL:(NSString *)chain_url pushFlag:(NSString*)push_flag userID:(NSString *)user_id postText:(NSString *)post_text editFlag:(NSString *)edit_flag posterID:(NSString *)poster_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:community_id forKey:@"community_id"];
    [firstDic setObject:forum_id forKey:@"forum_id"];
    [firstDic setObject:post_title forKey:@"post_title"];
    [firstDic setObject:main_image_url forKey:@"main_image_url"];
    [firstDic setObject:chain_flag forKey:@"chain_flag"];
    [firstDic setObject:chain_name forKey:@"chain_name"];
    [firstDic setObject:chain_url forKey:@"chain_url"];
    [firstDic setObject:push_flag forKey:@"push_flag"];
    [firstDic setObject:user_id forKey:@"user_id"];
    [firstDic setObject:post_text forKey:@"post_text"];
    [firstDic setObject:edit_flag forKey:@"edit_flag"];
    [firstDic setObject:poster_id forKey:@"poster_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"PostEdit" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic  success:^(id responseObject) {
        // no response
        
    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];

}

//请求帖子操作
+(void)statusToolPostOperateWithcommunityID:(NSString *)community_id forumID:(NSString *)forum_id postID:(NSString *)post_id userID:(NSString *)user_id Flag:(NSNumber *)flag Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:community_id forKey:@"community_id"];
    [firstDic setObject:forum_id forKey:@"forum_id"];
    [firstDic setObject:post_id forKey:@"post_id"];
    [firstDic setObject:user_id forKey:@"user_id"];
    [firstDic setObject:flag forKey:@"flag"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"PostOperate" forKey:@"method"];
    [HttpTool postWithparams:thirdDic  success:^(id responseObject) {
        // no response
        
    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
    
}



//删除帖子操作
+(void)statusToolDeletePostWithpostID:(NSString *)post_id deleteUserID:
(NSString *)delete_user_id communityID:(NSString *)community_id fourmID:
(NSString *)forum_id Success:(StatusSuccess)success failurs:
(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:post_id forKey:@"post_id"];
    [firstDic setObject:delete_user_id forKey:@"delete_user_id"];
    [firstDic setObject:community_id forKey:@"community_id"];
    [firstDic setObject:forum_id forKey:@"forum_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"DeletePost" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         NSData *data = [[NSData alloc] initWithData:responseObject];
                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                         deletepostItem  *delete_post_item = [deletepostItem createItemWitparametes:dic];
                         success(delete_post_item);
                         
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];
    
    
}



//请求回复列表
+(void)statusToolGetReplyListWithPostID:(NSString *)postID Page:(NSNumber *)page Rows:(NSNumber *)rows  Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:postID forKey:@"id"];
    [firstDic setObject:page forKey:@"page"];  //获得列表的第几页
    [firstDic setObject:rows forKey:@"rows"];  //每页的行数
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"ReplyContent" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic  success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        replyInfoListItem *reply_list_item = [replyInfoListItem createItemWitparametes:dic];
        success(reply_list_item);
        
    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
}

//请求发送回复
+(void)statusToolPostReplyWithReplyText:(NSString *)reply_text communityID:(NSString*)community_id forumID:(NSString*)forum_id postID:(NSString *)post_id userID:(NSString *)user_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:reply_text forKey:@"reply_text"];
    [firstDic setObject:community_id forKey:@"community_id"];
    [firstDic setObject:forum_id forKey:@"forum_id"];
    [firstDic setObject:post_id forKey:@"post_id"];
    [firstDic setObject:user_id forKey:@"user_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"PostReply" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic  success:^(id responseObject) {
        success(responseObject);
        
    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
    
}

//刷新数据库，更新上传图片
+(void)statusToolRefreshUserImageWithUserID:(NSString *)user_id ImageGUID:(NSString *)image_guid Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:user_id forKey:@"id"];
    [firstDic setObject:image_guid forKey:@"photourl"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"UserUploadPhoto" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic  success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
        
}

//发帖
+(void)statusToolNewPostWithcID:(NSString *)communityID fID:(NSString *)forumID PosterID:(NSString *)posterID postTitle:(NSString *)post_title postText:(NSString *)post_text imgURL:(NSString *)img_url chain:(NSString *)chain chainName:(NSString *)chain_name chainURL:(NSString *)chain_url apply:(NSString *)apply limApplyNum:(NSString*)limit_apply_num needCheck:(NSString *)need_check Checked:(NSString *)checked Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:communityID forKey:@"community_id"];
    [firstDic setObject:forumID forKey:@"forum_id"];
    [firstDic setObject:posterID forKey:@"poster_id"];
    [firstDic setObject:post_title forKey:@"post_title"];
    [firstDic setObject:post_text forKey:@"post_text"];
    [firstDic setObject:img_url forKey:@"main_image_url"];
    [firstDic setObject:chain forKey:@"chain"];
    [firstDic setObject:chain_name forKey:@"chain_name"];
    [firstDic setObject:chain_url forKey:@"chain_url"];
    [firstDic setObject:apply forKey:@"open_apply"];
    [firstDic setObject:limit_apply_num forKey:@"limit_apply_num"];
    [firstDic setObject:need_check forKey:@"need_check"];
    [firstDic setObject:checked forKey:@"checked"];

    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];

    [thirdDic setObject:@"NewPost" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         // no response
                         
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];


}
//请求实名认证
+(void)statusToolUserAuthWithRealName:(NSString *)realname HostName:(NSString *)name ID:(NSString *)user_id HouseNumber:(NSString *)house Phone:(NSString *)phone Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:realname forKey:@"realName"];
    [firstDic setObject:name forKey:@"name"];
    [firstDic setObject:user_id forKey:@"user_id"];
    [firstDic setObject:house forKey:@"house"];
    [firstDic setObject:phone forKey:@"phone"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"UserAuthenticate" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
    
}

+(void)statusToolIfApplyWithcommunity_id:(NSString *)community_id forum_id:(NSString *)forum_id post_id:(NSString *)post_id user_id:(NSString *)user_id  Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:community_id forKey:@"community_id"];
    [firstDic setObject:forum_id forKey:@"forum_id"];
    [firstDic setObject:post_id forKey:@"post_id"];
    [firstDic setObject:user_id forKey:@"user_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"IfApply" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        ifApplyItem *if_apply_item = [ifApplyItem createItemWitparametes:dic];
        success(if_apply_item);
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
    
}
//用户报名操作
+(void)statusToolPostApplyWithcommunity_id:(NSString *)community_id forum_id:(NSString *)forum_id post_id:(NSString *)post_id user_id:(NSString *)user_id limit_apply_num:(NSString *)limit_apply_num  Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:community_id forKey:@"community_id"];
    [firstDic setObject:forum_id forKey:@"forum_id"];
    [firstDic setObject:post_id forKey:@"post_id"];
    [firstDic setObject:user_id forKey:@"user_id"];
    [firstDic setObject:limit_apply_num forKey:@"limit_apply_num"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"PostApply" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
}
//结束报名操作
+(void)statusToolEndApplyWithcommunity_id:(NSString *)community_id forum_id:(NSString *)forum_id post_id:(NSString *)post_id user_id:(NSString *)user_id  Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:community_id forKey:@"community_id"];
    [firstDic setObject:forum_id forKey:@"forum_id"];
    [firstDic setObject:post_id forKey:@"post_id"];
    [firstDic setObject:user_id forKey:@"user_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"PostEndApply" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];

}


//hmx05181056 加载轮播图
+(void)statusToolGetSlideListWithCommunityID:(NSString *)community_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:community_id forKey:@"community_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"GetSlideList" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        SlideInfoList *list = [SlideInfoList createItemWitparametes:dic];
        NSMutableArray *ListArray = [NSMutableArray array];
        
        for(NSDictionary *dic in list.slideList){
            [ListArray addObject:[SlideInfoItem createItemWitparametes:dic]];
        }
        success(ListArray);
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
}

//post_id加载帖子详情
+(void)statusToolGetPostInfoWithPostID:(NSString *)post_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    NSMutableDictionary *fir = [[NSMutableDictionary alloc]init];
    [fir setObject:post_id forKey:@"post_id"];
    NSMutableDictionary *sec = [[NSMutableDictionary alloc]init];
    [sec setObject:fir forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:sec forKey:@"param"];
    [thirdDic setObject:@"LoadPostInfo" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic1 = [[NSDictionary alloc]init];
        dic1 = [dic valueForKey:@"data"];
        NSDictionary *dic2 = [[NSDictionary alloc]init];
        dic2 = [dic1 valueForKey:@"postinfo"];
        postItem *post_item = [postItem createItemWitparametes:dic2];
        success(post_item);
        
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];

}


@end

