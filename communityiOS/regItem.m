//
//  regItem.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "regItem.h"

@implementation regItem

+(regItem *)createItemWitparametes:(NSDictionary*)dic
{
    regItem *item = [regItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[regItem mapDictionary]];
    return item;
}
+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@"data"
             };
}

@end
