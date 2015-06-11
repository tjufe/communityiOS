//
//  PostDetailViewController.m
//  communityiOS
//
//  Created by tjufe on 15/3/30.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "PostDetailViewController.h"
#import "PosterTableViewCell.h"
#import "PostTextTableViewCell.h"
#import "PostImageTableViewCell.h"
#import "ChainTableViewCell.h"
#import "ApplyTableViewCell.h"
#import "PostEditViewController.h"
#import "PostReplyViewController.h"
#import "UIViewController+Create.h"
#import "PostListViewController.h"
#import "UIImageView+WebCache.h"//加载图片
#import "StatusTool.h"
#import "deletepostItem.h"
#import "APIAddress.h"
#import "ifApplyItem.h"
#import "ChainToWebView.h"
#import "UserJoinPostListViewController.h"
#import "ChainToWebViewController.h"
#import "MBProgressHUD.h"
#import "ViewController.h"
#import "AppDelegate.h"




@interface PostDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PostListViewControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,UserJoinPostListViewControllerDelegate,PostEditViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (strong ,nonatomic) IBOutlet UIView *operlist;
@property (strong,nonatomic) postItem *post_item ;
@property (strong,nonatomic) ifApplyItem *if_apply_item ;
@property (strong,nonatomic) NSString *HeadPortraitUrl;//当前用户头像
@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
@property (strong,nonatomic) NSString *UserID;//当前用户id
@property (strong,nonatomic) NSString *AccountStatus;//当前用户账号状态
@property (strong,nonatomic) NSArray *moderator_of_forum_list;//版块版主信息
@property (weak,nonatomic) deletepostItem *delete;
@property (weak,nonatomic) NSString* post_id;//当前帖子的id号码
@property (weak,nonatomic) NSString* head_portrait_url;//发帖人头像url
@property (weak,nonatomic) NSString* poster_nickname;//发帖人昵称
@property (weak,nonatomic) NSString* reply_num;//当前帖子回复人数
@property (weak,nonatomic) NSString* apply_num;
@property (weak,nonatomic) NSString* read_num;
@property (weak,nonatomic) NSString* user_auth;//当前用户身份
@property (weak,nonatomic) NSString* user_id;//当前用户id
@property (weak,nonatomic) NSString* chain;//当前帖子是否添加外链
@property (weak,nonatomic) NSString* chain_name;
@property (weak,nonatomic) NSString* chain_url;
@property (weak,nonatomic) NSString* community_id;
@property (weak,nonatomic) NSString* forum_id;
@property (weak,nonatomic) NSString* post_text;
@property (weak,nonatomic) NSString* post_title;
@property (weak,nonatomic) NSString* post_date;
@property (weak,nonatomic) NSString* post_overed;//是否结帖
@property (weak,nonatomic) NSString* main_image_url;//主图url
@property (weak,nonatomic) NSString* poster_id;
@property (weak,nonatomic) NSString* set_top;
@property (weak,nonatomic) NSString* need_check;
@property (weak,nonatomic) NSString* open_apply;
@property (weak,nonatomic) NSString* limit_apply_num;
@property (weak,nonatomic) NSString* poster_auth;
@property (weak,nonatomic) NSString* forum_title;
@property (weak,nonatomic) NSString* apply_flag;
@property (weak,nonatomic) NSString* post_over;
@property (weak,nonatomic) NSString* apply_enough;
@property (strong,nonatomic) ApplyTableViewCell * applyCell;
@property (strong,nonatomic) ChainTableViewCell * chainCell;
@property (strong,nonatomic) PosterTableViewCell * posterCell;
@property (strong,nonatomic) PostTextTableViewCell * postTextCell;
@property (strong,nonatomic) PostImageTableViewCell * postImageCell;
@property (strong,nonatomic) UIBarButtonItem *rightItem;
@property (strong,nonatomic) UIButton * editbutton;
@property (strong,nonatomic) UIButton * endApplyButton;
@property (strong,nonatomic) UIButton * delebutton;

@end

@implementation PostDetailViewController

int count;//用于菜单点击计数
int alert = 0;//用于警告框UIAlertView计数
bool alertcount=false;//用于菜单点击计数
float cellheight = 0;
float chainHeight = 0;
float applyHeight = 0;
float imageHeight = 0;
NSInteger menuHeight ;//menu的高度
bool isModerator = NO;//是否是版主

#pragma mark------下方快速回复
- (IBAction)SendOnClick:(id)sender {
    
    PostReplyViewController *PEVC = [ PostReplyViewController createFromStoryboardName:@"PostReply" withIdentifier:@"postreply"];
    PEVC.postItem = self.post_item;
    PEVC.forum_item = self.forum_item;
    [self.navigationController pushViewController:PEVC animated:YES];
    
    
}
-(IBAction)ReplyNumOnClick:(id)sender{
    PostReplyViewController *PEVC = [ PostReplyViewController createFromStoryboardName:@"PostReply" withIdentifier:@"postreply"];
    PEVC.forum_item = _forum_item;
    PEVC.postItem = self.post_item;
    [self.navigationController pushViewController:PEVC animated:YES];

}


#pragma mark------当点击view的区域就会触发这个事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
       self.posterCell = [tableView dequeueReusableCellWithIdentifier:nil];
        
        if (!self.posterCell) {
            self.posterCell= [[[NSBundle mainBundle]loadNibNamed:@"PosterTableViewCell" owner:nil options:nil]objectAtIndex:0];
            self.posterCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.posterCell.posterAuth.hidden = YES;
        }
        if(self.post_date!=nil){
            self.posterCell.postDate.text = [self.post_date substringToIndex:16];
        }
        [self.posterCell.posterNickname setText:self.poster_nickname];
        //发帖人头像
        //HeadPortraitUrl
        if(self.head_portrait_url==nil || [self.head_portrait_url isEqualToString:@"''"] ){
            self.head_portrait_url=@"";
        }
        if(![self.head_portrait_url isEqualToString:@""]){
            [self loadPosterHead];
            
        }else{
            self.posterCell.headPortrait.image = [UIImage imageNamed:@"默认小头像"];
        }
        self.posterCell.headPortrait.contentMode=UIViewContentModeScaleAspectFill;
        self.posterCell.headPortrait.layer.masksToBounds = YES;
        [self.posterCell.headPortrait.layer setCornerRadius:self.posterCell.headPortrait.layer.frame.size.height/2];
        //认证图标
        if ([self.poster_auth isEqualToString:@"是"]) {
            self.posterCell.posterAuth.hidden = NO;
        }    
        return self.posterCell;
    }else if(indexPath.row == 1){
           self.postTextCell = [tableView dequeueReusableCellWithIdentifier:nil];
            self.postTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!self.postTextCell) {
                self.postTextCell= [[[NSBundle mainBundle]loadNibNamed:@"PostTextTableViewCell" owner:nil options:nil]objectAtIndex:0];
                self.postTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cellheight = self.postTextCell.postText.frame.size.height;

            }
            [self.postTextCell.postText setText:self.post_text];
            //改变cell的高度需要reload该cell
        CGSize size = CGSizeMake(300, 1000);
        CGSize labelSize = [self.postTextCell.postText.text sizeWithFont:self.postTextCell.postText.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
            cellheight = labelSize.height+10;
            return self.postTextCell;

        }else if(indexPath.row == 2){
            self.postImageCell = [tableView dequeueReusableCellWithIdentifier:nil];
            if (!self.postImageCell) {
                self.postImageCell= [[[NSBundle mainBundle]loadNibNamed:@"PostImageTableViewCell" owner:nil options:nil]objectAtIndex:0];
                self.postImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
                 self.postImageCell.hidden = YES;
            }
            
            //主图显示情况
            if (self.main_image_url!=nil && ![self.main_image_url isEqualToString:@""]) {
                [self loadMainImage];
//                imageHeight = 180;
                self.postImageCell.hidden = NO;
//                self.postImageCell.MainImage.contentMode=UIViewContentModeScaleAspectFill;
            }else{
                
            }
            return self.postImageCell;
        }else if(indexPath.row == 3){
            self.chainCell = [ tableView dequeueReusableCellWithIdentifier:nil];
            
            if (!self.chainCell) {
                self.chainCell= [[[NSBundle mainBundle]loadNibNamed:@"ChainTableViewCell" owner:nil options:nil]objectAtIndex:0];
                self.chainCell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.chainCell.hidden = YES;
            }

            //外链层
            if ([self.chain isEqualToString:@"是"]) {
                //        self.chainCell.btChain.hidden = NO;
                [self.chainCell.btChain setTitle:self.chain_name forState:UIControlStateNormal];
                [self.chainCell.btChain addTarget:self action:@selector(ChainToWeb) forControlEvents:UIControlEventTouchUpInside];
                
                chainHeight = 40;
                self.chainCell.hidden = NO;
                
            }

            
            
            return self.chainCell;
            
        }else {
            self.applyCell = [tableView dequeueReusableCellWithIdentifier:nil];
            
            if (!self.applyCell) {
                self.applyCell= [[[NSBundle mainBundle]loadNibNamed:@"ApplyTableViewCell" owner:nil options:nil]objectAtIndex:0];
                self.applyCell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.applyCell.hidden = YES;
                [self.applyCell.btApply setBackgroundImage:[UIImage imageNamed:@"icon_plus2"] forState:UIControlStateNormal];
                
                //取消用户点击
                self.applyCell.btApply.userInteractionEnabled = NO;

            }
            //报名层
            for(int i=0;i< self.forum_item.ForumSetlist.count; i++){
                forumSetItem *forumset = [forumSetItem createItemWitparametes:[self.forum_item.ForumSetlist objectAtIndex:i]];
                if ([forumset.site_name isEqualToString:@"是否提供报名功能"]) {
                    if ([forumset.site_value isEqualToString:@"是"]) {
                        if([self.open_apply isEqualToString:@"是"]){
                            
                            applyHeight = 40;
                            self.applyCell.hidden = NO;
                            
                            //nsstring change to nsinteger
                            NSInteger limit = [self.limit_apply_num intValue];
                            NSInteger apply = [self.apply_num intValue];
                            self.applyCell.pvApply.maximumValue = limit;
//                            self.applyCell.pvApply.currentValue = apply ;
//                            self.applyCell.pvApply.cornerRadius = self.applyCell.pvApply.layer.frame.size.height/4;
//                            [self.applyCell.pvApply updateToCurrentValue:self.applyCell.pvApply.currentValue animated:YES];
//                            NSInteger newCurrentValue;
//                            if ( self.applyCell.pvApply.currentValue == 0) {
//                                newCurrentValue = self.applyCell.pvApply.maximumValue;
//                            } else {
//                                newCurrentValue = self.applyCell.pvApply.currentValue;
//                            }
                            
                            [self.applyCell.pvApply updateToCurrentValue:limit -apply +1 animated:YES];
                            if ([self.limit_apply_num isEqualToString:@""]) {//没有人数限制，发帖页已经做修改，此处之后应该用不到
                                self.limit_apply_num = @"100";
                            }
                            if ([self.apply_num isEqualToString:@""]) {
                                self.apply_num = @"0";
                            }
                            [self.applyCell.applyNum setText:self.apply_num];
                            [self.applyCell.limitApplyNum setText:self.limit_apply_num];
                            
                            if ([self.user_auth isEqualToString:@"认证用户"]) {
                                if ([self.apply_flag isEqualToString:@"1"]) {
                                    
                                }else if([self.post_over isEqualToString:@"是"]){
                                    
                                }else if([self.apply_enough isEqualToString:@"是"]){
                                    
                                }else{
                                    [self.applyCell.btApply setBackgroundImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
                                    //开启用户点击
                                    self.applyCell.btApply.userInteractionEnabled = YES;
                                    [self.applyCell.btApply addTarget:self action:@selector(applyOnLine) forControlEvents:UIControlEventTouchUpInside];
                                    
                                }
                            }
                            
    
                        }
                        break;
                    }
                }
                
            }

            return self.applyCell;
        }
    }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        return 100;
    }else if(indexPath.row ==1){
        return cellheight;
    }else if(indexPath.row ==2){
        return imageHeight;
    }else if (indexPath.row == 3){
        return chainHeight ;
        
    }else{
        return applyHeight+20 ;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [self.view endEditing:YES];
}
    


#pragma mark------实现PostListViewControllerDelegate
-(void)addpostItem:(postItem *)PostItem{
    self.post_item = PostItem;
    
}

#pragma mark------实现UserJoinPostListViewControllerDelegate
-(void)addpostItem2:(postItem *)PostItem{
    self.post_item = PostItem;
}
#pragma mark------实现PostEditViewControllerDelegate
-(void)addpostItem3:(postItem *)PostItem{
    self.post_item = PostItem;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:(BOOL)animated];
    count = 0;
    if(pop_code==1){
        if (self.postIDFromOutside == nil) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                [StatusTool statusToolGetPostInfoWithPostID:self.post_item.post_id Success:^(id object) {
                    self.post_item = (postItem *)object;
                    [self setData_2];
                    [self.tableview reloadData];
                    [self initUI];
                } failurs:^(NSError *error) {
                    //
                }];
                
            });
            
        }
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:(BOOL)animated];
    [self.operlist removeFromSuperview];
    count = 0;
    //self.menuHeight = 0;
    imageHeight = 0;
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //start by wangyao 0513
    //
    if(self.post_item == nil){
        [self loadPostInfo:self.postIDFromOutside];

    }else{
        [self setData_2];
        [self initUI];
    
    }

    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划线    
    self.navigationItem.title = @"详情";
       UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;

    
}

-(void)loadPostInfo:(NSString *)postID{
    [StatusTool statusToolGetPostInfoWithPostID:postID Success:^(id object) {
        self.post_item = (postItem *)object;
        [self setData_2];
        [self initUI];
        [self.tableview reloadData];
    } failurs:^(NSError *error) {
        //to do
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark----赋值函数
-(void)setData_2{
    self.head_portrait_url = self.post_item.poster_head;
    self.poster_nickname = self.post_item.poster_nickname;
    self.reply_num = self.post_item.reply_num;
    self.apply_num = self.post_item.apply_num;
    self.read_num = self.post_item.read_num;
    self.chain = self.post_item.chain;
    self.chain_name = self.post_item.chain_name;
    self.chain_url = self.post_item.chain_url;
    self.community_id  = self.post_item.belong_community_id;
    self.forum_id = self.post_item.belong_forum_id;
    self.post_id = self.post_item.post_id;
    self.post_text = self.post_item.post_text;
    self.post_title = self.post_item.title;
    self.post_date = self.post_item.post_date;
    self.post_overed = self.post_item.post_overed;
    self.main_image_url = self.post_item.main_image_url;
    self.poster_id = self.post_item.poster_id;
    self.set_top = self.post_item.set_top;
    self.need_check = self.post_item.need_check;
    self.open_apply =self.post_item.open_apply;
    self.limit_apply_num = self.post_item.limit_apply_num;
    self.poster_auth = self.post_item.poster_auth;
    self.post_over = self.post_item.post_overed;
    self.apply_enough = self.post_item.apply_enough;
    imageHeight = 150;
    
    if(self.forumList==nil){
        self.forumList = [ViewController getForumList];
    }
    
    for(int i=0; i<self.forumList.count; i++) {
        forumItem *forumitem = [self.forumList objectAtIndex:i];
        if ([forumitem.forum_id isEqualToString:self.forum_id] ) {
            self.forum_title = forumitem.forum_name;
            self.forum_item = forumitem;//将查到的forumitem保存起来
            break;
        }
    }


    //获取当前用户信息
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user_auth =[defaults objectForKey:@"UserPermission"];
    self.user_id = [defaults objectForKey:@"UserID"];
    self.AccountStatus = [defaults objectForKey:@"AccountStatus"];
    self.HeadPortraitUrl = [defaults objectForKey:@"HeadPortraitUrl"];//当前用户头像url 不同于 head——portrait－url
    self.moderator_of_forum_list = [defaults objectForKey:@"moderator_of_forum_list"];

//    menuHeight = 0;


}
#pragma mark----初始化界面

-(void)initUI{
    [self setViewGone];
    //制作导航栏右侧菜单按钮
    [self setMenuButton];
    //制作menu下拉菜单
    [self setMenu];
    //认证用户查看是否已报名，普通用户不查看
    if([self.user_auth  isEqualToString: @"认证用户"]){
        [self getApply];
    }else{
        [self setUserInit];
    }


    
    
}



-(void)setViewGone{
    self.operlist.hidden = YES;
    self.replyImage.hidden = YES;
    self.replyNum.hidden = YES;
    self.btReplyNum.userInteractionEnabled = NO;
//其他隐去放在各个cell中
}
-(void)setMenuButton{
    //设置导航右侧按钮,但没有显示出来
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"菜单"];
    
    button.frame = CGRectMake(self.view.frame.size.width-30, 20, 20, 5);
    
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    // 让按钮图片右移15
    //    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(MenuAppear) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)setMenu{
   
    menuHeight = 0;
    //下拉菜单
//    if(!self.operlist){
    self.operlist = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 100, 50*menuHeight)];

    self.operlist.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.operlist.alpha=0;
//    }
    //编辑 按钮
    self.editbutton = [[UIButton alloc]init];
    self.editbutton.frame = CGRectMake(25, 0, 50, 50);
    self.editbutton.titleLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
    [self.editbutton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editbutton addTarget:self action:@selector(EditPost) forControlEvents:UIControlEventTouchUpInside];
    [self.editbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //删除按钮
    self.delebutton = [[UIButton alloc]init];
    self.delebutton.frame = CGRectMake(25, 50, 100, 50);
    self.delebutton.titleLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
    [self.delebutton setTitle:@"删除" forState:UIControlStateNormal];
    [self.delebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.delebutton addTarget:self action:@selector(DelePost) forControlEvents:UIControlEventTouchUpInside];
    
    //结束报名按钮
    self.endApplyButton = [[UIButton alloc]init];
    self.endApplyButton.frame = CGRectMake(25, 100, 100, 50);
    self.endApplyButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
    [self.endApplyButton setTitle:@"结束报名" forState:UIControlStateNormal];
    [self.endApplyButton addTarget:self action:@selector(endapply) forControlEvents:UIControlEventTouchUpInside];
    [self.endApplyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    

    
    
}
-(void)MenuAppear{
    if(count==1){//表示menu开着
//    if(!self.operlist.hidden){//已显示,关上
        [UIView animateWithDuration:0.3 animations:^{

            self.operlist.frame = CGRectMake(self.view.frame.size.width-100, -90, 100, 50*menuHeight);

            self.operlist.alpha = 1;
        }];
        count = 0;
    //    self.operlist.hidden = YES;
        
    }else{ //未显示，弹出
            [UIView animateWithDuration:0.3 animations:^{
                self.operlist.frame = CGRectMake(self.view.frame.size.width-100, 60, 100, 50*menuHeight);

                self.operlist.alpha = 1;
            }];
            [self.view addSubview:self.operlist];
           self.operlist.hidden = NO;
        count=1;
    }
//    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~%d",count);
}

-(void)getApply{
    [StatusTool statusToolIfApplyWithcommunity_id:self.community_id forum_id:self.forum_id post_id:self.post_id user_id:self.user_id Success:^(id object) {
        self.if_apply_item = (ifApplyItem *)object;
        self.apply_flag = self.if_apply_item.apply_flag;
        [self setUserInit];
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)setUserInit{
    menuHeight = 0;
    [self.postTitle setText:self.post_title];
    self.postTitle .numberOfLines = 0;
//    [label setFrame:CGRectMake(10,50, size01.width, size01.height)];
//    if(self.post_date!=nil){
//        self.posterCell.postDate.text = [self.post_date substringToIndex:16];
//    }
//    [self.postTextCell.postText setText:self.post_text];
    
    //改变cell的高度需要reload该cell
//    cellheight = self.postTextCell.postText.frame.size.height;
//    NSLog(@"^^^^^^^^^^^^^%f",cellheight);
//    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:2 inSection:0];
//    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//    [self.tableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableview reloadData];
    
    if(![self.reply_num isEqualToString:@""]){
        [self.replyNum setText:self.reply_num];
    }else{
        [self.replyNum setText:@"0"];
    }
//    [self.posterCell.posterNickname setText:self.poster_nickname];
    [self.forumTitle setText:self.forum_title];
        //postdetailmenu里面按钮的显示情况
    //编辑按钮
    if([self.user_id isEqualToString:self.poster_id]){
        [self.operlist addSubview:self.editbutton];

        self.editbutton.frame = CGRectMake(25, 50*menuHeight, 50, 50);
        menuHeight++;

        
    }
    //结束报名按钮
    for(int i=0 ; i< self.forum_item.ForumSetlist.count ; i++){
        forumSetItem *forumset = [forumSetItem createItemWitparametes:[self.forum_item.ForumSetlist objectAtIndex:i]];
        if ([forumset.site_name isEqualToString:@"是否提供报名功能"]) {
            if ([forumset.site_value isEqualToString:@"是"]) {
                if ([self.open_apply isEqualToString:@"是"] && [self.user_id isEqualToString:self.poster_id] && [self.post_over isEqualToString:@"否"]) {
                    [self.operlist addSubview:self.endApplyButton];
                     self.endApplyButton.frame = CGRectMake(0, 50*menuHeight, 100, 50);
                    menuHeight++;

                }
                
            }
            break;
        }
    
    }
    //delete button
    if ([self.user_auth containsString:@"/系统管理员/"] || [self.moderator_of_forum_list containsObject:self.forum_id] || [self.user_id isEqualToString:self.poster_id]) {
         [self.operlist addSubview:self.delebutton];
         self.delebutton.frame = CGRectMake(25, 50*menuHeight, 50, 50);
            menuHeight++;
    }
//    [self setMenu];
    self.operlist.frame = CGRectMake(self.view.frame.size.width-100, 0, 100, 50*menuHeight);

    //postdetailmenu显示情况
    
    if(![self.user_auth isEqualToString:@""]){
    if([self.moderator_of_forum_list containsObject:self.forum_id] ||[self.user_auth containsString:@"/系统管理员/"] ||[self.user_id isEqualToString:self.poster_id]){
        //        [self.view addSubview:self.operlist];
        self.navigationItem.rightBarButtonItem = self.rightItem;
    }
    }

    //评论（）人
    for(int i=0; i< self.forum_item.ForumSetlist.count; i++){
        forumSetItem *forumset = [forumSetItem createItemWitparametes:[self.forum_item.ForumSetlist objectAtIndex:i]];
        if ([forumset.site_name isEqualToString:@"是否允许回帖"]) {
            if ([forumset.site_value isEqualToString:@"是"]) {
                self.replyImage.hidden= NO;
                self.replyNum.hidden = NO;
                self.btReplyNum.userInteractionEnabled = YES;
                
            }
        }
    
    }
//    //发帖人头像
//    //HeadPortraitUrl
//    if(self.head_portrait_url==nil || [self.head_portrait_url isEqualToString:@"''"] ){
//        self.head_portrait_url=@"";
//    }
//    
//    if(![self.head_portrait_url isEqualToString:@""]){
//        [self loadPosterHead];
//        
//    }else{
//        
//        self.posterCell.headPortrait.image = [UIImage imageNamed:@"默认小头像"];
//    }
//    self.posterCell.headPortrait.contentMode=UIViewContentModeScaleAspectFill;
//    self.posterCell.headPortrait.layer.masksToBounds = YES;
//    [self.posterCell.headPortrait.layer setCornerRadius:self.posterCell.headPortrait.layer.frame.size.height/2];
//    //认证图标
//    if ([self.poster_auth isEqualToString:@"是"]) {
//        self.posterCell.posterAuth.hidden = NO;
//    }
//    //主图显示情况
//    if (self.main_image_url!=nil && ![self.main_image_url isEqualToString:@""]) {
//        [self loadMainImage];
//        imageHeight = 150;
//        self.postImageCell.hidden = NO;
//        self.postImageCell.MainImage.contentMode=UIViewContentModeScaleAspectFill;
//        NSIndexPath *indexPath_2=[NSIndexPath indexPathForRow:2 inSection:0];
//        NSArray *indexArray_2=[NSArray arrayWithObject:indexPath_2];
//        [self.tableview reloadRowsAtIndexPaths:indexArray_2 withRowAnimation:UITableViewRowAnimationAutomatic];
//    }else{
//        
//    }
   
//    //外链层
//    if ([self.chain isEqualToString:@"是"]) {
////        self.chainCell.btChain.hidden = NO;
//        [self.chainCell.btChain setTitle:self.chain_name forState:UIControlStateNormal];
//        [self.chainCell.btChain addTarget:self action:@selector(ChainToWeb) forControlEvents:UIControlEventTouchUpInside];
//        
//        chainHeight = 80;
//        self.chainCell.hidden = NO;
//        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:3 inSection:0];
//        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//        [self.tableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    }
//    //报名层
//    for(int i=0;i< self.forum_item.ForumSetlist.count; i++){
//        forumSetItem *forumset = [forumSetItem createItemWitparametes:[self.forum_item.ForumSetlist objectAtIndex:i]];
//        if ([forumset.site_name isEqualToString:@"是否提供报名功能"]) {
//            if ([forumset.site_value isEqualToString:@"是"]) {
//                if([self.open_apply isEqualToString:@"是"]){
//                   
//                    if ([self.limit_apply_num isEqualToString:@""]) {//没有人数限制，发帖页已经做修改，此处之后应该用不到
//                        self.limit_apply_num = @"100";
//                    }
//                    if ([self.apply_num isEqualToString:@""]) {
//                        self.apply_num = @"0";
//                    }
//                    [self.applyCell.applyNum setText:self.apply_num];
//                    [self.applyCell.limitApplyNum setText:self.limit_apply_num];
//                    //nsstring change to nsinteger
//                    NSInteger limit = [self.limit_apply_num intValue];
//                    NSInteger apply = [self.apply_num intValue];
//                    self.applyCell.pvApply.maximumValue = limit;
//                    [self.applyCell.pvApply updateToCurrentValue:apply animated:YES];
//                    if ([self.user_auth isEqualToString:@"认证用户"]) {
//                        if ([self.apply_flag isEqualToString:@"1"]) {
//                            
//                        }else if([self.post_over isEqualToString:@"是"]){
//                            
//                        }else if([self.apply_enough isEqualToString:@"是"]){
//                        
//                        }else{
//                            [self.applyCell.btApply setBackgroundImage:[UIImage imageNamed:@"icon_plus"] forState:UIControlStateNormal];
//                            //开启用户点击
//                            self.applyCell.btApply.userInteractionEnabled = YES;
//                            [self.applyCell.btApply addTarget:self action:@selector(applyOnLine) forControlEvents:UIControlEventTouchUpInside];
//                            
//                        }
//                    }
//                    applyHeight = 80;
//                    self.applyCell.hidden = NO;
//                    NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:4 inSection:0];
//                    NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//                    [self.tableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
//                    
//                    
//                }
//                break;
//            }
//        }
//        
//    }
    //没有审核，推送，置顶情况
    

}
-(void)loadPosterHead{
    NSString *url = [NSString stringWithFormat:@"%@/uploadimg/%@",API_HOST,self.head_portrait_url];
    
    [self.posterCell.headPortrait sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.posterCell.headPortrait.image = image;
        
    }];
}
-(void)loadMainImage{
    NSString *url = [NSString stringWithFormat:@"%@/topicpic/%@",API_HOST,self.main_image_url];
    
    [self.postImageCell.MainImage sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.postImageCell.MainImage.image = image;
        
    }];




}
-(void)ChainToWeb{
    
    
    ChainToWebViewController *CTWBVC = [ ChainToWebViewController createFromStoryboardName:@"chainToWeb" withIdentifier:@"chianToWeb"];
    if ([self.chain_url containsString:@"http://"]) {
         CTWBVC.chain_url = self.chain_url;
    }else{
         CTWBVC.chain_url = [@"http://" stringByAppendingString:self.chain_url];
    }
   
    [self.navigationController pushViewController:CTWBVC animated:YES];



}
#pragma mark------报名
-(void)applyOnLine{

    self.applyCell.btApply.enabled = NO;
    [StatusTool statusToolPostApplyWithcommunity_id:self.community_id forum_id:self.forum_id post_id:self.post_id user_id:self.user_id limit_apply_num:self.limit_apply_num Success:^(id object) {
        //提示报名成功
        
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.labelText = @"报名成功！";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
        }];
        //
        NSInteger apply_num_int  = [self.apply_num intValue];
         apply_num_int= apply_num_int+1;
        
        
        self.apply_num = [NSString stringWithFormat: @"%ld", (long)apply_num_int];
        self.apply_flag = @"1";
        [self.applyCell.btApply setBackgroundImage:[UIImage imageNamed:@"icon_plus2"] forState:UIControlStateNormal];
        //取消用户点击
        self.applyCell.btApply.userInteractionEnabled = NO;
        //更新进度条
        [self.applyCell.pvApply updateToCurrentValue:1 animated:YES];
        [self.applyCell.applyNum setText:self.apply_num];
        //刷新applycell
//        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:4 inSection:0];
//        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
//        [self.tableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableview reloadData];
       

    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
       self.applyCell.btApply.enabled = YES;
    }];


}
-(void)endapply{
    
    pop_code = 1;
    [StatusTool statusToolEndApplyWithcommunity_id:self.community_id forum_id:self.forum_id post_id:self.post_id user_id:self.user_id Success:^(id object) {
        //提示结束报名成功
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.labelText = @"结束报名成功！";
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
        }];
        [self.operlist removeFromSuperview];
        count = 0;

    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
        [self.operlist removeFromSuperview];
        
    }];
    

}
-(void)toReplyList{

    PostReplyViewController *PEVC = [ PostReplyViewController createFromStoryboardName:@"PostReply" withIdentifier:@"postreply"];
    PEVC.postItem = self.post_item;
    PEVC.forum_item = _forum_item;
    [self.navigationController pushViewController:PEVC animated:YES];

}
//#pragma mark-------右上角菜单
//-(void)Operation{
////    if(count % 2!=0){
////        count++;
//    if(alertcount){
//        alertcount = false;
//        self.operlist.hidden = YES;
//    }else{
//        
//        
//    self.operlist = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 100, 150)];
//    self.operlist.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
//    self.operlist.alpha=0;
//        
//        
//    [UIView animateWithDuration:0.5 animations:^{
//        self.operlist.frame = CGRectMake(self.view.frame.size.width-100, 60, 100, 150);
//        self.operlist.alpha = 1;
//    }];
//    [self.view addSubview:self.operlist];
//    //编辑按钮
//    //楼主可编辑z
//    if([self.UserID isEqualToString:self.post_item.poster_id]){
//
//    UIButton * editbutton = [[UIButton alloc]init];
//    editbutton.frame = CGRectMake(25, 0, 50, 50);
//    [editbutton setTitle:@"编辑" forState:UIControlStateNormal];
//    [editbutton addTarget:self action:@selector(EditPost) forControlEvents:UIControlEventTouchUpInside];
//    [editbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.operlist addSubview:editbutton];
//    }
//    
//    //删除按钮
//    //楼主、版主和管理员显示删除按钮
//    if([self.UserID isEqualToString:self.post_item.poster_id]||[self.UserPermission rangeOfString:@"管理员"].location!=NSNotFound||isModerator){
//    UIButton * delebutton = [[UIButton alloc]init];
//    delebutton.frame = CGRectMake(25, 50, 50, 50);
//    [delebutton setTitle:@"删除" forState:UIControlStateNormal];
//    [delebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [delebutton addTarget:self action:@selector(DelePost) forControlEvents:UIControlEventTouchUpInside];
//    [self.operlist addSubview:delebutton];
//    }
//        
//        
//    //置顶按钮
//    //版主和管理员显示置顶按钮
//    if([self.UserPermission rangeOfString:@"管理员"].location!=NSNotFound||isModerator){
//    UIButton * settopbutton = [[UIButton alloc]init];
//    settopbutton.frame = CGRectMake(25, 100, 50, 50);
//    
//    [settopbutton setTitle:@"置顶" forState:UIControlStateNormal];
//    [settopbutton addTarget:self action:@selector(Settop) forControlEvents:UIControlEventTouchUpInside];
//    [settopbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.operlist addSubview:settopbutton];
//    }
//        alertcount = true;
//      //  count++;
//    }
//    
//}
#pragma mark--------菜单中编辑帖子
-(void)EditPost{
//    count++;
    alertcount = false;
    pop_code = 1;//跳转标志
    PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];
    //通过UIViewController+Create扩展方法创建FourViewController的实例对象
    //传值
    PEVC.ED_FLAG = @"2";//编辑帖子
    PEVC.post_item = self.post_item;//帖子详情
    PEVC.forum_item = _forum_item;
    [self.operlist removeFromSuperview];
    self.operlist = nil;
    self.navigationItem.rightBarButtonItem= nil;
    [self.navigationController pushViewController:PEVC animated:YES];
    count = 0;
}

#pragma mark------菜单中删除帖子
-(void)DelePost{
//    count++;
    alertcount = false;
    [self.operlist removeFromSuperview];
    
    //警告框
    UIAlertView *delete_alert=[[UIAlertView alloc]initWithTitle:@"删除确认" message:@"是否确定删除该话题?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [delete_alert show];
    alert=0;
    count = 0;

}

#pragma mark------实现delete_alert警告框中的点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alert==0){
        if(buttonIndex==0){//"取消"
            [alertView removeFromSuperview];
        
        }else{             //"确定"
            [self deletePost];//删除帖子操作
        }
    }
    if(alert==1){
        if (buttonIndex==0) {
//        PostListViewController *PLVC=[PostListViewController createFromStoryboardName:@"PostList" withIdentifier:@"PostListID"];
//            PLVC.forum_item = _forum_item;
            
//        [self.navigationController pushViewController:PLVC animated:YES];
            //0527
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark------删除帖子操作
-(void)deletePost{
    
    [StatusTool statusToolDeletePostWithpostID:self.post_id deleteUserID:self.user_id communityID:self.community_id fourmID:self.forum_id Success:^(id object) {
        
        self.delete = (deletepostItem *)object;
        if ([self.delete.delete_result isEqualToString:@"是"]) {
            UIAlertView *result_alert = [[UIAlertView alloc]initWithTitle:@"删除成功！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [result_alert show];
            alert=1;
            
        }else{
            UIAlertView *result_alert = [[UIAlertView alloc]initWithTitle:@"删除失败！" message:self.delete.msg  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [result_alert show];
            alert=2;

        }
        
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

//#pragma mark------菜单中置顶帖子
//-(void)Settop{
//    alertcount = false;
//    //count++;
//     [self.operlist removeFromSuperview];
//}
//
//
//-(void)setReply_text:(UITextView *)reply_text{
//    
//    
//    reply_text.layer.masksToBounds = YES;
//    [reply_text.layer setCornerRadius:reply_text.layer.frame.size.height/8];
//
//    }



@end
