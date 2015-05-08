//
//  UserJoinPostListViewController.m
//  communityiOS
//
//  Created by tjufe on 15/5/8.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "UserJoinPostListViewController.h"
#import "PostListViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "StatusTool.h"
#import "postListItem.h"
#import "postItem.h"
#import "PostTableViewCell.h"

@interface UserJoinPostListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *postListArray;
}
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIImageView *left_img;
@property (weak, nonatomic) IBOutlet UIImageView *right_img;

@property(strong,nonatomic)postListItem *post_list_item;
@property (strong,nonatomic)postItem *pitem;
@property (strong,nonatomic) NSString *communityID;
@property (strong,nonatomic) NSString *UserID;//当前用户id
@property (strong,nonatomic) NSNumber *Page;
@property (strong,nonatomic) NSNumber *Rows;
@property (strong,nonatomic) NSString *filter;//筛选条件
@end

@implementation UserJoinPostListViewController

int page = 1;//页数
int rows = 5;//分页请求行数
int page_filter = 0;

#pragma mark------切换我报名的
- (IBAction)isApply:(id)sender {
    if(![self.filter isEqualToString:@"我报名的"]){
        self.filter = @"我报名的";
        page = 1;
        self.left_img.hidden = NO;
        self.right_img.hidden = YES;
        [postListArray removeAllObjects];
        [self loadData];
    }
}

#pragma mark------切换我回复的
- (IBAction)isReply:(id)sender {
    if(![self.filter isEqualToString:@"我回复的"]){
        self.filter = @"我回复的";
        page = 1;
        self.left_img.hidden = YES;
        self.right_img.hidden = NO;
        [postListArray removeAllObjects];
        [self loadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [postListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//绘制行高
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell =[[[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    postItem *ptiem1 = [postItem createItemWitparametes:[postListArray objectAtIndex:indexPath.row]];
    
    //title
    if(ptiem1.title!=nil){
        cell.PostLabel.text = ptiem1.title;
    }else{
        cell.PostLabel.text = @"";
    }
    //date
    if(ptiem1.post_date!=nil){
        cell.postDate.text = [self twoDateDistants:ptiem1.post_date];
    }else{
        cell.postDate.text = @"00:00:00";
    }
    //nickname
    if(ptiem1.poster_nickname!=nil){
        cell.poster_nic.text = ptiem1.poster_nickname;
    }else{
        cell.poster_nic.text = @"游客";
    }
    //reply
    if(![ptiem1.reply_num isEqualToString:@""]&&![ptiem1.reply_num isEqualToString:@"''"]){
        cell.post_reply_num.text = ptiem1.reply_num;
    }else{
        cell.post_reply_num.text = @"0";
    }
    
    return cell;
}



-(NSString *)twoDateDistants:(NSString *)date{
    //日期格式转换
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2 = [formatter dateFromString:date];
    
    //解决采用世界时间转换后与实际时间相差8小时的问题
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date2];
    NSDate *p_date = [date2 dateByAddingTimeInterval:interval];
    //日期比较
    NSDate *cur_date = [[NSDate alloc]init];//获取当前时间
    interval = [timeZone secondsFromGMTForDate:cur_date];
    cur_date = [cur_date dateByAddingTimeInterval:interval];
    
    NSInteger seconds = [cur_date timeIntervalSinceDate:p_date];//计算时间差秒数
    long time =(long) seconds;
    NSString *date_time = [[NSString alloc]init];
    NSNumber *longNumber;
    NSString *post_date = [[NSString alloc]init];
    if (time<0) {
        post_date = @"刚刚";
    }
    else if(time<60){
        longNumber = [NSNumber numberWithLong:time];
        date_time = [longNumber stringValue];
        post_date = [date_time stringByAppendingString:@"秒前"];
    }
    else if (time<60*60){
        time = time/60;
        longNumber = [NSNumber numberWithLong:time];
        date_time = [longNumber stringValue];
         post_date =[date_time stringByAppendingString:@"分钟前"];
        
    }
    else if (time<60*60*24){
        time = time/60/60;
        longNumber = [NSNumber numberWithLong:time];
        date_time = [longNumber stringValue];
         post_date = [date_time stringByAppendingString:@"小时前"];
        
    }
    else if(time<60*60*24*7){
        time = time/60/60/24;
        longNumber = [NSNumber numberWithLong:time];
        date_time = [longNumber stringValue];
        post_date = [date_time stringByAppendingString:@"天前"];
        
    }
    else if(time<60*60*24*365){
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat : @"MM-dd"];
        date_time = [formatter1 stringFromDate:date2];
         post_date = date_time;
        
    }
    else{
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat : @"yyyy-MM-dd"];
        date_time = [formatter1 stringFromDate:date2];
         post_date = date_time;
        
    }
    return post_date;
}

#pragma mark----上拉刷新
-(void)footerRereshing{
    
    page_filter = 2;
    page++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //          [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            [self loadData];

       // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
       [self.table footerEndRefreshing];
    });
    
}

-(void)setupRefresh{
    //waring自动刷新
    //   [self.pltable headerBeginRefreshing];
    //上拉加载更多
    [self.table addFooterWithTarget:self action:@selector(footerRereshing)];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取当前用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.UserID =[defaults objectForKey:@"UserID"];
    self.communityID = [defaults objectForKey:@"CommunityID"];
    
    //初始化数据
    self.filter = @"我报名的";
    postListArray = [[NSMutableArray alloc]init];
    //初始化table刷新控件
    [self setupRefresh];
    //请求table数据
    [self loadData];
}

#pragma mark-------请求加载帖子列表数据(我报名的，我回复的)
-(void)loadData{
    self.Page = [NSNumber numberWithInt:page];
    self.Rows = [NSNumber numberWithInt:rows];
    [StatusTool statusToolGetPostListWithbfID:@"" bcID:self.communityID userID:self.UserID filter:self.filter page:self.Page rows:self.Rows Success:^(id object) {
        
        self.post_list_item = (postListItem *)object;
        
        if(self.post_list_item.PostList!=nil){
            for(int i=0;i<[self.post_list_item.PostList count];i++){
                self.pitem = [postItem createItemWitparametes:[self.post_list_item.PostList objectAtIndex:i]];
                if(page_filter==0){//第一次加载
                    [postListArray addObject:self.pitem];
                }else{ //上拉刷新
                    if(![postListArray containsObject:self.pitem]){//去重
                        [postListArray addObject:self.pitem];
                    }
                    
                }
            }
            [self.table reloadData];
        }else{
            if(page_filter==0){
                self.table.hidden = YES;
            }else{//刷新完成，已无更多
                page--;
            }
        }
        
        
        
        
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
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
