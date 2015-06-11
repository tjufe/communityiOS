//
//  AddressGetter.h
//  communityiOS
//
//  Created by tjufe on 15/6/10.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressGetter : NSObject

+(instancetype)sharedGetter;

@property(strong,nonatomic)NSString *address;

@end
