//
//  RepairList.h
//  communityiOS
//
//  Created by 金钟 on 15/5/22.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepairList : NSObject

@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;

@property (nonatomic,strong)NSArray *RepairList;




+(RepairList *)createItemWitparametes:(NSDictionary*)dic;
@end
