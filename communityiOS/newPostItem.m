//
//  newPostItem.m
//  communityiOS
//
//  Created by tjufe on 15/5/15.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "newPostItem.h"

@implementation newPostItem

+(newPostItem *)createItemWitparametes:(NSDictionary*)dic
{
    newPostItem *item = [newPostItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[newPostItem mapDictionary]];
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

