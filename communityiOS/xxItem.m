//
//  xxItem.m
//  YouYanChuApp
//
//  Created by 李昂Leon on 15/3/31.
//  Copyright (c) 2015年 HGG. All rights reserved.
//

#import "xxItem.h"
#import "KZPropertyMapper.h"
@implementation xxItem

+(xxItem*)createItemWitparametes:(NSDictionary*)dic
{
    xxItem *item = [xxItem new];
   
    [KZPropertyMapper mapValuesFrom:dic toInstance:item usingMapping:[xxItem mapDictionary]];
    
    return item;
}

+ (NSDictionary*)mapDictionary
{
    return @{
             @"id" : @"concertId",
             @"progress" : @"progress",
             @"areas" : @"areas",
             @"address" : @"address",
             @"genre" : @"genre",
             @"kind" : @{
                          @"name":@"username",
                          @"photos":@"phohos"
                       },
             @"title" : @"concertTitle",
             @"description" : @"concertDescription",
             @"begin_at" : @"beginAt"
             };
}
@end
