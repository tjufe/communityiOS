//
//  ViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/3/18.
//  Copyright (c) 2015年 何茂馨. All rights reserved.
//

#import "ViewController.h"
#import "ForumTableViewCell.h"
#import "LoginNavigationController.h"
#import "UIViewController+Create.h"

@interface ViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tableData;  //表格数据
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *mainPageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation ViewController

- (IBAction)go2Login:(id)sender {
    //pod
    LoginNavigationController *vc=[LoginNavigationController createFromStoryboardName:@"Login" withIdentifier:@"loginACT"];
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentModalViewController:vc animated:YES];
}

- (void)initTableData {
    tableData = [[NSMutableArray alloc] initWithObjects:
                 [NSMutableArray arrayWithObjects:@"社区信息通告",@"号码万事通",@"拼生活",@"周末生活",@"结伴生活",@"物业报修",@"物业投诉",nil],[NSMutableArray arrayWithObjects:@"……",@"……",@"……",@"……",@"……",@"……",@"……", nil],
                      [NSMutableArray arrayWithObjects:@"icon_01",@"icon_02",@"icon_03",@"icon_04",@"icon_05",@"icon_06",@"icon_07", nil],nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    tableData = [[NSMutableArray alloc] init];
//    for (int i = 0; i< 7; i++) {
//        [tableData addObject:[NSString stringWithFormat:@"模块%i",i+1]];
//    }
    
    [self initTableData];
    
    self.avaterImageView.layer.masksToBounds=YES;
    [self.avaterImageView.layer setCornerRadius:self.avaterImageView.frame.size.width/2];
    self.avaterImageView.contentMode=UIViewContentModeScaleAspectFill;
    
    // Do any additional setup after loading the view, typically from a nib.
    //    图片的宽
    CGFloat imageW = self.view.frame.size.width;
    //    CGFloat imageW = 300;
    //    图片高
    CGFloat imageH = self.mainScrollView.frame.size.height;
    //    图片的Y
    CGFloat imageY = 0;
    //    图片中数
    NSInteger totalCount = 3;
    //   1.添加5张图片
    for (int i = 0; i < totalCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //        图片X
        CGFloat imageX = i * imageW;
        //        设置frame
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        //        设置图片
        NSString *name = [NSString stringWithFormat:@"image_0%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        //        隐藏指示条
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
        
        [self.mainScrollView addSubview:imageView];
    }
    
    //    2.设置scrollview的滚动范围
    CGFloat contentW = totalCount *imageW;
    //不允许在垂直方向上进行滚动
    self.mainScrollView.contentSize = CGSizeMake(contentW, 0);
    
    //    3.设置分页
    self.mainScrollView.pagingEnabled = YES;
    
    //    4.监听scrollview的滚动
    self.mainScrollView.delegate = self;
    
    [self addTimer];
}

- (void)nextImage
{
    int page = (int)self.mainPageControl.currentPage;
    if (page == 2) {
        page = 0;
    }else
    {
        page++;
    }
    
    //  滚动scrollview
    CGFloat x = page * self.mainScrollView.frame.size.width;
    [self.mainScrollView setContentOffset:CGPointMake(x,0) animated:YES];
}

// scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"滚动中");
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.mainPageControl.currentPage = page;
}

// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
    //    [self.timer invalidate];
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    开启定时器
    [self addTimer];
}

/**
 *  开启定时器
 */
- (void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
/**
 *  关闭定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[tableData objectAtIndex:0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForumTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell =[[[NSBundle mainBundle] loadNibNamed:@"ForumTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setForumIconImage:[UIImage imageNamed:[[tableData objectAtIndex:2] objectAtIndex:indexPath.row]]];
    [cell setForumName:[[tableData objectAtIndex:0] objectAtIndex:indexPath.row]];
    [cell setLastNewContent:[[tableData objectAtIndex:1] objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    // custom view for header. will be adjusted to default or specified header height
//    
////    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
////    if(section>0)
////        headerView.backgroundColor=[UIColor redColor];
////    else
////        headerView.backgroundColor=[UIColor blueColor];
////    
//////    [headerView addSubview:<#(UIView *)#>];
////    
////    return headerView;
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

@end
