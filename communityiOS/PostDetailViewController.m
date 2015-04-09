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

@interface PostDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *SendButton;

@property (weak, nonatomic) IBOutlet UIView *TitleRect;
@property (weak, nonatomic) IBOutlet UILabel *Ftitle;
@property (weak, nonatomic) IBOutlet UIImageView *PosterImage;
@property (strong, nonatomic) IBOutlet UIView *operlist;


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
            return cell;
        }else if(indexPath.row == 1){
            PostTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"PostTextTableViewCell" owner:nil options:nil]objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cellheight = cell.Text.frame.size.height;
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
-(void)setFtitle:(UILabel *)Ftitle{
    Ftitle.layer.masksToBounds = YES;
    [Ftitle.layer setCornerRadius:Ftitle.layer.frame.size.height/3];

}
-(void)setPosterImage:(UIImageView *)PosterImage{
    PosterImage.layer.masksToBounds = YES;
    [PosterImage.layer setCornerRadius:PosterImage.layer.frame.size.height/4];

}

- (void)viewDidLoad {
//    self.scrollview.frame.size.width = self.view.frame.size.width;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划线
    [super viewDidLoad];
    self.navigationItem.title = @"话题";
       UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title=@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    //设置导航右侧按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered  target:self action:@selector(Operation)];
    [rightItem setImage:[UIImage imageNamed:@"菜单"] ];
    [rightItem setTintColor:[UIColor redColor]];
    
    self.navigationItem.rightBarButtonItem = rightItem;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Operation{
    self.operlist = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 100, 150)];
    self.operlist.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    self.operlist.alpha=0;
    [UIView animateWithDuration:0.5 animations:^{
        self.operlist.frame = CGRectMake(self.view.frame.size.width-100, 60, 100, 150);
        self.operlist.alpha = 1;
    }];
    [self.view addSubview:self.operlist];
    //编辑按钮
    UIButton * editbutton = [[UIButton alloc]init];
    editbutton.frame = CGRectMake(25, 0, 50, 50);
    [editbutton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.operlist addSubview:editbutton];
    [editbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [editbutton addTarget:self action:@selector(EditPost) forControlEvents:UIControlEventTouchUpInside];
    //删除按钮
    UIButton * delebutton = [[UIButton alloc]init];
    delebutton.frame = CGRectMake(25, 50, 50, 50);
    [delebutton setTitle:@"删除" forState:UIControlStateNormal];
    [self.operlist addSubview:delebutton];
    [delebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [delebutton addTarget:self action:@selector(DelePost) forControlEvents:UIControlEventTouchUpInside];
    //删除按钮
    UIButton * settopbutton = [[UIButton alloc]init];
    settopbutton.frame = CGRectMake(25, 100, 50, 50);
    
    [settopbutton setTitle:@"置顶" forState:UIControlStateNormal];
    [self.operlist addSubview:settopbutton];
    [settopbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [settopbutton addTarget:self action:@selector(Settop) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)EditPost{
    PostEditViewController *PEVC = [ PostEditViewController createFromStoryboardName:@"PostEdit" withIdentifier:@"pe"];
    //通过UIViewController+Create扩展方法创建FourViewController的实例对象
    [self.navigationController pushViewController:PEVC animated:YES];
    [self.operlist removeFromSuperview];
}
-(void)DelePost{
 [self.operlist removeFromSuperview];

}
-(void)Settop{
    
     [self.operlist removeFromSuperview];
}

@end
