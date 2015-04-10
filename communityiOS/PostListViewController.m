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
#import "PostEditViewController.h"

#import "forumItem.h"

@interface PostListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *ForumName;

@end
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
    self.navigationItem.title = @"版块名";
    //设置导航右侧按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered  target:self action:@selector(NewPost)];
    [rightItem setImage:[UIImage imageNamed:@"icon_main_add"]];
    [rightItem setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    postTitleData = [[NSMutableArray alloc]init];
    postDateData = [[NSMutableArray alloc]init];
    postImageData = [[NSMutableArray alloc]init];
    postSetTopData = [[NSMutableArray alloc]init];
    //请求数据
    [self loadData];

    // Do any additional setup after loading the view.
}

-(void)loadData{
    [StatusTool statusToolGetPostListWithbfID:_forum_item.forum_id bcID:_forum_item.community_id userID:@"0003" filter:@"全部" Success:^(id object) {
        
        self.PostListArray =(NSMutableArray*)object;
        for (int i = 0; i < [object count]; i++) {
            self.pitem = [object objectAtIndex:i];
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
    [self.navigationController pushViewController:PEVC animated:YES];

}


@end
