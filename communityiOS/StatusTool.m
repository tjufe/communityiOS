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
@end
