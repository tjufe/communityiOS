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
#import "ViewController.h"
#import "StatusTool.h"
#import "postListItem.h"
#import "UIImageView+WebCache.h"//加载图片
#import "postInfoItem.h"
#import "PostEditViewController.h"
#import "forumSetItem.h"
#import "uncheckPostListItem.h"
#import "MJRefresh.h"//用于列表下拉刷新第三方集成控件
#import "MBProgressHUD.h" //刷新的进度条

#import "APIAddress.h"

#import "NewPostEditViewController.h"
#import "PostMendDetailViewController.h"



@interface PostListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *postTitleData;  //表格数据
    NSMutableArray *postImageData;
    NSMutableArray *postDateData;
    NSMutableArray *postSetTopData;
    
}
//@property (weak, nonatomic) IBOutlet UINavigationBar *ForumName;
@property (weak, nonatomic) IBOutlet UITableView *pltable;
@property(strong,nonatomic)postItem *pitem;
@property(strong,nonatomic)NSMutableArray *PostListArray;
@property (strong,nonatomic) postInfoItem *post_info_item;

@property(strong,nonatomic)postListItem *post_list_item;
@property(strong,nonatomic)uncheckPostListItem *uncheck_post_list_item;//待审核帖子列表
@property (strong,nonatomic) NSMutableArray *postinfo;
@property (strong,nonatomic) forumSetItem *forum_set_item;//版块设置
@property (strong,nonatomic) NSMutableArray *Poster_Nic_Array;//发帖人昵称数组
@property (strong,nonatomic) NSMutableArray *Poster_Apply_Array;//帖子报名数数组
@property (strong,nonatomic) NSMutableArray *Post_Rpply_Array;//帖子评论数
@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
@property (strong,nonatomic) NSString *UserID;//当前用户id
@property (strong,nonatomic) NSString *AccountStatus;//当前用户账号状态
@property (strong,nonatomic) NSArray *moderator;//版主版号
@property (strong,nonatomic) NSString *forumID;
@property (strong,nonatomic) NSString *communityID;
@property (strong,nonatomic) NSMutableArray *checked_forum_id;//审核请求需要的版块号列表
@property (strong,nonatomic) NSNumber *Page;
@property (strong,nonatomic) NSNumber *Rows;

@property (strong,nonatomic)NSString *ISNEWPOST;
@property (weak,nonatomic)NSString *ISApply;
@property (weak,nonatomic)NSString *ISReply;
@property (weak,nonatomic)NSString *ISBrowse;//是否可以浏览
@property (strong,nonatomic) NSMutableArray *Apply;
@property (strong,nonatomic) NSMutableArray *Reply;

@end


//NSString * const TOPIC_PIC_PATH = @"topicpic";
//NSString * const HEAD_PIC_PATH = @"uploadimg";
//NSString * const URL_SERVICE = @"http://192.168.28.211/sq/";



@implementation PostListViewController


NSInteger page ;//页数
NSInteger rows ;//分页请求行数
NSInteger page_filter;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  self.PostListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell =[[[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
     NSString *title =[postTitleData objectAtIndex:indexPath.row];
//     if(title.length > 7){//过长时截取
//          title =[title substringToIndex:7];
//          title = [title stringByAppendingString:@"…"];
//       cell.PostLabel.text = title;//title
//     }else{
         cell.PostLabel.text = title;
//     }
    cell.postDate.text = [postDateData objectAtIndex:indexPath.row];//date

     NSString *nic = [self.Poster_Nic_Array objectAtIndex:indexPath.row];
     if(nic.length > 7){//过长时截取
          nic =[nic substringToIndex:7];
          nic = [nic stringByAppendingString:@"…"];
          cell.poster_nic.text = nic;//nickname
     }else{
          cell.poster_nic.text = nic;
     }
     //reply
     if([_filter_flag isEqualToString:@"全部"]){
     if([self.ISReply isEqualToString:@"Y"]){
    cell.post_reply_num.text = [self.Post_Rpply_Array objectAtIndex:indexPath.row];
     }else{
          cell.post_reply_num.hidden = YES;
          cell.img_reply.hidden = YES;
          cell.dot_reply.hidden = YES;
     }
     }else{
          if([[self.Reply objectAtIndex:indexPath.row]isEqualToString:@"Y"]){
               cell.post_reply_num.text = [self.Post_Rpply_Array objectAtIndex:indexPath.row];
          }else{
               cell.post_reply_num.hidden = YES;
               cell.img_reply.hidden = YES;
               cell.dot_reply.hidden = YES;
          }

     }
     //apply
//     if(self.PostListArray){
     postItem *p = [self.PostListArray objectAtIndex:indexPath.row];
     if([_filter_flag isEqualToString:@"全部"]){
     if([self.ISApply isEqualToString:@"Y"]&&[p.open_apply isEqualToString:@"是"]){
          if(![[self.Poster_Apply_Array objectAtIndex:indexPath.row] isEqualToString:@"0"]){
          
          cell.post_apply_num.text = [self.Poster_Apply_Array objectAtIndex:indexPath.row];
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
     }else{
          if([[self.Apply objectAtIndex:indexPath.row]isEqualToString:@"Y"]&&
             [p.open_apply isEqualToString:@"是"]){
               if(![[self.Poster_Apply_Array objectAtIndex:indexPath.row] isEqualToString:@"0"]){
                    
                    cell.post_apply_num.text = [self.Poster_Apply_Array objectAtIndex:indexPath.row];
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
  
          
     }
          //是否置顶&&审核
          
          if([p.need_check isEqualToString:@"是"]&&[p.checked isEqualToString:@"否"]){
               cell.setTop.image = [UIImage imageNamed:@"待审核"];
          }
          else if ([p.set_top isEqualToString:@"是"]){
               cell.setTop.hidden = NO;
          }
          else{
               cell.setTop.hidden = YES;
          }

//     }
    // if([reply_num isKindOfClass:[NSNull class]]){
   // if([reply_num isEqualToString:@""]){
//     if(reply_num ==nil){
//          cell.post_reply_num.text = @"暂无";
//     }else{
//          cell.post_reply_num.text = reply_num;//reply_num
//
//     }
     
    //加载图片
    NSString* URL=[[NSString alloc]init];
    URL =[postImageData objectAtIndex:indexPath.row];

    NSString *img_url = [NSString stringWithFormat:@"%@%@",API_TOPIC_PIC_PATH,URL];

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
    
    
//    NSString *SP = [[NSString alloc]init];
//    SP = [postSetTopData objectAtIndex:indexPath.row];
//    if([SP isEqualToString:@"是"]){
//        cell.setTop.hidden = NO;
//    }else{
//        cell.setTop.hidden = YES;
//    }

    return cell;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//3绘制行高
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     
     if ([self.forum_item.display_type isEqualToString:@"纵向"]) {
          _PostItem = [self.PostListArray objectAtIndex:indexPath.row];
          PostDetailViewController *PDVC = [ PostDetailViewController createFromStoryboardName:@"PostDetailStoryboard" withIdentifier:@"postDetail"];
          //全局变量传值
          PDVC.forum_item = _forum_item;
          PDVC.forumList = _forumlist;
          //协议实现页面传值
          self.delegate = PDVC;
          if ([self.delegate
               respondsToSelector:@selector(addpostItem:)]) {
               [self.delegate addpostItem:_PostItem];
          }
          [self.navigationController pushViewController:PDVC animated:YES];
     }else{
          _PostItem = [self.PostListArray objectAtIndex:indexPath.row];
          PostMendDetailViewController *PDVC = [ PostMendDetailViewController createFromStoryboardName:@"PostMendDetail" withIdentifier:@"postMendDetail"];
          //全局变量传值
          PDVC.forum_item = _forum_item;
          PDVC.forumList = _forumlist;
          //协议实现页面传值
          self.delegate = PDVC;
          if ([self.delegate
               respondsToSelector:@selector(addpostItem:)]) {
               [self.delegate addpostItem:_PostItem];
          }
          [self.navigationController pushViewController:PDVC animated:YES];

     }
     
}


#pragma mark----下拉刷新
-(void)headerRereshing{
     page_filter=1;
//     page--;
//     if(page<=0){
//          page = 1;
//     }
     page=1;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 //         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
          if([_filter_flag isEqualToString:@"待审核"]){
               [self loadData2];
          }else{
               [self loadData];
          }
          // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
          [self.pltable headerEndRefreshing];
     });

}

#pragma mark----上拉刷新
-(void)footerRereshing{
     
     page_filter = 2;
     page++;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//          [MBProgressHUD showHUDAddedTo:self.view animated:YES];
          if([_filter_flag isEqualToString:@"待审核"]){
               [self loadData2];
          }else{
               [self loadData];
          }
          
          // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
          [self.pltable footerEndRefreshing];
     });

}

-(void)setupRefresh{
     //下拉刷新
     [self.pltable  addHeaderWithTarget:self  action:@selector(headerRereshing)];
     //waring自动刷新
  //   [self.pltable headerBeginRefreshing];
     //上拉加载更多
     [self.pltable addFooterWithTarget:self action:@selector(footerRereshing)];
}



#pragma mark-----视图切换回pop该页调用
-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:(BOOL)animated];
     page =1;
     rows = 5;
     page_filter = 0;
     [self.PostListArray removeAllObjects];
     [postDateData removeAllObjects];
     [postImageData removeAllObjects];
     [postTitleData removeAllObjects];
     [postSetTopData removeAllObjects];
     [self.Poster_Apply_Array removeAllObjects];
     [self.Poster_Nic_Array removeAllObjects];
     [self.Post_Rpply_Array removeAllObjects];
     [self.Apply removeAllObjects];
     [self.Reply removeAllObjects];
     
     if(![_filter_flag isEqualToString:@"待审核"]){
          
          [self loadData];
     }else{
          [self loadData2];
     }
     
}


- (void)viewDidLoad {
    [super viewDidLoad];
 //    page =1;
 //    rows = 5;
 //    page_filter = 0;
     //去除多余的线
     [self clearExtraLine:self.pltable];
     
     //获取当前用户信息
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     self.UserID =[defaults objectForKey:@"UserID"];
     self.UserPermission = [defaults objectForKey:@"UserPermission"];
     self.AccountStatus = [defaults objectForKey:@"AccountStatus"];
     self.moderator = [defaults objectForKey:@"moderator_of_forum_list"];
     self.communityID = [defaults objectForKey:@"CommunityID"];

     
     self.ISNEWPOST = @"N";
     self.ISReply = @"N";
     self.ISApply = @"N";
     self.ISBrowse = @"N";
     

     if(_forum_item!=nil&&[_filter_flag isEqualToString:@"全部"]){
          self.forumID = _forum_item.forum_id;
     }else if([_filter_flag isEqualToString:@"我发起的"]){
          self.forumID = @"";
     }else{//待审核，判断版主的版块id
          self.checked_forum_id = [[NSMutableArray alloc]init];
          if([self.UserPermission rangeOfString:@"管理员"].location!=NSNotFound){
               for(int i=0;i<[_forumlist count];i++){
                    forumItem *fitem = [_forumlist objectAtIndex:i];
                    [self.checked_forum_id addObject:fitem.forum_id];
               }
          }else if([self.moderator count]!=0){//版主
               for(int i=0;i<[self.moderator count];i++){
                    [self.checked_forum_id addObject:
                        [self.moderator objectAtIndex:i]];
               }
          }
     }
//     bool status_auth = NO;//是否认证用户
//     bool status_admin = NO;//管理员
//     bool status_normal = NO;//普通用户
//     if ([self.UserPermission rangeOfString:@"认证用户"].location!=NSNotFound) {
//          status_auth =YES;
//     }
//     if ([self.UserPermission rangeOfString:@"管理员"].location!=NSNotFound) {
//          status_admin = YES;
//     }
//     if([self.UserPermission rangeOfString:@"普通用户"].location!=NSNotFound) {
//          status_normal = YES;
//     }



     
     
   //使下一页的导航栏左边没有文字
    UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    //本导航栏题目
     if([_filter_flag isEqualToString:@"全部"]){
         self.navigationItem.title = _forum_item.forum_name;
     }else if ([_filter_flag isEqualToString:@"我发起的"]){
         self.navigationItem.title = @"我的话题";
     }else{
          self.navigationItem.title = @"待审核话题";
     }

    //try nav button fail
//    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [rightbutton setTitle:@"aaa" forState:UIControlStateNormal];
//    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
//    self.navigationItem.rightBarButtonItem = rightItem;
     


     //               if([self.forum_set_item.site_name isEqualToString:site_newpost_user]&&[self.forum_set_item.site_value rangeOfString:@"普通用户"].location!=NSNotFound){

//                    if (status_normal) {
//                         self.ISNEWPOST = @"Y";
//                    }
//               }
//          if([self.forum_set_item.site_name isEqualToString:site_newpost_user]&&[self.forum_set_item.site_value rangeOfString:@"认证用户"].location!=NSNotFound){
//               if (status_auth) {
//                    self.ISNEWPOST = @"Y";
//               }
//          }
//          if([self.forum_set_item.site_name isEqualToString:site_newpost_user]&&[self.forum_set_item.site_value rangeOfString:@"管理员"].location!=NSNotFound){
//               if (status_admin) {
//                    self.ISNEWPOST = @"Y";
//               }
//          }

//


    //设置导航右侧按钮
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"icon_main_add"];
    
    button.frame = CGRectMake(self.view.frame.size.width-30, 20, 20, 20);
    
    // 这里需要注意：由于是想让图片右移，所以left需要设置为正，right需要设置为负。正在是相反的。
    // 让按钮图片右移15
    //    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(NewPost) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
     
     //判断用户身份来决定是否显示发帖图标（我发起的和待审核的都不显示发帖图标）
     
     if([_filter_flag isEqualToString:@"全部"]){
     

           [self check];

     
     if (![self.UserPermission isEqualToString:@""]&&[self.ISNEWPOST isEqualToString:@"Y"]&&[self.AccountStatus isEqualToString:@"正常"]) {
          
    
          self.navigationItem.rightBarButtonItem = rightItem;

     }
     }
     
    postTitleData = [[NSMutableArray alloc]init];
    postDateData = [[NSMutableArray alloc]init];
    postImageData = [[NSMutableArray alloc]init];
    postSetTopData = [[NSMutableArray alloc]init];

    self.postinfo = [[NSMutableArray alloc]init];
    self.Poster_Nic_Array = [[NSMutableArray alloc]init];
    self.Poster_Apply_Array = [[NSMutableArray alloc]init];
    self.Post_Rpply_Array =[[NSMutableArray alloc]init];
    self.PostListArray =[[NSMutableArray alloc]init];
    self.Apply = [[NSMutableArray alloc]init];
    self.Reply = [[NSMutableArray alloc]init];

    self.Page = [[NSNumber alloc]init];
    self.Rows = [[NSNumber alloc]init];
  
     [self setupRefresh];
     
    //请求数据
     
//     if(![_filter_flag isEqualToString:@"待审核"]){
//     
//          [self loadData];
//     }else{
//          [self loadData2];
//     }
   

    // Do any additional setup after loading the view.
}
#pragma mark-
#pragma mark--------------------去掉多余的线----------------------------
-(void)clearExtraLine:(UITableView *)tableView{
     UIView *view = [[UIView alloc]init];
     view.backgroundColor = [UIColor clearColor];
     [self.pltable setTableFooterView:view];
}
#pragma mark-


#pragma mark-----获取版块设置
-(void)check{
     //获取版块设置
     

     
     if([_filter_flag isEqualToString:@"全部"]){
         
          
          NSString *user_status = @"/";
          user_status = [user_status stringByAppendingString:self.UserPermission];
//          user_status = [user_status stringByAppendingString:self.UserPermission];
          if(_forum_item.ForumSetlist!=nil){
          for(int i=0;i < [_forum_item.ForumSetlist count];i++){
               self.forum_set_item  = [forumSetItem createItemWitparametes:[_forum_item.ForumSetlist objectAtIndex:i]];
               
               //能否发帖
               if ([self.forum_set_item.site_name isEqualToString:site_newpost_user]) {
                    
                    if([self.forum_set_item.site_value rangeOfString:user_status].location!=NSNotFound){
                         self.ISNEWPOST = @"Y";
                    //     break;
                    }
                    
                    //版主
                    else if(self.moderator!=nil){
                         for(int m=0;m<[self.moderator count];m++){
                              if([[self.moderator objectAtIndex:m] isEqualToString:_forum_item.forum_id]){
                                   self.ISNEWPOST = @"Y";
                     //              break;
                              }
                              
                         }
                    }
               }
               //能否回复
               if([self.forum_set_item.site_name isEqualToString:site_isreply]){
                    if([self.forum_set_item.site_value rangeOfString:@"是"].location!=NSNotFound){
                         self.ISReply = @"Y";
                    }else{
                         self.ISReply = @"N";
                    }
               }
               
               //能否报名
               if([self.forum_set_item.site_name isEqualToString:site_addapply]){
                    if([self.forum_set_item.site_value rangeOfString:@"是"].location!=NSNotFound){
                         self.ISApply = @"Y";
                    }else{
                         self.ISApply = @"N";
                    }

               }
             //能否查看
               if([self.forum_set_item.site_name isEqualToString:site_isbrowse]){
                    if([self.forum_set_item.site_value containsString:user_status]){
                         self.ISBrowse = @"Y";
                       //  break;
                    }
                   else if(self.moderator!=nil){
                         for(int m=0;m<[self.moderator count];m++){
                              if([[self.moderator objectAtIndex:m] isEqualToString:_forum_item.forum_id]){
                                   self.ISBrowse = @"Y";
                              //     break;
                              }
                              
                         }
                    }

                    
               }
          }
          }
     }

}

#pragma mark-------请求加载帖子列表数据(全部、我发起的)
-(void)loadData{
     self.Page = [NSNumber numberWithInteger:page];
     self.Rows = [NSNumber numberWithInteger:rows];

     [StatusTool statusToolGetPostListWithbfID:self.forumID bcID:self.communityID userID:self.UserID filter:_filter_flag page:self.Page rows:self.Rows Success:^(id object) {
        
        self.post_list_item = (postListItem *)object;
          if(page_filter==0){//刚开始第一次加载
                if(self.post_list_item.PostList!=nil){
                     [self getData];
                     [self.pltable reloadData];
                }else{

                 //    self.pltable.hidden = YES;//没有数据则隐藏table

                }
               
          }else{
               if(self.post_list_item.PostList!=nil){
                    if(page_filter==2){
                         [self getData];
                         //[self.pltable reloadData];
                    }else{
                         [self.PostListArray removeAllObjects];
                         [postDateData removeAllObjects];
                         [postImageData removeAllObjects];
                         [postTitleData removeAllObjects];
                         [postSetTopData removeAllObjects];
                         [self.Poster_Apply_Array removeAllObjects];
                         [self.Poster_Nic_Array removeAllObjects];
                         [self.Post_Rpply_Array removeAllObjects];
                         [self.Apply removeAllObjects];
                         [self.Reply removeAllObjects];
                         [self getData];
                        
                    }
                     [self.pltable reloadData];
               }else{
                    //刷新完成，已无更多
                    if(page_filter==2){
                         page--;
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
          }
          
          
          
          
          
//         if(self.post_list_item.PostList!=nil){
//        for (int i = 0; i < [self.post_list_item.PostList count]; i++) {
//             self.pitem = [postItem createItemWitparametes:[self.post_list_item.PostList objectAtIndex:i]];
//             [self.PostListArray addObject:self.pitem];
//             
//             //取title
//            if (self.pitem.title != nil){
//                [postTitleData addObject:self.pitem.title];
//            }else{
//                [postTitleData addObject:@""];
//            }
//             
//            //取date
//            if(self.pitem.post_date!=nil){
//                 //时间处理
//                  [self twoDateDistants:self.pitem.post_date];
//              
////                NSString *pdate=[[NSString alloc]init];
////
////               pdate=[self.pitem.post_date substringToIndex:16];//截取字符串
////               [postDateData addObject:pdate];
//            }else{
//                [postDateData addObject:@"00:00:00"];
//            }
//             
//            //取main_img_url
//            if(self.pitem.main_image_url!=nil){
//                [postImageData addObject:self.pitem.main_image_url];
//            }else{
//                [postImageData addObject:@""];
//            }
//            if(self.pitem.set_top!=nil){
//                [postSetTopData addObject:self.pitem.set_top];
//            }else{
//                [postSetTopData addObject:@""];
//            }
//             
//             //取nickname
//             if(self.pitem.poster_nickname!=nil){
//                  [self.Poster_Nic_Array addObject:self.pitem.poster_nickname];
//             }else{
//                  [self.Poster_Nic_Array addObject:@"游客"];
//             }
//             
//             //取poster_head_url
//             if(self.pitem.poster_head!=nil){
//                  [self.Poster_Img_Array addObject:self.pitem.poster_head];
//             }else{
//                  [self.Poster_Img_Array addObject:@""];
//             }
//             //取reply_num
//             if(![self.pitem.reply_num isEqualToString:@""]){
//                  [self.Post_Rpply_Array addObject:self.pitem.reply_num];
//             }else{
//                  [self.Post_Rpply_Array addObject:@"0"];
//             }
//             
//        }
        
         
//        [self.pltable reloadData];
//              
//         }else{
//              self.pltable.hidden = YES;//没有数据则隐藏table
//         }
          }failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
 //   [self.pltable reloadData];
}


#pragma mark--------加载table数据
-(void)getData{
     
     if(![_filter_flag isEqualToString:@"待审核"]){
     for (int i = 0; i < [self.post_list_item.PostList count]; i++) {
          self.pitem = [postItem createItemWitparametes:[self.post_list_item.PostList objectAtIndex:i]];
          if(page_filter==2){
               if(![self.PostListArray containsObject:self.pitem]){

                    if([_filter_flag isEqualToString:@"全部"]){
                         if([self.ISBrowse isEqualToString:@"N"]){
                         if([self.pitem.poster_id isEqualToString:self.UserID]||
                            [self.pitem.set_top isEqualToString:@"是"]){
                              [self.PostListArray addObject:self.pitem];
                              if(self.PostListArray){
                                   [self getData2];
                              }
                              
                         }
                         }else{
                             [self.PostListArray addObject:self.pitem];
                              if(self.PostListArray){
                                   [self getData2];
                              }

                         }
                     }else{
                         [self.PostListArray addObject:self.pitem];
                          if(self.PostListArray){
                               [self getData2];
                          }
                     }
               }
          }else{
               
               if([_filter_flag isEqualToString:@"全部"]){
                    if([self.ISBrowse isEqualToString:@"N"]){
                         if([self.pitem.poster_id isEqualToString:self.UserID]||
                            [self.pitem.set_top isEqualToString:@"是"]){
                              [self.PostListArray addObject:self.pitem];
                              if(self.PostListArray){
                                   [self getData2];
                              }
                         }
                    }else{
                         [self.PostListArray addObject:self.pitem];
                         if(self.PostListArray){
                              [self getData2];
                         }
                    }
               }else{
                    [self.PostListArray addObject:self.pitem];
                    if(self.PostListArray){
                         [self getData2];
                    }
               }
               
          }
     }
          

     }else{//待审核
          for (int i = 0; i < [self.uncheck_post_list_item.PostList count]; i++) {
               self.pitem = [postItem createItemWitparametes:[self.uncheck_post_list_item.PostList objectAtIndex:i]];
               if(page_filter==2){
                    if(![self.PostListArray containsObject:self.pitem]){
                         [self.PostListArray addObject:self.pitem];
                          [self getData2];
                    }
               }else{
                    [self.PostListArray addObject:self.pitem];
                    [self getData2];
               }
               
          }
         

     }
}

#pragma mark------分别加载个部分数据
-(void)getData2{
     
     
     
     //判断权限（我的话题）

     
     if([_filter_flag isEqualToString:@"我发起的"]){
          _forumlist=[ViewController getForumList];
          forumItem *f2;
          for(int m=0;m<[_forumlist count];m++){
               forumItem *f1 = [_forumlist objectAtIndex:m];
               if([self.pitem.belong_forum_id isEqualToString:f1.forum_id]){
                    f2 = f1;//找到所属版块
                   _forum_item = f1;
                    break;
               }
          }
          
     if(f2.ForumSetlist!=nil){
          for(int i=0;i<[f2.ForumSetlist count];i++){
               forumSetItem *fs = [forumSetItem createItemWitparametes:[f2.ForumSetlist objectAtIndex:i]];
               //能否回复
               if([fs.site_name isEqualToString:site_isreply]){
                    if([fs.site_value rangeOfString:@"是"].location!=NSNotFound){
                         [self.Reply addObject:@"Y"];
                    }else{
                         [self.Reply addObject:@"N"];
                    }
               }
               
               //能否报名
               if([fs.site_name isEqualToString:site_addapply]){
                    if([fs.site_value rangeOfString:@"是"].location!=NSNotFound){
                         [self.Apply addObject:@"Y"];
                    }
                    else{
                         [self.Apply addObject:@"N"];
                    }
                    
               }

          }
     }
     }
     
     
     
     

     //取title
    
          if (self.pitem.title != nil){
               [postTitleData addObject:self.pitem.title];
          }else{
               [postTitleData addObject:@""];
          }
     
     //取date
     if(self.pitem.post_date!=nil){
          //时间处理
          [self twoDateDistants:self.pitem.post_date];
          
          //                NSString *pdate=[[NSString alloc]init];
          //
          //               pdate=[self.pitem.post_date substringToIndex:16];//截取字符串
          //               [postDateData addObject:pdate];
     }else{
          [postDateData addObject:@"00:00:00"];
     }
     
     //取main_img_url
     if(self.pitem.main_image_url!=nil){
          [postImageData addObject:self.pitem.main_image_url];
     }else{
          [postImageData addObject:@""];
     }
     if(self.pitem.set_top!=nil){
          [postSetTopData addObject:self.pitem.set_top];
     }else{
          [postSetTopData addObject:@""];
     }
     
     //取nickname
     if(self.pitem.poster_nickname!=nil){
          [self.Poster_Nic_Array addObject:self.pitem.poster_nickname];
     }else{
          [self.Poster_Nic_Array addObject:@"游客"];
     }
     

     //取apply_num
     if(![self.pitem.apply_num isEqualToString:@""]&&![self.pitem.apply_num isEqualToString:@"''"]){
          [self.Poster_Apply_Array addObject:self.pitem.apply_num];
     }else{
          [self.Poster_Apply_Array addObject:@"0"];

     }
     //取reply_num
     if(![self.pitem.reply_num isEqualToString:@""]&&![self.pitem.reply_num isEqualToString:@"''"]){
          [self.Post_Rpply_Array addObject:self.pitem.reply_num];
     }else{
          [self.Post_Rpply_Array addObject:@"0"];
     }
  

}

#pragma mark--------请求加载帖子列表数据（待审核）
-(void)loadData2{
    
     self.Page = [NSNumber numberWithInteger:page];
     self.Rows = [NSNumber numberWithInteger:rows];
     [StatusTool statusToolGetUncheckPostListWithbfID:self.checked_forum_id bcID:self.communityID page:self.Page rows:self.Rows Success:^(id object) {
          
          self.uncheck_post_list_item = (uncheckPostListItem *)object;
          
          /////
          if(page_filter==0){//刚开始第一次加载
               if(self.uncheck_post_list_item.PostList!=nil){
                    [self getData];
                    [self.pltable reloadData];
               }else{
               //     self.pltable.hidden = YES;//没有数据则隐藏table
               }
               
          }else{
               if(self.uncheck_post_list_item.PostList!=nil){
                    if(page_filter==2){
                         [self getData];
                         //[self.pltable reloadData];
                    }else{
                         [self.PostListArray removeAllObjects];
                         [postDateData removeAllObjects];
                         [postImageData removeAllObjects];
                         [postTitleData removeAllObjects];
                         [postSetTopData removeAllObjects];
                         [self.Poster_Apply_Array removeAllObjects];
                         [self.Poster_Nic_Array removeAllObjects];
                         [self.Post_Rpply_Array removeAllObjects];
                         [self getData];
                         
                    }
                    [self.pltable reloadData];
               }else{
                    //刷新完成，已无更多
                    if(page_filter==2){
                         page--;
                    }
               }
          }

          ////
          
//          if(self.uncheck_post_list_item.PostList!=nil){
//          for (int i = 0; i < [self.uncheck_post_list_item.PostList count]; i++) {
//               self.pitem = [postItem createItemWitparametes:[self.uncheck_post_list_item.PostList objectAtIndex:i]];
//               [self.PostListArray addObject:self.pitem];
//               
//               //取title
//               if (self.pitem.title != nil){
//                    [postTitleData addObject:self.pitem.title];
//               }else{
//                    [postTitleData addObject:@""];
//               }
//               
//               //取date
//               if(self.pitem.post_date!=nil){
//                    //时间处理
//                    [self twoDateDistants:self.pitem.post_date];
//                    
//               }else{
//                    [postDateData addObject:@"00:00:00"];
//               }
//               
//               //取main_img_url
//               if(self.pitem.main_image_url!=nil){
//                    [postImageData addObject:self.pitem.main_image_url];
//               }else{
//                    [postImageData addObject:@""];
//               }
//               if(self.pitem.set_top!=nil){
//                    [postSetTopData addObject:self.pitem.set_top];
//               }else{
//                    [postSetTopData addObject:@""];
//               }
//               
//               //取nickname
//               if(self.pitem.poster_nickname!=nil){
//                    [self.Poster_Nic_Array addObject:self.pitem.poster_nickname];
//               }else{
//                    [self.Poster_Nic_Array addObject:@"游客"];
//               }
//               
//               //取poster_head_url
//               if(self.pitem.poster_head!=nil){
//                    [self.Poster_Img_Array addObject:self.pitem.poster_head];
//               }else{
//                    [self.Poster_Img_Array addObject:@""];
//               }
//               //取reply_num
//               if(![self.pitem.reply_num isEqualToString:@""]){
//                    [self.Post_Rpply_Array addObject:self.pitem.reply_num];
//               }else{
//                    [self.Post_Rpply_Array addObject:@"0"];
//               }
//               
//          }
//          
//          [self.pltable reloadData];
//          }else{
//               self.pltable.hidden = YES;
//          }

          
     }failurs:^(NSError *error) {
          NSLog(@"%@",error);
     }];


}


-(void)twoDateDistants:(NSString *)date{
     //日期格式转换
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
     NSDate *date2 = [formatter dateFromString:date];
     
     //解决采用世界时间转换后与实际时间相差8小时的问题
     NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
     //  NSTimeZone *GTMZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
     NSInteger interval = [timeZone secondsFromGMTForDate:date2];
     NSDate *p_date = [date2 dateByAddingTimeInterval:interval];
//     [formatter setDateFormat:@"MM-dd"];
//     [formatter setTimeZone:timeZone];
//     NSString *p_date1 = [formatter stringFromDate:p_date];
//     NSLog(@"^^^^^1%@",p_date1);
 //    [formatter setTimeZone:timeZone];
//     NSLog(@"*****%@",[formatter stringFromDate:date2]);
 //    NSLog(@"^^^^^%@",p_date);
     //日期比较
     NSDate *cur_date = [[NSDate alloc]init];//获取当前时间
     interval = [timeZone secondsFromGMTForDate:cur_date];
     cur_date = [cur_date dateByAddingTimeInterval:interval];
 //    NSLog(@"^^^^^%@",cur_date);
     NSInteger seconds = [cur_date timeIntervalSinceDate:p_date];//计算时间差秒数
//     NSLog(@"^^^^^%li",(long)seconds);
     long time =(long) seconds;
     NSString *date_time = [[NSString alloc]init];
     NSNumber *longNumber;
     if (time<0) {
          [postDateData addObject:@"刚刚"];
     }
     else if(time<60){
          longNumber = [NSNumber numberWithLong:time];
          date_time = [longNumber stringValue];
          [postDateData addObject:[date_time stringByAppendingString:@"秒前"]];
     }
     else if (time<60*60){
          time = time/60;
          longNumber = [NSNumber numberWithLong:time];
          date_time = [longNumber stringValue];
          [postDateData addObject:[date_time stringByAppendingString:@"分钟前"]];
          
     }
     else if (time<60*60*24){
          time = time/60/60;
          longNumber = [NSNumber numberWithLong:time];
          date_time = [longNumber stringValue];
          [postDateData addObject:[date_time stringByAppendingString:@"小时前"]];

     }
     else if(time<60*60*24*7){
          time = time/60/60/24;
          longNumber = [NSNumber numberWithLong:time];
          date_time = [longNumber stringValue];
          [postDateData addObject:[date_time stringByAppendingString:@"天前"]];

     }
     else if(time<60*60*24*365){
          NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
          [formatter1 setDateFormat : @"MM-dd"];
          date_time = [formatter1 stringFromDate:date2];
 //         NSLog(@"*****%@",date_time);
          [postDateData addObject:date_time];

     }
     else{
          NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
          [formatter1 setDateFormat : @"yyyy-MM-dd"];
          date_time = [formatter1 stringFromDate:date2];
          [postDateData addObject:date_time];

     }
     

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark------当前版块下发帖
-(void)NewPost{
     if ([self.forum_item.display_type isEqualToString:@"纵向"]) {
         PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];//通过UIViewController+Create扩展方法创建FourViewController的实例对象
         PEVC.forum_item = _forum_item;
         PEVC.ED_FLAG =@"1";// 当前版块下发帖
         [self.navigationController pushViewController:PEVC animated:YES];
     }else{
          NewPostEditViewController *PEVC2 = [[NewPostEditViewController alloc] initWithNibName:@"NewPostEditViewController" bundle:nil];
          PEVC2.forum_item = _forum_item;
          PEVC2.ED_FLAG =@"1";// 当前版块下发帖
     
          PEVC2.mainScrollView.frame = CGRectMake(PEVC2.mainScrollView.frame.origin.x , PEVC2.mainScrollView.frame.origin.y , self.view.frame.size.width , PEVC2.mainScrollView.frame.size.height);;
          [self.navigationController pushViewController:PEVC2 animated:YES];
     }
}


@end
