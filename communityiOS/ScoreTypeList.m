//
//  ScoreTypeList.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/28.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "ScoreTypeList.h"
#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@implementation ScoreTypeList

+(ScoreTypeList *)createItemWitparametes:(NSDictionary*)dic
{
    ScoreTypeList *list = [ScoreTypeList new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:list usingMapping:[ScoreTypeList mapDictionary]];
    return list;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                     @"scoreType":@"scoreType"
                     }
             };
    
}

@end
