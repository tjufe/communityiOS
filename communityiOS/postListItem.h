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
@property (nonatomic,strong)NSString *total;
//@property (nonatomic,strong)NSArray *apply_num;
//@property (nonatomic,strong)NSArray *reply_num;
//@property (nonatomic,strong)NSArray *read_num;
//@property (nonatomic,strong)NSArray *Phead_portrait_url;
//@property (nonatomic,strong)NSArray *poster_nickname;




+(postListItem *)createItemWitparametes:(NSDictionary*)dic;



@end

//这是请求帖子列表时，返回的帖子的列表对象