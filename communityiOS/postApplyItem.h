//
//  postApplyItem.h
//  communityiOS
//
//  Created by 何茂馨 on 15/5/15.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"
@interface postApplyItem : NSObject
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;


+(postApplyItem *)createItemWitparametes:(NSDictionary*)dic;
@end
