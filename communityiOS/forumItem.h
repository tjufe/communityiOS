//
//  forumItem.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface forumItem : NSObject
@property (nonatomic,strong)NSString *community_id;
@property (nonatomic,strong)NSString *forum_id;
@property (nonatomic,strong)NSString *forum_name;
@property (nonatomic,strong)NSString *display_num;
@property (nonatomic,strong)NSString *image_url;
@property (nonatomic,strong)NSString *open_status;
@property (nonatomic,strong)NSArray *ForumSetlist;
@property (nonatomic,strong)NSString *first_post_context;
@property (nonatomic,strong)NSString *first_post_date;
@property (nonatomic,strong)NSString *display_type;

+(forumItem *)createItemWitparametes:(NSDictionary*)dic;

@end
//这是请求板块列表是返回的^^^^^^^板块详情^^^^^^^^的数据对象模型