//
//  xxItem.h
//  YouYanChuApp
//
//  Created by 李昂Leon on 15/3/31.
//  Copyright (c) 2015年 HGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface xxItem : NSObject

@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSArray* phohts;

+(xxItem*)createItemWitparametes:(NSDictionary*)dic;
;

@end
