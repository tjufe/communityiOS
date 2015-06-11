//
//  UserJoinPostListViewController.m
//  communityiOS
//
//  Created by tjufe on 15/5/8.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "UserJoinPostListViewController.h"

#import "UIViewController+Create.h"
#import "APIAddress.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "StatusTool.h"
#import "postListItem.h"
#import "postItem.h"
#import "PostTableViewCell.h"
#import "PostMendDetailViewController.h"
#import "forumItem.h"
#import "ViewController.h"
#import "forumSetItem.h"
#import "PostEditViewController.h"
#import "PostDetailViewController.h"
#import "MBProgressHUD.h"



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
@property (strong,nonatomic)NSMutableArray *ISApply2;
@property (strong,nonatomic)NSMutableArray *ISReply1;
@property (weak,nonatomic)NSArray *forumlist;
@property (strong,nonatomic) forumItem *forumitem;



@end

@implementation UserJoinPostListViewController


NSInteger page1 ;//页数
NSInteger rows1 ;//分页请求行数
NSInteger page_filter1 ;

//int pop_code;

#pragma mark------切换我报名的
- (IBAction)isApply:(id)sender {
    if(![self.filter isEqualToString:@"我报名的"]){
        self.filter = @"我报名的";
        page1 = 1;

        page_filter1 = 0;
        self.left_img.hidden = NO;
        self.right_img.hidden = YES;
        [postListArray removeAllObjects];
        [self.ISReply1 removeAllObjects];
        [self.ISApply2 removeAllObjects];

        [self loadData];
    }
}

#pragma mark------切换我回复的
- (IBAction)isReply:(id)sender {
    if(![self.filter isEqualToString:@"我回复的"]){
        self.filter = @"我回复的";
        page1 = 1;

        page_filter1 = 0;
        self.left_img.hidden = YES;
        self.right_img.hidden = NO;
        [postListArray removeAllObjects];
        [self.ISReply1 removeAllObjects];
        [self.ISApply2 removeAllObjects];

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
    postItem *ptiem1;

    if ([postListArray count] != 0) {
        ptiem1 = [postListArray objectAtIndex:indexPath.row];
    }
   
    
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

        NSString *nic = ptiem1.poster_nickname;
        if(nic.length > 7){//过长时截取
            nic =[nic substringToIndex:7];
            nic = [nic stringByAppendingString:@"…"];
            cell.poster_nic.text = nic;//nickname
        }else{
            cell.poster_nic.text = nic;
        }

    //    cell.poster_nic.text = ptiem1.poster_nickname;

    }else{
        cell.poster_nic.text = @"游客";
    }
    //reply

    if([[self.ISReply1 objectAtIndex:indexPath.row] isEqualToString:@"Y"]){
        if(![ptiem1.reply_num isEqualToString:@""]&&![ptiem1.reply_num isEqualToString:@"''"]){
            cell.post_reply_num.text = ptiem1.reply_num;
        }else{
            cell.post_reply_num.text = @"0";
        }

    }else{
        cell.post_reply_num.hidden = YES;
        cell.img_reply.hidden = YES;
        cell.dot_reply.hidden = YES;
    }
    
    //apply
    if([[self.ISApply2 objectAtIndex:indexPath.row] isEqualToString:@"Y"]&&[ptiem1.open_apply isEqualToString:@"是"]){
        if(![ptiem1.apply_num isEqualToString:@""]&&![ptiem1.apply_num isEqualToString:@"''"]){
            
            cell.post_apply_num.text = ptiem1.apply_num;
        }else{
            cell.post_apply_num.hidden = YES;
            cell.img_apply.hidden = YES;
            cell.dot_apply.hidden = YES;
        }
    }else{
        cell.post_apply_num.hidden = YES;
        cell.img_apply.hidden = YES;
        cell.dot_apply.hidden = YES;
    }

    
    //imge
    NSString* URL=[[NSString alloc]init];
    URL =ptiem1.main_image_url;
    NSString *img_url = [NSString stringWithFormat:@"%@/topicpic/%@",API_HOST,URL];
    //包含中文字符的string转换为nsurl
    NSURL *iurl = [NSURL URLWithString:[img_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if([URL isEqualToString:@""] ||[URL isEqualToString:@"''"]){
        cell.postImg.hidden = YES;
    }else{
        cell.postImg.hidden = NO;
        [cell.postImg sd_setImageWithURL:iurl placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.postImg.image = image;
        }];
    }
    
    cell.postImg.contentMode=UIViewContentModeScaleAspectFill;
    
    //审核
    //是否置顶
    if([ptiem1.need_check isEqualToString:@"是"]&&[ptiem1.checked isEqualToString:@"否"]){
        cell.setTop.image = [UIImage imageNamed:@"待审核"];
    }
    else if ([ptiem1.set_top isEqualToString:@"是"]){
        cell.setTop.hidden = NO;
    }
    else{
        cell.setTop.hidden = YES;
    }
    //是否结贴
    if([ptiem1.post_overed isEqualToString:@"是"]){
        cell.img_finish.hidden = NO;
    }else{
        cell.img_finish.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(![self.forumitem.forum_name isEqualToString:@"报修"]){
    PostDetailViewController *PDVC = [ PostDetailViewController createFromStoryboardName:@"PostDetailStoryboard" withIdentifier:@"postDetail"];
    //全局变量传值
    PDVC.forum_item = self.forumitem;
    //协议实现页面传值
    self.delegate = PDVC;
    if ([self.delegate
         respondsToSelector:@selector(addpostItem2:)]) {
        
        [self.delegate addpostItem2:[postListArray objectAtIndex:indexPath.row]];
    }
    
    
    [self.navigationController pushViewController:PDVC animated:YES];
    }else{
        PostMendDetailViewController *PDVC = [ PostMendDetailViewController createFromStoryboardName:@"PostMendDetail" withIdentifier:@"postMendDetail"];
       PDVC.forum_item = self.forumitem;
        self.delegate = PDVC;
        if ([self.delegate
             respondsToSelector:@selector(addpostItem2:)]) {
            
            [self.delegate addpostItem2:[postListArray objectAtIndex:indexPath.row]];
        }
        
        
        [self.navigationController pushViewController:PDVC animated:YES];

    }
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
    
    page_filter1 = 2;
    page1++;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:(BOOL)animated];
//    if(pop_code==1){
        [self loadData];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    pop_code = 1;
    //使下一页的导航栏左边没有文字
    UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    page1 = 1;
    rows1 = 10;
    page_filter1 = 0;
    


    //获取当前用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.UserID =[defaults objectForKey:@"UserID"];
    self.communityID = [defaults objectForKey:@"CommunityID"];
    
    //初始化数据
    self.filter = @"我报名的";
    postListArray = [[NSMutableArray alloc]init];

    self.ISApply2 = [[NSMutableArray alloc]init];
    self.ISReply1 = [[NSMutableArray alloc]init];

    //初始化table刷新控件
    [self setupRefresh];
    //请求table数据
//    [self loadData];
    //去掉多余的线
     [self clearExtraLine:self.table];

}

#pragma mark-
#pragma mark--------------------去掉多余的线----------------------------
-(void)clearExtraLine:(UITableView *)tableView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.table setTableFooterView:view];
}
#pragma mark-

#pragma mark-------请求加载帖子列表数据(我报名的，我回复的)
-(void)loadData{

    self.Page = [NSNumber numberWithInteger:page1];
    self.Rows = [NSNumber numberWithInteger:rows1];

    [StatusTool statusToolGetPostListWithbfID:@"" bcID:self.communityID userID:self.UserID filter:self.filter page:self.Page rows:self.Rows Success:^(id object) {
        
        self.post_list_item = (postListItem *)object;
        
        if(self.post_list_item.PostList!=nil){
            for(int i=0;i<[self.post_list_item.PostList count];i++){
                self.pitem = [postItem createItemWitparametes:[self.post_list_item.PostList objectAtIndex:i]];
                if(page_filter1==0){//第一次加载
                    [postListArray addObject:self.pitem];
                }else{ //上拉刷新
                    if(![postListArray containsObject:self.pitem]){//去重
                        [postListArray addObject:self.pitem];
                    }
                    
                }

                //获取当前帖子的版块设置
                [self check2];
            }

            [self.table reloadData];
        }else{
            if(page_filter1==0){
            //    self.table.hidden = YES;
                [self.table reloadData];
            }else{//刷新完成，已无更多
                page1--;
                //提示
                MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:hud];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"没有更多内容了！";
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                }completionBlock:^{
                    [hud removeFromSuperview];
                }];


            }
        }
        
        
        
        
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark------获取当前帖子的版块设置
-(void)check2{
      //判断权限
        self.forumlist=[ViewController getForumList];
        for(int m=0;m<[_forumlist count];m++){
            forumItem *f1 = [_forumlist objectAtIndex:m];
            if([self.pitem.belong_forum_id isEqualToString:f1.forum_id]){
                //找到所属版块
                self.forumitem = f1;
                break;
            }
        }
    if(self.forumitem.ForumSetlist!=nil){
        for(int i=0;i<[self.forumitem.ForumSetlist count];i++){
            forumSetItem *fs = [forumSetItem createItemWitparametes:[self.forumitem.ForumSetlist objectAtIndex:i]];
            //能否回复
            if([fs.site_name isEqualToString:site_isreply]){
                if([fs.site_value rangeOfString:@"是"].location!=NSNotFound){
                    [self.ISReply1 addObject:@"Y"];
                }else{
                    [self.ISReply1 addObject:@"N"];
                }
            }
            
            //能否报名
            if([fs.site_name isEqualToString:site_addapply]){
                if([fs.site_value rangeOfString:@"是"].location!=NSNotFound){
                    [self.ISApply2 addObject:@"Y"];
                }else{
                    [self.ISApply2 addObject:@"N"];
                }
                
            }
            
        }
    }
    

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
