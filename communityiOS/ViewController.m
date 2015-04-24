
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
#import "RegistViewController.h"




//NSString const *

@interface ViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,LoginViewControllerDelegate>{
    NSMutableArray *tableData;  //表格数据
    NSInteger *currentPage;
}

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


@end

@implementation ViewController

//@synthesize btnNickname;


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
    //   1.添加5张图片
    for (int i = 0; i < totalCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //        图片X
        CGFloat imageX = i * imageW;
        //        设置frame
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        //        设置图片
        NSString *name = [NSString stringWithFormat:@"image_0%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        //        隐藏指示条
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
        
        [self.mainScrollView addSubview:imageView];
    }
    
    //    2.设置scrollview的滚动范围
    CGFloat contentW = totalCount *imageW;
    //不允许在垂直方向上进行滚动
    self.mainScrollView.contentSize = CGSizeMake(contentW, 0);
    
    //    3.设置分页
    self.mainScrollView.pagingEnabled = YES;
    
    //    4.监听scrollview的滚动
    self.mainScrollView.delegate = self;
    
    [self addTimer];
    [self reloadData];
    [self autoLogin];
    
    
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
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
        [self.mainTableView reloadData];
        
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listForumItem count];
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
    [cell setForumIconImage:item.image_url];
    return cell;
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
    poLVC.forum_item = [self.listForumItem objectAtIndex:indexPath.row];
    
    
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
            RegistViewController *RVC = [RegistViewController createFromStoryboardName:@"Login" withIdentifier:@"regist"];
            [self.navigationController pushViewController:RVC animated:YES];
        }
    }
}

#pragma mark --在视图间切换时，并不会再次载入viewDidLoad方法，所以如果在调入视图时，需要对数据做更新，就只能在这个方法内实现了。所以这个方法也非常常用。hmx
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:(BOOL)animated];
    [self reloadUserStateBarUI];//刷新用户状态栏UI
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
        [self.btnNickname setTitle:userNickname forState:UIControlStateNormal];
        [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:headPortraitUrl] placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image!=nil){
                self.avaterImageView.image = image;
            }
        }];
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




@end
