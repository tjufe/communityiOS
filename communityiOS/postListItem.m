//
//  postListItem.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "postListItem.h"

@implementation postListItem

+(postListItem *)createItemWitparametes:(NSDictionary*)dic
{
    postListItem *item = [postListItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[postListItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" : @{
                     @"PostList":@"PostList",
                     @"apply_num":@"apply_num",
                     @"reply_num":@"reply_num",
                     @"read_num":@"read_num",
                     @"Phead_portrait_url":@"Phead_portrait_url",
                     @"poster_nickname":@"poster_nickname"
                    }
             };
}


@end
