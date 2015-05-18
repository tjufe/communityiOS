//
//  PostEditViewController.m
//  communityiOS
//
//  Created by tjufe on 15/3/31.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "PostEditViewController.h"
#import "TitleTableViewCell.h"
//#import "ImageTableViewCell.h"
#import "PostImageTableViewCell.h"
#import "TextTableViewCell.h"
#import "ChainTableViewCell.h"
#import "PushTableViewCell.h"
#import "SaveTableViewCell.h"
#import "ForumSelectTableViewCell.h"
#import "DialogView.h"
#import "FSCollectionview.h"
#import "PostDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "StatusTool.h"


@interface PostEditViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *PEtableview;//IBOutlet 表示该类是在xib中展示
@property(strong,nonatomic)FSCollectionview *fs;

@property (weak,nonatomic)NSString *ns;
@property (strong,nonatomic)UIView *addchain;
@property (strong,nonatomic)UIView *addpush;
@property (strong,nonatomic)UIView *addapply;
@property (strong,nonatomic)UIView *maskview;
@property (nonatomic ,strong) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIPickerView *pickview;
@property (strong, nonatomic) TextTableViewCell *textcell;


@property (strong,nonatomic)NSMutableArray *forumSetList;//帖子设置数组
@property (strong,nonatomic)forumSetItem *forum_set_item;//帖子的设置

@property (strong,nonatomic) NSMutableArray *select_forum;//允许选择发帖的版块

@property (strong,nonatomic)NSString *ISCHAIN;
@property (strong,nonatomic)NSString *ISAPPLY;
@property (strong,nonatomic)NSString *ISMAINIMG;
@property (strong,nonatomic)NSString *ISCHECK;
//@property (strong,nonatomic)NSString *ISNEWPOST;


@property (strong,nonatomic)NSString *select_forum_id;//选择的版块id
@property (strong,nonatomic)NSString *select_forum_name;//选择的版块名称
@property (strong,nonatomic)NSIndexPath *select_row;



@property (strong,nonatomic) NSString *UserPermission;//当前用户身份
@property (strong,nonatomic) NSString *userID;//
@property (strong,nonatomic) NSString *communityID;
@property (strong,nonatomic) NSArray *moderator;//版主版号
@property (weak,nonatomic)NSString *alert_flag;


//@property (strong,nonatomic) UIImage *select_image;//选择上传的图片
//@property (strong,nonatomic) NSString *select_image_name;//上传后图片的名字
//@property (strong,nonatomic) NSString *select_chain;//上传的外链状态
//@property (strong,nonatomic) NSString *select_chain_context;//上传的外链内容
//@property (strong,nonatomic) NSString *select_chain_address;//上传的外链地址
//@property (strong,nonatomic) NSString *select_open_apply;//上传的是否报名
//@property (strong,nonatomic) NSString *select_limit_apply_num;//上传的报名人数限制
//@property (strong,nonatomic) NSString *select_post_title;//上传的帖子标题
//@property (strong,nonatomic) NSString *select_post_text;//上传的帖子内容
//@property (strong,nonatomic) NSString *select_need_check;//上传的帖子是否需要审核
//@property (strong,nonatomic) NSString *select_checked;//上传的帖子审核状态
@property (strong,nonatomic) NSMutableDictionary *inputArray;//用来存放输入的控件

@end

NSString * const site_addchain = @"是否提供外链功能";
NSString * const site_addapply = @"是否提供报名功能";
NSString * const site_addmainimg=@"主帖是否包含主图";
NSString * const site_isreply = @"是否允许回帖";
NSString * const site_newpost_user = @"允许发帖的用户";
NSString * const site_ischeck= @"是否需要审核";
NSString * const site_isbrowse= @"允许查看帖子的用户";

@implementation PostEditViewController
NSArray *activities_;
NSArray *feelings_;
NSArray *third_;
NSString *num1 ;
NSString *num2 ;
NSString *num3 ;


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row== 0 ) {
        ForumSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            
        
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"ForumSelectTableViewCell" owner:nil options:nil]objectAtIndex:0];
        }
            if(![_ED_FLAG isEqualToString:@"0"]){
                cell.fslabel.text = _forum_item.forum_name;
            }
            else{
                if(self.fs.select_forum_name){
                    cell.fslabel.text =self.fs.select_forum_name;
                }
            
            
        }

        
        return cell;
       
      }else if (indexPath.row== 1 ) {
        TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
//          TitleTableViewCell *cell;
        
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"TitleTableViewCell" owner:nil options:nil]objectAtIndex:0];
            }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
          cell.Title.delegate = self;
                if([_ED_FLAG isEqualToString:@"2"]){
                    //编辑帖子
                   cell.Title.text = _post_item.title;
                    
                }else{
                    cell.Title.text = self.select_post_title;
                }
          

          
        
        return cell;

    }else if(indexPath.row==2){
        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];

//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      //  cell.textview.delegate = self;
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"TextTableViewCell" owner:nil options:nil]objectAtIndex:0];
        }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //flag如果是2，表示编辑原有帖子
            if([_ED_FLAG isEqualToString:@"2"]){
                //编辑帖子
                cell.textview.text = _post_item.post_text;
            }
        
//            }else{
//                cell.textview.text = self.select_post_text;
//            }

        
        return cell;

    }else{
        PostImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PostImageTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            }
            //编辑原帖
            if([_ED_FLAG isEqualToString:@"2"]){
                
            }else{
                //添加长按手势
                UILongPressGestureRecognizer*lp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImage)];
                cell.MainImage.userInteractionEnabled=YES;
                [cell.MainImage addGestureRecognizer:lp];
            //    if(self.select_image!=nil)
                    cell.MainImage.image = self.select_image;
                if([self.fs.ISMAINIMG1 isEqualToString:@"N"]){
                    cell.MainImage.hidden = YES;
                }else{
                    cell.MainImage.hidden = NO;
                }
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
    //    return self.PEtableview.frame.size.height - 160;
        return 150;
    }else if(indexPath.row ==3){
        return 150;
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
        self.fs.select_forum = self.select_forum;
        self.fs.Addpic = self.addpic;
        self.fs.Apply = self.apply;
        self.fs.Chain = self.chain;
           

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

//            

            
        }

    }
}

#pragma mark-----title
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.select_post_title = textField.text;
    //显示在UI中
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark----text
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.select_post_text = textView.text;
    //显示在UI中
    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)textViewDidChange:(UITextView *)textView
{
    self.select_post_text = textView.text;
    //显示在UI中
    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark----长按图片
-(void)deleteImage{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除图片？" message:@"您确定删除该图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    self.alert_flag = @"delete_img";

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
//获取选中的
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if(component==0){
        num1 = [activities_ objectAtIndex:row];
    }else if (component==1){
        num2 = [feelings_ objectAtIndex:row];
    }else{
        num3 = [third_ objectAtIndex:row];
    }
    
    
}

#pragma mark-------UIImagePickerViewController  delegate 20150514 lx
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获得编辑过的图片
    UIImage* chosenImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    self.select_image = chosenImage;
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
    //显示在UI中
    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
   // [self.PEtableview reloadData];
    //上传图片
    [self uploadinitWithImage:chosenImage];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark--------------上传图片
-(void)uploadinitWithImage:(UIImage *)image{
    
    NSURL *baseUrl = [NSURL URLWithString:@"http://192.168.1.109/sq/upload_topic_pic.php"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:@"" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //上传时使用当前的系统事件作为文件名
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"uploadfile" fileName:fileName mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //上传图片后获取的图片名字
        self.select_image_name = [NSString stringWithFormat:@"%@.jpg",(NSString *)responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    self.select_image = [[UIImage alloc]init];
    self.select_open_apply = [[NSString alloc]init];
    self.select_open_apply = @"否";
    self.select_limit_apply_num = [[NSString alloc]init];
    self.select_limit_apply_num = @"0";
    self.select_chain = [[NSString alloc]init];
    self.select_chain = @"否";
    self.select_need_check = [[NSString alloc]init];
    self.select_need_check = @"是";
    self.select_checked = [[NSString alloc]init];
    self.select_checked = @"否";
    self.inputArray = [[NSMutableDictionary alloc]init];
    //获取当前用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.UserPermission = [defaults objectForKey:@"UserPermission"];
    self.moderator = [defaults objectForKey:@"moderator_of_forum_list"];

    self.communityID = [defaults objectForKey:@"CommunityID"];
    self.userID = [defaults objectForKey:@"UserID"];

    
    //直接从首页发新帖时，获取版块信息
    if([_ED_FLAG isEqualToString:@"0"]){
    self.select_forum = [[NSMutableArray alloc]init];
    [self getForumList];
    }
    
    self.PEtableview.separatorStyle = UITableViewCellSeparatorStyleNone;//取消下划
    // Do any additional setup after loading the view.
    if([_ED_FLAG isEqualToString:@"2"]){
        self.navigationItem.title = @"编辑话题";
    }else{
        self.navigationItem.title = @"发布话题";
    }
//    TextTableViewCell *ttvc = [[TextTableViewCell alloc]init];
    
    //加导航栏右侧按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleBordered  target:self action:@selector(NewPost2Web)];
    self.navigationItem.rightBarButtonItem = rightItem;

    //设置username输入文本框的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification  object:nil];
    
    
    activities_=[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",
                 @"4",@"5",@"6",@"7",@"8",@"9", nil];
    feelings_=[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",
               @"4",@"5",@"6",@"7",@"8",@"9",nil];
    third_=[[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",
            @"4",@"5",@"6",@"7",@"8",@"9",nil];
    
    num1 = @"0";
    num2 = @"0";
    num3 = @"0";
    
    //设置按钮是否显示
    if(![_ED_FLAG isEqualToString:@"0"]){
        
        //获取版块设置
        [self check];
        [self initUIButton];
        
    }
    
    [self.PEtableview reloadData];



}


#pragma mark-------获取版块设置
-(void)check{
    //获取版块设置
    self.ISMAINIMG = @"N";
    self.ISAPPLY = @"N";
    self.ISCHAIN =@"N";

    //    self.ISNEWPOST = @"N";
        if(_forum_item.ForumSetlist!=nil){
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
    

}


#pragma mark-------设置按钮是否显示
-(void)initUIButton{
    if(![self.ISMAINIMG isEqualToString:@"Y"]){
        self.addpic.enabled = NO;
        self.addpic.hidden = YES;
    }
    if(![self.ISCHAIN isEqualToString:@"Y"]){
        self.chain.enabled = NO;
        self.chain.hidden = YES;
    }
    if(![self.ISAPPLY isEqualToString:@"Y"]){
        self.apply.enabled = NO;
        self.apply.hidden = YES;
    }

}

#pragma mark-------获取可以允许发帖的版块
-(void)getForumList{
    //判断当前用户选择的版块能否发帖
    NSString *user_status = @"/";
    user_status = [user_status stringByAppendingString:self.UserPermission];
        for(int j=0;j<[_forum_list_item count];j++){
            forumItem *fitem = [_forum_list_item objectAtIndex:j];
            if(fitem.ForumSetlist!=nil){
                for(int m=0;m<[fitem.ForumSetlist count];m++){
                    forumSetItem *fs_item = [forumSetItem createItemWitparametes:[fitem.ForumSetlist objectAtIndex:m]];
                    
                    if ([fs_item.site_name isEqualToString:site_newpost_user]) {
                        
                        //版块设置值
                        if([fs_item.site_value rangeOfString:user_status].location!=NSNotFound){
                            [self.select_forum addObject:fitem];
                            break;
                        }
                        
                        //版主
                        if(self.moderator!=nil){
                            for(int m=0;m<[self.moderator count];m++){
                                if([[self.moderator objectAtIndex:m] isEqualToString:fitem.forum_id]){
                                    [self.select_forum addObject:fitem];
                                    break;
                                }
                                
                            }
                        }
                        break;
                    }
                }
            }

        }

}

#pragma mark------发帖 20150515 lx
-(void)NewPost2Web{
    
    if([_ED_FLAG isEqualToString:@"0"]){//首页直接发帖
        
        //报名
        if(![self.fs.ISAPPLY1 isEqualToString:@"Y"]){
            self.select_open_apply = @"否";
            self.select_limit_apply_num = @"";
        }
//        if(!self.select_open_apply){
//             self.select_open_apply = @"否";
//        }
        if([self.select_limit_apply_num isEqualToString:@"0"]){
            self.select_limit_apply_num = @"";
        }
        //外链
        if(![self.fs.ISCHAIN1 isEqualToString:@"Y"]){
            self.select_chain = @"否";
            self.select_chain_address = @"";
            self.select_chain_context = @"";
        }
        if(!self.select_chain_context){
            self.select_chain = @"否";
            self.select_chain_address = @"";
            self.select_chain_context = @"";
        }else{
            self.select_chain = @"是";
            if(!self.select_chain_address)
                self.select_chain_address=@"";
        }
        //审核
        if([self.fs.ISCHECK1 isEqualToString:@"Y"]){
            self.select_need_check = @"是";
            self.select_checked = @"否";
        }else{
            self.select_need_check = @"否";
            self.select_checked = @"是";
        }
        //图片
        if(!self.select_image_name){
            self.select_image_name = @"";
        }
        self.select_forum_id = self.fs.select_forum_id;
        if(!self.select_forum_id){
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"请选择版块！";
            hud.dimBackground = YES;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            }completionBlock:^{
                [hud removeFromSuperview];
            }];

        }else{
        
    //    TitleTableViewCell *cell = [self.PEtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    //    self.select_post_title = cell.Title.text;
        if([self.select_post_title isEqualToString:@""]){
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"标题不能为空！";
            hud.dimBackground = YES;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            }completionBlock:^{
                [hud removeFromSuperview];
            }];

        }else{
            TextTableViewCell *cell = [self.PEtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            self.select_post_text = cell.textview.text;
            
            [StatusTool statusToolNewPostWithcID:self.communityID fID:self.select_forum_id PosterID:self.userID postTitle:self.select_post_title postText:self.select_post_text imgURL:self.select_image_name chain:self.select_chain chainName:self.select_chain_context chainURL:self.select_chain_address apply:self.select_open_apply limApplyNum:self.select_limit_apply_num needCheck:self.select_need_check Checked:self.select_checked Success:^(id object) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发布成功！" message:@"请耐心等待审核..." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                alert.delegate = self;
                [alert show];
                self.alert_flag = @"s";
            } failurs:^(NSError *error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"发布失败！" message:@"请稍后再试..." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                 [alert show];
                self.alert_flag = @"f";
            }];
        }
        }
        
    }
    
    
    
    
    
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex ==0) {
        if([self.alert_flag isEqualToString:@"s"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        self.select_image = nil;
        self.select_image_name = @"";
        //显示在UI中
        NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
        NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
        //刷新指定行
        [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textDidChange:(NSNotification *)notification{
    
    
}
- (IBAction)AddPicOnClick:(id)sender {
//    UIView *addpic = [[UIView alloc]initWithFrame:CGRectMake(self.PEtableview.center.x-150, self.PEtableview.center.y-100, 300, 220)];
//    addpic.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
//    [self.PEtableview addSubview:addpic];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self presentModalViewController:self.imagePicker animated:YES];

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
    //放入控件
    [self.inputArray setObject:ctfield forKey:@"ChainContext"];
    
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
    
    [self.inputArray setObject:wtfield forKey:@"ChainAddress"];
    
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
//    [applyswitch addTarget:self action:@selector(onChange) forControlEvents: UIControlEventValueChanged];
    //放入控件
    [self.inputArray setObject:applyswitch forKey:@"Apply"];
    num1 = @"0";
    num2 = @"0";
    num3 = @"0";
    //设置初始开关状态
    if([self.select_open_apply isEqualToString:@"是"]){
            [applyswitch setOn:YES];
    }else{
        [applyswitch setOn:NO];
    }
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

//-(void)onChange{
//    UISwitch *switch1 = [self.inputArray valueForKey:@"Apply"];
//     [[NSUserDefaults standardUserDefaults]setBool:switch1.on forKey:@"didRember"];
//}


#pragma mark------添加外连确定 20150515 lx
-(void)surea{
    
    
    //获取输入值
    UITextField *chainName= [self.inputArray valueForKey:@"ChainContext"];
    UITextField *chainText = [self.inputArray valueForKey:@"ChainAddress"];
    if([chainName.text isEqualToString:@""]
        &&![chainText.text isEqualToString:@""]){
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"外链文字不能为空！";
        hud.dimBackground = YES;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        }completionBlock:^{
            [hud removeFromSuperview];
        }];
    }else{
        self.addchain.hidden = YES;
        [self.maskview removeFromSuperview];
        self.select_chain_address = chainText.text;
        self.select_chain_context = chainName.text;
        if(!self.select_chain_context){
            self.select_chain = @"否";
            self.select_chain_address = @"";
            self.select_chain_context = @"";
        }else{
            self.select_chain = @"是";
            if(!self.select_chain_address){
                self.select_chain_address = @"";
            }
        }
    }
   
   
}
-(void)sureb{

    self.addpush.hidden = YES;
    [self.maskview removeFromSuperview];
}

#pragma mark------添加报名确定 20150515 lx
-(void)surec{
    
    
    //获取输入的报名人数参数值
    UISwitch *apply = [self.inputArray valueForKey:@"Apply"];
    //获取报名数
    if(![num1 isEqualToString:@"0"]){
        self.select_limit_apply_num = [NSString stringWithFormat:@"%@%@%@",num1,num2,num3];
    }else{
        if(![num2 isEqualToString:@"0"]){
            self.select_limit_apply_num = [NSString stringWithFormat:@"%@%@",num2,num3];
            
        }else{
            
                self.select_limit_apply_num = num3;
            }
    }
    //判断是否开通
    if(apply.on&&[self.select_limit_apply_num isEqualToString:@"0"]){
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"限制报名人数不能为空！";
        hud.dimBackground = YES;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        }completionBlock:^{
            [hud removeFromSuperview];
        }];

    }else{
        self.addapply.hidden = YES;
        [self.maskview removeFromSuperview];
        
        if(apply.on){
            self.select_open_apply = @"是";
        }else{
            self.select_open_apply = @"否";
            self.select_limit_apply_num = @"";
        }
    }
  //  NSLog(@"^^^^%@",self.select_limit_apply_num);
  //  NSLog(@"^^^^%@",self.select_open_apply);
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
