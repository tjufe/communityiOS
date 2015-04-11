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
@property (strong,nonatomic) postInfoItem *post_info_item;
@property (strong,nonatomic) NSMutableArray *postinfo;
@property (strong,nonatomic)NSMutableArray *Poster_Nic_Array;//发帖人昵称数组
@property (strong,nonatomic)NSMutableArray *Poster_Img_Array;//发帖人头像url数组
@property (strong,nonatomic)NSMutableArray *Post_Rpply_Array;//帖子评论数

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
    cell.PostLabel.text = [postTitleData objectAtIndex:indexPath.row];
    cell.postDate.text = [postDateData objectAtIndex:indexPath.row];
    postInfoItem *pt =[self.postinfo objectAtIndex:indexPath.row];
    cell.poster_nic.text = pt.poster_nickname;
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
    PDVC.forum_item = _forum_item;
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

//    self.navigationItem.title = @"版块名";
    //设置导航右侧按钮

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
    self.navigationItem.rightBarButtonItem = rightItem;

    
    postTitleData = [[NSMutableArray alloc]init];
    postDateData = [[NSMutableArray alloc]init];
    postImageData = [[NSMutableArray alloc]init];
    postSetTopData = [[NSMutableArray alloc]init];
    self.postinfo = [[NSMutableArray alloc]init];
    self.Poster_Nic_Array = [[NSMutableArray alloc]init];
    self.Poster_Img_Array = [[NSMutableArray alloc]init];
    self.Post_Rpply_Array =[[NSMutableArray alloc]init];
    //请求数据
    [self loadData];

    // Do any additional setup after loading the view.
}

-(void)loadData{
    [StatusTool statusToolGetPostListWithbfID:_forum_item.forum_id bcID:_forum_item.community_id userID:@"0003" filter:@"全部" Success:^(id object) {
        
        self.PostListArray =(NSMutableArray*)object;
        for (int i = 0; i < [object count]; i++) {
            self.pitem = [object objectAtIndex:i];
            
            ////
            [StatusTool statusToolGetPostRelatedInfoWithpostID:self.pitem.post_id poster_ID:self.pitem.poster_id community_ID:self.pitem.belong_community_id forum_ID:self.pitem.belong_forum_id Success:^(id object) {
                
                self.post_info_item = (postInfoItem *)object;
                
                [self.postinfo addObject:self.post_info_item];
//                if(self.post_info_item.poster_nickname!=nil){
//                    [self.Poster_Nic_Array addObject:self.post_info_item.poster_nickname];
//                }else{
//                    [self.Poster_Nic_Array addObject:@"游客"];
//                }
 //               [self.pltable reloadData];
                
            } failurs:^(NSError *error) {
                  NSLog(@"%@",error);
            }];
            
            
            ///
            
            
            
            
            if (self.pitem.title != nil){
                [postTitleData addObject:self.pitem.title];
            }else{
                [postTitleData addObject:@"default"];
            }
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
//        NSLog(@"^^^^%d",Poster_Nic_Array.count);
        [self.pltable reloadData];
        
    }failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)NewPost{
    PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];//通过UIViewController+Create扩展方法创建FourViewController的实例对象
    PEVC.forum_item = _forum_item;
    PEVC.ED_FLAG =@"1";// 当前版块下发帖
    [self.navigationController pushViewController:PEVC animated:YES];
    
}


@end
