//
//  replyInfoItem.m
//  communityiOS
//
//  Created by 金钟 on 15/4/11.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "replyInfoItem.h"

@implementation replyInfoItem

+(replyInfoItem *)createItemWitparametes:(NSDictionary*)dic
{
    replyInfoItem *item = [replyInfoItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[replyInfoItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             
             @"nickname":@"nickname",
             @"date":@"date",
             @"content":@"content",
             @"head_portrait_url":@"head_portrait_url"
             };
}

@end
