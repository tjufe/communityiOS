//
//  regItem.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface regItem : NSObject

@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;

+(regItem *)createItemWitparametes:(NSDictionary*)dic;

@end
