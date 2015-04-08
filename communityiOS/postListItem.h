//
//  postListItem.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface postListItem : NSObject
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;

@property (nonatomic,strong)NSArray *PostList;



+(postListItem *)createItemWitparametes:(NSDictionary*)dic;



@end
