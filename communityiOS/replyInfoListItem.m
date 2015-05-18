//
//  replyInfoListItem.m
//  communityiOS
//
//  Created by 金钟 on 15/4/11.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "replyInfoListItem.h"
#import "KZPropertyMapper.h"

@implementation replyInfoListItem

+(replyInfoListItem *)createItemWitparametes:(NSDictionary*)dic
{
    replyInfoListItem *item = [replyInfoListItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[replyInfoListItem mapDictionary]];
    return item;
}


+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" : @{
                     @"contentList":@"contentList"
                     }
             };
}

@end
