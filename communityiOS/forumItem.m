//
//  forumItem.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "forumItem.h"

@implementation forumItem

+(forumItem *)createItemWitparametes:(NSDictionary*)dic
{
    forumItem *item = [forumItem new];
//    static forumItem *_item =nil;
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[forumItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             
                             @"community_id":@"community_id",
                             @"forum_id":@"forum_id",
                             @"forum_name":@"forum_name",    //板块名称
                             @"display_num":@"display_num",
                             @"image_url":@"image_url",      //图片
                             @"open_status":@"open_status",
                             @"ForumSetlist":@"ForumSetlist",
                             @"new_post_context":@"first_post_context",
                             @"new_post_date":@"first_post_date",
                             @"display_type":@"display_type"
                
             };
    
}

@end
