//
//  ifApplyItem.h
//  communityiOS
//
//  Created by 金钟 on 15/4/11.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface ifApplyItem : NSObject
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;

@property (nonatomic,copy)NSString *apply_flag;

+(ifApplyItem *)createItemWitparametes:(NSDictionary*)dic;

@end

//这是用于判断用户是否参加活动(bao ming)的对象数据