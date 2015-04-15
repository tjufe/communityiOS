//
//  ReplyListViewController.m
//  communityiOS
//
//  Created by 金钟 on 15/4/14.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "ReplyListViewController.h"
#import "ReplyitemTableViewCell.h"
#import "StatusTool.h"
#import "replyInfoItem.h"
#import "replyInfoListItem.h"
#import "UIImageView+WebCache.h"//加载图片

@interface ReplyListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *replyImageData;  //表格数据
    NSMutableArray *replyNickname;
    NSMutableArray *replydate;
    NSMutableArray *replyText;
    


}
@property (weak, nonatomic) IBOutlet UITableView *rtableview;
@property(strong,nonatomic)replyInfoListItem *reply_list;
@property(strong,nonatomic)replyInfoItem *reply_item;
@property(strong,nonatomic)NSMutableArray *ReplyListArray;
@end

@implementation ReplyListViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 8;
    return  replyNickname.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyitemTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell =[[[NSBundle mainBundle] loadNibNamed:@"ReplyitemTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.Rnickname.text =[replyNickname objectAtIndex:indexPath.row];//nickname
    cell.Rdate.text = [replydate objectAtIndex:indexPath.row];//date
    
    
    cell.Rtext.text = [replyText objectAtIndex:indexPath.row];//text
    
//    加载图片
    NSString* URL=[[NSString alloc]init];
    URL =[replyImageData objectAtIndex:indexPath.row];
    if([URL isEqualToString:@""] ){
        cell.reply_head.hidden = YES;
    }else{
        cell.reply_head.hidden = NO;
        [cell.reply_head sd_setImageWithURL:[NSURL URLWithString:[replyImageData objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.reply_head.image = image;
        }];
    }
    cell.reply_head.contentMode=UIViewContentModeScaleAspectFill;

    return cell;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{//3绘制行高
    return 80;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    [StatusTool statusToolReplyContentWithID:self.post_id Success:^(id object) {
          self.reply_list = (replyInfoListItem *)object;
        for(int i = 0; i < [self.reply_list.replyInfoList count]; i++){
            self.reply_item = [replyInfoItem createItemWitparametes:[self.reply_list.replyInfoList objectAtIndex:i]];
            [self.ReplyListArray addObject:self.reply_item];
            
            if(self.reply_item.head_portrait_url!=nil){
                [replyImageData addObject:self.reply_item.head_portrait_url];
            }else{
                [replyImageData addObject:@""];
            }
            
            if (self.reply_item.nickname!=nil) {
                [replyNickname addObject:self.reply_item.nickname];
            }else{
                [replyNickname addObject:@""];
            }
            
            if(self.reply_item.content!=nil){
                [replyText addObject:self.reply_item.content];
            }else{
                [replyText addObject:@""];
            }
            if (self.reply_item.date!=nil) {
                [replydate addObject:self.reply_item.date];
            }
        
        }
        [self.rtableview reloadData];
        
        
        
    } failurs:^(NSError *error) {
        
    }];
    
        
      
        
     
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
