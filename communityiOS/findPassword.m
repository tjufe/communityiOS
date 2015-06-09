//
//  findPassword.m
//  communityiOS
//
//  Created by tjufe on 15/6/5.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "findPassword.h"

@implementation findPassword
+(findPassword *)createItemWitparametes:(NSDictionary*)dic
{
    findPassword *item = [findPassword new];
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[findPassword mapDictionary]];
    return item;
}
+ (NSDictionary*)mapDictionary
{
    return @{
             @"status" : @"status",
             @"msg" : @"msg",
             @"data" :@{
                     @"ErrorMessage":@"ErrorMessage"
                     
                     }
             };
}




@end
