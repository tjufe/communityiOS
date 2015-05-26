//
//  RepairInfo.h
//  communityiOS
//
//  Created by 金钟 on 15/5/22.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepairInfo : NSObject

@property (nonatomic,strong)NSString *community_id;
@property (nonatomic,strong)NSString *forum_id;
@property (nonatomic,strong)NSString *show_index;
@property (nonatomic,strong)NSString *repair_text;

+(RepairInfo *)createItemWitparametes:(NSDictionary*)dic;

@end
