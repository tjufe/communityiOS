//
//  postItem.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface postItem : NSObject


@property (nonatomic,strong)NSString *post_id;
@property (nonatomic,strong)NSString *belong_community_id;
@property (nonatomic,strong)NSString *belong_forum_id;
@property (nonatomic,strong)NSString *poster_id;
@property (nonatomic,strong)NSString *post_date;
@property (nonatomic,strong)NSString *last_edit_date;
@property (nonatomic,strong)NSString *set_top;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *main_image_url;
@property (nonatomic,strong)NSString *chain;
@property (nonatomic,strong)NSString *chain_name;
@property (nonatomic,strong)NSString *chain_url;
@property (nonatomic,strong)NSString *push;
@property (nonatomic,strong)NSString *push_member;
@property (nonatomic,strong)NSString *post_text;
@property (nonatomic,strong)NSString *post_overed;
@property (nonatomic,strong)NSString *post_over_date;
@property (nonatomic,strong)NSString *post_over_man;
@property (nonatomic,strong)NSString *deleted;
@property (nonatomic,strong)NSString *delete_date;
@property (nonatomic,strong)NSString *delete_man_id;
@property (nonatomic,strong)NSString *need_check;
@property (nonatomic,strong)NSString *checked;


+(postItem *)createItemWitparametes:(NSDictionary*)dic;
@end
