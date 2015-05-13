//
//  PostReplyViewController.m
//  communityiOS
//
//  Created by 金钟 on 15/4/8.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "PostReplyViewController.h"
#import "replyInfoListItem.h"
#import "replyInfoItem.h"
#import "StatusTool.h"
#import "MBProgressHUD.h"



@interface PostReplyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

- (IBAction)replyAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *replyContentField;

@end

@implementation PostReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.navigationItem.title = self.postItem.title;
    
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

- (IBAction)replyAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [StatusTool statusToolPostReplyWithReplyText:self.replyContentField.text communityID:self.postItem.belong_community_id forumID:self.postItem.belong_forum_id postID:self.postItem.post_id userID:[defaults valueForKey:@"UserID"] Success:^(id object) {
        NSData *data = [[NSData alloc] initWithData:object];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[result valueForKey:@"status"] isEqualToString:@"OK"]){
            
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hud];
            hud.labelText = @"回复成功";
            hud.mode = MBProgressHUDModeText;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
            }];
        }else{
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hud];
            hud.labelText = @"请查看您的网络";
            hud.mode = MBProgressHUDModeText;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
            }];
        }
    } failurs:^(NSError *error) {
        //to do wrong
    }];
}
@end
