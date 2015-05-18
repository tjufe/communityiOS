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

@property (nonatomic,strong)NSString *user_nickname;
@property (nonatomic,strong)NSString *post_reply_date;
@property (nonatomic,strong)NSString *reply_text;
@property (nonatomic,strong)NSString *post_reply_man_id;
@property (nonatomic,strong)NSString *head_portrait_url;
@property (nonatomic,strong)NSString *post_reply_id;
@property (nonatomic,strong)NSString *deleted;


+(replyInfoItem *)createItemWitparametes:(NSDictionary*)dic;

@end

//这是回复具体内容

