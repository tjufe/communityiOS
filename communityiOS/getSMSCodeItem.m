//
//  getSMSCodeItem.m
//  communityiOS
//
//  Created by tjufe on 15/6/5.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "getSMSCodeItem.h"

@implementation getSMSCodeItem
+(getSMSCodeItem *)createItemWitparametes:(NSDictionary*)dic
{
    getSMSCodeItem *item = [getSMSCodeItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[getSMSCodeItem mapDictionary]];
    return item;
}
+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                     @"code":@"code"
                     
                     }
             };
}




@end
