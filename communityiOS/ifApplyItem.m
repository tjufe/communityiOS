//
//  ifApplyItem.m
//  communityiOS
//
//  Created by 金钟 on 15/4/11.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "ifApplyItem.h"

@implementation ifApplyItem

+(ifApplyItem *)createItemWitparametes:(NSDictionary*)dic
{
    ifApplyItem *item = [ifApplyItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[ifApplyItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                     @"apply_flag":@"apply_flag"
                     }
             };
}

@end