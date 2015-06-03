
//
//  ViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/3/18.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import "ViewController.h"
#import "ForumTableViewCell.h"
#import "LoginNavigationController.h"
#import "UIViewController+Create.h"
#import "PostTableViewCell.h"
#import "PostListViewController.h"
#import "PPRevealSideViewController.h"
#import "UserCenterUnloggedViewController.h"
#import "UserCenterLoggedViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "LoginViewController.h"
#import "StatusTool.h"
#import "forumItem.h"
#import "PostEditViewController.h"
#import "APIClient.h"
#import "loginItem.h"
#import "UIImageView+WebCache.h"
//#import "RegistViewController.h"

#import "SlideInfoItem.h"
#import "PostDetailViewController.h"
#import "MainTableViewHeaderCell.h"



//NSString const *

@interface ViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,LoginViewControllerDelegate>{
    NSMutableArray *tableData;  //表格数据
    NSInteger *currentPage;
}
@property (weak, nonatomic) IBOutlet UIImageView *user_status;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *mainPageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong)NSString *checkin_community_id;
@property NSInteger *currentPage;
@property (weak, nonatomic) IBOutlet UISwitch *testSwitch;
@property (nonatomic ,strong) forumItem *forum_item;
//@property (nonatomic ,strong) NSMutableArray *forum_list_item;

@property (nonatomic,strong) NSMutableArray *forumName;
@property (nonatomic,strong) NSMutableArray *forumImage;


@property (nonatomic,strong) NSArray *listForumItem;

@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
@property (strong,nonatomic) NSString *UserID;//当前用户id
@property (strong,nonatomic) NSString *AccountStatus;//当前用户账号状态

@property (nonatomic,strong) NSArray *listSlide;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation ViewController

NSArray *forum;
//@synthesize btnNickname;


#pragma mark----获取版块信息
+(NSArray *)getForumList{
    return forum;
}


-(void) setupRefresh {
    //    1.下拉刷新（进入刷新状态就会调用self的headerRereshing）
    [self.mainTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //    自动刷新（一进入程序就下拉刷新）
    //    [self.mainTableView headerBeginRefreshing];
    //    2.上拉加载更多（进入刷新状态就会调用self的footerRereshing）
    [self.mainTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

-(void) headerRereshing {
    [self getData];
    
}

-(void) footerRereshing {
    [self loadNextPage];
}

-(void) getData {
    //显示／隐藏等待进度条
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void) loadNextPage {
    //    @{
    //      @"pageSize":@(20),
    //      @"pageNumber":@(self.currentPage),
    //      }
    //    [[APIClient sharedClient] POST:<#(NSString *)#> parameters:<#(id)#> constructingBodyWithBlock:<#^(id<AFMultipartFormData> formData)block#> success:<#^(AFHTTPRequestOperation *operation, id responseObject)success#> failure:<#^(AFHTTPRequestOperation *operation, NSError *error)failure#>]
}


- (void)initTableData {
    //    tableData = [[NSMutableArray alloc] initWithObjects:
    //                 self.forumName,[NSMutableArray arrayWithObjects:@"……",@"……",@"……",@"……",@"……",@"……",@"……", nil],
    //                 self.forumImage,nil];
    //    [self.mainTableView reloadData];
}

- (IBAction)go2Login:(id)sender {
    
    LoginNavigationController *vc=[LoginNavigationController createFromStoryboardName:@"Login" withIdentifier:@"loginACT"];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    [self presentModalViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate=self;
    UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
  
    self.navigationController.delegate=self;
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.dimBackground = YES;
    [self.hud show:YES];
    [self initSlide];
    [self addTimer];
    [self autoLogin];
    
    [self clearExtraLine:self.mainTableView];
}
#pragma mark-
#pragma mark--------------------去掉多余的线----------------------------
-(void)clearExtraLine:(UITableView *)tableView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.mainTableView setTableFooterView:view];
}
#pragma mark-

#pragma mark --初始化轮播图
-(void)initSlide{
    // Do any additional setup after loading the view, typically from a nib.
    //    图片的宽
    CGFloat imageW = self.view.frame.size.width;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = self.mainScrollView.frame.size.height;
    //    图片的Y
    CGFloat imageY = 0;
    //    图片中数
    NSInteger totalCount = 3;
    [StatusTool statusToolGetSlideListWithCommunityID:@"0001" Success:^(NSArray *array) {
        NSInteger i = 0;
        self.listSlide = array;
        //   1.添加图片
        for(SlideInfoItem *row in array){
            if(i<totalCount){
                UIImageView *imageView = [[UIImageView alloc] init];
//                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                //        图片X
                CGFloat imageX = i * imageW;
                //        设置frame
                imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
                //        设置图片
//                NSString *name = [NSString stringWithFormat:@"image_0%d", i + 1];
//                imageView.image = [UIImage imageNamed:name];
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",API_TOPIC_PIC_PATH,row.main_image_url];
                NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlStr, NULL,CFSTR("!*'();@&=+$,?%#[]-"), kCFStringEncodingUTF8 ));
                NSURL *portraitDownLoadUrl = [NSURL URLWithString:escapedUrlString];
                [imageView sd_setImageWithURL:portraitDownLoadUrl placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    NSData *imageData = UIImageJPEGRepresentation(image, 1);
                    if(image!=nil){
                        imageView.image = image;
                    }
                }];
                UILabel *titleLabel = [[UILabel alloc]init];
                titleLabel.frame = CGRectMake(imageX, imageY, imageW, 30);
                NSString *t=[@"  " stringByAppendingString:row.title];
                titleLabel.text =t;
                [titleLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
                [titleLabel setTextColor:[UIColor whiteColor]];
                
                //        隐藏指示条
                self.mainScrollView.showsHorizontalScrollIndicator = NO;
                
                [self.mainScrollView addSubview:imageView];
                [self.mainScrollView addSubview:titleLabel];
                
                [imageView setUserInteractionEnabled:YES];
                [imageView setTag:i];
                UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoThisPost:)];
                [imageView addGestureRecognizer:singleTap3];
                i++;
            }else{
                break;
            }
            //    2.设置scrollview的滚动范围
            CGFloat contentW = totalCount *imageW;
            //不允许在垂直方向上进行滚动
            self.mainScrollView.contentSize = CGSizeMake(contentW, 0);
            
            //    3.设置分页
            self.mainScrollView.pagingEnabled = YES;
            
            //    4.监听scrollview的滚动
            self.mainScrollView.delegate = self;
        }
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)GoThisPost:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *view = [gestureRecognizer view];
    NSInteger *index = view.tag;
    SlideInfoItem *s = [self.listSlide objectAtIndex:index];
    //查找所属forum lx 20150603
    forumItem *f1;
    for(int i=0;i<[self.listForumItem count];i++){
        forumItem *f = [self.listForumItem objectAtIndex:i];
        if([s.belong_forum_id isEqualToString:f.forum_id]){
            f1 = f;
            break;
        }
    }
    
    //往帖子详情页跳转
    PostDetailViewController *PDVC = [ PostDetailViewController createFromStoryboardName:@"PostDetailStoryboard" withIdentifier:@"postDetail"];
    PDVC.postIDFromOutside = s.post_id;

    PDVC.forum_item = f1;
    NSString *str = s.post_id;
    [self.navigationController pushViewController:PDVC animated:YES];

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( viewController == self) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else{
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)nextImage
{
    int page = (int)self.mainPageControl.currentPage;
    if (page == 2) {
        page = 0;
    }else
    {
        page++;
    }
    
    //  滚动scrollview
    CGFloat x = page * self.mainScrollView.frame.size.width;
    [self.mainScrollView setContentOffset:CGPointMake(x,0) animated:YES];
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"滚动中");
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.mainPageControl.currentPage = page;
}

// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    //    [self.timer invalidate];
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    开启定时器
    [self addTimer];
}


#pragma mark --开启定时器
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark --关闭定时器
- (void)removeTimer{
    [self.timer invalidate];
}




#pragma mark --LoginViewController delegate
-(void)addUser:(LoginViewController *)addVc didAddUser:(NSString *)login_id{
    self.checkin_community_id = login_id;
    [self.mainTableView reloadData];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark --201504081638刷新帖子列表
-(void) reloadData {
    [StatusTool statusToolGetForumListWithID:@"0001" Success:^(NSArray *array) {
        _listForumItem = array;
        forum = array;
        [self.mainTableView reloadData];
        [self.hud hide:YES];
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}


#pragma mark------日期处理
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
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [((NSMutableArray*)[tableData objectAtIndex:0]) count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ForumTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if(!cell){
//        cell =[[[NSBundle mainBundle] loadNibNamed:@"ForumTableViewCell" owner:self options:nil] objectAtIndex:0];
//    }
//    [cell setForumIconImage:[_forumImage objectAtIndex:indexPath.row]];
//    [cell setForumName:[[tableData objectAtIndex:0] objectAtIndex:indexPath.row]];
//    [cell setLastNewContent:[[tableData objectAtIndex:1] objectAtIndex:indexPath.row]];
//    return cell;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [tableData count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    ForumTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if(!cell){
//        cell =[[[NSBundle mainBundle] loadNibNamed:@"ForumTableViewCell" owner:self options:nil] objectAtIndex:0];
//    }
//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PostListViewController *poLVC = [PostListViewController createFromStoryboardName:@"PostList" withIdentifier:@"PostListID"];
    poLVC.forumlist = self.listForumItem;
    poLVC.forum_item = [self.listForumItem objectAtIndex:indexPath.row];
    poLVC.filter_flag = @"全部";

  //  poLVC.pl_go = @"1";//从首页跳转

    
    
    [self.navigationController pushViewController:poLVC animated:YES];
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    // custom view for header. will be adjusted to default or specified header height
//
////    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
////    if(section>0)
////        headerView.backgroundColor=[UIColor redColor];
////    else
////        headerView.backgroundColor=[UIColor blueColor];
////
//////    [headerView addSubview:(UIView *)];
////
////    return headerView;
//    return nil;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    // custom view for header. will be adjusted to default or specified header height
//
//    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    if(section>0)
//        headerView.backgroundColor=[UIColor redColor];
//    else
//        headerView.backgroundColor=[UIColor blueColor];
//
////    [headerView addSubview:(UIView *)];
//
//    return headerView;
//}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

#pragma mark-----直接发新帖20150413
- (IBAction)NewPostOnClick:(id)sender {
    //获取当前用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.UserID =[defaults objectForKey:@"UserID"];
    self.UserPermission = [defaults objectForKey:@"UserPermission"];
    self.AccountStatus = [defaults objectForKey:@"AccountStatus"];
    
    //判断用户身份来决定是否能够发帖
    if (![self.UserPermission isEqualToString:@""]&&[self.AccountStatus isEqualToString:@"正常"]) {
    PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];//通过UIViewController+Create扩展方法创建FourViewController的实例对象
        PEVC.ED_FLAG = @"0";//直接发新帖
        PEVC.forum_list_item = self.listForumItem;//传递版块列表

    
    [self.navigationController pushViewController:PEVC animated:YES];
    }else{
        if([self.UserPermission isEqualToString:@""]){
            LoginViewController *RVC = [LoginViewController createFromStoryboardName:@"Login" withIdentifier:@"Login"];
            [self.navigationController pushViewController:RVC animated:YES];
        }
    }
}

#pragma mark --在视图间切换时，并不会再次载入viewDidLoad方法，所以如果在调入视图时，需要对数据做更新，就只能在这个方法内实现了。所以这个方法也非常常用。hmx
- (void)viewWillAppear:(BOOL)animated {
        [super viewWillAppear:(BOOL)animated];

        [self reloadUserStateBarUI];//刷新用户状态栏UI
        [self reloadData];

    
}

#pragma mark --处理自动登录hmx
- (void) autoLogin {
    //读取上次存储的数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults valueForKey:@"UserID"];
    if(userID==nil){//没有userID的情况，初次打开app，分配guid
        [self initUserInfoIntoLoc];
    }else{//处理自动登录
        NSString *phoneNumber = [defaults valueForKey:@"PhoneNumber"];
        NSString *loginPassword = [defaults valueForKey:@"LoginPassword"];
        if(phoneNumber!=nil){//存在历史登录记录，处理为自动登录
            [self loginActionWithPhone:phoneNumber withPassword:loginPassword];//调用登录接口
        }
    }
}

#pragma mark --初始化保存本地用户信息（用于app首次运行）hmx
- (void) initUserInfoIntoLoc {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID=[self genUUID];//生成唯一编码作为userID
    [defaults setObject:userID forKey:@"UserID"];//保存本地
    [defaults setObject:@"0001" forKey:@"CommunityID"];
    [defaults setObject:@"" forKey:@"UserPermission"];
    [defaults synchronize];//保存同步
}

#pragma mark --生成UUIDhmx
- (NSString *) genUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

#pragma mark --调用登录接口hmx
- (IBAction) loginActionWithPhone:(NSString *)phoneNumber withPassword:(NSString *)loginPassword{
    [StatusTool statusToolGetUserLoginWithName:[phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                      PassWord:[loginPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                       Success:^(id object) {
                                           [self checkLoginResult:object];
                                           
                                       } failurs:^(NSError *error) {
                                           NSLog(@"%@",error);
                                       }];
}

#pragma mark --检查登录结果hmx
- (void) checkLoginResult: (id)loginResult {
    loginItem *loginItem=loginResult;
    if(loginItem.LoginSucceed){
        [self saveIntoLoc:loginItem];//保存在本地
    }else{
        NSLog(@"%@",loginItem.ErrorMessage);
        [self reduceLoginInfoFormLoc];//清除本地保存的历史登录信息
    }
}

#pragma mark --清除本地保存的历史登录信息hmx
- (void) reduceLoginInfoFormLoc {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"UserNickname"];
    [defaults setObject:nil forKey:@"PhoneNumber"];
    [defaults setObject:nil forKey:@"HeadPortraitUrl"];
    [defaults setObject:@"" forKey:@"UserPermission"];
    [defaults setObject:nil forKey:@"LoginPassword"];
    [defaults setBool:NO forKey:@"Logged"];
    [defaults synchronize];  //保持同步
}

#pragma mark --保存在本地hmx
- (void) saveIntoLoc: (loginItem *)loginItem {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:loginItem.checkin_community_id forKey:@"CommunityID"];
    [defaults setObject:loginItem.user_id forKey:@"UserID"];
    [defaults setObject:loginItem.user_nickname forKey:@"UserNickname"];
    [defaults setObject:loginItem.phone_number forKey:@"PhoneNumber"];
    [defaults setObject:loginItem.head_portrait_url forKey:@"HeadPortraitUrl"];
    [defaults setObject:loginItem.user_permission forKey:@"UserPermission"];
    [defaults setObject:loginItem.login_password forKey:@"LoginPassword"];
    [defaults setObject:loginItem.account_status forKey:@"AccountStatus"];
    [defaults setObject:loginItem.moderator_of_forum_list forKey:@"moderator_of_forum_list"];
    [defaults setBool:YES forKey:@"Logged"];
    [defaults synchronize];  //保持同步
}

#pragma mark --刷新用户状态栏UIhmx
- (void) reloadUserStateBarUI {
    [self.btnNickname setTitle:@"游客" forState:UIControlStateNormal];
    self.avaterImageView.layer.masksToBounds=YES;
    [self.avaterImageView.layer setCornerRadius:self.avaterImageView.frame.size.width/2];
    self.avaterImageView.contentMode = UIViewContentModeScaleAspectFill; //取图片的中部分
    UIImage *placeholderImage = [UIImage imageNamed:@"icon_acatar_default_r"];
    self.avaterImageView.image = placeholderImage;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [defaults valueForKey:@"PhoneNumber"];
    if(phoneNumber!=nil){
        NSString *userNickname = [defaults valueForKey:@"UserNickname"];
        NSString *headPortraitUrl = [defaults valueForKey:@"HeadPortraitUrl"];
        NSString *user_id = [defaults valueForKey:@"UserID"];
        
        ///20150418 认证标志显示
        NSString *userPermission = [defaults valueForKey:@"UserPermission"];
        if([userPermission rangeOfString:@"认证用户"].location!=NSNotFound){
            self.user_status.hidden = NO;
        }else{
            self.user_status.hidden = YES;
        }
        ///
        [self.btnNickname setTitle:userNickname forState:UIControlStateNormal];
        NSString * userPortraitImage = [[NSString alloc]initWithFormat:@"%@.jpg",user_id ];
        NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:userPortraitImage];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExits = [fileManager fileExistsAtPath:fullPathToFile];
        if (fileExits) {
            self.avaterImageView.image = [UIImage imageWithContentsOfFile:fullPathToFile];
        } else {
            NSString *str = [NSString stringWithFormat:@"%@%@",API_HEAD_PIC_PATH,headPortraitUrl];
            NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)str, NULL,CFSTR("!*'();@&=+$,?%#[]-"), kCFStringEncodingUTF8 ));
            NSURL *portraitDownLoadUrl = [NSURL URLWithString:escapedUrlString];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                [self.avaterImageView sd_setImageWithURL:portraitDownLoadUrl placeholderImage:[UIImage imageNamed:@"icon_acatar_default_r"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image != nil) {
                        NSData *imageData = UIImageJPEGRepresentation(image, 1);
                        [imageData writeToFile:fullPathToFile atomically:NO];
                    }
                    
                }];
            });
            
        }
    }
}


#pragma mark --点击用户状态栏hmx
- (IBAction)tapItem:(id)sender {
    BOOL logged = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Logged" ] boolValue];
    if(!logged){
        UserCenterUnloggedViewController *vc=[UserCenterUnloggedViewController createFromStoryboardName:@"UserCenterUnlogged" withIdentifier:@"UserCenterUnlogged"];
        [self.revealSideViewController pushViewController:vc onDirection:PPRevealSideDirectionLeft animated:YES];
    }else{
        UserCenterLoggedViewController *vc=[UserCenterLoggedViewController createFromStoryboardName:@"UserCenterLogged" withIdentifier:@"UserCenterLogged"];
        [self.revealSideViewController pushViewController:vc onDirection:PPRevealSideDirectionLeft animated:YES];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger forumcount =[_listForumItem count];
    for(forumItem *row in self.listForumItem){
        if([row.display_type rangeOfString:@"横向"].location!=NSNotFound){
            forumcount--;
        }
    }
    return forumcount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForumTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell =[[[NSBundle mainBundle] loadNibNamed:@"ForumTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    //    [cell setForumIconImage:[_forumImage objectAtIndex:indexPath.row]];
    //    [cell setForumName:[[tableData objectAtIndex:0] objectAtIndex:indexPath.row]];
    //    [cell setLastNewContent:[[tableData objectAtIndex:1] objectAtIndex:indexPath.row]];
    forumItem *item = [_listForumItem objectAtIndex:indexPath.row];
    [cell setForumName:item.forum_name];
    //lx 20150508
    //    NSString *main_img_url = [URL_SERVICE stringByAppendingString:TOPIC_PIC_PATH];
    //    main_img_url = [main_img_url stringByAppendingString:@"/"];
    //    main_img_url = [main_img_url stringByAppendingString:item.image_url];
    
    NSString *main_img_url = [NSString stringWithFormat:@"%@%@",API_TOPIC_PIC_PATH,item.image_url];//字符串拼接
    [cell setForumIconImage:main_img_url];
    
    //lx 20150513
    NSString *lastnew_context = item.first_post_context;
    if(lastnew_context.length > 11){
        lastnew_context=[lastnew_context substringToIndex:11];
    }
    if(item.first_post_context!=nil){
        [cell setLastNewContent:lastnew_context];
    }else{
        cell.lastNewContentLabel.hidden = YES;
    }
    if(item.first_post_date!=nil){
        [cell setLast_new_date:[self twoDateDistants:item.first_post_date]];
    }else{
        cell.lastNewDate.hidden = YES;
    }
 
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    CGFloat iconsCountPerPage = 4;//一页中显示几个快速通道入口
    CGFloat w = self.view.frame.size.width;
    CGFloat h = 80;
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, 0, w, h);
    scrollView.backgroundColor = [UIColor whiteColor];
    int i = 0;
    int j = 0;
    for(forumItem *row in self.listForumItem){
        if([row.display_type rangeOfString:@"横向"].location!=NSNotFound){
            MainTableViewHeaderCell
            *cell =[[[NSBundle mainBundle] loadNibNamed:@"MainTableViewHeaderCell" owner:self options:nil] objectAtIndex:0];
            cell.frame = CGRectMake(w/iconsCountPerPage*i, 0, w/iconsCountPerPage, h);
            cell.forumNameLabel.text = row.forum_name;
            
            //设置版块主图URL
            NSString *main_img_url = [NSString stringWithFormat:@"%@%@",API_TOPIC_PIC_PATH,row.image_url];//字符串拼接
            cell.forumIconURLStr = main_img_url;
            
            [scrollView addSubview:cell];
            
            [cell setUserInteractionEnabled:YES];
            [cell setTag:j];
            UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoThisRepairReportForum:)];
            [cell addGestureRecognizer:singleTap3];
            
            i++;
        }
        j++;
    }
    //不显示滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    //设置scrollview的滚动范围
    CGFloat contentW = i * w / iconsCountPerPage;
    //不允许在垂直方向上进行滚动
    scrollView.contentSize = CGSizeMake(contentW, 0);
    //找到scrollview中最后一个子视图
    MainTableViewHeaderCell
    *cell =scrollView.subviews.lastObject;
    //将最后一个子视图的分割线设置为隐藏
    cell.breakLineImage.hidden = YES;
    
    return scrollView;
}

-(void)GoThisRepairReportForum:(UIGestureRecognizer *)gestureRecognizer
{
    MainTableViewHeaderCell *view = [gestureRecognizer view];
    NSInteger *index = view.tag;
    forumItem *f = [self.listForumItem objectAtIndex:index];
    NSLog(@"%@",f.forum_name);
    PostListViewController *poLVC = [PostListViewController createFromStoryboardName:@"PostList" withIdentifier:@"PostListID"];
    poLVC.forumlist = self.listForumItem;
    poLVC.forum_item = [self.listForumItem objectAtIndex:index];
    poLVC.filter_flag = @"全部";
    
    [self.navigationController pushViewController:poLVC animated:YES];
    
    NSLog(@"%@",@"hmx");
}



@end
