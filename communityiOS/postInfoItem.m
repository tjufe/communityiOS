//
//  postInfoItem.m
//  communityiOS
//
//  Created by 金钟 on 15/4/11.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "postInfoItem.h"

@implementation postInfoItem

+(postInfoItem *)createItemWitparametes:(NSDictionary*)dic{
    postInfoItem *item = [postInfoItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[postInfoItem mapDictionary]];
    return item;
    
}

+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                     @"poster_nickname":@"poster_nickname",
                     @"read_num":@"read_num",
                     @"reply_num":@"reply_num",
                     @"apply_num":@"apply_num"
                     }
             };
}


@end