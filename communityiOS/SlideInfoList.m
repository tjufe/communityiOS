//
//  SlideInfoList.m
//  communityiOS
//
//  Created by 金钟 on 15/5/18.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "SlideInfoList.h"
#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@implementation SlideInfoList

+(SlideInfoList *)createItemWitparametes:(NSDictionary*)dic
{
    SlideInfoList *list = [SlideInfoList new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:list usingMapping:[SlideInfoList mapDictionary]];
    return list;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                     @"slideList":@"slideList"
                     }
             };
    
}



@end
