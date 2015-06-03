//
//  SlideInfoItem.h
//  communityiOS
//
//  Created by 金钟 on 15/5/18.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface SlideInfoItem : NSObject

@property (nonatomic,strong)NSString *belong_community_id;
@property (nonatomic,strong)NSString *belong_forum_id;
@property (nonatomic,strong)NSString *post_id;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *main_image_url;

+(SlideInfoItem *)createItemWitparametes:(NSDictionary*)dic;

@end
