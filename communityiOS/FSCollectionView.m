//
//  FSCollectionview.m
//  communityiOS
//
//  Created by tjufe on 15/4/3.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "FSCollectionview.h"
#import "PostEditViewController.h"
#import <UIKit/UIKit.h>
#import "ForumSelectTableViewCell.h"


@implementation FSCollectionview{
    
}


int i ;




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_forum_name count];
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    //    FSCollectionView *fs = [[FSCollectionView alloc]init];
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell11" forIndexPath:indexPath ];
   // NSArray *qwer=[[NSArray alloc]initWithObjects:@"社区信息通告",@"号码万事通",@"拼生活",@"周末生活",@"结伴生活",@"物业报修",@"物业投诉",@"敬请期待...",nil];

    //cell里面的控件
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
    label.text = [_forum_name objectAtIndex:indexPath.row] ;
    label.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [cell addSubview:label];
    cell.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1];
//    self.i= label.text;
    //cell边框
//    UIView *view_wt = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
//    [view_wt setBackgroundColor:[UIColor grayColor]];
//    [cell addSubview:view_wt];
//    UIView *view_hl = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, cell.frame.size.height)];
//    [view_hl setBackgroundColor:[UIColor grayColor]];
//    [cell addSubview:view_hl];
//    UIView *view_wb = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, 1)];
//    [view_wb setBackgroundColor:[UIColor grayColor]];
//    [cell addSubview:view_wb];
//    UIView *view_hr = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width, 0, 1, cell.frame.size.height)];
//    [view_hr setBackgroundColor:[UIColor grayColor]];
//    [cell addSubview:view_hr];
//    self.backgroundColor = [UIColor blueColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self removeFromSuperview ];
    
//    i = (int)indexPath.item;
//    NSArray *as=[[NSArray alloc]initWithObjects:@"社区信息通告",@"号码万事通",@"拼生活",@"周末生活",@"结伴生活",@"物业报修",@"物业投诉",@"敬请期待...",nil];
    ForumSelectTableViewCell *cell = [self.tb cellForRowAtIndexPath:self.index];
    cell.fslabel.text = [_forum_name objectAtIndex:indexPath.row];
//    [self.maskView removeFromSuperview];
    _select_forum_id = [_forum_id objectAtIndex:indexPath.row];
    _select_forum_name = [_forum_name objectAtIndex:indexPath.row];
    _select_row = indexPath;//选择的索引号
    
}


-(void)getcelltext:(NSIndexPath *)indexPath:(UITableView*)tableview{
    
    self.index = indexPath;
    self.tb = tableview;

    
    
}


//定义每个collectionview的cell大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(100, 40);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
