//
//  PostInfo.h
//  communityiOS
//
//  Created by 金钟 on 15/5/25.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostInfo : NSObject

@property (nonatomic,strong)NSString *community_id;
@property (nonatomic,strong)NSString *post_id;
@property (nonatomic,strong)NSString *forum_id;
@property (nonatomic,strong)NSString *poster_id;
@property (nonatomic,strong)NSString *post_title;
@property (nonatomic,strong)NSString *post_text;         //故障位置
@property (nonatomic,strong)NSString *main_image_url;
@property (nonatomic,strong)NSString *chain;
@property (nonatomic,strong)NSString *chain_name;
@property (nonatomic,strong)NSString *chain_url;
@property (nonatomic,strong)NSString *open_apply;
@property (nonatomic,strong)NSString *limit_apply_num;
@property (nonatomic,strong)NSString *need_check;
@property (nonatomic,strong)NSString *checked;
@property (nonatomic,strong)NSString *post_text_1;      //故障描述
@property (nonatomic,strong)NSString *post_text_2;      //联系人
@property (nonatomic,strong)NSString *post_text_3;      //联系电话


@end
