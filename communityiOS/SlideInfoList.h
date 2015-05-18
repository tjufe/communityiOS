//
//  SlideInfoList.h
//  communityiOS
//
//  Created by 金钟 on 15/5/18.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideInfoList : NSObject

@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;

@property (nonatomic,strong)NSArray *slideList;




+(SlideInfoList *)createItemWitparametes:(NSDictionary*)dic;
@end
