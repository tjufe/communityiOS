//
//  PostListViewController.m
//  communityiOS
//
//  Created by tjufe on 15/3/19.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "PostListViewController.h"
#import "PostTableViewCell.h"
#import "PostDetailViewController.h"
#import "UIViewController+Create.h"

#import "forumItem.h"

@interface PostListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *ForumName;

@end

@implementation PostListViewController



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  10;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell =[[[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//3绘制行高
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostDetailViewController *PDVC = [ PostDetailViewController createFromStoryboardName:@"PostDetailStoryboard" withIdentifier:@"postDetail"];
    [self.navigationController pushViewController:PDVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   //使下一页的导航栏左边没有文字
    UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    //本导航栏题目
    self.navigationItem.title = @"版块名";

    
    //try nav button fail
//    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [rightbutton setTitle:@"aaa" forState:UIControlStateNormal];
//    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    

    // Do any additional setup after loading the view.
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
