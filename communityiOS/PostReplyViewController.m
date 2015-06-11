//
//  PostReplyViewController.m
//  communityiOS
//
//  Created by 金钟 on 15/4/8.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "PostReplyViewController.h"
#import "PostDetailViewController.h"
#import "UIViewController+Create.h"
#import "ReplyTableViewCell.h"
#import "MyReplyTableViewCell.h"
#import "PostEditViewController.h"
#import "replyInfoListItem.h"
#import "replyInfoItem.h"
#import "StatusTool.h"
#import "AuthViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "APIAddress.h"
#import "AppDelegate.h"




@interface PostReplyViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *reply_btn;

- (IBAction)replyAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *replyContentField;
@property (retain, nonatomic) IBOutlet UITableView *replyListTable;
//cell数据源
@property (strong,nonatomic) NSMutableArray *replyIDData;
@property (strong,nonatomic) NSMutableArray *replyerNickNameData;
@property (strong,nonatomic) NSMutableArray *replyDateData;
@property (strong,nonatomic) NSMutableArray *replyerHeadData;
@property (strong,nonatomic) NSMutableArray *replyContentData;

@property (strong,nonatomic) replyInfoListItem *reply_list_item;
@property (strong,nonatomic) NSMutableArray *replyListArray;
@property (strong,nonatomic) replyInfoItem *reply_info_item;
@property (strong,nonatomic) NSNumber *Page;
@property (strong,nonatomic) NSNumber *Rows;
@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
@property (nonatomic) BOOL havePower;
@property (nonatomic,strong) NSMutableArray *forumSetArray;



@end

@implementation PostReplyViewController

int reply_page = 1;
int reply_rows = 6;
int reply_page_filter = 0;
int screenHeight = 0;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.forumSetArray = [[NSMutableArray alloc]init ];
    self.replyListArray = [[NSMutableArray alloc]init ];
    self.replyIDData = [[NSMutableArray alloc]init];
    self.replyerNickNameData = [[NSMutableArray alloc]init];
    self.replyDateData = [[NSMutableArray alloc]init];
    self.replyerHeadData = [[NSMutableArray alloc]init];
    self.replyContentData = [[NSMutableArray alloc]init];
    self.Page = [[NSNumber alloc]init];
    self.Rows = [[NSNumber alloc]init];
    self.havePower = false;
    
    //设置标题
    self.navigationItem.title = self.postItem.title;
    //获取当前用户身份
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.UserPermission = [defaults objectForKey:@"UserPermission"];
    
    //判断是否允许回帖 lx 0529
    for(int i =0;i<[self.forum_item.ForumSetlist count];i++){
        self.forum_set_item = [forumSetItem createItemWitparametes:[self.forum_item.ForumSetlist objectAtIndex:i]];
        [self.forumSetArray addObject:self.forum_set_item];
    }
    for (int i = 0; i<[self.forumSetArray count]; i++) {
        forumSetItem *tempItem = [self.forumSetArray objectAtIndex:i];
        if ([tempItem.site_name isEqualToString:site_reply_user]) {
            if ([tempItem.site_value containsString:[NSString stringWithFormat:@"/%@%@",self.UserPermission,@"/"]]) {
                self.havePower = true;
                break;
            }
        }
         
    }
//    if([self.UserPermission isEqualToString:@""]){
//        self.havePower = false;
//    }
    
    if(!self.havePower){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"对不起，您无权回复！" message:nil delegate:self cancelButtonTitle:@"去实名认证" otherButtonTitles:@"取消", nil];
        alert.delegate = self;
        [alert show];
        self.reply_btn.enabled = NO;
        [self.replyContentField setEnabled:NO];
    }
    
    
    [self setupRefreshing];
    [self loadReplyListData];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    //设置textFeild代理
    self.replyContentField.delegate = self;
    //获取屏幕高度
    screenHeight = self.view.frame.size.height;
    //清楚多余的表
    [self clearExtraLine:self.replyListTable];
}


#pragma mark---------对话框点击按钮事件 lx 0529
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){//去实名认证
        AuthViewController *AVC = [AuthViewController createFromStoryboardName:@"Settings" withIdentifier:@"Auth"];
        //使下一页的导航栏左边没有文字
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title=@"";
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [self.navigationController pushViewController:AVC animated:YES];
    }
}




#pragma mark-
#pragma mark--------------------去掉多余的线----------------------------
-(void)clearExtraLine:(UITableView *)tableView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.replyListTable setTableFooterView:view];
}
#pragma mark-
#pragma mark----------------------防止键盘遮盖---------------------------

//点击屏幕别处键盘收起
-(void)hidenKeyboard
{
    [self.replyContentField resignFirstResponder];
}

//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    
//    CGRect newFrame = self.view.frame;
//    newFrame.size.height -= kbHeight ;
//    NSTimeInterval animationDuration = 0.50f;
//    [UIView beginAnimations:@"ResizeTextView" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    self.view.frame = newFrame;
//    [UIView commitAnimations];
//
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height +kbHeight);
//    
//}

//注册监听
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//取消监听
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect newFrame = self.view.frame;
    newFrame.size.height = screenHeight - keyboardRect.size.height;
    NSTimeInterval animationDuration = 0.50f;
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = newFrame;
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSTimeInterval animationDuration = 0.50f;
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, screenHeight);
    [UIView commitAnimations];
}


#pragma mark-
#pragma mark----------------TableViewControllerDelegate------------


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)[self.replyListArray count]);
    return [self.replyListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ReplyTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        //填装数据
        cell.replyerNickName.text = [self.replyerNickNameData objectAtIndex:indexPath.row];
        cell.replyTime.text = [self.replyDateData objectAtIndex:indexPath.row];
        [cell setReplyContentText:[self.replyContentData objectAtIndex:indexPath.row]];
        //图片
        NSString *replyImage = [NSString stringWithString:[self.replyerHeadData objectAtIndex:indexPath.row]];
        NSString *urlStr = [NSString stringWithFormat:@"%@/uploadimg/%@",API_HOST,replyImage];
        NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlStr, NULL,CFSTR("!*'();@&=+$,?%#[]-"), kCFStringEncodingUTF8 ));
        NSURL *portraitDownLoadUrl = [NSURL URLWithString:escapedUrlString];
        [cell.replyerHead sd_setImageWithURL:portraitDownLoadUrl placeholderImage:[UIImage imageNamed:@"icon_acatar_default_r"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                cell.replyerHead.layer.masksToBounds =YES;
                [cell.replyerHead.layer setCornerRadius:cell.replyerHead.frame.size.width/2];
                cell.replyerHead.contentMode = UIViewContentModeScaleAspectFill;
                cell.replyerHead.image = image;
            }else{
                cell.replyerHead.layer.masksToBounds =YES;
                [cell.replyerHead.layer setCornerRadius:cell.replyerHead.frame.size.width/2];
                cell.replyerHead.contentMode = UIViewContentModeScaleAspectFill;
                cell.replyerHead.image = [UIImage imageNamed:@"icon_acatar_default_r"];
            }
        }];
        return cell;
    
    
}

//绘制行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.replyListTable cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
//    return 80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        replyInfoItem *delete_item = [self.replyListArray objectAtIndex:indexPath.row];
        if (![delete_item.post_reply_man_id isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserID"]]||[self.UserPermission isEqualToString:@""]) {
//            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
//            [self.view addSubview:hud];
//            hud.labelText = @"您只能删除自己的回复";
//            hud.mode = MBProgressHUDModeText;
//            [hud showAnimated:YES whileExecutingBlock:^{
//                sleep(1);
//            } completionBlock:^{
//                [hud removeFromSuperview];
//            }];
        }else{
            [self.replyListArray removeObjectAtIndex:indexPath.row];
            [self.replyListTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [StatusTool statusToolPostDeleteReplyWithUserID:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserID"] Reply_id:delete_item.post_reply_id PostID:self.postItem.post_id Success:^(id object) {
                // do nothing
                pop_code = 1;//跳回detail页刷新
            } failurs:^(NSError *error) {
                // do nothing
            }];
        }
        
    }
    
}

#pragma mark-
#pragma mark-------------设置刷新控件---------------------
-(void)setupRefreshing{
    [self.replyListTable addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.replyListTable addFooterWithTarget:self action:@selector(footerRefreshing)];
}

-(void)headerRefreshing{//下拉
    reply_page_filter = 1;
    reply_page =1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int16_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadReplyListData];
        [self.replyListTable headerEndRefreshing];
    });
}

-(void)footerRefreshing{//上拉
    reply_page_filter = 2;
    reply_page++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int16_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadReplyListData];
        [self.replyListTable footerEndRefreshing];
    });

}
#pragma mark-
#pragma mark---------------加载回复列表的数据-----------------
-(void)loadReplyListData{
    self.Page = [NSNumber numberWithInt:reply_page];
    self.Rows = [NSNumber numberWithInt:reply_rows];
    [StatusTool statusToolGetReplyListWithPostID:self.postItem.post_id Page:self.Page Rows:self.Rows Success:^(id object) {
        self.reply_list_item = object;
        if (reply_page_filter == 0) {
            if (self.reply_list_item.contentList !=nil) {
                [self.replyListArray removeAllObjects];
                [self.replyIDData removeAllObjects];
                [self.replyerNickNameData removeAllObjects];
                [self.replyDateData removeAllObjects];
                [self.replyerHeadData removeAllObjects];
                [self.replyContentData removeAllObjects];
                [self getReplyData];
 //               [self.replyListTable reloadData];
            }else {
                
            }
        }else{
            if (self.reply_list_item.contentList !=nil) {
                if (reply_page_filter == 2) {
                    [self getReplyData];
                }else{
                    [self.replyListArray removeAllObjects];
                    [self.replyIDData removeAllObjects];
                    [self.replyerNickNameData removeAllObjects];
                    [self.replyDateData removeAllObjects];
                    [self.replyerHeadData removeAllObjects];
                    [self.replyContentData removeAllObjects];
    
                    [self getReplyData];
                }
                [self.replyListTable reloadData];
            }else{
                if (reply_page_filter == 2) {
                    reply_page--;
                }
            }
        }
        
    } failurs:^(NSError *error) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.labelText = @"请查看您的网络";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
        }];
    }];

}
#pragma mark-
#pragma mark---------------加载回复详情的数据-----------------
-(void)getReplyData{
    for (int i = 0; i < [self.reply_list_item.contentList count]; i++) {
        self.reply_info_item = [replyInfoItem createItemWitparametes:[self.reply_list_item.contentList objectAtIndex:i]];
        if (reply_page_filter == 2) {
            if (![self.replyListArray containsObject:self.reply_info_item]) {
                [self.replyListArray addObject:self.reply_info_item];
                [self getEveryPartData];
            }
        }else{
            [self.replyListArray addObject:self.reply_info_item];
            [self getEveryPartData];
            

        }
        
    }
}

-(void)getEveryPartData{
    //获得回复人ID
    if (self.reply_info_item.post_reply_man_id != nil) {
        [self.replyIDData addObject:self.reply_info_item.post_reply_man_id];
    }else{
        [self.replyIDData addObject:@""];
    }
    //为数据源加内容
    if (self.reply_info_item.reply_text != nil) {
        [self.replyContentData addObject:self.reply_info_item.reply_text];
    }else{
        [self.replyContentData addObject:@""];
    }
    //加昵称
    if (self.reply_info_item.user_nickname != nil) {
        [self.replyerNickNameData addObject:self.reply_info_item.user_nickname];
    }else{
        [self.replyerNickNameData addObject:@"游客"];
    }
    //加回复人头像
    if (self.reply_info_item.head_portrait_url != nil) {
        [self.replyerHeadData addObject:self.reply_info_item.head_portrait_url];
    }else{
        [self.replyerHeadData addObject:@""];

    }
    //加时间
    if (self.reply_info_item.post_reply_date != nil) {
        [self twoDateDistants:self.reply_info_item.post_reply_date];
    }else{
        [self.replyDateData addObject:@"00:00:00"];
    }
    
     [self.replyListTable reloadData];
    
}
#pragma mark-
#pragma mark-------------计算时间差函数--------------
-(void)twoDateDistants:(NSString *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2 = [formatter dateFromString:date];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date2];
    NSDate *reply_date = [date2 dateByAddingTimeInterval:interval];
    NSDate *cur_date = [[NSDate alloc]init];
    interval = [timeZone secondsFromGMTForDate:cur_date];
    cur_date = [cur_date dateByAddingTimeInterval:interval];
    NSInteger seconds = [cur_date timeIntervalSinceDate:reply_date];
    long time = (long) seconds;
    NSString *date_time = [[NSString alloc]init];
    NSNumber *longNumber;
    if (time <0) {
        [self.replyDateData addObject:@"刚刚"];
        
    }else if (time<60){
        longNumber = [NSNumber numberWithLong:time];
        date_time = [longNumber stringValue];
        [self.replyDateData addObject:[date_time stringByAppendingString:@"秒前"]];
    }else if (time<60*60){
        time = time/60;
        longNumber = [NSNumber numberWithLong:time];
        date_time = [longNumber stringValue];
        [self.replyDateData addObject:[date_time stringByAppendingString:@"分钟前"]];
    }else if (time<60*60*24){
        time = time/60/60;
        longNumber = [NSNumber numberWithLong:time];
        date_time = [longNumber stringValue];
        [self.replyDateData addObject:[date_time stringByAppendingString:@"小时前"]];
    }else if (time<60*60*24*7){
        time = time/60/60/24;
        longNumber = [NSNumber numberWithLong:time];
        date_time = [longNumber stringValue];
        [self.replyDateData addObject:[date_time stringByAppendingString:@"天前"]];
    }else if (time<60*60*24*365){
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat : @"MM-dd"];
        date_time = [formatter1 stringFromDate:date2];
        [self.replyDateData addObject:date_time];
    }else {
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat : @"yyyy-MM-dd"];
        date_time = [formatter1 stringFromDate:date2];
        [self.replyDateData addObject:date_time];
    }

}

#pragma mark-


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
#pragma mark-
#pragma mark----------------------------发送回复--------------------------------------

- (IBAction)replyAction:(id)sender {
        self.reply_btn.enabled = NO;
        //获取当前时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *curDate = [formatter stringFromDate:[NSDate date]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *str = [self genUUID];
        if ([self.replyContentField.text isEqualToString:@""]) {
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hud];
            hud.labelText = @"内容不能为空";
            hud.mode = MBProgressHUDModeText;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
                
            } completionBlock:^{
                [hud removeFromSuperview];
                self.reply_btn.enabled = YES;
            }];
        }else{
            [StatusTool statusToolPostReplyWithReplyText:self.replyContentField.text CommunityID:self.postItem.belong_community_id ForumID:self.postItem.belong_forum_id PostID:self.postItem.post_id UserID:[defaults valueForKey:@"UserID"] Date:curDate ReplyID:[self genUUID] Success:^(id object) {
                
                pop_code = 1;//跳回detail页刷新
                self.replyContentField.text =  @"";
                if (object != nil) {
                    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:hud];
                    hud.labelText = @"回复成功";
                    hud.mode = MBProgressHUDModeText;
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        reply_page = 1;
                        reply_page_filter = 0;
                        [self loadReplyListData];
                        self.reply_btn.enabled = YES;
                    }];
                    
                    [self.replyContentField resignFirstResponder];

                }
                    else{
                    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                    [self.view addSubview:hud];
                    hud.labelText = @"请查看您的网络";
                    hud.mode = MBProgressHUDModeText;
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        self.reply_btn.enabled = YES;
                    }];
                    
                }

            } failurs:^(NSError *error) {
                //to do
                self.reply_btn.enabled = YES;
            }];
        }
}
#pragma mark-
#pragma mark -----------------------------生成UUID-----------------------------------
- (NSString *) genUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

@end


