//
//  DemoViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/4/2.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DemoViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 32;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[[UICollectionViewCell alloc] init];
    cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor=[UIColor redColor];

    UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 50)];
    NSString *indexPathRowStr=[NSString stringWithFormat:@"%d",indexPath.row];
    l.text=indexPathRowStr;
    
    [cell addSubview:l];
    cell.backgroundColor=[UIColor colorWithRed:15*indexPath.row/255 green:89*indexPath.row/255 blue:30*indexPath.row/255 alpha:1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing=0;
//    flowLayout.itemSize
    [flowLayout setItemSize:CGSizeMake(self.view.frame.size.width/2, 50)];
    
    
    [_collectionView registerClass:[UICollectionViewCell class]
        forCellWithReuseIdentifier:@"cell"];
    _collectionView.collectionViewLayout=flowLayout;
    
//    [_collectionView reloadData];
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
