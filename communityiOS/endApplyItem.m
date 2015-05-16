//
//  endApplyItem.m
//  communityiOS
//
//  Created by 何茂馨 on 15/5/15.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "endApplyItem.h"

@implementation endApplyItem
+(endApplyItem *)createItemWitparametes:(NSDictionary*)dic
{
    endApplyItem *item = [endApplyItem new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[endApplyItem mapDictionary]];
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
