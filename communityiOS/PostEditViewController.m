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
#import "PostDetailViewController.h"


@interface PostEditViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addpic;
@property (weak, nonatomic) IBOutlet UITableView *PEtableview;//IBOutlet 表示该类是在xib中展示
@property(strong,nonatomic)FSCollectionview *fs;

@property (weak,nonatomic)NSString *ns;
@property (strong,nonatomic)UIView *addchain;
@property (strong,nonatomic)UIView *addpush;
@property (strong,nonatomic)UIView *addapply;
@property (strong,nonatomic)UIView *maskview;

@property (strong, nonatomic) UIPickerView *pickview;
@property (strong, nonatomic) TextTableViewCell *textcell;


@property (strong,nonatomic)NSMutableArray *forumSetList;//帖子设置数组
@property (strong,nonatomic)forumSetItem *forum_set_item;//帖子的设置


@property (strong,nonatomic) NSMutableArray *forum_id;
@property (strong,nonatomic) NSMutableArray *forum_name;

@property (strong,nonatomic)NSString *ISCHAIN;
@property (strong,nonatomic)NSString *ISAPPLY;
@property (strong,nonatomic)NSString *ISMAINIMG;


@property (strong,nonatomic)NSString *select_forum_id;//选择的版块id
@property (strong,nonatomic)NSString *select_forum_name;//选择的版块名称
@property (strong,nonatomic)NSIndexPath *select_row;
@property (strong,nonatomic)NSString *ISNEWPOST;
@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
@property (strong,nonatomic) NSArray *moderator;//版主版号




@end

NSString * const site_addchain = @"是否提供外链功能";
NSString * const site_addapply = @"是否提供报名功能";
NSString * const site_addmainimg=@"主帖是否包含主图";

NSString * const site_newpost_user = @"允许发帖的用户";

@implementation PostEditViewController
NSArray *activities_;
NSArray *feelings_;
NSArray *third_;



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
            if(![_ED_FLAG isEqualToString:@"0"]){
                cell.fslabel.text = _forum_item.forum_name;
            }
            
        }

        
        return cell;
       
      }else if (indexPath.row== 1 ) {
        TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"TitleTableViewCell" owner:nil options:nil]objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
                if([_ED_FLAG isEqualToString:@"2"]){
                    //编辑帖子
                   cell.Title.text = _post_item.title;
                    
                }

            }
        
        return cell;

    }else{
        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];

//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      //  cell.textview.delegate = self;
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"TextTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //flag如果是2，表示编辑原有帖子
            if([_ED_FLAG isEqualToString:@"2"]){
                //编辑帖子
                cell.textview.text = _post_item.post_text;
                
            }
//            cell.textview.placeholder = @"adsafadsaf";
//            NSLog(@"%@",cell.textview.placeholder);
        }
        return cell;

    }
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

        
        if([_ED_FLAG isEqualToString:@"0"]){

        //collectionview布局
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.minimumLineSpacing = 2;
        [flowlayout setItemSize:CGSizeMake(100, 40)];
        
        //初始化colletionview
        self.fs  = [[FSCollectionview alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, -50, 202, 200) collectionViewLayout:flowlayout];
            //传值
            self.fs.forum_id = self.forum_id;
            self.fs.forum_name = self.forum_name;
            self.fs.forum_list_item = _forum_list_item;
            self.fs.UserPermission = self.UserPermission;
            self.fs.moderator = self.moderator;
        self.fs.alpha = 0;

        
        self.fs.backgroundColor= [UIColor whiteColor];
       
        self.fs.dataSource = self.fs;
       self.fs.delegate = self.fs;
        //在collectionview注册collectionviewcell；
        [self.fs  registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell11"];

        [self.PEtableview addSubview:self.fs];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.fs.frame= CGRectMake(self.view.frame.size.width/2 - 100, 50, 202, 200) ;
            self.fs.alpha = 1;
            [self.fs.layer setCornerRadius:self.fs.frame.size.height/20];
        }];

            [self.fs getcelltext:indexPath:self.PEtableview];
            
            //获取选择的版块
//            NSMutableArray *select = [self.fs GetSelectedResult];
//            self.select_forum_id = [select objectAtIndex:1];
//            self.select_forum_name =[select objectAtIndex:2];
//            self.select_row = [select objectAtIndex:0];
                   
        }
            
    }
}

/*
 下面代码是设置pickerview
 
 */
//返回显示的列数
    
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

//返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==0){
        return [activities_ count];
    }else if(component==1){
        return [feelings_ count];
    }else
        return [third_ count];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component==0)
        return [activities_ objectAtIndex:row];
    
    else if(component==1){
        return [feelings_ objectAtIndex:row];
    }else
        return [third_ objectAtIndex:row];
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return 30.0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel * myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 30, 20)];
    
    myView.textAlignment = NSTextAlignmentCenter;
    
    
    myView.text = [activities_ objectAtIndex:row];
    
    //  myView.font = [UIFont systemFontOfSize:16];   //用label来设置字体大小
    
    myView.backgroundColor = [UIColor clearColor];
    
    myView.textColor = [UIColor redColor];
    
    
    return myView;
    
}







- (void)viewDidLoad {
    [super viewDidLoad];
    
    //直接从首页发新帖时，获取版块信息
    
    self.forum_id = [[NSMutableArray alloc]init];
    self.forum_name = [[NSMutableArray alloc]init];
    for(int j=0;j<[_forum_list_item count];j++){
        forumItem *fitem = [_forum_list_item objectAtIndex:j];
        [self.forum_id addObject:fitem.forum_id];
        [self.forum_name addObject:fitem.forum_name];
    }
    
    //获取当前用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.UserPermission = [defaults objectForKey:@"UserPermission"];
    self.moderator = [defaults objectForKey:@"moderator_of_forum_list"];
    
    
    self.PEtableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"发布话题";
//    TextTableViewCell *ttvc = [[TextTableViewCell alloc]init];
    
    //加导航栏右侧按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleBordered  target:self action:@selector(Tonextview)];
    self.navigationItem.rightBarButtonItem = rightItem;

    //设置username输入文本框的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification  object:nil];
    
    
    activities_=[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",
                 @"4",@"5",@"6",@"7",@"8",@"9", nil];
    feelings_=[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",
               @"4",@"5",@"6",@"7",@"8",@"9",nil];
    third_=[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",
            @"4",@"5",@"6",@"7",@"8",@"9",nil];
    //获取版块设置
    self.ISMAINIMG = @"N";
    self.ISAPPLY = @"N";
    self.ISCHAIN =@"N";

    self.ISNEWPOST = @"N";
    if(![_ED_FLAG isEqualToString:@"0"]){
        for(int i=0;i < [_forum_item.ForumSetlist count];i++){
            self.forum_set_item  = [forumSetItem createItemWitparametes:[_forum_item.ForumSetlist objectAtIndex:i]];
            if([self.forum_set_item.site_name isEqualToString:site_addapply]&&[self.forum_set_item.site_value isEqualToString:@"是"]){
                self.ISAPPLY = @"Y";
            }
            if ([self.forum_set_item.site_name isEqualToString:site_addchain]&&[self.forum_set_item.site_value isEqualToString:@"是"]) {
                self.ISCHAIN = @"Y";
            }
            if([self.forum_set_item.site_name isEqualToString:site_addmainimg]&&[self.forum_set_item.site_value isEqualToString:@"是"]){
                self.ISMAINIMG=@"Y";
            }
        }
    }
    //设置按钮是否显示
    if(![_ED_FLAG isEqualToString:@"0"]){
        if(![self.ISMAINIMG isEqualToString:@"Y"]){
            self.addpic.enabled = NO;
            // self.addpic.hidden = YES;
        }
        if(![self.ISCHAIN isEqualToString:@"Y"]){
            self.chain.enabled = NO;
            //  self.chain.hidden = YES;
        }
        if(![self.ISAPPLY isEqualToString:@"Y"]){
            self.apply.enabled = NO;
            //   self.apply.hidden = YES;
        }
        
        
    }
    
    [self.PEtableview reloadData];



}
-(void)Tonextview{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"tijiao" message:@"access" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex ==0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textDidChange:(NSNotification *)notification{
    
    
}
- (IBAction)AddPicOnClick:(id)sender {
    UIView *addpic = [[UIView alloc]initWithFrame:CGRectMake(self.PEtableview.center.x-150, self.PEtableview.center.y-100, 300, 220)];
    addpic.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
    [self.PEtableview addSubview:addpic];
}
- (IBAction)AddChainOnClick:(id)sender {
//    self.PEtableview.userInteractionEnabled = NO;
    
    self.maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.maskview.backgroundColor = [UIColor blackColor];
    self.maskview.alpha = 0.3;
    [self.view addSubview:self.maskview];
    
    
    self.addchain =[[UIView alloc]init];
    
    self.addchain.frame = CGRectMake(self.PEtableview.center.x-150, self.view.frame.size.height+100, 300, 220);
    self.addchain.alpha  = 0;
    self.addchain.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addchain];
    //实例化一个view
    [UIView animateWithDuration:0.5 animations:^{
        self.addchain.alpha = 1;
         self.addchain.frame = CGRectMake(self.PEtableview.center.x-150, self.PEtableview.center.y-110, 300, 220);
        [self.addchain.layer setCornerRadius:self.addchain.frame.size.height/20];
    }];
   
    
    
    
    //wailian
    UILabel *adchain = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 30)];
    
    adchain.text = @"添加外链";
    adchain.textColor = [UIColor redColor];
    adchain.font = [UIFont fontWithName:@"STHeitiTC-Light" size:20];
    [self.addchain addSubview:adchain];
    //hongxian
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 300, 1)];
    [vi setBackgroundColor:[UIColor redColor]];
    [self.addchain   addSubview:vi];
    //wenzi
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
    tlabel.text = @"文字";
    tlabel.textColor = [UIColor grayColor];
    tlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18];
    [self.addchain addSubview:tlabel];
    //qingshuru
    UITextField *ctfield = [[UITextField alloc ]initWithFrame:CGRectMake(80, 80, 200, 30)];
    ctfield.placeholder = @"请输入外联文字";
    ctfield.borderStyle = UITextBorderStyleNone;
    ctfield.textColor = [UIColor grayColor];
    ctfield.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18];
    [self.addchain addSubview:ctfield];
    //
    UIView *vi2 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, 300, 1)];
    vi2.backgroundColor = [UIColor grayColor];
    [self.addchain addSubview:vi2];
    //wenzi
    UILabel *wlabel = [[UILabel alloc]initWithFrame:CGRectMake(10,140, 100, 30)];
    wlabel.text = @"网址";
    wlabel.textColor = [UIColor grayColor];
    wlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18];
    [self.addchain addSubview:wlabel];
    //qingshuru
    UITextField *wtfield = [[UITextField alloc ]initWithFrame:CGRectMake(80, 140, 200, 30)];
    wtfield.placeholder = @"请输入外联网址";
    wtfield.borderStyle = UITextBorderStyleNone;
    wtfield.textColor = [UIColor grayColor];
    wtfield.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18];
    [self.addchain addSubview:wtfield];
    //
    UIView *vi3 = [[UIView alloc]initWithFrame:CGRectMake(0, 170, 300, 1)];
    vi3.backgroundColor = [UIColor grayColor];
    [self.addchain addSubview:vi3];
    UIButton *bt =  [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(125, 170, 50, 50);
    [bt setTitle:@"确定" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //点击进入函数
    [bt addTarget:self action:@selector(surea) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addchain addSubview:bt];
    
    
    

}
//点击推送按钮
- (IBAction)AddPushOnClick:(id)sender {
    
    self.maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.maskview.backgroundColor = [UIColor blackColor];
    self.maskview.alpha = 0.3;
    [self.view addSubview:self.maskview];
    
    

    
    //实例化一个view
    self.addpush =[[UIView alloc]init];
    self.addpush.frame = CGRectMake(self.PEtableview.center.x-150, self.view.frame.size.height, 300, 220);
    self.addpush.alpha = 0;
    self.addpush.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.addpush.alpha = 1;
        self.addpush.frame = CGRectMake(self.PEtableview.center.x-150, self.PEtableview.center.y-110, 300, 220);
        [self.addpush.layer setCornerRadius:self.addpush.frame.size.height/20];
    }];
    
    
    [self.view addSubview:self.addpush];
    
    
    
    //tuisong
    UILabel *adpush = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 30)];
    adpush.text = @"推送";
    adpush.textColor = [UIColor redColor];
    adpush.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18];
    [self.addpush addSubview:adpush];
    //hongxian
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 300, 1)];
    [vi setBackgroundColor:[UIColor redColor]];
    [self.addpush   addSubview:vi];
    //wenzi
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 130, 30)];
    tlabel.text = @"首页轮播图推送";
    tlabel.textColor = [UIColor grayColor];
    tlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.addpush addSubview:tlabel];
    //swich
    UISwitch *picswitch = [[UISwitch alloc ]initWithFrame:CGRectMake(220, 70, 30, 30)];
    [self.addpush addSubview:picswitch];
    //
    UIView *vi2 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, 300, 1)];
    vi2.backgroundColor = [UIColor grayColor];
    [self.addpush addSubview:vi2];
    //wenzi
    UILabel *wlabel = [[UILabel alloc]initWithFrame:CGRectMake(10,130, 130, 30)];
    wlabel.text = @"手机通知推送";
    wlabel.textColor = [UIColor grayColor];
    wlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.addpush addSubview:wlabel];
    //swich
    UISwitch *notiswitch = [[UISwitch alloc ]initWithFrame:CGRectMake(220, 130, 30, 30)];
    [self.addpush addSubview:notiswitch];

    //
    UIView *vi3 = [[UIView alloc]initWithFrame:CGRectMake(0, 170, 300, 1)];
    vi3.backgroundColor = [UIColor grayColor];
    [self.addpush addSubview:vi3];
    UIButton *bt =  [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(125, 170, 50, 50);
    [bt setTitle:@"确定" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //点击进入函数
    [bt addTarget:self action:@selector(sureb) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addpush addSubview:bt];

    
}

//点击报名按钮
- (IBAction)AddApplyOnClick:(id)sender {
    //实例化一个view
    self.maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.maskview.backgroundColor = [UIColor blackColor];
    self.maskview.alpha = 0.3;
    [self.view addSubview:self.maskview];

    self.addapply =[[UIView alloc]init];
    self.addapply.frame = CGRectMake(self.PEtableview.center.x-150, self.view.frame.size.height+100, 300, 330);
    self.addapply.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.addapply.frame = CGRectMake(self.PEtableview.center.x-150, self.PEtableview.center.y-165, 300, 330);
        self.addapply.alpha = 1;
        [self.addapply.layer setCornerRadius:self.addapply.frame.size.height/20 ];
    }];
    self.addapply.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addapply];
    
    
    
    //baoming
    UILabel *adpush = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 30)];
    adpush.text = @"报名";
    adpush.textColor = [UIColor redColor];
    adpush.font = [UIFont fontWithName:@"STHeitiTC-Light" size:18];
    [self.addapply addSubview:adpush];
    //hongxian
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 300, 1)];
    [vi setBackgroundColor:[UIColor redColor]];
    [self.addapply   addSubview:vi];
    //wenzi
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 130, 30)];
    tlabel.text = @"开通报名";
    tlabel.textColor = [UIColor grayColor];
    tlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.addapply addSubview:tlabel];
    //swich
    UISwitch *applyswitch = [[UISwitch alloc ]initWithFrame:CGRectMake(220, 70, 30, 30)];
    [self.addapply addSubview:applyswitch];
    //
    UIView *vi2 = [[UIView alloc]initWithFrame:CGRectMake(0, 110, 300, 1)];
    vi2.backgroundColor = [UIColor grayColor];
    [self.addapply addSubview:vi2];
    //wenzi
    UILabel *wlabel = [[UILabel alloc]initWithFrame:CGRectMake(10,180, 130, 30)];
    wlabel.text = @"人数限制";
    wlabel.textColor = [UIColor grayColor];
    wlabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:14];
    [self.addapply addSubview:wlabel];
    //pick
    self.pickview = [[UIPickerView alloc]initWithFrame:CGRectMake(170, 120, 130, 80)];
    self.pickview.delegate = self;
    self.pickview.dataSource = self;
    
    [self.addapply addSubview:self.pickview];
    
    
    
    //
    UIView *vi3 = [[UIView alloc]initWithFrame:CGRectMake(0, 280, 300, 1)];
    vi3.backgroundColor = [UIColor grayColor];
    [self.addapply addSubview:vi3];
    UIButton *bt =  [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(125, 280, 50, 50);
    [bt setTitle:@"确定" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //点击进入函数
    [bt addTarget:self action:@selector(surec) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addapply addSubview:bt];

    
    
}


-(void)surea{
    
        self.addchain.hidden = YES;
    [self.maskview removeFromSuperview];
   
}
-(void)sureb{

    self.addpush.hidden = YES;
    [self.maskview removeFromSuperview];
}
-(void)surec{
    
    self.addapply.hidden = YES;
    [self.maskview removeFromSuperview];
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
