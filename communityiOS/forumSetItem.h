//
//  forumSetItem.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface forumSetItem : NSObject

@property (nonatomic,strong)NSString *community_id;
@property (nonatomic,strong)NSString *forum_id;
@property (nonatomic,strong)NSString *site_id;
@property (nonatomic,strong)NSString *site_name;
@property (nonatomic,strong)NSString *site_value;

+(forumSetItem *)createItemWitparametes:(NSDictionary*)dic;

@end
