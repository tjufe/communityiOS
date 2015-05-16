//
//  uncheckPostListItem.h
//  communityiOS
//
//  Created by lx on 15/5/4.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface uncheckPostListItem : NSObject

@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;

@property (nonatomic,strong)NSArray *PostList;

+(uncheckPostListItem *)createItemWitparametes:(NSDictionary*)dic;

@end

//这是请求待审核帖子列表时，返回的待审核帖子的列表对象