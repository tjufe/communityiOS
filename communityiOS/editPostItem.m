//
//  editPostItem.m
//  communityiOS
//
//  Created by tjufe on 15/5/18.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "editPostItem.h"

@implementation editPostItem

+(editPostItem *)createItemWitparametes:(NSDictionary*)dic
{
    editPostItem *item = [editPostItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[editPostItem mapDictionary]];
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
