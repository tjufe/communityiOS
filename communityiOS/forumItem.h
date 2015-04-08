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

+(forumItem *)createItemWitparametes:(NSDictionary*)dic;

@end
