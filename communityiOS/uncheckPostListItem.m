//
//  uncheckPostListItem.m
//  communityiOS
//
//  Created by tjufe on 15/5/4.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "uncheckPostListItem.h"

@implementation uncheckPostListItem

+(uncheckPostListItem *)createItemWitparametes:(NSDictionary*)dic
{
    uncheckPostListItem *item = [uncheckPostListItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[uncheckPostListItem mapDictionary]];
    return item;
    
}
+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" : @{
                     @"PostList":@"PostList"
                     
                     }
             };
}



@end
