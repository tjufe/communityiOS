//
//  ScoreTypeList.h
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/28.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreTypeList : NSObject
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;
@property (nonatomic,strong)NSArray *scoreType;


+(ScoreTypeList *)createItemWitparametes:(NSDictionary*)dic;

@end
