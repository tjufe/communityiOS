//
//  forumListItem.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "forumListItem.h"

@implementation forumListItem

+(forumListItem *)createItemWitparametes:(NSDictionary*)dic
{
    forumListItem *item = [forumListItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[forumListItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                     @"ForumList":@"ForumList"
                     }
    };
             
}

@end
