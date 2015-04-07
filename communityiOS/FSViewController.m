//
//  FSViewController.m
//  communityiOS
//
//  Created by tjufe on 15/4/2.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "FSViewController.h"

@interface FSViewController()<UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation FSViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
//    FSCollectionView *fs = [[FSCollectionView alloc]init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell11" forIndexPath:indexPath ];
    //cell里面的控件
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
    label.text =@"周末生活";
    [cell addSubview:label];
    //cell边框
    UIView *view_w = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    [view_w setBackgroundColor:[UIColor grayColor]];
    [cell addSubview:view_w];
    UIView *view_h = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, cell.frame.size.height)];
    [view_h setBackgroundColor:[UIColor grayColor]];
    [cell addSubview:view_h];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.fscollectionview removeFromSuperview];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置collectionview的布局
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.minimumLineSpacing = 0;
        [flowlayout setItemSize:CGSizeMake(self.view.frame.size.width/2, 50)];
    
    
        //在collectionview注册collectionviewcell；
        [_fscollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell11"];
        _fscollectionview.collectionViewLayout =flowlayout;
        [_fscollectionview reloadData];

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
