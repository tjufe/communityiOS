//
//  postItem.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "postItem.h"

@implementation postItem


+(postItem *)createItemWitparametes:(NSDictionary*)dic
{
    postItem *item = [postItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[postItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
                             @"post_id":@"post_id",
                             @"belong_community_id":@"belong_community_id",
                             @"belong_forum_id":@"belong_forum_id",
                             @"poster_id":@"poster_id",
                             @"post_date":@"post_date",
                             @"last_edit_date":@"last_edit_date",
                             @"set_top":@"set_top",
                             @"title":@"title",
                             @"main_image_url":@"main_image_url",
                             @"chain":@"chain",
                             @"chain_name":@"chain_name",
                             @"chain_url":@"chain_url",
                             @"push":@"push",
                             @"push_member":@"push_member",
                             @"post_text":@"post_text",
                             @"post_overed":@"post_overed",
                             @"post_over_date":@"post_over_date",
                             @"post_over_man":@"post_over_man",
                             @"deleted":@"deleted",
                             @"delete_date":@"delete_date",
                             @"delete_man_id":@"delete_man_id",
                             @"need_check":@"need_check",
                             @"checked":@"checked",
                             @"limit_apply_num":@"limit_apply_num",
                             @"apply_enough":@"apply_enough"
                             
                     
             };
}



@end
