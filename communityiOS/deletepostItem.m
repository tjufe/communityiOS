//
//  deletepostItem.m
//  communityiOS
//
//  Created by tjufe on 15/4/13.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "deletepostItem.h"

@implementation deletepostItem

+(deletepostItem *)createItemWitparametes:(NSDictionary*)dic
{
    deletepostItem *item = [deletepostItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[deletepostItem mapDictionary]];
    return item;
}
+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                        @"delete_result":@"delete_result"
                     }
             };
}

@end
