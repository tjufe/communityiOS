//
//  replyInfoItem.h
//  communityiOS
//
//  Created by 金钟 on 15/4/11.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZPropertyMapper.h"

@interface replyInfoItem : NSObject

@property (nonatomic,strong)NSString *nickname;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *content;


+(replyInfoItem *)createItemWitparametes:(NSDictionary*)dic;

@end

//这是回复具体内容

