//
//  ChainToWebViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/5/14.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "ChainToWebViewController.h"

@interface ChainToWebViewController ()<UIWebViewDelegate>




@end

@implementation ChainToWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.ChainToWebView.scalesPageToFit =YES;
    self.ChainToWebView.delegate =self;
    [self loadWebPage];
    
}
- (void)loadWebPage
{
    
    NSURL *url =[NSURL URLWithString:self.chain_url ];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.ChainToWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
