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
#import "ifApplyItem.h"
#import "ChainToWebView.h"
#import "UserJoinPostListViewController.h"
#import "ChainToWebViewController.h"
#import "MBProgressHUD.h"
#import "forumSetItem.h"
#import "MendRplyTableViewCell.h"
#import "MyMendReplyTableViewCell.h"
#import "replyInfoListItem.h"
#import "replyInfoItem.h"
#import "MJRefresh.h"
#import "RatingBar.h"
#import "ScoreTypeList.h"
#import "EvaluateTableViewCell.h"
#import "NewPostEditViewController.h"
#import "PostText1TableViewCell.h"
#import "PostText23TableViewCell.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "APIAddress.h"


@interface PostMendDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PostListViewControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,UserJoinPostListViewControllerDelegate,PostEditViewControllerDelegate,UITextFieldDelegate>
- (IBAction)replyAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *replyContentField;
@property (weak, nonatomic) IBOutlet UIButton *reply_btn;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (strong, nonatomic) IBOutlet UIImageView *endImage;
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
@property (weak,nonatomic) NSString* post_text_1;
@property (weak,nonatomic) NSString* post_text_2;
@property (weak,nonatomic) NSString* post_text_3;
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
@property (weak,nonatomic) NSString* post_text_4;
@property (weak,nonatomic) NSString* post_text_5;
@property (strong,nonatomic) ApplyTableViewCell * applyCell;
@property (strong,nonatomic) ChainTableViewCell * chainCell;
@property (strong,nonatomic) PosterTableViewCell * posterCell;
@property (strong,nonatomic) PostTextTableViewCell * postTextCell;
@property (strong,nonatomic) PostText1TableViewCell * postTextCell1;
@property (strong,nonatomic) PostText23TableViewCell * postTextCell23;
@property (strong,nonatomic) PostImageTableViewCell * postImageCell;
@property (strong,nonatomic) EvaluateTableViewCell * evaluateCell;
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
@property (strong,nonatomic)NSMutableArray *scoreTypeList;
@property (strong,nonatomic)RatingBar *ratingBar;
@property (strong,nonatomic)UILabel *assessLabel;
@property (strong,nonatomic)UITextField *messageField;
@property (strong, nonatomic) IBOutlet UIView *replyView;
@property (nonatomic,strong) MBProgressHUD *hud;

- (IBAction)ViewTouchDown:(id)sender;


@end

@implementation PostMendDetailViewController

int mend_count=0;//用于菜单点击计数
//int mend_pop_code;//用于跳转标志
int mend_alert = 0;//用于警告框UIAlertView计数
bool mend_alertcount=false;//用于菜单点击计数
float mend_cellheight = 0;
float mend_cellheight1 = 0;
float mend_cellheight23 = 0;
float mend_chainHeight = 0;
float mend_applyHeight = 0;
float mend_imageHeight = 0;
NSInteger mend_menuHeight ;//menu的高度
bool mend_isModerator = NO;//是否是版主
int mend_reply_page = 1;
int mend_reply_rows = 1000;
int mend_page_filter = 0;
int mend_screenHeight = 0;
int mend_score = 0;
int starAmount = 0;
int reply_flag = 0;
bool isReply = false;
float assessViewX = 0;
float assessViewY = 0;

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
    
    return self.replyListArray.count + 8;
    
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

        }else if(indexPath.row == 1){     //故障地点单元格
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
            
        }else if (indexPath.row == 2){   //故障描述单元格
            self.postTextCell1 = [tableView dequeueReusableCellWithIdentifier:nil];
            self.postTextCell1.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!self.postTextCell1) {
                self.postTextCell1= [[[NSBundle mainBundle]loadNibNamed:@"PostText1TableViewCell" owner:nil options:nil]objectAtIndex:0];
                self.postTextCell1.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [self.postTextCell1.postText1 setText:self.post_text_1];
            CGSize size = CGSizeMake(300, 1000);
            CGSize labelSize = [self.postTextCell1.postText1.text sizeWithFont:self.postTextCell1.postText1.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
            mend_cellheight1 = labelSize.height+10;

            return  self.postTextCell1;
            
        }else if (indexPath.row == 3){       //保修人及联系方式单元格
            self.postTextCell23 = [tableView dequeueReusableCellWithIdentifier:nil];
            self.postTextCell23.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!self.postTextCell23) {
                self.postTextCell23= [[[NSBundle mainBundle]loadNibNamed:@"PostText23TableViewCell" owner:nil options:nil]objectAtIndex:0];
                self.postTextCell23.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            self.postTextCell23.postText2.text = [NSString stringWithFormat:@"报修人：%@",self.post_text_2];
            self.postTextCell23.postText3.text = [NSString stringWithFormat:@"联系电话：%@",self.post_text_3];
            CGSize size = CGSizeMake(300, 1000);
            CGSize labelSize = [self.postTextCell23.postText3.text sizeWithFont:self.postTextCell23.postText3.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
            mend_cellheight23 = labelSize.height+25;
            
            return  self.postTextCell23;
            
        }
        else if(indexPath.row == 4){       //主图
            if (!self.postImageCell) {
                self.postImageCell= [[[NSBundle mainBundle]loadNibNamed:@"PostImageTableViewCell" owner:nil options:nil]objectAtIndex:0];
                self.postImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.postImageCell.hidden = YES;
            }
            //主图显示情况
            if (self.main_image_url!=nil && ![self.main_image_url isEqualToString:@""]) {
                [self loadMainImage];
                self.postImageCell.hidden = NO;
            }else{
                mend_imageHeight = 0;
                self.postImageCell.hidden = YES;
            }
            
            return self.postImageCell;
            
        }else if(indexPath.row == 5){     //外链
            self.chainCell = [ tableView dequeueReusableCellWithIdentifier:nil];
            
            if (!self.chainCell) {
                self.chainCell= [[[NSBundle mainBundle]loadNibNamed:@"ChainTableViewCell" owner:nil options:nil]objectAtIndex:0];
                self.chainCell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.chainCell.hidden = YES;
            }
            //外链层
            if ([self.chain isEqualToString:@"是"]) {
                [self.chainCell.btChain setTitle:self.chain_name forState:UIControlStateNormal];
                [self.chainCell.btChain addTarget:self action:@selector(ChainToWeb) forControlEvents:UIControlEventTouchUpInside];
                mend_chainHeight = 40;
                self.chainCell.hidden = NO;
            }
            
            return self.chainCell;
            
        }else if(indexPath.row == 6){     //报名单元格
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
            
        }else if (indexPath.row == 7){      // 评分单元格
            
            self.evaluateCell = [ tableView dequeueReusableCellWithIdentifier:nil];
            if (!self.evaluateCell) {
                self.evaluateCell= [[[NSBundle mainBundle]loadNibNamed:@"EvaluateTableViewCell" owner:nil options:nil]objectAtIndex:0];
                self.evaluateCell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.evaluateCell.hidden = YES;
                self.evaluateCell.scoreLabel.text = self.post_text_4;
                self.evaluateCell.messageLabel.text = self.post_text_5;

            }
            if (![self.post_item.post_text_4 isEqualToString:@""]||![self.post_item.post_text_5 isEqualToString:@""]) {
                self.evaluateCell.hidden = NO;
                self.endImage.hidden = NO;
            }
            
            return self.evaluateCell;
            
        }else {
    
            if ([self.forum_item.display_type isEqualToString:@"横向"]) {
                if ([[self.replyIDData objectAtIndex:indexPath.row - 8]isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"UserID"]]) {
                    MyMendReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    if(!cell){
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyMendReplyTableViewCell" owner:nil options:nil] objectAtIndex:0];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //填装数据
                    cell.replyerNickName.text = [self.replyerNickNameData objectAtIndex:indexPath.row-8];
                    cell.replyTime.text = [self.replyDateData objectAtIndex:indexPath.row-8];
                    [cell setReplyContentText:[self.replyContentData objectAtIndex:indexPath.row-8]];

                    //图片
                    NSString *replyImage = [NSString stringWithString:[self.replyerHeadData objectAtIndex:indexPath.row-8]];
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
            }
            
            MendRplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if(!cell){
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MendRplyTableViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //填装数据
            cell.replyerNickName.text = [self.replyerNickNameData objectAtIndex:indexPath.row-8];
            cell.replyTime.text = [self.replyDateData objectAtIndex:indexPath.row-8];
            [cell setReplyContentText:[self.replyContentData objectAtIndex:indexPath.row-8]];
            //图片
            NSString *replyImage = [NSString stringWithString:[self.replyerHeadData objectAtIndex:indexPath.row-8]];
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

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row == 0 ) {
            return 100;
        }else if(indexPath.row ==1){
            return mend_cellheight;
        }else if (indexPath.row == 2){
            return mend_cellheight1;
        }else if (indexPath.row == 3){
            return mend_cellheight23;
        }else if(indexPath.row ==4){
            return mend_imageHeight;
        }else if (indexPath.row == 5){
            return mend_chainHeight ;
        }else if (indexPath.row == 6){
            return mend_applyHeight ;
        }else if (indexPath.row == 7){
            UITableViewCell *cell = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height + 10;
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
    //注册监听,实现上推和收起键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    if(mend_pop_code==1){
        // 从编辑页跳回来的时候重新请求数据
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            self.hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:self.hud];
            self.hud.dimBackground = YES;
            [self.hud show:YES];
            [self loadPostInfo:self.post_item.post_id];
        });
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
    self.scoreTypeList = [[NSMutableArray alloc]init];

    if(self.post_item == nil){
        if(_postitem!=nil){
            self.post_item = _postitem;
            [self setData_2];
            [self.tableview reloadData];
            [self initUI];
        }else{
            self.hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:self.hud];
            self.hud.dimBackground = YES;
            [self.hud show:YES];
            
            [self loadPostInfo:self.postIDFromOutside];
        }
        
        
    }else{
        [self setData_2];
        [self initUI];
        
    }
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划线
    self.navigationItem.title = @"详情";
    UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    [self.tableview.tableHeaderView setHidden:YES];

    [self loadReplyListData];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    [self.assessView addGestureRecognizer:gesture];
    //设置textFeild代理
    self.replyContentField.delegate = self;
    //获取屏幕高度
    mend_screenHeight = self.view.frame.size.height;
    assessViewX = self.view.center.x - 150;
    assessViewY = self.view.center.y - 150;
    self.replyView.backgroundColor = [UIColor whiteColor];
    //清楚多余的表
    [self clearExtraLine:self.tableview];
    
    //下载评分的类型
    [StatusTool statusToolGetScoreTypeWithCommunityID:self.community_id ForumID:self.forum_id Success:^(id object) {
        
        for (int i = 0; i<[object count]; i++) {
            [self.scoreTypeList addObject:[object objectAtIndex:i]];
        }
        starAmount = (int)[self.scoreTypeList count];
        
    } failurs:^(NSError *error) {
        //
    }];
    
    //注册通知 assessLabel
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabelText:) name:@"ChangeLabelTextNotification" object:nil];
    
}

-(void)changeLabelText:(NSNotification *)notification{
    
    id score = notification.object;
    mend_score = [score intValue];
    self.assessLabel.text = [self.scoreTypeList objectAtIndex:mend_score-1];
    
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
    [self.messageField resignFirstResponder];
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
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [self.operlist removeFromSuperview];
    self.operlist = nil;
    mend_menuHeight = 0;
    mend_count = 0;
    mend_imageHeight = 0;

}

- (void)keyboardWillShow:(NSNotification *)aNotification{

    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    id d = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [d doubleValue] ;
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.replyView.frame = CGRectMake(0, mend_screenHeight- keyboardRect.size.height - self.replyView.frame.size.height, self.replyView.frame.size.width, self.replyView.frame.size.height);
    [UIView commitAnimations];
    float assessViewBottom = mend_screenHeight - self.assessView.frame.size.height - self.assessView.frame.origin.y;
    float temp = assessViewBottom - keyboardRect.size.height;
    if (temp < 0) {
        [UIView animateWithDuration:0.25f animations:^{
            self.assessView.frame = CGRectMake(assessViewX, assessViewY+temp - 5, 300, 220);
        }];
    }
    
    

}
- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
     self.replyView.frame = CGRectMake(0, mend_screenHeight-self.replyView.frame.size.height, self.replyView.frame.size.width, self.replyView.frame.size.height);
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.25f animations:^{
        self.assessView.frame = CGRectMake(assessViewX, assessViewY, 300, 220);
    }];

}


#pragma mark-


-(void)loadPostInfo:(NSString *)postID{
    
        [StatusTool statusToolGetPostInfoWithPostID:postID Success:^(id object) {
            self.post_item = (postItem *)object;
            [self setData_2];
            [self.tableview reloadData];
            [self initUI];
            
            [self.hud hide:YES];
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
    self.post_text_4 = self.post_item.post_text_4;
    self.post_text_5 = self.post_item.post_text_5;
    self.post_text_1 = self.post_item.post_text_1;
    self.post_text_2 = self.post_item.post_text_2;
    self.post_text_3 = self.post_item.post_text_3;
    mend_imageHeight = 150;
    
    
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
    mend_menuHeight = 0;
    
    //判断是否允许回帖 lx 0529
    for(int i =0;i<[self.forum_item.ForumSetlist count];i++){
       forumSetItem  *forum_set_item = [forumSetItem createItemWitparametes:[self.forum_item.ForumSetlist objectAtIndex:i]];
        [self.forumSetArray addObject:forum_set_item];
    }
    for (int i = 0; i<[self.forumSetArray count]; i++) {
        forumSetItem *tempItem = [self.forumSetArray objectAtIndex:i];
        if ([tempItem.site_name isEqualToString:site_reply_user]) {
            if ([tempItem.site_value containsString:[NSString stringWithFormat:@"/%@%@",self.user_auth,@"/"]]) {
                isReply = true;
                break;
            }
        }
        
    }
    
    
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
    //是否可以回复
    if([self.post_overed isEqualToString:@"是"]||!isReply){
        self.replyContentField.enabled = NO;
        self.reply_btn.enabled = NO;
    }else{
        self.replyContentField.enabled = YES;
        self.reply_btn.enabled = YES;
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
    self.editbutton.frame = CGRectMake(25, 0, 100, 50);
    self.editbutton.titleLabel.frame = CGRectMake(25, 0, 100, 50);
    [self.editbutton setTitle:@"编辑" forState:UIControlStateNormal];
    self.editbutton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [self.editbutton addTarget:self action:@selector(EditPost) forControlEvents:UIControlEventTouchUpInside];
    [self.editbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //结束保修按钮
    self.endMendBtn = [[UIButton alloc]init];
    self.endMendBtn.frame = CGRectMake(25, 100, 100, 50);
    self.endMendBtn.titleLabel.frame = CGRectMake(25, 0, 100, 50);
    [self.endMendBtn setTitle: @"结束报修" forState: UIControlStateNormal];
    self.endMendBtn.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [self.endMendBtn addTarget:self action:@selector(endMend) forControlEvents:UIControlEventTouchUpInside];
    [self.endMendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //删除按钮
    self.delebutton = [[UIButton alloc]init];
    self.delebutton.frame = CGRectMake(25, 50, 100, 50);
    self.delebutton.titleLabel.frame = CGRectMake(25, 0, 100, 50);
    [self.delebutton setTitle:@"删除" forState:UIControlStateNormal];
    self.delebutton.titleLabel.font = [UIFont systemFontOfSize: 16.0];
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
    mend_menuHeight = 0;
    [self.postTitle setText:self.post_title];
    if(![self.reply_num isEqualToString:@""]){
        [self.replyNum setText:self.reply_num];
    }else{
        [self.replyNum setText:@"0"];
    }
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
        self.endMendBtn.frame = CGRectMake(0, 50*mend_menuHeight, 100, 50);
        mend_menuHeight++;
    }
    //delete button
    if ([self.user_auth containsString:@"/系统管理员/"] || [self.moderator_of_forum_list containsObject:self.forum_id] || [self.user_id isEqualToString:self.poster_id]) {
        [self.operlist addSubview:self.delebutton];
        self.delebutton.frame = CGRectMake(25, 50*mend_menuHeight, 50, 50);
        mend_menuHeight++;
    }
    self.operlist.frame = CGRectMake(self.view.frame.size.width-100, 0, 100, 50*mend_menuHeight);
    //postdetailmenu显示情况
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.moderator_of_forum_list = [defaults objectForKey:@"moderator_of_forum_list"];
    self.user_auth =[defaults objectForKey:@"UserPermission"];
    self.user_id = [defaults objectForKey:@"UserID"];
    if(![self.user_auth isEqualToString:@""]){
        if([self.moderator_of_forum_list containsObject:self.forum_id] ||[self.user_auth containsString:@"/系统管理员/"] || ([self.user_id isEqualToString:self.poster_id] &&![self.post_overed isEqualToString:@"是"]) ){
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


-(void)endMend{
    self.replyView.hidden = YES;
    [self.operlist removeFromSuperview];
    
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
    [UIView animateWithDuration:0.3 animations:^{
        self.assessView.alpha = 1;
        self.assessView.frame = CGRectMake(assessViewX, assessViewY, 300, 220);
        [self.assessView.layer setCornerRadius:self.assessView.frame.size.height/20];
    }];
    [self.view addSubview:self.assessView];
    
    //推送
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 30)];
    title.text = @"结束报修";
    title.textColor = [UIColor redColor];
    title.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18];
    [self.assessView addSubview:title];
    //红线1
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 300, 2)];
    [vi setBackgroundColor:[UIColor redColor]];
    [self.assessView  addSubview:vi];
    
    //第一行文字
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 70)];
    tlabel.text = @"请为本次报修打分:";
    tlabel.adjustsFontSizeToFitWidth = YES;
    tlabel.textAlignment = NSTextAlignmentLeft;
    tlabel.lineBreakMode = UILineBreakModeWordWrap;
    tlabel.numberOfLines = 0;
    tlabel.textColor = [UIColor grayColor];
    tlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17];
    [self.assessView addSubview:tlabel];
    
    //第一行评价语句
    self.assessLabel = [[UILabel alloc]initWithFrame:CGRectMake(tlabel.frame.origin.x+tlabel.frame.size.width+15, 65, 130, 15)];
    self.assessLabel.text = @"非常满意";
    self.assessLabel.textColor = [UIColor grayColor];
    self.assessLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.assessView addSubview:self.assessLabel];
    
    //星星
    self.ratingBar = [[RatingBar alloc] initWithFrame:CGRectMake(tlabel.frame.origin.x+tlabel.frame.size.width-16, self.assessLabel.frame.origin.y+self.assessLabel.frame.size.height, 180, 35) WithStarAmount:starAmount];
    self.ratingBar.starNumber = starAmount;
    [self.assessView addSubview:self.ratingBar];
    
    //红线2
    UIView *vii = [[UIView alloc]initWithFrame:CGRectMake(0, self.ratingBar.frame.origin.y+self.ratingBar.frame.size.height+5, 300, 1)];
    [vii setBackgroundColor:[UIColor lightGrayColor]];
    vii.alpha = 0.7;
    [self.assessView  addSubview:vii];
    
    //第二行文字
    UILabel *flabel = [[UILabel alloc]initWithFrame:CGRectMake(10, vii.frame.origin.y+vii.frame.size.height+13, 100, 35)];
    flabel.text = @"请给我们留言:";
    flabel.textAlignment = UITextAlignmentLeft;
    flabel.numberOfLines = 0;
    flabel.lineBreakMode = UILineBreakModeWordWrap;
    flabel.textColor = [UIColor grayColor];
    flabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:17];
    [self.assessView addSubview:flabel];
    //留言文本框
    self.messageField = [[UITextField alloc]init];
    self.messageField.frame = CGRectMake(flabel.frame.origin.x+flabel.frame.size.width, flabel.frame.origin.y, 180, 30);
    self.messageField.delegate = self;
    [self.messageField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    // messageField.backgroundColor = [UIColor lightGrayColor];
    [self.assessView addSubview:self.messageField];
    //留言框黑线
    UIView *textLine = [[UIView alloc]initWithFrame:CGRectMake(flabel.frame.origin.x+flabel.frame.size.width, self.messageField.frame.origin.y+self.messageField.frame.size.height+5, 180, 0.5)];
    [textLine setBackgroundColor:[UIColor blackColor]];
    [self.assessView  addSubview:textLine];
    
    //红线3
    UIView *viii = [[UIView alloc]initWithFrame:CGRectMake(0, flabel.frame.origin.y+flabel.frame.size.height+10, 300, 1)];
    [viii setBackgroundColor:[UIColor lightGrayColor]];
    viii.alpha = 0.7;
    [self.assessView  addSubview:viii];
    
    //按钮
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn .frame = CGRectMake(10, viii.frame.origin.y+viii.frame.size.height+5, 135, 30);
    [sureBtn setTitle: @"确定" forState: UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor lightGrayColor];
    sureBtn.alpha = 0.8;
    [sureBtn.layer setMasksToBounds:YES];
    [sureBtn.layer setCornerRadius:5.0];
    [sureBtn addTarget:self action:@selector(assessAndClose) forControlEvents:UIControlEventTouchUpInside];
    [self.assessView addSubview:sureBtn];
    UIButton *cancelBtn = [[UIButton alloc]init];
    cancelBtn.frame = CGRectMake(sureBtn.frame.origin.x+sureBtn.frame.size.width+10, viii.frame.origin.y+viii.frame.size.height+5, 135, 30);
    [cancelBtn setTitle: @"取消" forState: UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor lightGrayColor];
    cancelBtn.alpha = 0.8;
    [cancelBtn.layer setMasksToBounds:YES];
    [cancelBtn.layer setCornerRadius:5.0];
    [cancelBtn addTarget:self action:@selector(justClose) forControlEvents:UIControlEventTouchUpInside];
    [self.assessView addSubview:cancelBtn];
    
}


-(void)textFieldEditChanged:(UITextField *)textField{
    
    self.evaluateStr = textField.text;
}


-(void)assessAndClose{
    //发送评分
    [StatusTool statusToolPostMendScoreWithPostID:self.post_id User_ID:self.user_id Score:[NSString stringWithFormat:@"%d",mend_score] Evaluate:self.evaluateStr Success:^(id object) {
        if (![[object valueForKey:@"status"] isEqualToString:@""]) {
            //不可回复 lx
            self.reply_btn.enabled = NO;
            self.replyContentField.enabled = NO;
            [self justClose];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failurs:^(NSError *error){
        
    }];
    
}
-(void)justClose{
    self.replyView.hidden = NO;
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
    //通过UIViewController+Create扩展方法创建FourViewController的实例对象
    //传值
    if ([self.forum_item.forum_name containsString:@"投诉"]) {
        PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];
        PEVC.ED_FLAG = @"2";//编辑帖子
        PEVC.post_item = self.post_item;//帖子详情
        PEVC.forum_item = _forum_item;
        [self.navigationController pushViewController:PEVC animated:YES];

    }else{
        NewPostEditViewController *NPEVC = [[NewPostEditViewController alloc]initWithNibName:@"NewPostEditViewController" bundle:nil];
        NPEVC.ED_FLAG = @"2";
        NPEVC.post_item = self.post_item;
        NPEVC.forum_item = _forum_item;
        [self.navigationController pushViewController:NPEVC animated:YES];
    }
   
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
            
            //0527 lx
            [self.navigationController popViewControllerAnimated:YES];
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
//-(void)setupRefreshing{
//    [self.tableview addHeaderWithTarget:self action:@selector(headerRefreshing)];
//    [self.tableview addFooterWithTarget:self action:@selector(footerRefreshing)];
//}
//
//-(void)headerRefreshing{//下拉
//    mend_page_filter = 1;
//    mend_reply_page =1;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int16_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self loadReplyListData];
//        [self.tableview headerEndRefreshing];
//    });
//}
//
//-(void)footerRefreshing{//上拉
//    mend_page_filter = 2;
//    mend_reply_page++;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int16_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self loadReplyListData];
//        [self.tableview footerEndRefreshing];
//    });
//    
//}
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
                //用来滚回tableview底部
                if(reply_flag ==1){
                    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.replyListArray.count+8)-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }

                
            }else {
               
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
        [StatusTool statusToolPostReplyWithReplyText:self.replyContentField.text CommunityID:self.post_item.belong_community_id ForumID:self.post_item.belong_forum_id PostID:self.post_item.post_id UserID:[defaults valueForKey:@"UserID"] Date:curDate ReplyID:[self genUUID] Success:^(id object) {
            self.replyContentField.text =  @"";
            if (object != nil) {
                //回复数+1
                int num = [self.reply_num intValue];
                num=num+1;
                self.reply_num = [NSString stringWithFormat:@"%d",num];
                self.replyNum.text = self.reply_num;
                reply_flag = 1;
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

#pragma mark -----------------------------点击屏幕别处收起键盘-----------------------
- (IBAction)ViewTouchDown:(id)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


@end
