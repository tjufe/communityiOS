//
//  SlideInfoItem.m
//  communityiOS
//
//  Created by 金钟 on 15/5/18.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "SlideInfoItem.h"

@implementation SlideInfoItem

+(SlideInfoItem *)createItemWitparametes:(NSDictionary*)dic
{
    SlideInfoItem *item = [SlideInfoItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[SlideInfoItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             
             @"belong_community_id":@"belong_community_id",
             @"belong_forum_id":@"belong_forum_id",
             @"post_id":@"post_id",
             @"title":@"title",
             @"main_image_url":@"main_image_url",
             
               };
    
}

@end
