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

#import "StatusTool.h"
#import "postListItem.h"
#import "UIImageView+WebCache.h"//加载图片
#import "postInfoItem.h"
#import "PostEditViewController.h"



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
@property(strong,nonatomic)postListItem *post_list_item;
@property (strong,nonatomic) postInfoItem *post_info_item;
@property (strong,nonatomic) NSMutableArray *postinfo;
//@property (strong,nonatomic) NSMutableArray *Poster_Nic_Array;//发帖人昵称数组
//@property (strong,nonatomic) NSMutableArray *Poster_Img_Array;//发帖人头像url数组
//@property (strong,nonatomic) NSMutableArray *Post_Rpply_Array;//帖子评论数
@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
@property (strong,nonatomic) NSString *UserID;//当前用户id
@property (strong,nonatomic) NSString *AccountStatus;//当前用户账号状态
@end




@implementation PostListViewController



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  postTitleData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell =[[[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.PostLabel.text = [postTitleData objectAtIndex:indexPath.row];//title
    cell.postDate.text = [postDateData objectAtIndex:indexPath.row];//date

    cell.poster_nic.text = [self.post_list_item.poster_nickname objectAtIndex:indexPath.row];//nickname
     
     NSString *reply_num =[[NSString alloc]init];
     reply_num = [self.post_list_item.reply_num objectAtIndex:indexPath.row];
     
     if([reply_num isKindOfClass:[NSNull class]]){
          cell.post_reply_num.text = @"暂无";
     }else{
          cell.post_reply_num.text = reply_num;//reply_num

     }
     
    //加载图片
    NSString* URL=[[NSString alloc]init];
    URL =[postImageData objectAtIndex:indexPath.row];
    if([URL isEqualToString:@""] ){
        cell.postImg.hidden = YES;
     }else{
          cell.postImg.hidden = NO;
         [cell.postImg sd_setImageWithURL:[NSURL URLWithString:[postImageData objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             cell.postImg.image = image;
         }];
    }
        
    cell.postImg.contentMode=UIViewContentModeScaleAspectFill;
    
    //是否置顶
    NSString *SP = [[NSString alloc]init];
    SP = [postSetTopData objectAtIndex:indexPath.row];
    if([SP isEqualToString:@"是"]){
        cell.setTop.hidden = NO;
    }else{
        cell.setTop.hidden = YES;
    }

    return cell;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//3绘制行高
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     _PostItem = [self.PostListArray objectAtIndex:indexPath.row];
    
     PostDetailViewController *PDVC = [ PostDetailViewController createFromStoryboardName:@"PostDetailStoryboard" withIdentifier:@"postDetail"];
     //全局变量传值
     PDVC.forum_item = _forum_item;
     PDVC.poster_nickname = [self.post_list_item.poster_nickname objectAtIndex:indexPath.row];
     PDVC.Phead_portrait_url = [self.post_list_item.Phead_portrait_url objectAtIndex:indexPath.row];
     PDVC.reply_num = [self.post_list_item.reply_num objectAtIndex:indexPath.row];
    //协议实现页面传值
    self.delegate = PDVC;
    if ([self.delegate
         respondsToSelector:@selector(addpostItem:)]) {

    [self.delegate addpostItem:_PostItem];
    }
    
    
    [self.navigationController pushViewController:PDVC animated:YES];
    
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
     //获取当前用户信息
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     self.UserID =[defaults objectForKey:@"UserID"];
     self.UserPermission = [defaults objectForKey:@"UserPermission"];
     self.AccountStatus = [defaults objectForKey:@"AccountStatus"];
     

     
     
   //使下一页的导航栏左边没有文字
    UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    //本导航栏题目

    self.navigationItem.title = _forum_item.forum_name;
    //try nav button fail
//    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [rightbutton setTitle:@"aaa" forState:UIControlStateNormal];
//    UIBarButtonItem *rightItem  = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
//    self.navigationItem.rightBarButtonItem = rightItem;


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
     
     //判断用户身份来决定是否显示发帖图标
     if (![self.UserPermission isEqualToString:@""]&&[self.AccountStatus isEqualToString:@"正常"]) {
          
    
          self.navigationItem.rightBarButtonItem = rightItem;

     }
    postTitleData = [[NSMutableArray alloc]init];
    postDateData = [[NSMutableArray alloc]init];
    postImageData = [[NSMutableArray alloc]init];
    postSetTopData = [[NSMutableArray alloc]init];
    self.postinfo = [[NSMutableArray alloc]init];
//    self.Poster_Nic_Array = [[NSMutableArray alloc]init];
//    self.Poster_Img_Array = [[NSMutableArray alloc]init];
//    self.Post_Rpply_Array =[[NSMutableArray alloc]init];
    self.PostListArray =[[NSMutableArray alloc]init];
  
     
    //请求数据
    [self loadData];
   

    // Do any additional setup after loading the view.
}

#pragma mark-------请求加载帖子列表数据
-(void)loadData{
    [StatusTool statusToolGetPostListWithbfID:_forum_item.forum_id bcID:_forum_item.community_id userID:self.UserID filter:@"全部" Success:^(id object) {
        
        self.post_list_item = (postListItem *)object;
         
         
        for (int i = 0; i < [self.post_list_item.PostList count]; i++) {
             self.pitem = [postItem createItemWitparametes:[self.post_list_item.PostList objectAtIndex:i]];
             [self.PostListArray addObject:self.pitem];
             
             //取title
            if (self.pitem.title != nil){
                [postTitleData addObject:self.pitem.title];
            }else{
                [postTitleData addObject:@"default"];
            }
             
            //取date
            if(self.pitem.post_date!=nil){
                //日期格式转换
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                NSTimeZone *timeZone = [NSTimeZone localTimeZone];
//                
//                [formatter setTimeZone:timeZone];
//                [formatter setDateFormat : @"yyyy/MM/dd HH:mm"];
                NSString *pdate=[[NSString alloc]init];
//                pdate = self.pitem.post_date;
//                NSLog(@"%@",pdate);
//                NSDate *date =[[NSDate alloc]init];
//                [formatter dateFromString:@"2013-03-23 00:01:09"];
//                NSLog(@"%@",date);
//                pdate=[formatter stringFromDate:date];
                pdate=[self.pitem.post_date substringToIndex:16];//截取字符串
                [postDateData addObject:pdate];
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
        }
         
        [self.pltable reloadData];
          }failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
 //   [self.pltable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark------当前版块下发帖
-(void)NewPost{
    PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];//通过UIViewController+Create扩展方法创建FourViewController的实例对象
    PEVC.forum_item = _forum_item;
    PEVC.ED_FLAG =@"1";// 当前版块下发帖
    [self.navigationController pushViewController:PEVC animated:YES];
    
}


@end
