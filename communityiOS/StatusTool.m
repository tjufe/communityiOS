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
    [firstDic setObject:Pwd forKey:@"login_password"];
    NSMutableDictionary *secondDic = [[NSMutableDictionary  alloc] init];
    [secondDic  setObject:firstDic forKey:@"Data"];
    NSMutableDictionary *thirdDic = [[NSMutableDictionary  alloc] init];
    [thirdDic setObject:secondDic forKey:@"param"];
    [thirdDic setObject:@"UserLogin" forKey:@"method"];
    
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
//发送注册请求
+(void)statusToolGetUserRegWithName:(NSString *)Name  PassWord:(NSString *)Pwd Phone:(NSString *)Phone RegID:(NSString *)RegID Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
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
+(void)statusToolGetPostListWithbfID:(NSString *)bfID  bcID:(NSString *)bcID userID:(NSString *)userID filter:(NSString *)filter Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
    NSMutableDictionary *firstDic = [[NSMutableDictionary alloc]init];
    [firstDic setObject:bfID forKey:@"belong_forum_id"];
    [firstDic setObject:bcID forKey:@"belong_community_id"];
    [firstDic setObject:userID forKey:@"user_id"];
    [firstDic setObject:filter forKey:@"filter"];
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



//请求修改昵称
+(void)statusToolCorrectNickNameWithNickName:(NSString *)newNickname  UserID:(NSString *)ID Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
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
+(void)statusToolCorrectPwdWithPwd:(NSString *)password  UserID:(NSString *)ID  NewPwd:(NSString*)password1 ConfirmPwd:(NSString *) confirmPassword Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
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
+(void)statusToolGetPostRelatedInfoWithpostID:(NSString *)post_id  poster_ID:(NSString *)poster_id community_ID:(NSString *)community_id forum_ID:(NSString *)forum_id Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
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
+(void)statusToolPostNewPostWithcom_id:(NSString *)community_id  forumID:(NSString *)forum_id posterID:(NSString *)poster_id postTitle:(NSString *)post_title postText:(NSString *)post_text Image:(NSString*)main_image_url chainFlag:(NSString *)chain_flag chainName:(NSString *)chain_name chainURL:(NSString *)chain_url pushMember:(NSString*)push_member Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
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
+(void)statusToolPostEditWithcomID:(NSString *)community_id forumID:(NSString *)forum_id postTitle:(NSString *)post_title Image:(NSString*)main_image_url chainFlag:(NSString *)chain_flag chainName:(NSString *)chain_name chainURL:(NSString *)chain_url pushFlag:(NSString*)push_flag userID:(NSString *)user_id postText:(NSString *)post_text editFlag:(NSString *)edit_flag posterID:(NSString *)poster_id Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
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
+(void)statusToolPostOperateWithcommunityID:(NSString *)community_id forumID:(NSString *)forum_id postID:(NSString *)post_id userID:(NSString *)user_id Flag:(NSNumber *)flag Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure{
    
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

@end