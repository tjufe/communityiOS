//
//  MJRefreshBaseView+CustomActivityIndicator.m
//  MJRefreshExample
//
//  Created by ChenZhiWen on 10/16/14.
//  Copyright (c) 2014 itcast. All rights reserved.
//

#import "MJRefreshBaseView+CustomActivityIndicator.h"
static AMPActivityIndicator *customIndicator;
@interface MJRefreshBaseView(){
    __weak UIActivityIndicatorView *_activityView;
}
@end
@implementation MJRefreshBaseView (CustomActivityIndicator)

+(void)customIndicatorWithBarHeight:(CGFloat)barHeight andBarWidth:(CGFloat)barWidth andAperture:(CGFloat)aperture andThinColor:(UIColor *)color andBackgrounColor:(UIColor *)backgroundColor
{
    if (!customIndicator) {
        customIndicator = [[AMPActivityIndicator alloc]init];
        [customIndicator setAperture:aperture];
        [customIndicator setBarWidth:barWidth];
        [customIndicator setBarHeight:barHeight];
        [customIndicator setBarColor:color];
        [customIndicator setBackgroundColor:backgroundColor?backgroundColor:customIndicator.backgroundColor];
        [customIndicator setFrame:CGRectMake(0, 4.5, 30, 30)];
        
    }
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImage.bounds;
        activityView.autoresizingMask = self.arrowImage.autoresizingMask;
        [self addSubview:_activityView = activityView];
    }
    if (customIndicator) {
        [_activityView setColor:[UIColor clearColor]];
        [_activityView addSubview:customIndicator];
        [customIndicator startAnimating];
    }
    
    return _activityView;
}
- (void)dealloc
{
    customIndicator = nil;
}
@end

