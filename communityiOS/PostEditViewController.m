//
//  PostEditViewController.m
//  communityiOS
//
//  Created by tjufe on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "PostEditViewController.h"
#import "TitleTableViewCell.h"
#import "ImageTableViewCell.h"
#import "TextTableViewCell.h"
#import "ChainTableViewCell.h"
#import "PushTableViewCell.h"
#import "SaveTableViewCell.h"
#import "ForumSelectTableViewCell.h"


@interface PostEditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *PEtableview;


@end

@implementation PostEditViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row== 0 ) {
        ForumSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"ForumSelectTableViewCell" owner:nil options:nil]objectAtIndex:0];
            
        }
        return cell;
       
      }else if (indexPath.row== 1 ) {
        TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"TitleTableViewCell" owner:nil options:nil]objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        return cell;
    }else if(indexPath.row == 2){
        ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"ImageTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else if(indexPath.row == 3){
        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        //设置自动换行，不知是否可行
        cell.textlabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textlabel.numberOfLines = 0;
        CGSize size = [cell.textlabel.text sizeWithFont:cell.textlabel.font constrainedToSize:self.view.bounds.size lineBreakMode:cell.textlabel.lineBreakMode];
        CGRect rect = cell.textlabel.frame;
        rect.size.height = size.height;
        cell.textlabel.frame = rect;
        //
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"TextTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else if(indexPath.row == 4){
        ChainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"ChainTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else if(indexPath.row == 5){
        PushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"PushTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else {
        SaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"SaveTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        return 50;
    }else if(indexPath.row ==1){
        return 250;
    }else if(indexPath.row ==2){
        return 300;
    }else if(indexPath.row ==3){
        return 50;
    }else if(indexPath.row ==4){
        return 50;
    }else if(indexPath.row ==5){
        return 50;
    }else{
        return 50;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.PEtableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"编辑";
//    TextTableViewCell *ttvc = [[TextTableViewCell alloc]init];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"aaa" style:UIBarButtonItemStyleBordered  target:self action:@selector(Tonextview)];
    self.navigationItem.rightBarButtonItem = rightItem;
  
}
-(void)Tonextview{
    
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
