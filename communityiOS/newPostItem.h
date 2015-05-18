//
//  newPostItem.h
//  communityiOS
//
//  Created by tjufe on 15/5/15.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface newPostItem : NSObject

@property (nonatomic,copy)NSString *community_id;
@property (nonatomic,copy)NSString *forum_id;
@property (nonatomic,strong)NSString *poster_id;
@property (nonatomic,strong)NSString *post_title;
@property (nonatomic,strong)NSString *post_text;
@property (nonatomic,strong)NSString *main_image_url;
@property (nonatomic,strong)NSString *chain;
@property (nonatomic,strong)NSString *chain_name;
@property (nonatomic,strong)NSString *chain_url;
@property (nonatomic,strong)NSString *open_apply;
@property (nonatomic,strong)NSString *limit_apply_num;
@property (nonatomic,strong)NSString *need_check;
@property (nonatomic,strong)NSString *checked;

+(newPostItem *)createItemWitparametes:(NSDictionary*)dic;


@end

//这是发帖子的的数据对象模型