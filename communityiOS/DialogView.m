//
//  DialogView.m
//  communityiOS
//
//  Created by tjufe on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "DialogView.h"

@implementation DialogView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.layer.cornerRadius = 10;
        
        self.layer.masksToBounds = YES;
        
        self.layer.borderWidth = 2;
        
        self.layer.borderColor = [[UIColor colorWithRed:0.50 green:0.10 blue:0.10 alpha:0.5]CGColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 23, 23)];
        [button setImage:[UIImage imageNamed:@"ic_setttings@2x"]forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeClickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag =1;
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(60, 60,100,20)];
        lab.text = @"welcome";
        [self addSubview:button];
        [self addSubview:lab];
//        UICollectionView *cw = [[UICollectionView alloc]init];
//        [self addSubview:cw];
    }
    return self;
    
        
        
        
    
}

-(IBAction)closeClickButton:(id)sender{
    NSLog(@"CLOSE");
    self.hidden = YES;
}

-(void)dealloc{
 //   [super dealloc];
}

@end
