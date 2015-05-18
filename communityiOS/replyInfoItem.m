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
             
             @"user_nickname":@"user_nickname",
             @"post_reply_date":@"post_reply_date",
             @"reply_text":@"reply_text",
             @"post_reply_man_id":@"post_reply_man_id",
             @"head_portrait_url":@"head_portrait_url",
             @"post_reply_id":@"post_reply_id",
             @"deleted":@"deleted"
             };
}

@end
