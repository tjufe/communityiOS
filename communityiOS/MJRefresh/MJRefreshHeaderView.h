//
//  MJRefreshHeaderView.h
//  MJRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#import "MJRefreshBaseView.h"

@interface MJRefreshHeaderView : MJRefreshBaseView

@property (nonatomic, copy) NSString *dateKey;

//是否draging外部的scrollview
@property (nonatomic, assign) BOOL draging;

+ (instancetype)header;

@end