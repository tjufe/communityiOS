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
#import "DialogView.h"
#import "FSCollectionview.h"


@interface PostEditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addpic;
@property (weak, nonatomic) IBOutlet UITableView *PEtableview;//IBOutlet 表示该类是在xib中展示
@property(strong,nonatomic)FSCollectionview *fs;

@property (weak,nonatomic)NSString *ns;
@property (strong,nonatomic)UIView *addchain;

@end

@implementation PostEditViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row== 0 ) {
        ForumSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"ForumSelectTableViewCell" owner:nil options:nil]objectAtIndex:0];
            
        }
//            [FSCollectionview getname];
//            [self performSelector:@selector(getname:) ];
        
        return cell;
       
      }else if (indexPath.row== 1 ) {
        TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"TitleTableViewCell" owner:nil options:nil]objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
            }
        
        return cell;
//    }else if(indexPath.row == 2){
//        ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (!cell) {
//            cell= [[[NSBundle mainBundle]loadNibNamed:@"ImageTableViewCell" owner:nil options:nil]objectAtIndex:0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        return cell;
    }else if(indexPath.row == 2){
        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        //设置自动换行，不知是否可行
//        cell.textlabel.lineBreakMode = UILineBreakModeWordWrap;
//        cell.textlabel.numberOfLines = 0;
//        CGSize size = [cell.textlabel.text sizeWithFont:cell.textlabel.font constrainedToSize:self.view.bounds.size lineBreakMode:cell.textlabel.lineBreakMode];
//        CGRect rect = cell.textlabel.frame;
//        rect.size.height = size.height;
//        cell.textlabel.frame = rect;
        //
        

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"TextTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
//    }else if(indexPath.row == 3){
//        ChainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (!cell) {
//            cell= [[[NSBundle mainBundle]loadNibNamed:@"ChainTableViewCell" owner:nil options:nil]objectAtIndex:0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        return cell;
//    }else if(indexPath.row == 4){
//        PushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (!cell) {
//            cell= [[[NSBundle mainBundle]loadNibNamed:@"PushTableViewCell" owner:nil options:nil]objectAtIndex:0];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        return cell;
    }else {
        SaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"SaveTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        return 50;
    }else if(indexPath.row ==1){
        return 50;
    }else if(indexPath.row ==2){
        return self.PEtableview.frame.size.height - 160;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0){
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.minimumLineSpacing = 2;
        [flowlayout setItemSize:CGSizeMake(100, 40)];
        
        
        self.fs  = [[FSCollectionview alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 50, 202, 200) collectionViewLayout:flowlayout];

        self.fs.backgroundColor= [UIColor whiteColor];
       
        self.fs.dataSource = self.fs;
        self.fs.delegate = self.fs;
        //在collectionview注册collectionviewcell；
        [self.fs  registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell11"];

    [self.PEtableview addSubview:self.fs];
        //定义数组
//        NSArray *arr = [[NSArray alloc]initWithObjects:@"社区信息通告",@"号码万事通",@"拼生活",@"周末生活",@"结伴生活",@"物业报修",@"物业投诉",@"敬请期待...",nil];
        //获取点击的cell
        [self.fs getcelltext:indexPath:self.PEtableview];
        
        
            
        }
        
    }


//    FSCollectionview *fs  = [[FSCollectionview alloc]initWithFrame:CGRectMake(10, 10, 300, 300)];
//    
//    [self.PEtableview addSubview:fs];


    


- (void)viewDidLoad {
    [super viewDidLoad];
    self.PEtableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"发布话题";
//    TextTableViewCell *ttvc = [[TextTableViewCell alloc]init];
    
    //加导航栏右侧按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleBordered  target:self action:@selector(Tonextview)];
    self.navigationItem.rightBarButtonItem = rightItem;

    //设置username输入文本框的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification  object:nil];
    
  
}
-(void)Tonextview{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textDidChange:(NSNotification *)notification{
    
    
}
- (IBAction)AddPicOnClick:(id)sender {
    UIView *addpic = [[UIView alloc]initWithFrame:CGRectMake(self.PEtableview.center.x-150, self.PEtableview.center.y-100, 300, 200)];
    addpic.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
    [self.PEtableview addSubview:addpic];
}
- (IBAction)AddChainOnClick:(id)sender {
    self.view.userInteractionEnabled = NO;
    
    
    
    //实例化一个view
    self.addchain =[[UIView alloc]init];
    self.addchain.frame = CGRectMake(self.PEtableview.center.x-150, self.PEtableview.center.y-100, 300, 300);
    self.addchain.backgroundColor = [UIColor whiteColor];
    [self.PEtableview addSubview:self.addchain];
    self.addchain.userInteractionEnabled=YES;
    //wailian
    UILabel *adchain = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 30)];
    adchain.text = @"添加外链";
    adchain.textColor = [UIColor redColor];
    adchain.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18];
    [self.addchain addSubview:adchain];
    //hongxian
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 300, 1)];
    [vi setBackgroundColor:[UIColor redColor]];
    [self.addchain   addSubview:vi];
    //wenzi
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 30, 30)];
    tlabel.text = @"文字";
    tlabel.textColor = [UIColor grayColor];
    tlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.addchain addSubview:tlabel];
    //qingshuru
    UITextField *ctfield = [[UITextField alloc ]initWithFrame:CGRectMake(80, 80, 200, 30)];
    ctfield.placeholder = @"请输入外联文字";
    ctfield.borderStyle = UITextBorderStyleNone;
    ctfield.textColor = [UIColor grayColor];
    ctfield.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.addchain addSubview:ctfield];
    //
    UIView *vi2 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, 300, 1)];
    vi2.backgroundColor = [UIColor grayColor];
    [self.addchain addSubview:vi2];
    //wenzi
    UILabel *wlabel = [[UILabel alloc]initWithFrame:CGRectMake(10,140, 30, 30)];
    wlabel.text = @"网址";
    wlabel.textColor = [UIColor grayColor];
    wlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.addchain addSubview:wlabel];
    //qingshuru
    UITextField *wtfield = [[UITextField alloc ]initWithFrame:CGRectMake(80, 140, 200, 30)];
    wtfield.placeholder = @"请输入外联网址";
    wtfield.borderStyle = UITextBorderStyleNone;
    wtfield.textColor = [UIColor grayColor];
    wtfield.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.addchain addSubview:wtfield];
    //
    UIView *vi3 = [[UIView alloc]initWithFrame:CGRectMake(0, 170, 300, 1)];
    vi3.backgroundColor = [UIColor grayColor];
    [self.addchain addSubview:vi3];
    UIButton *bt =  [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(125, 200, 50, 50);
    [bt setTitle:@"确定" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //点击进入函数
    [bt addTarget:self action:@selector(surea) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addchain addSubview:bt];
    
    
    

}

-(void)surea{
    self.addchain.hidden = YES;

    
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
