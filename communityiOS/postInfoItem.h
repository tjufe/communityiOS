//
//  postInfoItem.h
//  communityiOS
//
//  Created by 金钟 on 15/4/11.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface postInfoItem : NSObject
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;

@property (nonatomic,copy)NSString *poster_nickname;
@property (nonatomic,copy)NSString *read_num;
@property (nonatomic,copy)NSString *reply_num;
@property (nonatomic,copy)NSString *apply_num;


+(postInfoItem *)createItemWitparametes:(NSDictionary*)dic;

@end

//这是帖子^^^^^^相关信息^^^^^^的返回结果的数据模型