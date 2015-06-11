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
#import "newPostItem.h"
#import "getSMSCodeItem.h"
#import "SlideInfoList.h"
#import "SlideInfoItem.h"
#import "RepairList.h"
#import "RepairInfo.h"
#import "findPassword.h"

#import "replyInfoListItem.h"
#import "editPostItem.h"
#import "ifApplyItem.h"
#import "postApplyItem.h"
#import "ScoreTypeList.h"
#import <objc/runtime.h>

@implementation StatusTool


//请求板块列表
+ (void)statusToolGetForumListWithID:(NSString *)ID  Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:ID forKey:@"community_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"loadForumList" forKey:@"method"];
    
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
    [firstDic setValue:Name forKey:@"phone_number"];
    [firstDic setValue:Pwd forKey:@"login_password"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"UserLogin" forKey:@"method"];
    
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
    [firstDic setValue:Name forKey:@"name"];
    [firstDic setValue:Pwd forKey:@"password"];
    [firstDic setValue:Phone forKey:@"phone"];
    [firstDic setValue:RegID forKey:@"id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"UserReg" forKey:@"method"];
    
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
    [firstDic setValue:bfID forKey:@"belong_forum_id"];
    [firstDic setValue:bcID forKey:@"belong_community_id"];
    [firstDic setValue:userID forKey:@"user_id"];
    [firstDic setValue:filter forKey:@"filter"];
    [firstDic setValue:page forKey:@"page"];
    [firstDic setValue:rows forKey:@"rows"];
    
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"LoadPostList" forKey:@"method"];
    
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
    [firstDic setValue:bfID forKey:@"forum_id"];
    [firstDic setValue:bcID forKey:@"community_id"];
    [firstDic setValue:page forKey:@"page"];
    [firstDic setValue:rows forKey:@"rows"];

    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"LoadUncheckPostList" forKey:@"method"];
    
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
    [firstDic setValue:newNickname forKey:@"newNickname"];
    [firstDic setValue:ID forKey:@"id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"AlterNickname" forKey:@"method"];
    
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
    [firstDic setValue:password forKey:@"password"];
    [firstDic setValue:ID forKey:@"id"];
    [firstDic setValue:password1 forKey:@"password1"];
    [firstDic setValue:confirmPassword forKey:@"confirmPassword"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"AlterPassword" forKey:@"method"];
    
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
    [firstDic setValue:post_id forKey:@"post_id"];
    [firstDic setValue:poster_id forKey:@"poster_id"];
    [firstDic setValue:community_id forKey:@"community_id"];
    [firstDic setValue:forum_id forKey:@"forum_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"PostInfo" forKey:@"method"];
    
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
//+(void)statusToolPostNewPostWithcom_id:(NSString *)community_id  forumID:(NSString *)forum_id posterID:(NSString *)poster_id postTitle:(NSString *)post_title postText:(NSString *)post_text Image:(NSString*)main_image_url chainFlag:(NSString *)chain_flag chainName:(NSString *)chain_name chainURL:(NSString *)chain_url pushMember:(NSString*)push_member Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
//    
//    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
//    [firstDic setObject:community_id forKey:@"community_id"];
//    [firstDic setObject:forum_id forKey:@"forum_id"];
//    [firstDic setObject:poster_id forKey:@"poster_id"];
//    [firstDic setObject:post_title forKey:@"post_title"];
//    [firstDic setObject:post_text forKey:@"post_text"];
//    [firstDic setObject:main_image_url forKey:@"main_image_url"];
//    [firstDic setObject:chain_flag forKey:@"chain_flag"];
//    [firstDic setObject:chain_name forKey:@"chain_name"];
//    [firstDic setObject:chain_url forKey:@"chain_url"];
//    [firstDic setObject:push_member forKey:@"push_member"];
//    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
//    [secondDic  setObject:firstDic forKey:@"Data"];
//    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
//    [thirdDic setObject:secondDic forKey:@"param"];
//    [thirdDic setObject:@"NewPost" forKey:@"method"];
//    
//    [HttpTool postWithparams:thirdDic  success:^(id responseObject) {
//        // no response
//        
//    } failure:^(NSError *error) {
//        if (failure == nil) return;
//        failure(error);
//    }];
//}
//请求编辑帖子
+(void)statusToolEditPostWithcID:(NSString *)communityID fID:(NSString *)forumID postID:(NSString *)post_id PosterID:(NSString *)posterID postTitle:(NSString *)post_title postText:(NSString *)post_text imgURL:(NSString *)img_url chain:(NSString *)chain chainName:(NSString *)chain_name chainURL:(NSString *)chain_url apply:(NSString *)apply limApplyNum:(NSString*)limit_apply_num needCheck:(NSString *)need_check Checked:(NSString *)checked Success:(StatusSuccess)success failurs:(StatusFailurs)failure{

    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:communityID forKey:@"community_id"];
    [firstDic setValue:forumID forKey:@"forum_id"];
    [firstDic setValue:post_id forKey:@"post_id"];
    [firstDic setValue:posterID forKey:@"poster_id"];
    [firstDic setValue:post_title forKey:@"post_title"];
    [firstDic setValue:post_text forKey:@"post_text"];
    [firstDic setValue:img_url forKey:@"main_image_url"];
    [firstDic setValue:chain forKey:@"chain"];
    [firstDic setValue:chain_name forKey:@"chain_name"];
    [firstDic setValue:chain_url forKey:@"chain_url"];
    [firstDic setValue:apply forKey:@"open_apply"];
    [firstDic setValue:limit_apply_num forKey:@"limit_apply_num"];
    [firstDic setValue:need_check forKey:@"need_check"];
    [firstDic setValue:checked forKey:@"checked"];

  
   
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"PostEdit" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic  success:^(id responseObject) {
        // no response
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        editPostItem *edit_post_item = [editPostItem createItemWitparametes:dic];
        success(edit_post_item);

    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];

}

//请求帖子操作
+(void)statusToolPostOperateWithcommunityID:(NSString *)community_id forumID:(NSString *)forum_id postID:(NSString *)post_id userID:(NSString *)user_id Flag:(NSNumber *)flag Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:community_id forKey:@"community_id"];
    [firstDic setValue:forum_id forKey:@"forum_id"];
    [firstDic setValue:post_id forKey:@"post_id"];
    [firstDic setValue:user_id forKey:@"user_id"];
    [firstDic setValue:flag forKey:@"flag"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"PostOperate" forKey:@"method"];
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
    [firstDic setValue:post_id forKey:@"post_id"];
    [firstDic setValue:delete_user_id forKey:@"delete_user_id"];
    [firstDic setValue:community_id forKey:@"community_id"];
    [firstDic setValue:forum_id forKey:@"forum_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"DeletePost" forKey:@"method"];
    
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
    [firstDic setValue:postID forKey:@"id"];
    [firstDic setValue:page forKey:@"page"];  //获得列表的第几页
    [firstDic setValue:rows forKey:@"rows"];  //每页的行数
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"ReplyContent" forKey:@"method"];
    
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
+(void)statusToolPostReplyWithReplyText:(NSString *)reply_text CommunityID:(NSString*)community_id ForumID:(NSString*)forum_id PostID:(NSString*)post_id UserID:(NSString*)user_id Date:(NSString *)date ReplyID:(NSString*)reply_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:reply_text forKey:@"content"];
    [firstDic setValue:community_id forKey:@"belong_community_id"];
    [firstDic setValue:forum_id forKey:@"belong_forum_id"];
    [firstDic setValue:post_id forKey:@"id"];
    [firstDic setValue:user_id forKey:@"name"];
    [firstDic setValue:reply_id forKey:@"reply_id"];
    [firstDic setValue:date forKey:@"date"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"AddContent" forKey:@"method"];
    

    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];
    

}

//刷新数据库，更新上传图片
+(void)statusToolRefreshUserImageWithUserID:(NSString *)user_id ImageGUID:(NSString *)image_guid Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:user_id forKey:@"id"];
    [firstDic setValue:image_guid forKey:@"photourl"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"UserUploadPhoto" forKey:@"method"];
    
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
    [firstDic setValue:communityID forKey:@"community_id"];
    [firstDic setValue:forumID forKey:@"forum_id"];
    [firstDic setValue:posterID forKey:@"poster_id"];
    [firstDic setValue:post_title forKey:@"post_title"];
    [firstDic setValue:post_text forKey:@"post_text"];
    [firstDic setValue:img_url forKey:@"main_image_url"];
    [firstDic setValue:chain forKey:@"chain"];
    [firstDic setValue:chain_name forKey:@"chain_name"];
    [firstDic setValue:chain_url forKey:@"chain_url"];
    [firstDic setValue:apply forKey:@"open_apply"];
    [firstDic setValue:limit_apply_num forKey:@"limit_apply_num"];
    [firstDic setValue:need_check forKey:@"need_check"];
    [firstDic setValue:checked forKey:@"checked"];

    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];

    [thirdDic setValue:@"NewPost" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         // no response
                         NSData *data = [[NSData alloc]initWithData:responseObject];
                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                         newPostItem *new_post_item = [newPostItem createItemWitparametes:dic];
                         success(new_post_item);
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];


}
//请求实名认证
+(void)statusToolUserAuthWithRealName:(NSString *)realname HostName:(NSString *)name ID:(NSString *)user_id HouseNumber:(NSString *)house Phone:(NSString *)phone Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:realname forKey:@"realName"];
    [firstDic setValue:name forKey:@"name"];
    [firstDic setValue:user_id forKey:@"user_id"];
    [firstDic setValue:house forKey:@"house"];
    [firstDic setValue:phone forKey:@"phone"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"UserAuthenticate" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
    
}

+(void)statusToolIfApplyWithcommunity_id:(NSString *)community_id forum_id:(NSString *)forum_id post_id:(NSString *)post_id user_id:(NSString *)user_id  Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:community_id forKey:@"community_id"];
    [firstDic setValue:forum_id forKey:@"forum_id"];
    [firstDic setValue:post_id forKey:@"post_id"];
    [firstDic setValue:user_id forKey:@"user_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"IfApply" forKey:@"method"];
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
    [firstDic setValue:community_id forKey:@"community_id"];
    [firstDic setValue:forum_id forKey:@"forum_id"];
    [firstDic setValue:post_id forKey:@"post_id"];
    [firstDic setValue:user_id forKey:@"user_id"];
    [firstDic setValue:limit_apply_num forKey:@"limit_apply_num"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"PostApply" forKey:@"method"];
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
    [firstDic setValue:community_id forKey:@"community_id"];
    [firstDic setValue:forum_id forKey:@"forum_id"];
    [firstDic setValue:post_id forKey:@"post_id"];
    [firstDic setValue:user_id forKey:@"user_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"PostEndApply" forKey:@"method"];
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
    [firstDic setValue:community_id forKey:@"community_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"GetSlideList" forKey:@"method"];
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
//请求删除回复
+(void)statusToolPostDeleteReplyWithUserID:(NSString *)user_id Reply_id:(NSString *)post_reply_id PostID:(NSString*)post_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    NSMutableDictionary *fir = [[NSMutableDictionary alloc]init];
    [fir setValue:user_id forKey:@"user_id"];
    [fir setValue:post_reply_id forKey:@"post_reply_id"];
    [fir setValue:post_id forKey:@"post_id"];
    NSMutableDictionary *sec = [[NSMutableDictionary alloc]init];
    [sec setValue:fir forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:sec forKey:@"param"];
    [thirdDic setValue:@"DeleteItem" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];

}

//post_id加载帖子详情
+(void)statusToolGetPostInfoWithPostID:(NSString *)post_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    NSMutableDictionary *fir = [[NSMutableDictionary alloc]init];
    [fir setValue:post_id forKey:@"post_id"];
    NSMutableDictionary *sec = [[NSMutableDictionary alloc]init];
    [sec setValue:fir forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:sec forKey:@"param"];
    [thirdDic setValue:@"LoadPostInfo" forKey:@"method"];
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

+(void)statusToolLoadRepairTypeWithCommunityID:(NSString *)community_id ForumID:(NSString *)forum_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{

    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:community_id forKey:@"community_id"];
    [firstDic setValue:forum_id forKey:@"forum_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"LoadRepairType" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        RepairList *list = [RepairList createItemWitparametes:dic];
        NSMutableArray *ListArray = [NSMutableArray array];
        
        for(NSDictionary *dic in list.RepairList){
            [ListArray addObject:[RepairInfo createItemWitparametes:dic]];
        }
        success(ListArray);
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
}
//报修发帖
+(void)statusToolNewPostWithPostInfo:(PostInfo *)postInfo Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];

    NSString *className = NSStringFromClass([PostInfo class]);
    const char * cClassName = [className UTF8String];
    id classM = objc_getClass(cClassName);
    // i 计数 、  outCount 放我们的属性个数
    unsigned int outCount, i;
    // 反射得到属性的个数 、
    objc_property_t * properties = class_copyPropertyList(classM, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        // 获得属性名称
        NSString * attributeName = [NSString stringWithUTF8String:property_getName(property)];
        // 获得属性的值
        id value = [postInfo valueForKey:attributeName];
        if(value){
            [firstDic setValue:value forKey:attributeName];
        }
    }
    
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    
    [thirdDic setValue:@"NewPost" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic
                     success:^(id responseObject) {
                         // no response
                         NSData *data = [[NSData alloc]initWithData:responseObject];
                         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                         newPostItem *new_post_item = [newPostItem createItemWitparametes:dic];
                         success(new_post_item);
                     } failure:^(NSError *error) {
                         if (failure == nil) return;
                         failure(error);
                     }];
}
//编辑报修帖子 lx20150527
+(void)statusToolEditPostWithPostInfo:(PostInfo *)postInfo Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    
    NSString *className = NSStringFromClass([PostInfo class]);
    const char * cClassName = [className UTF8String];
    id classM = objc_getClass(cClassName);
    // i 计数 、  outCount 放我们的属性个数
    unsigned int outCount, i;
    // 反射得到属性的个数 、
    objc_property_t * properties = class_copyPropertyList(classM, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        // 获得属性名称
        NSString * attributeName = [NSString stringWithUTF8String:property_getName(property)];
        // 获得属性的值
        id value = [postInfo valueForKey:attributeName];
        if(value){
            [firstDic setValue:value forKey:attributeName];
        }
    }
    
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    
    [thirdDic setValue:@"PostEdit" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic  success:^(id responseObject) {
        // no response
        NSData *data = [[NSData alloc]initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        editPostItem *edit_post_item = [editPostItem createItemWitparametes:dic];
        success(edit_post_item);
        
    } failure:^(NSError *error) {
        if (failure == nil) return;
        failure(error);
    }];

}





//发送报修的评价
+(void)statusToolPostMendScoreWithPostID:(NSString *)post_id User_ID:(NSString*)user_id Score:(NSString*)score Evaluate:(NSString *)evaluate Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:post_id forKey:@"post_id"];
    [firstDic setValue:user_id forKey:@"user_id"];
    [firstDic setValue:score forKey:@"score"];
    if (evaluate == nil) {
        evaluate = @"";
    }
    [firstDic setValue:evaluate forKey:@"evaluate"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"EndRepair" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        success(dic);
        
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
}

//下载到评价的类型
+(void)statusToolGetScoreTypeWithCommunityID:(NSString *)community_id ForumID:(NSString *)forum_id Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setValue:community_id forKey:@"community_id"];
    [firstDic setValue:forum_id forKey:@"forum_id"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setValue:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:secondDic forKey:@"param"];
    [thirdDic setValue:@"LoadScoreType" forKey:@"method"];
    
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        ScoreTypeList *scoreTypeList = [ScoreTypeList createItemWitparametes:dic];
        success(scoreTypeList.scoreType);
        
        
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
    
}
//获取手机验证码
+(void)statusToolGetSMSCodeWithPhoneNumber:(NSString *)phone_number Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    NSMutableDictionary *fir = [[NSMutableDictionary alloc]init];
    [fir setValue:phone_number forKey:@"phone_number"];
    NSMutableDictionary *sec = [[NSMutableDictionary alloc]init];
    [sec setValue:fir forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:sec forKey:@"param"];
    [thirdDic setValue:@"GetSMSCode" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        getSMSCodeItem *result = [getSMSCodeItem createItemWitparametes:dic];
        success(result);
        
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];

}
//获取手机验证码
+(void)statusToolFindPasswordWithPhone:(NSString *)phone Id:(NSString *)user_id Password:(NSString *)password ConfirmPassword:(NSString *)confirm_password Success:(StatusSuccess)success failurs:(StatusFailurs)failure{
    
    NSMutableDictionary *fir = [[NSMutableDictionary alloc]init];
    [fir setValue:phone forKey:@"phone"];
    [fir setValue:user_id forKey:@"user_id"];
    [fir setValue:password  forKey:@"password1"];
    [fir setValue:confirm_password   forKey:@"confirm_password"];
    NSMutableDictionary *sec = [[NSMutableDictionary alloc]init];
    [sec setValue:fir forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setValue:sec forKey:@"param"];
    [thirdDic setValue:@"FindPassword" forKey:@"method"];
    [HttpTool postWithparams:thirdDic success:^(id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        findPassword *result = [findPassword createItemWitparametes:dic];
        success(result);
        
    } failure:^(NSError *error) {
        if (failure == nil) return ;
        failure(error);
    }];
}



@end

