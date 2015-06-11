//
//  AddressGetter.m
//  communityiOS
//
//  Created by tjufe on 15/6/10.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "AddressGetter.h"

@implementation AddressGetter

+(instancetype)sharedGetter{
    static AddressGetter *_sharedGetter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedGetter = [[AddressGetter alloc]init];
    });
    return _sharedGetter;
}

-(id)init{
    if (self = [super init]) {
        self.address = [[NSString alloc]init];
    }
    return self;
}



@end
