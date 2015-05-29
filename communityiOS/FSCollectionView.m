//
//  FSCollectionview.m
//  communityiOS
//
//  Created by tjufe on 15/4/3.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "FSCollectionview.h"
#import "NewPostEditViewController.h"
#import "ForumSelectTableViewCell.h"
#import "forumItem.h"
#import "forumSetItem.h"
#import "UIViewController+Create.h"



@implementation FSCollectionview{
    
}


int i ;
forumSetItem *forum_set_item;//帖子的设置

ForumSelectTableViewCell *cell;

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_select_forum count];
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    //    FSCollectionView *fs = [[FSCollectionView alloc]init];
    forumItem *f =[_select_forum objectAtIndex:indexPath.row];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell11" forIndexPath:indexPath ];
      //cell里面的控件
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 5, 200, 30)];
    label.text = f.forum_name ;
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [cell addSubview:label];
    cell.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self removeFromSuperview ];
    select_forum_dropdown_isonshowing = NO;
    forumItem *f = [_select_forum objectAtIndex:indexPath.row];
    _select_forum_id = f.forum_id;
    _select_forum_name = f.forum_name;
    _select_row = indexPath;//选择的索引号
    
//    i = (int)indexPath.item;
    cell = [_tb cellForRowAtIndexPath:_index];
    cell.fslabel.text = f.forum_name;
//    [self.maskView removeFromSuperview];
     [self checkForum:f];

}



#pragma mark-------获取版块设置
-(void)checkForum:(forumItem *)forum_item{
        //获取版块设置
        _ISMAINIMG1 = @"N";
        _ISAPPLY1 = @"N";
        _ISCHAIN1 =@"N";
        _ISCHECK1 = @"N";
        
        if(forum_item.ForumSetlist!=nil){
            for(int i=0;i < [forum_item.ForumSetlist count];i++){
                forum_set_item  = [forumSetItem createItemWitparametes:[forum_item.ForumSetlist objectAtIndex:i]];
                if([forum_set_item.site_name isEqualToString:site_addapply]&&[forum_set_item.site_value isEqualToString:@"是"]){
                    _ISAPPLY1 = @"Y";
                }
                if ([forum_set_item.site_name isEqualToString:site_addchain]&&[forum_set_item.site_value isEqualToString:@"是"]) {
                    _ISCHAIN1 = @"Y";
                }
                if([forum_set_item.site_name isEqualToString:site_addmainimg]&&[forum_set_item.site_value isEqualToString:@"是"]){
                   _ISMAINIMG1=@"Y";
                }
                if([forum_set_item.site_name isEqualToString:site_ischeck]&&[forum_set_item.site_value isEqualToString:@"是"]){
                    _ISCHECK1 = @"Y";
                }
            }
        }
        
    //显示在UI中
    NSIndexPath *index ;
    NSArray *indexArrary ;
    
      if(![_ISMAINIMG1 isEqualToString:@"Y"]){
        _Addpic.enabled = NO;
        _Addpic.hidden = YES;
          //显示在UI中
          
      }else{
          _Addpic.enabled = YES;
          _Addpic.hidden = NO;
      }
    index = [NSIndexPath indexPathForRow:3 inSection:0];
    indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [_tb reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];

      if(![_ISCHAIN1 isEqualToString:@"Y"]){
        _Chain.enabled = NO;
        _Chain.hidden = YES;
      }else{
          _Chain.enabled = YES;
          _Chain.hidden = NO;
      }
    index = [NSIndexPath indexPathForRow:4 inSection:0];
    indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [_tb reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
      if(![_ISAPPLY1 isEqualToString:@"Y"]){
        _Apply.enabled = NO;
        _Apply.hidden = YES;
      }else{
          _Apply.enabled = YES;
          _Apply.hidden = NO;
      }
    index = [NSIndexPath indexPathForRow:5 inSection:0];
    indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [_tb reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
    

}







- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        cell.fslabel.text = @"请重新选择！";
    }
}


-(void)getcelltext:(NSIndexPath *)indexPath:(UITableView*)tableview{
    
    _index = indexPath;
    _tb = tableview;

    
    
}

-(NSMutableArray *)GetSelectedResult{
    

    NSMutableArray *select_array = [NSMutableArray arrayWithObjects:_select_row,_select_forum_id,_select_forum_name,_ISMAINIMG1,_ISCHAIN1,_ISAPPLY1, nil ];

    return select_array;
}


////定义每个collectionview的cell大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(200, 50);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
