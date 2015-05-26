//
//  RepairInfo.m
//  communityiOS
//
//  Created by 金钟 on 15/5/22.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "RepairInfo.h"
#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"
@implementation RepairInfo

+(RepairInfo *)createItemWitparametes:(NSDictionary*)dic
{
    RepairInfo *item = [RepairInfo new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[RepairInfo mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             
             @"community_id":@"community_id",
             @"forum_id":@"forum_id",
             @"show_index":@"show_index",
             @"repair_text":@"repair_text",
             
             };
    
}
@end
