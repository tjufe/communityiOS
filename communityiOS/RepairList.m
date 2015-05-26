//
//  RepairList.m
//  communityiOS
//
//  Created by 金钟 on 15/5/22.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "RepairList.h"
#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@implementation RepairList

+(RepairList *)createItemWitparametes:(NSDictionary*)dic
{
    RepairList *list = [RepairList new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:list usingMapping:[RepairList mapDictionary]];
    return list;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                     @"RepairList":@"RepairList"
                     }
             };
    
}
@end
