//
//  deletepostItem.h
//  communityiOS
//
//  Created by tjufe on 15/4/13.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"


@interface deletepostItem : NSObject

@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;
@property (nonatomic,strong)NSString *delete_result;

+(deletepostItem *)createItemWitparametes:(NSDictionary*)dic;

@end



//这是删除帖子的的数据对象模型
