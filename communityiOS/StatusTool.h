//
//  StatusTool.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/7.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>


//请求板块列表
typedef void(^ForumListSuccess)(NSArray * array);
typedef void(^ForumListFailurs)(NSError * error);

@interface StatusTool : NSObject

//请求板块列表
+ (void)statusToolGetForumListWithID:(NSString *)ID  Success:(ForumListSuccess)success failurs:(ForumListFailurs)failure;

@end
