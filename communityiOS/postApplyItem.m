//
//  postApplyItem.m
//  communityiOS
//
//  Created by 何茂馨 on 15/5/15.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "postApplyItem.h"

@implementation postApplyItem

+(postApplyItem *)createItemWitparametes:(NSDictionary*)dic
{
    postApplyItem *item = [postApplyItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[postApplyItem mapDictionary]];
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                     
                     }
             };
}

@end
