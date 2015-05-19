//
//  editPostItem.h
//  communityiOS
//
//  Created by tjufe on 15/5/18.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface editPostItem : NSObject

@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;



+(editPostItem *)createItemWitparametes:(NSDictionary*)dic;


@end


//这是编辑帖子的的数据对象模型
