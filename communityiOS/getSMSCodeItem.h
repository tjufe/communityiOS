//
//  getSMSCodeItem.h
//  communityiOS
//
//  Created by tjufe on 15/6/5.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface getSMSCodeItem : NSObject
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSDictionary *data;
@property (nonatomic,strong)NSString *code;

+(getSMSCodeItem *)createItemWitparametes:(NSDictionary*)dic;



@end


//这是请求手机验证码的