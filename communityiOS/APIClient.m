//
//  APIClient.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/3/30.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "APIClient.h"
#import "AddressGetter.h"
#import "AppDelegate.h"


@implementation APIClient

+(instancetype)sharedClient{
    static APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc]initWithBaseURL:
                         [NSURL URLWithString:API_HOST]];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [_sharedClient.requestSerializer setValue:@"2" forHTTPHeaderField:@"Accept"];
    });
    return _sharedClient;
    
}

@end
