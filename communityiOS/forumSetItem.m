//
//  forumSetItem.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "forumSetItem.h"
#import "KZPropertyMapper.h"

@implementation forumSetItem

+(forumSetItem *)createItemWitparametes:(NSDictionary*)dic
{
    forumSetItem *item = [forumSetItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[forumSetItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
                @"community_id":@"community_id",
                @"forum_id":@"forum_id",
                @"site_id":@"site_id",
                @"site_name":@"site_name",
                @"site_value":@"site_value"
             };
    
}
@end
