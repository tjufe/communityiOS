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
#import "PostEditViewController.h"
#import "UIViewController+Create.h"
#import "PostListViewController.h"
#import "UIImageView+WebCache.h"//加载图片
#import "StatusTool.h"
#import "deletepostItem.h"



@interface PostDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PostListViewControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *post_reply_num;
@property (weak, nonatomic) IBOutlet UIButton *SendButton;

@property (weak, nonatomic) IBOutlet UIView *TitleRect;
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UITextView *reply_text;

@property (weak, nonatomic) IBOutlet UIImageView *PosterImage;
@property (strong, nonatomic) IBOutlet UIView *operlist;

@property (weak, nonatomic) IBOutlet UILabel *forumlabel;

@property(strong,nonatomic)postItem *post_item ;
@property (strong,nonatomic) NSString *HeadPortraitUrl;//当前用户头像
@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
@property (strong,nonatomic) NSString *UserID;//当前用户id
@property (strong,nonatomic) NSString *AccountStatus;//当前用户账号状态
@property (strong,nonatomic) NSArray *moderator_of_forum_list;//版块版主信息

@property (weak,nonatomic) deletepostItem *delete;




@end

@implementation PostDetailViewController
//int count=0;//用于菜单点击计数

int alert = 0;//用于警告框UIAlertView计数

bool alertcount=false;//用于菜单点击计数

float cellheight;

bool isModerator = NO;//是否是版主


#pragma mark------下方快速回复
- (IBAction)SendOnClick:(id)sender {
    
    PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];//通过UIViewController+Create扩展方法创建FourViewController的实例对象
    [self.navigationController pushViewController:PEVC animated:YES];
    
    
}


//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if(textView==self.reply_text){
//      //  [textView resignFirstResponder];
//      //  NSLog(@"^^^^^^^asx");
//       [self.SendButton setTitle:@"快速回复" forState:UIControlStateNormal];
//    }
//    
//}
#pragma mark------当点击view的区域就会触发这个事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  //  [self.reply_text resignFirstResponder];
    [self.view endEditing:YES];
    
}

#pragma mark------textview协议，当textview获取焦点，回复按钮text改变
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.SendButton setTitle:@"快速回复" forState:UIControlStateNormal];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if(![textView.text isEqualToString:@""]){
    [self.SendButton setTitle:@"发送" forState:UIControlStateNormal];
    }
    if ([textView.text isEqualToString:@""]) {
        [self.SendButton setTitle:@"查看回复" forState:UIControlStateNormal];
        
    }
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row== 0 ) {
        PosterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"PosterTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            //date
            if(self.post_item.post_date!=nil){
            cell.postDate.text = [self.post_item.post_date substringToIndex:16];
        
            }
            //nickname
            cell.poster_nickname.text = self.post_item.poster_nickname;
            //HeadPortraitUrl
            if(self.post_item.poster_head==nil || [self.post_item.poster_head isEqualToString:@"''"] ){
                self.post_item.poster_head=@"";
            }
            
            if(![self.post_item.poster_head isEqualToString:@""]){
                NSString *url = [NSString stringWithFormat:@"%@%@%@%@",URL_SERVICE,HEAD_PIC_PATH,@"/",self.post_item.poster_head];
                
                [cell.poster_img sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    cell.poster_img.image = image;
                    
                }];

            }else{
               
                    cell.poster_img.image = [UIImage imageNamed:@"默认小头像"];
                }
            cell.poster_img.contentMode=UIViewContentModeScaleAspectFill;
            cell.poster_img.layer.masksToBounds = YES;
            [cell.poster_img.layer setCornerRadius:cell.poster_img.layer.frame.size.height/2];
            
//            //用户认证标志
//            if([self.UserPermission isEqualToString:@"认证用户"]){
//                cell.poster_status.hidden = NO;
//            }else{
//                cell.poster_status.hidden = YES;
//            }
            
        }
        
        return cell;
    }else if(indexPath.row == 1){
            PostTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"PostTextTableViewCell" owner:nil options:nil]objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellheight = cell.Text.frame.size.height;
            }
            if(self.post_item.post_text!=nil){
                cell.Text.text = self.post_item.post_text;
            }else{
                cell.Text.text=@"";
            }
            return cell;

        }else{
            PostImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"PostImageTableViewCell" owner:nil options:nil]objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //加载图片
            if(self.post_item.main_image_url!=nil&&![self.post_item.main_image_url isEqualToString:@"''"]){
                NSString *url = [NSString stringWithFormat:@"%@%@%@%@",URL_SERVICE,TOPIC_PIC_PATH,@"/",self.post_item.main_image_url];
                cell.MainImage.hidden = NO;
                [cell.MainImage sd_setImageWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    cell.MainImage.image = image;
                    }];
            }else{
                cell.MainImage.hidden = NO;
            }
                
            cell.MainImage.contentMode=UIViewContentModeScaleAspectFill;
            
            return cell;
        }
    
    
    }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        return 100;
    }else if(indexPath.row ==1){
        return cellheight;
    }else{
        return 150;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
}
    

-(void)setTitleRect:(UIView *)TitleRect{
    TitleRect.layer.masksToBounds = YES;
    [TitleRect.layer setCornerRadius:TitleRect.frame.size.height/3];
    
    
}
//-(void)setSendButton:(UIButton *)SendButton{
//    SendButton.layer.masksToBounds = YES;
//    [SendButton.layer setCornerRadius:SendButton.frame.size.height/6];
//
//}
-(void)setForumlabel:(UILabel *)forumlabel{
    
    
    [forumlabel setText:_forum_item.forum_name];
    forumlabel.layer.masksToBounds = YES;
    [forumlabel.layer setCornerRadius:forumlabel.layer.frame.size.height/3];

}
-(void)setPosterImage:(UIImageView *)PosterImage{
    PosterImage.layer.masksToBounds = YES;
    [PosterImage.layer setCornerRadius:PosterImage.layer.frame.size.height/4];

}

#pragma mark------实现PostListViewControllerDelegate
-(void)addpostItem:(postItem *)PostItem{
    self.post_item = PostItem;
    
}

- (void)viewDidLoad {
//    self.scrollview.frame.size.width = self.view.frame.size.width;
    [super viewDidLoad];
    
    //获取当前用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.UserID =[defaults objectForKey:@"UserID"];
    self.UserPermission = [defaults objectForKey:@"UserPermission"];
    self.AccountStatus = [defaults objectForKey:@"AccountStatus"];
    self.HeadPortraitUrl = [defaults objectForKey:@"HeadPortraitUrl"];
    self.moderator_of_forum_list = [defaults objectForKey:@"moderator_of_forum_list"];
    
    //判断用户是否是版主
    for(int m=0;m<[self.moderator_of_forum_list count];m++){
        NSString *mod = [self.moderator_of_forum_list objectAtIndex:m];
        if ([mod isEqualToString:self.post_item.belong_forum_id]) {
            isModerator = YES;
        }
    }
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划线
    
    self.navigationItem.title = @"话题";
       UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    self.reply_text.delegate = self;
    
    //sendbutton设置
    self.SendButton.layer.masksToBounds = YES;
    [self.SendButton.layer setCornerRadius:self.SendButton.frame.size.height/6];

    //界面赋值
    //title
    [self.postTitle setText:self.post_item.title];
    
    //评论数
    NSString *ns = [[NSString alloc]init];
    ns = @"评论(";
 //   if(![_reply_num isKindOfClass:[NSNull class]]){
 //   if(![_reply_num isEqualToString:@""]){
    if (![self.post_item.reply_num isEqualToString:@""]) {
        ns = [ns stringByAppendingString:self.post_item.reply_num];
        ns = [ns stringByAppendingString:@")"];
    }else{
        ns = @"评论(暂无)";
    }
    [self.post_reply_num setText:ns];
    
    //下方回复框当前用户头像
    if(self.HeadPortraitUrl!=nil){
        [self.user_img sd_setImageWithURL:[NSURL URLWithString:self.HeadPortraitUrl] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.user_img.image = image;
            
        }];
        
    }
    self.user_img.layer.masksToBounds = YES;
    [self.user_img.layer setCornerRadius:self.user_img.layer.frame.size.height/2];

    //刷新table数据
    [self.tableview reloadData];

    //设置导航右侧按钮

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"菜单"];
    
    button.frame = CGRectMake(self.view.frame.size.width-30, 20, 20, 5);
    
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    // 让按钮图片右移15
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Operation) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //判断用户身份来决定是否显示菜单
    if (![self.UserPermission isEqualToString:@""]&&[self.AccountStatus isEqualToString:@"正常"]){
        if([self.UserID isEqualToString:self.post_item.poster_id]||[self.UserPermission isEqualToString:@"管理员"]||isModerator) {
    self.navigationItem.rightBarButtonItem = rightItem;
    }
    }
    
    //添加单击手势
//    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
//    tgr.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tgr];
   // [self.tableview addGestureRecognizer:tgr];
   
}

#pragma mark------单击方法，单击空白处，textview失去焦点
-(void)handleSingleTap:(UITapGestureRecognizer*)gestureRecognizer{
    [self.reply_text resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-------右上角菜单
-(void)Operation{
//    if(count % 2!=0){
//        count++;
    if(alertcount){
        alertcount = false;
        self.operlist.hidden = YES;
    }else{
    self.operlist = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 100, 150)];
    self.operlist.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.operlist.alpha=0;
    [UIView animateWithDuration:0.5 animations:^{
        self.operlist.frame = CGRectMake(self.view.frame.size.width-100, 60, 100, 150);
        self.operlist.alpha = 1;
    }];
    [self.view addSubview:self.operlist];
    //编辑按钮
    //楼主可编辑
    if([self.UserID isEqualToString:self.post_item.poster_id]){

    UIButton * editbutton = [[UIButton alloc]init];
    editbutton.frame = CGRectMake(25, 0, 50, 50);
    [editbutton setTitle:@"编辑" forState:UIControlStateNormal];
    [editbutton addTarget:self action:@selector(EditPost) forControlEvents:UIControlEventTouchUpInside];
    [editbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.operlist addSubview:editbutton];
    }
    
    //删除按钮
    //楼主、版主和管理员显示删除按钮
    if([self.UserID isEqualToString:self.post_item.poster_id]||[self.UserPermission rangeOfString:@"管理员"].location!=NSNotFound||isModerator){
    UIButton * delebutton = [[UIButton alloc]init];
    delebutton.frame = CGRectMake(25, 50, 50, 50);
    [delebutton setTitle:@"删除" forState:UIControlStateNormal];
    [delebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [delebutton addTarget:self action:@selector(DelePost) forControlEvents:UIControlEventTouchUpInside];
    [self.operlist addSubview:delebutton];
    }
        
        
    //置顶按钮
    //版主和管理员显示置顶按钮
    if([self.UserPermission rangeOfString:@"管理员"].location!=NSNotFound||isModerator){
    UIButton * settopbutton = [[UIButton alloc]init];
    settopbutton.frame = CGRectMake(25, 100, 50, 50);
    
    [settopbutton setTitle:@"置顶" forState:UIControlStateNormal];
    [settopbutton addTarget:self action:@selector(Settop) forControlEvents:UIControlEventTouchUpInside];
    [settopbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.operlist addSubview:settopbutton];
    }
        alertcount = true;
      //  count++;
    }
    
}
#pragma mark--------菜单中编辑帖子
-(void)EditPost{
//    count++;
    alertcount = false;
    PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];
    //通过UIViewController+Create扩展方法创建FourViewController的实例对象
    //传值
    PEVC.ED_FLAG = @"2";//编辑帖子
    PEVC.post_item = self.post_item;//帖子详情
    PEVC.forum_item = _forum_item;
    
    [self.navigationController pushViewController:PEVC animated:YES];
    [self.operlist removeFromSuperview];
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
        PostListViewController *PLVC=[PostListViewController createFromStoryboardName:@"PostList" withIdentifier:@"PostListID"];
            PLVC.forum_item = _forum_item;
            
        [self.navigationController pushViewController:PLVC animated:YES];
        }
    }
}

#pragma mark------删除帖子操作
-(void)deletePost{
    
    [StatusTool statusToolDeletePostWithpostID:self.post_item.post_id deleteUserID:self.UserID communityID:self.post_item.belong_community_id fourmID:self.post_item.belong_forum_id Success:^(id object) {
        
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

#pragma mark------菜单中置顶帖子
-(void)Settop{
    alertcount = false;
    //count++;
     [self.operlist removeFromSuperview];
}


-(void)setReply_text:(UITextView *)reply_text{
    
    
    reply_text.layer.masksToBounds = YES;
    [reply_text.layer setCornerRadius:reply_text.layer.frame.size.height/8];

    }

@end
