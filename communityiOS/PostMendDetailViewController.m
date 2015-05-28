//
//  PostMendDetailViewController.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/5/26.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "PostMendDetailViewController.h"
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

#import "MendRplyTableViewCell.h"
#import "MyMendReplyTableViewCell.h"
#import "replyInfoListItem.h"
#import "replyInfoItem.h"
#import "MJRefresh.h"
#import "RatingBar.h"

@interface PostMendDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PostListViewControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,UserJoinPostListViewControllerDelegate,PostEditViewControllerDelegate>
- (IBAction)replyAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *replyContentField;

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
@property (strong,nonatomic) UIButton * delebutton;
@property (strong,nonatomic) UIButton * endMendBtn;

@property (strong,nonatomic) NSMutableArray *replyListArray;
//cell数据源
@property (strong,nonatomic) NSMutableArray *replyIDData;
@property (strong,nonatomic) NSMutableArray *replyerNickNameData;
@property (strong,nonatomic) NSMutableArray *replyDateData;
@property (strong,nonatomic) NSMutableArray *replyerHeadData;
@property (strong,nonatomic) NSMutableArray *replyContentData;
@property (strong,nonatomic) replyInfoListItem *reply_list_item;
@property (strong,nonatomic) replyInfoItem *reply_info_item;
@property (strong,nonatomic) NSNumber *Page;
@property (strong,nonatomic) NSNumber *Rows;
@property (nonatomic,strong) NSMutableArray *forumSetArray;

@property (strong,nonatomic)UIView *maskView;
@property (strong,nonatomic)UIView *assessView;
@property (strong,nonatomic)NSString *evaluateStr;


@end

@implementation PostMendDetailViewController
int mend_count=0;//用于菜单点击计数
int mend_pop_code;//用于跳转标志
int mend_alert = 0;//用于警告框UIAlertView计数
bool mend_alertcount=false;//用于菜单点击计数
float mend_cellheight = 0;
float mend_chainHeight = 0;
float mend_applyHeight = 0;
float mend_imageHeight = 0;
NSInteger mend_menuHeight ;//menu的高度
bool mend_isModerator = NO;//是否是版主

int mend_reply_page = 1;
int mend_reply_rows = 1000;
int mend_page_filter = 0;
int mend_screenHeight = 0;
float mend_score = 0;

#pragma mark-
#pragma mark----------------当点击view的区域就会触发这个事件----------------------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //  [self.reply_text resignFirstResponder];
    [self.view endEditing:YES];
    
}
#pragma mark-
#pragma mark---------------------TableViewDelegate------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.replyListArray.count + 5;
    
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
            }
            [self.postTextCell.postText setText:self.post_text];
            //改变cell的高度需要reload该cell
            CGSize size = CGSizeMake(300, 1000);
            CGSize labelSize = [self.postTextCell.postText.text sizeWithFont:self.postTextCell.postText.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
            mend_cellheight = labelSize.height+10;
            
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
                mend_imageHeight = 150;
                self.postImageCell.hidden = NO;
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
                mend_chainHeight = 40;
                self.chainCell.hidden = NO;
            }
            
            return self.chainCell;
            
        }else if(indexPath.row == 4){
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
                            
                            mend_applyHeight = 40;
                            self.applyCell.hidden = NO;
                            //nsstring change to nsinteger
                            NSInteger limit = [self.limit_apply_num intValue];
                            NSInteger apply = [self.apply_num intValue];
                            self.applyCell.pvApply.maximumValue = limit;
                            
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
            
        }else {
    
            if ([self.forum_item.display_type isEqualToString:@"横向"]) {
                if ([[self.replyIDData objectAtIndex:indexPath.row - 5]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserID"]]) {
                    MyMendReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    if(!cell){
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyMendReplyTableViewCell" owner:nil options:nil] objectAtIndex:0];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //填装数据
                    cell.replyerNickName.text = [self.replyerNickNameData objectAtIndex:indexPath.row-5];
                    cell.replyTime.text = [self.replyDateData objectAtIndex:indexPath.row-5];
                    [cell setReplyContentText:[self.replyContentData objectAtIndex:indexPath.row-5]];
                    //图片
                    NSString *replyImage = [NSString stringWithString:[self.replyerHeadData objectAtIndex:indexPath.row-5]];
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@",API_PROTRAIT_DOWNLOAD,replyImage];
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
            }
            
            MendRplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if(!cell){
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MendRplyTableViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //填装数据
            cell.replyerNickName.text = [self.replyerNickNameData objectAtIndex:indexPath.row-5];
            cell.replyTime.text = [self.replyDateData objectAtIndex:indexPath.row-5];
            [cell setReplyContentText:[self.replyContentData objectAtIndex:indexPath.row-5]];
            //图片
            NSString *replyImage = [NSString stringWithString:[self.replyerHeadData objectAtIndex:indexPath.row-5]];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",API_PROTRAIT_DOWNLOAD,replyImage];
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

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row == 0 ) {
            return 100;
        }else if(indexPath.row ==1){
            return mend_cellheight;
        }else if(indexPath.row ==2){
            return mend_imageHeight;
        }else if (indexPath.row == 3){
            return mend_chainHeight ;
            
        }else if (indexPath.row == 4){
            return mend_applyHeight ;
        }else{
            
            UITableViewCell *cell = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height + 20;
        }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

#pragma mark-
#pragma mark------实现PostListViewControllerDelegate----------------------------
-(void)addpostItem:(postItem *)PostItem{
    self.post_item = PostItem;
    
}

#pragma mark------实现UserJoinPostListViewControllerDelegate-------------------
-(void)addpostItem2:(postItem *)PostItem{
    self.post_item = PostItem;
}
#pragma mark------实现PostEditViewControllerDelegate------------------------------
-(void)addpostItem3:(postItem *)PostItem{
    self.post_item = PostItem;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:(BOOL)animated];
    //注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    if(mend_pop_code==1){
        [StatusTool statusToolGetPostInfoWithPostID:self.post_item.post_id Success:^(id object) {
            self.post_item = (postItem *)object;
            [self.tableview reloadData];
        } failurs:^(NSError *error) {
            //
        }];
    }
}

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

    if(self.post_item == nil){
        
        [self loadPostInfo:self.postIDFromOutside];
        
    }else{
        [self setData_2];
        //        [self.tableview reloadData];
        [self initUI];
        
    }
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划线
    self.navigationItem.title = @"详情";
    UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    [self.tableview.tableHeaderView setHidden:YES];

  //  [self setupRefreshing];
    [self loadReplyListData];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    //设置textFeild代理
    self.replyContentField.delegate = self;
    //获取屏幕高度
    mend_screenHeight = self.view.frame.size.height;
    //清楚多余的表
    [self clearExtraLine:self.tableview];
    
}
#pragma mark-
#pragma mark--------------------去掉多余的线----------------------------
-(void)clearExtraLine:(UITableView *)tableView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableview setTableFooterView:view];
}
#pragma mark-
#pragma mark----------------------防止键盘遮盖---------------------------

//点击屏幕别处键盘收起
-(void)hidenKeyboard
{
    [self.replyContentField resignFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    newFrame.size.height = mend_screenHeight - keyboardRect.size.height;
    NSTimeInterval animationDuration = 0.50f;
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = newFrame;
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSTimeInterval animationDuration = 0.20f;
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, mend_screenHeight);
    [UIView commitAnimations];
}


#pragma mark-


-(void)loadPostInfo:(NSString *)postID{
    [StatusTool statusToolGetPostInfoWithPostID:postID Success:^(id object) {
        self.post_item = (postItem *)object;
        [self setData_2];
        [self.tableview reloadData];
        [self initUI];
    } failurs:^(NSError *error) {
        //to do
    }];
}

#pragma mark------------------------赋值函数------------------------------
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
    mend_menuHeight = 0;
    
    
}
#pragma mark-----------------------初始化界面------------------------------

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
    
    //下拉菜单
    self.operlist = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 100, 50*mend_menuHeight)];
    self.operlist.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.operlist.alpha=0;
    //编辑 按钮
    self.editbutton = [[UIButton alloc]init];
    self.editbutton.frame = CGRectMake(25, 0, 50, 50);
    [self.editbutton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editbutton addTarget:self action:@selector(EditPost) forControlEvents:UIControlEventTouchUpInside];
    [self.editbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //结束保修按钮
    self.endMendBtn = [[UIButton alloc]init];
    self.endMendBtn.frame = CGRectMake(25, 100, 50, 50);
    [self.endMendBtn setTitle:@"结束报修" forState:UIControlStateNormal];
    [self.endMendBtn addTarget:self action:@selector(endMend) forControlEvents:UIControlEventTouchUpInside];
    [self.endMendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //删除按钮
    self.delebutton = [[UIButton alloc]init];
    self.delebutton.frame = CGRectMake(25, 50, 50, 50);
    [self.delebutton setTitle:@"删除" forState:UIControlStateNormal];
    [self.delebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.delebutton addTarget:self action:@selector(DelePost) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)MenuAppear{
    if(mend_count==1){//表示menu开着
        
        [UIView animateWithDuration:0.3 animations:^{
            self.operlist.frame = CGRectMake(self.view.frame.size.width-100, -90, 100, 50*mend_menuHeight);
            self.operlist.alpha = 1;
        }];
        mend_count = 0;
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.operlist.frame = CGRectMake(self.view.frame.size.width-100, 60, 100, 50*mend_menuHeight);
            self.operlist.alpha = 1;
        }];
        [self.view addSubview:self.operlist];
        mend_count=1;
    }
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
    [self.postTitle setText:self.post_title];
    
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
        self.editbutton.frame = CGRectMake(25, 50*mend_menuHeight, 50, 50);
        mend_menuHeight++;
        
    }
    
    //结束报修按钮
    if ([self.post_over isEqualToString:@"否"]) {
        [self.operlist addSubview:self.endMendBtn];
        self.endMendBtn.frame = CGRectMake(25, 50*mend_menuHeight, 50, 50);
        mend_menuHeight++;
    }
    
    //结束报名
//    for(int i=0 ; i< self.forum_item.ForumSetlist.count ; i++){
//        forumSetItem *forumset = [forumSetItem createItemWitparametes:[self.forum_item.ForumSetlist objectAtIndex:i]];
//        if ([forumset.site_name isEqualToString:@"是否提供报名功能"]) {
//            if ([forumset.site_value isEqualToString:@"是"]) {
//                if ([self.open_apply isEqualToString:@"是"] && [self.user_id isEqualToString:self.poster_id] && [self.post_over isEqualToString:@"否"]) {
//                    [self.operlist addSubview:self.endApplyButton];
//                    self.endApplyButton.frame = CGRectMake(25, 50*mend_menuHeight, 50, 50);
//                    mend_menuHeight++;
//                }
//                
//            }
//            break;
//        }
//    }
    //delete button
    if ([self.user_auth containsString:@"/系统管理员/"] || [self.moderator_of_forum_list containsObject:self.forum_id] || [self.user_id isEqualToString:self.poster_id]) {
        [self.operlist addSubview:self.delebutton];
        self.delebutton.frame = CGRectMake(25, 50*mend_menuHeight, 50, 50);
        mend_menuHeight++;
    }
    //    [self setMenu];
    self.operlist.frame = CGRectMake(self.view.frame.size.width-100, 0, 100, 50*mend_menuHeight);
    //postdetailmenu显示情况
    
    if([self.moderator_of_forum_list containsObject:self.forum_id] ||[self.user_auth containsString:@"/系统管理员/"] || ([self.user_id isEqualToString:self.poster_id] && ![self.user_auth isEqualToString:@""]) ){
        //        [self.view addSubview:self.operlist];
        self.navigationItem.rightBarButtonItem = self.rightItem;
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
    
}
-(void)loadPosterHead{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_HEAD_PIC_PATH,self.head_portrait_url];
    
    [self.posterCell.headPortrait sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.posterCell.headPortrait.image = image;
        
    }];
}
-(void)loadMainImage{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_TOPIC_PIC_PATH,self.main_image_url];
    
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
-(void)applyOnLine{
    
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
        
    }];
    
    
}
//-(void)endapply{
//    [StatusTool statusToolEndApplyWithcommunity_id:self.community_id forum_id:self.forum_id post_id:self.post_id user_id:self.user_id Success:^(id object) {
//        //提示结束报名成功
//        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
//        [self.view addSubview:hud];
//        hud.labelText = @"结束报名成功！";
//        hud.mode = MBProgressHUDModeText;
//        [hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [hud removeFromSuperview];
//        }];
//        [self.operlist removeFromSuperview];
//        mend_count = 0;
//        
//    } failurs:^(NSError *error) {
//        NSLog(@"%@",error);
//        [self.operlist removeFromSuperview];
//        
//    }];
//    
//}
-(void)endMend{
    //下载评分的类型
    [StatusTool statusToolGetScoreTypeWithCommunityID:self.community_id ForumID:self.forum_id Success:^(id object) {
        
        NSLog(@"%@",object[@"score_text"]);
       //
    } failurs:^(NSError *error) {
        //
    }];
    
    //添加蒙版
    self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self.view addSubview:self.maskView];
    //评价的对话框
    self.assessView =[[UIView alloc]init];
    self.assessView.frame = CGRectMake(self.tableview.center.x-150, self.view.frame.size.height, 300, 220);
    self.assessView.alpha = 0;
    self.assessView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.assessView.alpha = 1;
        self.assessView.frame = CGRectMake(self.tableview.center.x-150, self.tableview.center.y-110, 300, 220);
        [self.assessView.layer setCornerRadius:self.assessView.frame.size.height/20];
    }];
    [self.view addSubview:self.assessView];
    
    //推送
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 30)];
    title.text = @"推送";
    title.textColor = [UIColor redColor];
    title.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18];
    [self.assessView addSubview:title];
    //红线
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 300, 2)];
    [vi setBackgroundColor:[UIColor redColor]];
    [self.assessView  addSubview:vi];
    
    //第一行文字
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 130, 50)];
    tlabel.text = @"请为本次报修打分:";
    tlabel.textAlignment = UITextAlignmentLeft;
    tlabel.lineBreakMode = UILineBreakModeWordWrap;
    tlabel.numberOfLines = 0;
    tlabel.textColor = [UIColor grayColor];
    tlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.assessView addSubview:tlabel];
    //第一行评价语句
    UILabel *assessLabel = [[UILabel alloc]initWithFrame:CGRectMake(tlabel.frame.origin.x+30, 70, 130, 15)];
    assessLabel.text = @"Welcome";
    assessLabel.textColor = [UIColor grayColor];
    assessLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.assessView addSubview:assessLabel];
    //星星
    RatingBar *ratingBar = [[RatingBar alloc]init];
    ratingBar.frame = CGRectMake(tlabel.frame.origin.x+30, assessLabel.frame.origin.y+assessLabel.frame.size.height, 180, 35);
    [ratingBar setImageDeselected:@"unselected" halfSelected:@"halfselected" fullSelected:@"selected" andDelegate:self];
    [self.assessView addSubview:ratingBar];
    mend_score = [ratingBar rating];
    
    //第二行文字
    UILabel *flabel = [[UILabel alloc]initWithFrame:CGRectMake(10, tlabel.frame.origin.y+tlabel.frame.size.height, 130, 15)];
    flabel.text = @"请给我们留言:";
    flabel.textAlignment = UITextAlignmentLeft;
    flabel.textColor = [UIColor grayColor];
    flabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.assessView addSubview:flabel];
    //留言文本框
    UITextField *messageField = [[UITextField alloc]init];
    messageField.frame = CGRectMake(tlabel.frame.origin.x+30, ratingBar.frame.origin.y+ratingBar.frame.size.height, 180, 13);
    [messageField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.assessView addSubview:messageField];
    
    UIView *vii = [[UIView alloc]initWithFrame:CGRectMake(tlabel.frame.origin.x+30, messageField.frame.origin.y+messageField.frame.size.height, 180, 1)];
    [vii setBackgroundColor:[UIColor redColor]];
    [self.assessView  addSubview:vii];
    
    //按钮
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn .frame = CGRectMake(tlabel.frame.origin.x+30, flabel.frame.origin.y+flabel.frame.size.height+10, 145, 40);
    sureBtn.titleLabel.text = @"确定";
    sureBtn.backgroundColor = [UIColor lightGrayColor];
    [sureBtn addTarget:self action:@selector(assessAndClose) forControlEvents:UIControlEventTouchUpInside];
    [self.assessView addSubview:sureBtn];
    UIButton *cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(sureBtn.frame.origin.x+10, flabel.frame.origin.y+flabel.frame.size.height+10, 145, 40);
    cancelBtn.titleLabel.text = @"取消";
    cancelBtn.backgroundColor = [UIColor lightGrayColor];
    [cancelBtn addTarget:self action:@selector(justClose) forControlEvents:UIControlEventTouchUpInside];
    [self.assessView addSubview:cancelBtn];

}


-(void)textFieldEditChanged:(UITextField *)textField{
    
    self.evaluateStr = textField.text;
}

-(void)assessAndClose{
    //发送评分
    [StatusTool statusToolPostMendScoreWithPostID:self.post_id User_ID:self.user_id Score:[NSString stringWithFormat:@"%f",mend_score] Evaluate:self.evaluateStr Success:^(id object) {
        if (![[object valueForKey:@"status"] isEqualToString:@""]) {
             [self justClose];
        }
    } failurs:^(NSError *error) {
        //
    }];
    
}
-(void)justClose{
    self.assessView.hidden =YES;
    [self.maskView removeFromSuperview];
}

-(void)toReplyList{
    
    PostReplyViewController *PEVC = [ PostReplyViewController createFromStoryboardName:@"PostReply" withIdentifier:@"postreply"];
    PEVC.postItem = self.post_item;
    [self.navigationController pushViewController:PEVC animated:YES];
    
}

#pragma mark--------------------菜单中编辑帖子------------------------------
-(void)EditPost{
    //    count++;
    mend_alertcount = false;
    mend_pop_code = 1;//跳转标志
    PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];
    //通过UIViewController+Create扩展方法创建FourViewController的实例对象
    //传值
    PEVC.ED_FLAG = @"2";//编辑帖子
    PEVC.post_item = self.post_item;//帖子详情
    PEVC.forum_item = _forum_item;
    
    [self.navigationController pushViewController:PEVC animated:YES];
    [self.operlist removeFromSuperview];
    mend_count = 0;
}

#pragma mark-------------------------------菜单中删除帖子-------------------
-(void)DelePost{
    //    count++;
    mend_alertcount = false;
    [self.operlist removeFromSuperview];
    
    //警告框
    UIAlertView *delete_alert=[[UIAlertView alloc]initWithTitle:@"删除确认" message:@"是否确定删除该话题?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [delete_alert show];
    mend_alert=0;
    mend_count = 0;
    
}

#pragma mark--------------------实现delete_alert警告框中的点击事件--------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(mend_alert==0){
        if(buttonIndex==0){//"取消"
            [alertView removeFromSuperview];
            
        }else{             //"确定"
            [self deletePost];//删除帖子操作
        }
    }
    if(mend_alert==1){
        if (buttonIndex==0) {
            //        PostListViewController *PLVC=[PostListViewController createFromStoryboardName:@"PostList" withIdentifier:@"PostListID"];
            //            PLVC.forum_item = _forum_item;
            
            //        [self.navigationController pushViewController:PLVC animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

#pragma mark---------------------------删除帖子操作------------------------------
-(void)deletePost{
    
    [StatusTool statusToolDeletePostWithpostID:self.post_id deleteUserID:self.user_id communityID:self.community_id fourmID:self.forum_id Success:^(id object) {
        
        self.delete = (deletepostItem *)object;
        if ([self.delete.delete_result isEqualToString:@"是"]) {
            UIAlertView *result_alert = [[UIAlertView alloc]initWithTitle:@"删除成功！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [result_alert show];
            mend_alert=1;
            
        }else{
            UIAlertView *result_alert = [[UIAlertView alloc]initWithTitle:@"删除失败！" message:self.delete.msg  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [result_alert show];
            mend_alert=2;
            
        }
        
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark-
#pragma mark---------------------------------设置刷新控件---------------------------
-(void)setupRefreshing{
    [self.tableview addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [self.tableview addFooterWithTarget:self action:@selector(footerRefreshing)];
}

-(void)headerRefreshing{//下拉
    mend_page_filter = 1;
    mend_reply_page =1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int16_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadReplyListData];
        [self.tableview headerEndRefreshing];
    });
}

-(void)footerRefreshing{//上拉
    mend_page_filter = 2;
    mend_reply_page++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int16_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadReplyListData];
        [self.tableview footerEndRefreshing];
    });
    
}
#pragma mark-
#pragma mark------------------------------加载回复列表的数据----------------------
-(void)loadReplyListData{
    self.Page = [NSNumber numberWithInt:mend_reply_page];
    self.Rows = [NSNumber numberWithInt:mend_reply_rows];
    [StatusTool statusToolGetReplyListWithPostID:self.post_item.post_id Page:self.Page Rows:self.Rows Success:^(id object) {
        self.reply_list_item = object;
        if (mend_page_filter == 0) {
            if (self.reply_list_item.contentList !=nil) {
                [self.replyListArray removeAllObjects];
                [self.replyIDData removeAllObjects];
                [self.replyerNickNameData removeAllObjects];
                [self.replyDateData removeAllObjects];
                [self.replyerHeadData removeAllObjects];
                [self.replyContentData removeAllObjects];
                [self getReplyData];
                [self.tableview reloadData];
            }else {
                self.tableview.hidden = YES;
            }
        }else{
            if (self.reply_list_item.contentList !=nil) {
                if (mend_page_filter == 2) {
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
                [self.tableview reloadData];
            }else{
                if (mend_page_filter == 2) {
                    mend_reply_page--;
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
#pragma mark-----------------------------加载回复详情的数据----------------------------
-(void)getReplyData{
    for (int i = 0; i < [self.reply_list_item.contentList count]; i++) {
        int t = (int )[self.reply_list_item.contentList count] - i - 1;
        self.reply_info_item = [replyInfoItem createItemWitparametes:[self.reply_list_item.contentList objectAtIndex:t]];
        if (mend_page_filter == 2) {
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
    
}
#pragma mark-
#pragma mark-----------------------计算时间差函数------------------------
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
#pragma mark----------------------------发送回复--------------------------------------

- (IBAction)replyAction:(id)sender {
    
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
        }];
    }else{
        [StatusTool statusToolPostReplyWithReplyText:self.replyContentField.text CommunityID:self.post_item.belong_community_id ForumID:self.post_item.belong_forum_id PostID:self.post_item.post_id UserID:[defaults valueForKey:@"UserID"] Date:curDate ReplyID:[self genUUID] Success:^(id object) {
            self.replyContentField.text =  @"";
            if (object != nil) {
                MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                [self.view addSubview:hud];
                hud.labelText = @"回复成功";
                hud.mode = MBProgressHUDModeText;
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                    mend_reply_page = 1;
                    mend_page_filter = 0;
                    [self loadReplyListData];
                } completionBlock:^{
                    [hud removeFromSuperview];
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
                }];
                
            }
            
        } failurs:^(NSError *error) {
            //to do
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
