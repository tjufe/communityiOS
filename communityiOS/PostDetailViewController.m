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


@interface PostDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PostListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *SendButton;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;

@property (weak, nonatomic) IBOutlet UIView *TitleRect;

@property (weak, nonatomic) IBOutlet UIImageView *PosterImage;

@property (weak, nonatomic) IBOutlet UILabel *forumlabel;

@property(strong,nonatomic)postItem *post_item ;


@end

@implementation PostDetailViewController

float cellheight;
- (IBAction)SendOnClick:(id)sender {
    
    PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];//通过UIViewController+Create扩展方法创建FourViewController的实例对象
    [self.navigationController pushViewController:PEVC animated:YES];
    
    
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
        }
        if(self.post_item.post_date!=nil){
        cell.postDate.text = [self.post_item.post_date substringToIndex:16];
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
//
        }else{
            PostImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"PostImageTableViewCell" owner:nil options:nil]objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //加载图片
            if(self.post_item.main_image_url!=nil){
                
                cell.MainImage.hidden = NO;
                [cell.MainImage sd_setImageWithURL:self.post_item.main_image_url placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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

    

-(void)setTitleRect:(UIView *)TitleRect{
    TitleRect.layer.masksToBounds = YES;
    [TitleRect.layer setCornerRadius:TitleRect.frame.size.height/3];
    
    
}
-(void)setForumlabel:(UILabel *)forumlabel{
    
    
    [forumlabel setText:_forum_item.forum_name];
    forumlabel.layer.masksToBounds = YES;
    [forumlabel.layer setCornerRadius:forumlabel.layer.frame.size.height/3];

}
-(void)setPosterImage:(UIImageView *)PosterImage{
    PosterImage.layer.masksToBounds = YES;
    [PosterImage.layer setCornerRadius:PosterImage.layer.frame.size.height/4];

}

-(void)addpostItem:(postItem *)PostItem{
    self.post_item = PostItem;
    
}

- (void)viewDidLoad {
//    self.scrollview.frame.size.width = self.view.frame.size.width;
    [super viewDidLoad];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划线
    
    self.navigationItem.title = @"话题";
       UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    //界面赋值
    [self.postTitle setText:self.post_item.title];
    
    NSLog(@"^^^^%d",_forum_item.forum_name.length);
    
    [self.tableview reloadData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
