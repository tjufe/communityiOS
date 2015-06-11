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
#import "APIAddress.h"
#import "ViewController.h"
#import "newPostItem.h"
#import "editPostItem.h"
#import "PostListViewController.h"
#import "EditApplyTableViewCell.h"
#import "EditChainTableViewCell.h"
#import "UIViewController+Create.h"
#import "UIImageView+WebCache.h"//加载图片
#import "AppDelegate.h"

#define kANimationDuration 0.2 //动画时间


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
@property (strong,nonatomic) UIBarButtonItem *rightItem;//导航条右侧按钮

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

@property (strong,nonatomic) NSString *select_post_id;//修改的帖子id
@property (strong,nonatomic) NSString *select_poster_id;//修改的帖子的发帖人id
@property (strong,nonatomic) UIImage *select_image;//选择上传的图片
@property (strong,nonatomic) NSString *select_image_name;//上传后图片的名字
@property (strong,nonatomic) NSString *select_chain;//上传的外链状态
@property (strong,nonatomic) NSString *select_chain_context;//上传的外链内容
@property (strong,nonatomic) NSString *select_chain_address;//上传的外链地址
@property (strong,nonatomic) NSString *select_open_apply;//上传的是否报名
@property (strong,nonatomic) NSString *select_limit_apply_num;//上传的报名人数限制
@property (strong,nonatomic) NSString *select_post_title;//上传的帖子标题
@property (strong,nonatomic) NSString *select_post_text;//上传的帖子内容
@property (strong,nonatomic) NSString *select_need_check;//上传的帖子是否需要审核
@property (strong,nonatomic) NSString *select_checked;//上传的帖子审核状态
@property (strong,nonatomic) NSMutableDictionary *inputArray;//用来存放输入的控件
@property (strong,nonatomic) UITextField *title_tf;
@property (strong,nonatomic) UITextView *text_tv;




@end

NSString * const site_addchain = @"是否提供外链功能";
NSString * const site_addapply = @"是否提供报名功能";
NSString * const site_addmainimg=@"主帖是否包含主图";
NSString * const site_isreply = @"是否允许回帖";
NSString * const site_newpost_user = @"允许发帖的用户";
NSString * const site_ischeck= @"是否需要审核";
NSString * const site_isbrowse= @"允许查看帖子的用户";
NSString * const site_reply_user = @"允许回帖的用户";

@implementation PostEditViewController
NSArray *activities_;
NSArray *feelings_;
NSArray *third_;
NSString *num1 ;
NSString *num2 ;
NSString *num3 ;
float cellHeight = 1000;
bool edit;


#pragma mark------当点击view的区域就会触发这个事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    select_forum_dropdown_isonshowing = NO;
        if (indexPath.row== 0 ) {
//        ForumSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            ForumSelectTableViewCell *cell ;
        
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
//        TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
          TitleTableViewCell *cell ;
          edit = true;
        
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"TitleTableViewCell" owner:nil options:nil]objectAtIndex:0];
            }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor colorWithRed:222.0/255 green:222.0/255 blue:222.0/255 alpha:1];
          self.title_tf = cell.Title;
          cell.Title.delegate = self;
          //      if([_ED_FLAG isEqualToString:@"2"]){
                    //编辑帖子
                   cell.Title.text = self.select_post_title;
                    
 //               }else{
 //                   cell.Title.text = self.select_post_title;
 //               }
          

          
        
        return cell;

    }else if(indexPath.row==2){
        //        TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!self.textcell) {
            self.textcell= [[[NSBundle mainBundle]loadNibNamed:@"TextTableViewCell" owner:nil options:nil]objectAtIndex:0];
            self.textcell.textview.delegate = self;
            self.textcell.textview.scrollEnabled = NO;
            self.textcell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.textcell.textview.delegate = self;
            self.text_tv = self.textcell.textview;
            //定义一个toolBar
            UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
            //设置style
            [topView setBarStyle:UIBarStyleDefault];
            
            //定义两个flexibleSpace的butto，放在toolbar上，这样完成按钮就会在最右边
            UIBarButtonItem * btn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem * btn2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            
            //定义完成按钮
            UIBarButtonItem *donebtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
            
            //在toolBar上加上这些按钮
            NSArray *btnArray = [NSArray arrayWithObjects:btn1,btn2,donebtn,nil];
            [topView setItems:btnArray];
            
            
            [self.textcell.textview setInputAccessoryView:topView];
            
            
            
            
            //flag如果是2，表示编辑原有帖子
            if([_ED_FLAG isEqualToString:@"2"]){
                //编辑帖子

                self.textcell.textview.text = self.select_post_text;
                if([self.select_post_text isEqualToString:@""]||self.select_post_text==nil){
                     self.textcell.textview.text = @"请输入内容";
                }
                
                
            }else{
                if( self.textcell.textview.text!=nil&& ![self.textcell.textview.text isEqualToString:@"请输入内容"]){
                     self.textcell.textview.text = self.select_post_text;
                }
            }
            //               else{
            //                if(![self.select_post_text isEqualToString:@""]){
            //                self.textcell.textview.text = self.select_post_text;
            //                }
            //            }
            
            //   cellHeight = self.textcell.textview.frame.size.height;
        }

        return self.textcell;

    }else if(indexPath.row==3){
//        PostImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        PostImageTableViewCell *cell;
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PostImageTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            }
            //编辑原帖
            if([_ED_FLAG isEqualToString:@"2"]){
                NSString *img_url = [NSString stringWithFormat:@"%@/topicpic/%@",API_HOST,self.select_image_name];
                
                //包含中文字符的string转换为nsurl
                NSURL *iurl = [NSURL URLWithString:[img_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                if([self.select_image_name isEqualToString:@""] ||[self.select_image_name isEqualToString:@"''"]){
                    if(!self.select_image){
                    cell.MainImage.hidden = YES;
                    }else{
                        cell.MainImage.hidden = NO;
                        cell.MainImage.image = self.select_image;
                    }
                }else{
                    cell.MainImage.hidden = NO;
                    [cell.MainImage sd_setImageWithURL:iurl placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        cell.MainImage.image = image;
                    }];
                    
                }
                
            }else{
               
            //    if(self.select_image!=nil)
                    cell.MainImage.image = self.select_image;
                if([_ED_FLAG isEqualToString:@"0"]){
                if([self.fs.ISMAINIMG1 isEqualToString:@"N"]){
                    cell.MainImage.hidden = YES;
                }else{
                    cell.MainImage.hidden = NO;
                }
                }
            }
    //    cell.MainImage.contentMode=UIViewContentModeScaleAspectFill;
        //添加长按手势
    //    UILongPressGestureRecognizer*lp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImage)];
        cell.MainImage.userInteractionEnabled=YES;
    //    [cell.MainImage addGestureRecognizer:lp];
        
        
        return cell;
    }else if (indexPath.row==4){
//        EditChainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        EditChainTableViewCell *cell;
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EditChainTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        cell.chainName.text = self.select_chain_context;
        cell.chainUrl.text = self.select_chain_address;
        if ([_ED_FLAG isEqualToString:@"0"]) {
            if(self.fs){
            if([self.fs.ISCHAIN1 isEqualToString:@"N"]){
                cell.chainName.hidden = YES;
                cell.chainNameLab.hidden = YES;
                cell.chainUrl.hidden = YES;
                cell.chainUrlLab.hidden = YES;
            }else{
                if([self.select_chain isEqualToString:@"是"]){
                    if(self.select_chain_context!=nil&&![self.select_chain_context isEqualToString:@""]){
                       cell.chainName.hidden =NO;
                       cell.chainNameLab.hidden = NO;
                       cell.chainUrl.hidden = NO;
                       cell.chainUrlLab.hidden = NO;
                    }
                }else{
                    cell.chainName.hidden = YES;
                    cell.chainNameLab.hidden = YES;
                    cell.chainUrl.hidden = YES;
                    cell.chainUrlLab.hidden = YES;

                }
            }
            }else{
                if([self.select_chain isEqualToString:@"是"]){
                  if(self.select_chain_context!=nil&&![self.select_chain_context isEqualToString:@""]){
                    cell.chainName.hidden =NO;
                    cell.chainNameLab.hidden = NO;
                    cell.chainUrl.hidden = NO;
                    cell.chainUrlLab.hidden = NO;
                  }
                }else{
                    cell.chainName.hidden = YES;
                    cell.chainNameLab.hidden = YES;
                    cell.chainUrl.hidden = YES;
                    cell.chainUrlLab.hidden = YES;
                    
                }
            }
        }else{
            if([self.select_chain isEqualToString:@"是"]){
                cell.chainName.hidden =NO;
                cell.chainNameLab.hidden = NO;
                cell.chainUrl.hidden = NO;
                cell.chainUrlLab.hidden = NO;
            }else{
                cell.chainName.hidden = YES;
                cell.chainNameLab.hidden = YES;
                cell.chainUrl.hidden = YES;
                cell.chainUrlLab.hidden = YES;
                
            }

        }
        return cell;
    }else{
//        EditApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        EditApplyTableViewCell *cell;
        if(!cell){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EditApplyTableViewCell" owner:nil options:nil]objectAtIndex:0];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
        }
        cell.limitApplyNum.text = self.select_limit_apply_num;
        
        if([_ED_FLAG isEqualToString:@"0"]){
            if(self.fs){
            if([self.fs.ISAPPLY1 isEqualToString:@"N"]){
                cell.limitApplyNum.hidden = YES;
                cell.limitApplyNumLab.hidden = YES;
            }else{
                if([self.select_open_apply isEqualToString:@"是"]&&self.select_limit_apply_num){
                    cell.limitApplyNum.hidden = NO;
                    cell.limitApplyNumLab.hidden = NO;
                }else{
                    cell.limitApplyNum.hidden = YES;
                    cell.limitApplyNumLab.hidden = YES;
 
                }
            }
            }else{
                if([self.select_open_apply isEqualToString:@"是"]&&self.select_limit_apply_num){
                    cell.limitApplyNum.hidden = NO;
                    cell.limitApplyNumLab.hidden = NO;
                }else{
                    cell.limitApplyNum.hidden = YES;
                    cell.limitApplyNumLab.hidden = YES;
                    
                }
            }
        }else{
            if([self.select_open_apply isEqualToString:@"是"]&&self.select_limit_apply_num){
                cell.limitApplyNum.hidden = NO;
                cell.limitApplyNumLab.hidden = NO;
            }else{
                cell.limitApplyNum.hidden = YES;
                cell.limitApplyNumLab.hidden = YES;
                
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
     //   return self.PEtableview.frame.size.height - 160;
        return cellHeight;
    }else if(indexPath.row ==3){
        return 180;
    }else if(indexPath.row ==4){
        return 100;
    }else if(indexPath.row ==5){
        return 50;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0){
        if(!select_forum_dropdown_isonshowing){
        
        if([_ED_FLAG isEqualToString:@"0"]){

        //collectionview布局
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.minimumLineSpacing = 2;
        [flowlayout setItemSize:CGSizeMake(200, 40)];
        
        //初始化colletionview
        self.fs  = [[FSCollectionview alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, -50, 200, [self.select_forum count]*40) collectionViewLayout:flowlayout];

        //传值
       // self.fs.PEVC = self;
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
            self.fs.frame= CGRectMake(self.view.frame.size.width/2 - 100, 50, 200, [self.select_forum count]*40) ;
            self.fs.alpha = 1;
            [self.fs.layer setCornerRadius:self.fs.frame.size.height/20];
        }];

            [self.fs getcelltext:indexPath:self.PEtableview];
            select_forum_dropdown_isonshowing = YES;
        }
        }
    }else if (indexPath.row==2){
        
    

    }else if(indexPath.row==3){//删图片
        if(self.select_image_name&&![self.select_image_name isEqualToString:@""]&&![self.select_image_name isEqualToString:@""""]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除图片？" message:@"您确定删除该图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        self.alert_flag = @"delete_img";
        }

    }else if (indexPath.row==4){//删链接
        if([self.select_chain isEqualToString:@"是"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除外链？" message:@"您确定删除该外链吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        self.alert_flag = @"delete_chain";
        }
    }
    
}



-(void)resignKeyboard{
    [self.text_tv resignFirstResponder];
}

#pragma mark-----title
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField == self.title_tf){
    self.select_post_title = textField.text;
    //显示在UI中
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark-----收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    UITextField *chainName= [self.inputArray valueForKey:@"ChainContext"];
//    UITextField *chainText = [self.inputArray valueForKey:@"ChainAddress"];
//    if(chainName||chainText){
//        [chainText resignFirstResponder];
//        [chainName resignFirstResponder];
//    }
    return YES;
}



#pragma mark----text

- (void)textViewDidBeginEditing:(UITextView *)textView{
    //去掉初始的提示文字
    if(edit){
        if([textView.text isEqualToString:@"请输入内容"]){
               textView.text = nil;
               textView.textColor = [UIColor blackColor];
            
        }
    }

    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
//    CGSize size = CGSizeMake(300, 1000);
//    CGSize labelSize = [textView.text sizeWithFont:textView.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCellHeight" object:[NSString stringWithFormat:@"%f",labelSize.height]];
//   cellHeight = labelSize.height+10;
//    [self.PEtableview beginUpdates];
//    [self.PEtableview endUpdates];
    
    
//    //显示在UI中
//    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:0];
//    NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
//    [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.PEtableview reloadData];
    if(![textView.text isEqualToString:@""]){
        self.textcell.textview.text = textView.text;
        self.select_post_text = textView.text;
        edit = false;
    }else{
        self.textcell.textview.text = @"请输入内容";
        self.select_post_text = @"";
        textView.textColor = [UIColor grayColor];
        edit =true;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    CGSize size = CGSizeMake(300, 1000);
    CGSize labelSize = [textView.text sizeWithFont:textView.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCellHeight" object:[NSString stringWithFormat:@"%f",labelSize.height]];
//    cellHeight = labelSize.height+10;
//    [self.PEtableview beginUpdates];
//    [self.PEtableview endUpdates];

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
    CGSize size = CGSizeMake(300, 150);
    self.select_image = [self scaleToSize:chosenImage size:size];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
//    //显示在UI中
//    NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
//    NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
//    //刷新指定行
////    [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.PEtableview reloadData];
    //上传图片
    [self uploadinitWithImage:self.select_image];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark---------------剪裁图片
-(UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *endImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return endImage;
}

#pragma mark--------------上传图片
-(void)uploadinitWithImage:(UIImage *)image{
    
    NSURL *baseUrl = [NSURL URLWithString:API_HOST];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:API_UPLOAD_HOST parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //上传时使用当前的系统事件作为文件名
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"uploadfile" fileName:fileName mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"上传成功！";
        hud.dimBackground = YES;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        }completionBlock:^{
            [hud removeFromSuperview];
        }];

        //上传图片后获取的图片名字
        if(responseObject!=nil){
        self.select_image_name = [NSString stringWithFormat:@"%@.jpg",(NSString *)responseObject[@"photourl"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"上传失败，请稍后重试！";
        hud.dimBackground = YES;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        }completionBlock:^{
            [hud removeFromSuperview];
        }];

    }];
    
}

//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    //注册通知，监听键盘出现
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    
//    //注册通知，监听键盘消失事件
//     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKeyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
//}
//
//#pragma mark-----
//#pragma mark------监听键盘事件
//-(void)handleKeyboardDidShow:(NSNotification *)paramNotification{
//    //获取键盘高度
//    NSValue *keyboardRectAsObject = [[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect;
//    [keyboardRectAsObject getValue:&keyboardRect];
////    self.textcell.textview.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0);
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:kANimationDuration];
//    //上移
//    [(UIView *)[self.view viewWithTag:1000]setFrame:CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height, self.view.frame.size.width, 56)];
//    [UIView commitAnimations];
//}
//
//-(void)handleKeyboardDidHidden{
// //   self.textcell.textview.contentInset = UIEdgeInsetsZero;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:kANimationDuration];
//    //下移
//    [(UIView *)[self.view viewWithTag:1000]setFrame:CGRectMake(0, self.view.frame.size.height-56, self.view.frame.size.width, 56)];
//    [UIView commitAnimations];
//}
#pragma mark-----

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    cellHeight = self.PEtableview.frame.size.height - 160;
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
    }else if ([_ED_FLAG isEqualToString:@"1"]){//当前版块下发帖
        self.select_forum_id = _forum_item.forum_id;
        self.select_forum_name = _forum_item.forum_name;
    }else{//编辑帖子
        self.select_post_title = _post_item.title;
        self.select_post_text = _post_item.post_text;
        self.select_forum_id = _post_item.belong_forum_id;
        self.select_post_id = _post_item.post_id;
        self.select_poster_id = _post_item.poster_id;
        self.select_post_text = _post_item.post_text;
        self.select_post_title = _post_item.title;
        self.select_image_name = _post_item.main_image_url;
        self.select_chain = _post_item.chain;
        self.select_chain_context = _post_item.chain_name;
        self.select_chain_address = _post_item.chain_url;
        self.select_open_apply = _post_item.open_apply;
        self.select_limit_apply_num = _post_item.limit_apply_num;
        self.select_need_check = _post_item.need_check;
        self.select_checked = _post_item.checked;
       NSArray *forum =[ViewController getForumList];
        
        for(int i=0;i< [forum count];i++){
            forumItem *f = [forum objectAtIndex:i];
            if([_post_item.belong_forum_id isEqualToString:f.forum_id]){
                _forum_item = f;
                break;
            }
        }
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
    self.rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStyleBordered  target:self action:@selector(NewPost2Web)];
    self.navigationItem.rightBarButtonItem = self.rightItem;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCellHeight:) name:@"UpdateCellHeight" object:nil];
    
}

-(void)updateCellHeight:(NSNotification *)notification{
    id height = notification.object;
    cellHeight = [height intValue]+10;
    [self.PEtableview beginUpdates];
    [self.PEtableview endUpdates];
}


#pragma mark-------获取版块设置
-(void)check{
    //获取版块设置
    self.ISMAINIMG = @"N";
    self.ISAPPLY = @"N";
    self.ISCHAIN =@"N";
    self.ISCHECK = @"N";

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
                if([self.forum_set_item.site_name isEqualToString:site_ischeck]&&[self.forum_set_item.site_value isEqualToString:@"是"]){
                    self.ISCHECK = @"Y";
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
    user_status = [user_status stringByAppendingString:@"/"];
        for(int j=0;j<[_forum_list_item count];j++){
            forumItem *fitem = [_forum_list_item objectAtIndex:j];
            if([fitem.display_type isEqualToString:@"纵向"]){
            if(fitem.ForumSetlist!=nil){
                for(int m=0;m<[fitem.ForumSetlist count];m++){
                    forumSetItem *fs_item = [forumSetItem createItemWitparametes:[fitem.ForumSetlist objectAtIndex:m]];
                    
                    if ([fs_item.site_name isEqualToString:site_newpost_user]) {
                        
                        //版块设置值
                        if([fs_item.site_value rangeOfString:user_status].location!=NSNotFound){
                            [self.select_forum addObject:fitem];
                        //    break;
                        }
                        
                        //版主
                       else if(self.moderator!=nil){
                            for(int m=0;m<[self.moderator count];m++){
                                if([[self.moderator objectAtIndex:m] isEqualToString:fitem.forum_id]){
                                    [self.select_forum addObject:fitem];
                                //    break;
                                }
                                
                            }
                        }
                        break;
                    }
                }
            }
            }
        }

}

#pragma mark------发帖 20150515 lx
-(void)NewPost2Web{
    
    self.rightItem.enabled = NO;//点完后不可点击
    [self.textcell.textview resignFirstResponder];
    [self.title_tf resignFirstResponder];
    if([_ED_FLAG isEqualToString:@"0"]){//首页直接发帖
        //版块号
        self.select_forum_id = self.fs.select_forum_id;
        [self newPostCheck:self.fs.ISAPPLY1 isChain:self.fs.ISCHAIN1 isCheck:self.fs.ISCHECK1];
       
    }else if([_ED_FLAG isEqualToString:@"1"]){//当前版块下发帖
        [self newPostCheck:self.ISAPPLY isChain:self.ISCHAIN isCheck:self.ISCHECK];
    }else{
        [self editPostCheck:self.ISAPPLY isChain:self.ISCHAIN isCheck:self.ISCHECK];
    }
    
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
            self.rightItem.enabled = YES;
        }else{
        
        TitleTableViewCell *cell = [self.PEtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        self.select_post_title = cell.Title.text;
            
            
        if([self.select_post_title isEqualToString:@""]||self.select_post_title==nil){
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
            
            self.rightItem.enabled = YES;

        }else{
            TextTableViewCell *cell = [self.PEtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            self.select_post_text = cell.textview.text;
            
            if([self.select_post_text isEqualToString:@"请输入内容"]){
                self.select_post_text = @"";
            }
            if(![_ED_FLAG isEqualToString:@"2"]){//发新帖
            [StatusTool statusToolNewPostWithcID:self.communityID fID:self.select_forum_id PosterID:self.userID postTitle:self.select_post_title postText:self.select_post_text imgURL:self.select_image_name chain:self.select_chain chainName:self.select_chain_context chainURL:self.select_chain_address apply:self.select_open_apply limApplyNum:self.select_limit_apply_num needCheck:self.select_need_check Checked:self.select_checked Success:^(id object) {
                newPostItem *new = (newPostItem *)object;
                if([new.msg isEqualToString:@"发送成功"]){
                    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"发布成功！" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    if([self.select_need_check isEqualToString:@"是"]){
                        alert1.message =@"请耐心等待审核...";
                    }
                                    alert1.delegate = self;
                    
                [alert1 show];
                self.alert_flag = @"s";
                    
                }else{
                    UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"发布失败！" message:@"请稍后再试..." delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    alert2.delegate = self;
                    [alert2 show];
                    self.alert_flag = @"f";
                    self.rightItem.enabled = YES;
                }
            } failurs:^(NSError *error) {
                UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"发布失败！" message:@"网络异常..." delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                alert2.delegate = self;
                 [alert2 show];
                self.alert_flag = @"f";
                self.rightItem.enabled = YES;
            }];
            }else{//编辑帖子
                [StatusTool statusToolEditPostWithcID:self.communityID fID:self.select_forum_id postID:self.select_post_id PosterID:self.select_poster_id postTitle:self.select_post_title postText:self.select_post_text imgURL:self.select_image_name chain:self.select_chain chainName:self.select_chain_context chainURL:self.select_chain_address apply:self.select_open_apply limApplyNum:self.select_limit_apply_num needCheck:self.select_need_check Checked:self.select_checked Success:^(id object) {
                    editPostItem *new = (editPostItem *)object;
                    if([new.msg isEqualToString:@"编辑成功"]){
                        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"已发布！" message: nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        
                        if([self.select_need_check isEqualToString:@"是"]){
                            alert1.message = @"请耐心等待审核...";
                        }
                        alert1.delegate = self;
                        [alert1 show];
                        self.alert_flag = @"s";
                        
                    }else{
                        UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"发布失败！" message:@"请稍后再试..." delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        alert2.delegate = self;
                        [alert2 show];
                        self.alert_flag = @"f";
                        self.rightItem.enabled = YES;
                    }

                } failurs:^(NSError *error) {
                    UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"编辑失败！" message:@"请稍后再试..." delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    alert2.delegate = self;
                    [alert2 show];
                    self.alert_flag = @"f";
                    self.rightItem.enabled = YES;
                }];
                
            }
        }
        }
        
    
    
    
    
    
    
    
    
    
    
}
#pragma mark------编辑帖子完成提交前
-(void)editPostCheck:(NSString *)ISApply isChain:(NSString *)ISChain isCheck:(NSString *)ISCheck{
    //审核
    if([ISCheck isEqualToString:@"Y"]){
        self.select_need_check = @"是";
        self.select_checked = @"否";
    }else{
        self.select_need_check = @"否";
        self.select_checked = @"是";
    }
    //报名
    if(![ISApply isEqualToString:@"Y"]){
        self.select_open_apply = @"否";
        self.select_limit_apply_num = @"";
    }
    if([self.select_open_apply isEqualToString:@"否"]){
        self.select_limit_apply_num = @"";
    }
    //外链
    if(![ISChain isEqualToString:@"Y"]){
        self.select_chain = @"否";
        self.select_chain_address = @"";
        self.select_chain_context = @"";
    }
    
    if(![self.select_chain isEqualToString:@"否"]){
    if(!self.select_chain_context){
        self.select_chain = @"否";
        self.select_chain_address = @"";
        self.select_chain_context = @"";
    }else{
        self.select_chain = @"是";
        if(!self.select_chain_address)
            self.select_chain_address=@"";
    }
    }else{
        self.select_chain_address = @"";
        self.select_chain_context = @"";
    }
    //图片
    if(!self.select_image_name){
        self.select_image_name = @"";
    }

}


#pragma mark------发帖前检查
-(void)newPostCheck:(NSString *)ISApply isChain:(NSString *)ISChain isCheck:(NSString *)ISCheck{
    
    //报名
    if(![ISApply isEqualToString:@"Y"]){
        self.select_open_apply = @"否";
        self.select_limit_apply_num = @"";
    }
    
    if([self.select_limit_apply_num isEqualToString:@"0"]){
        self.select_limit_apply_num = @"";
    }
    
    //外链
    if(![ISChain isEqualToString:@"Y"]){
        self.select_chain = @"否";
        self.select_chain_address = @"";
        self.select_chain_context = @"";
    }
    if(!self.select_chain_context){
        self.select_chain = @"否";
        self.select_chain_address = @"";
        self.select_chain_context = @"";
    }else{
        if(![self.select_chain isEqualToString:@"否"]){
                self.select_chain = @"是";
            if(!self.select_chain_address){
                self.select_chain_address=@"";
            }
        }
    }
    //审核
    if([ISCheck isEqualToString:@"Y"]){
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

   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex ==0) {
        if([self.alert_flag isEqualToString:@"s"]){
            if([_ED_FLAG isEqualToString:@"0"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
            }else if([_ED_FLAG isEqualToString:@"1"]){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    }else{
        if([self.alert_flag isEqualToString:@"delete_img"]){
        self.select_image = nil;
        self.select_image_name = @"";
        //显示在UI中
        NSIndexPath *index = [NSIndexPath indexPathForRow:3 inSection:0];
        NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
        //刷新指定行
        [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
        }else if([self.alert_flag isEqualToString:@"delete_chain"]){
            self.select_chain = @"否";
            self.select_chain_context = @"";
            self.select_chain_address = @"";
            //显示在UI中
            NSIndexPath *index = [NSIndexPath indexPathForRow:4 inSection:0];
            NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
            //刷新指定行
            [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
        }
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
    
    //改变cell的高度需要reload该cell
    CGSize size = CGSizeMake(300, 1000);
    CGSize labelSize = [self.textcell.textview.text sizeWithFont:self.textcell.textview.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    cellHeight = labelSize.height+10;
//    [self.PEtableview reloadData];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
   // [self presentModalViewController:self.imagePicker animated:YES];
    [self presentViewController:self.imagePicker animated:YES completion:nil];

}
- (IBAction)AddChainOnClick:(id)sender {
//    self.PEtableview.userInteractionEnabled = NO;
    
    self.maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.maskview.backgroundColor = [UIColor blackColor];
    self.maskview.alpha = 0.3;
    [self.view addSubview:self.maskview];
    
    //添加点击手势
    self.maskview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [self.maskview addGestureRecognizer:singleTap];
    
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
    ctfield.delegate = self;
    if(self.select_chain_context!=nil&&![self.select_chain_context isEqualToString:@""]){
        ctfield.text = self.select_chain_context;
    }else{
        ctfield.placeholder = @"请输入外联文字";
    }
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
    wtfield.delegate = self;
    
    if(self.select_chain_address!=nil&&![self.select_chain_address isEqualToString:@""]){
        wtfield.text = self.select_chain_address;
    }else{
        wtfield.placeholder = @"请输入外联网址";
    }
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
    
    //添加点击手势
    self.maskview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [self.maskview addGestureRecognizer:singleTap];


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
-(void)closeView{
    [self.addapply removeFromSuperview];
    [self.addchain removeFromSuperview];
    [self.maskview removeFromSuperview];
}

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
        
        if([self.select_chain isEqualToString:@"否"]){//排除原来有外链又修改的情况
        if(!self.select_chain_context||([self.select_chain_context isEqualToString:@""]&&[self.select_chain_address isEqualToString:@""])){
            self.select_chain = @"否";
            self.select_chain_address = @"";
            self.select_chain_context = @"";
        }else{
            self.select_chain = @"是";
            if(!self.select_chain_address){
                self.select_chain_address = @"";
            }
        }
        }else{//原来有外链，又修改
            if([self.select_chain_context isEqualToString:@""]&&
               [self.select_chain_address isEqualToString:@""]){
                self.select_chain = @"否";
            }
            
        }
    }
    //显示在UI中
    NSIndexPath *index = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
 //   [self.PEtableview reloadData];
   
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
    //显示在UI中
    NSIndexPath *index = [NSIndexPath indexPathForRow:5 inSection:0];
    NSArray *indexArrary = [NSArray arrayWithObjects:index,nil];
    //刷新指定行
    [self.PEtableview reloadRowsAtIndexPaths:indexArrary withRowAnimation:UITableViewRowAnimationAutomatic];
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
