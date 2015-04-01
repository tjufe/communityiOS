//
//  MJRefreshBaseView+CustomActivityIndicator.h
//  MJRefreshExample
//
//  Created by ChenZhiWen on 10/16/14.
//  Copyright (c) 2014 itcast. All rights reserved.
//

#import "MJRefreshBaseView.h"
#import "AMPActivityIndicator.h"

@interface MJRefreshBaseView (CustomActivityIndicator)

+(void)customIndicatorWithBarHeight:(CGFloat)barHeight andBarWidth:(CGFloat)barWidth andAperture:(CGFloat)aperture andThinColor:(UIColor *)color andBackgrounColor:(UIColor *)backgroundColor;
@end
