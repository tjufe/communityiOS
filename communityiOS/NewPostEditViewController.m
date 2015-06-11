//
//  NewPostEditViewController.m
//  communityiOS
//
//  Created by 金钟 on 15/5/22.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "NewPostEditViewController.h"
#import "StatusTool.h"
#import "RepairInfo.h"
#import "forumSetItem.h"
#import "PostInfo.h"
#import "StatusTool.h"
#import "MBProgressHUD.h"
#import "APIAddress.h"
#import "UIImageView+WebCache.h"//加载图片
#import "AFHTTPRequestOperationManager.h"
#import "editPostItem.h"
#import "newPostItem.h"
#import "PostMendDetailViewController.h"
#import "AppDelegate.h"


@interface NewPostEditViewController ()<UIImagePickerControllerDelegate,UITextFieldDelegate>

@property(strong,nonatomic) UIImageView *postMainPicImageView;
@property(strong,nonatomic) UILabel *forumNameLabel;
@property(strong,nonatomic) UITextField *postTitleTextField;
@property(strong,nonatomic) UIView *v;
@property(strong,nonatomic) UITextField *postLocationTextField;
@property(strong,nonatomic) UIView *v3;
@property(retain,nonatomic) UITextView *postContentTextView;
@property(strong,nonatomic) UITextField *reporterNameTextField;
@property(strong,nonatomic) UITextField *reporterPhoneTextField;
@property(strong,nonatomic) UIView *v2;
@property(strong,nonatomic) UIScrollView *sv;
@property(strong,nonatomic) UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UIImageView *ImagePickerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *LinkPickerImageView;
@property (strong,nonatomic) UIView *v4;//外链层
@property (strong,nonatomic) UILabel *chain_name;
@property (strong,nonatomic) UILabel *chain_address;
@property (nonatomic,strong)UIBarButtonItem *rightItem;
@property (nonatomic ,strong) UIImagePickerController *imagePicker;
@property (strong,nonatomic)UIView *addchain;
@property (strong,nonatomic)UIView *maskview;
@property (strong,nonatomic) NSString * isCheck;
@property (strong,nonatomic) NSString * isMainImg;
@property (strong,nonatomic) NSString * isChain;
@property (strong,nonatomic) NSString *select_chain;//上传的外链状态
@property (strong,nonatomic) NSString *select_chain_context;//上传的外链内容
@property (strong,nonatomic) NSString *select_chain_address;//上传的外链地址
@property (strong,nonatomic) UIImage *select_img;//上传的图片
@property (strong,nonatomic) NSString *select_img_name;//上传的图片名称
@property (strong,nonatomic) NSMutableDictionary *inputArray;//用来存放输入的控件

@end

@implementation NewPostEditViewController

NSString * const m_site_addchain = @"是否提供外链功能";
NSString * const m_site_addmainimg = @"主帖是否包含主图";
NSString * const m_site_needcheck= @"是否需要审核";
NSString * const KEY_SITE_VALUE_YES = @"是";
int flag;
NSString  *alert_flag;



#pragma mark------收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

#pragma mark-------UIImagePickerViewController  delegate 20150527 lx
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获得编辑过的图片
    UIImage* chosenImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    CGSize size = CGSizeMake(300, 150);
    self.select_img = [self scaleToSize:chosenImage size:size];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    //显示在UI中
    self.postMainPicImageView.image = self.select_img;
    self.postMainPicImageView.hidden = NO;
    //上传图片
    [self uploadinitWithImage:self.select_img];
    
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
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
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
            self.select_img_name = [NSString stringWithFormat:@"%@.jpg",(NSString *)responseObject[@"photourl"]];
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



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //赋值
    if([_ED_FLAG isEqualToString:@"2"]){
        self.select_chain = _post_item.chain;
        self.select_chain_address = _post_item.chain_url;
        self.select_chain_context = _post_item.chain_name;
        self.select_img_name = _post_item.main_image_url;
    }
    self.inputArray = [[NSMutableDictionary alloc]init];
    
    [self initNavigationBar];
    [self initMainScrollView];
    [self initFooterToolbar];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

//点击屏幕别处键盘收起
-(void)hidenKeyboard
{
    [self.postTitleTextField resignFirstResponder];
    [self.postLocationTextField resignFirstResponder];
    [self.reporterNameTextField resignFirstResponder];
    [self.reporterPhoneTextField resignFirstResponder];
}

- (void)initFooterToolbar {
    for (NSArray *row  in _forum_item.ForumSetlist) {
        forumSetItem *fs = [forumSetItem createItemWitparametes:row];
        if([fs.site_name rangeOfString:m_site_addchain].location!=NSNotFound){
            [self setLinkPickerWithNeedHidden:[fs.site_value rangeOfString:KEY_SITE_VALUE_YES].location == NSNotFound];
        }else if([fs.site_name rangeOfString:m_site_addmainimg].location!=NSNotFound){
            [self setImagePickerWithNeedHidden:[fs.site_value rangeOfString:KEY_SITE_VALUE_YES].location == NSNotFound];
        }else if([fs.site_name containsString:m_site_needcheck]){
            if([fs.site_value isEqualToString:@"是"]){
                self.isCheck = @"Y";
            }else{
                self.isCheck = @"N";

            }
        }
    }
}

- (void)setLinkPickerWithNeedHidden:(BOOL)needHidden {
    [self.LinkPickerImageView setHidden:needHidden];
    if(needHidden){
        self.isChain = @"N";
    }else{
        self.isChain = @"Y";
    }
    self.LinkPickerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showLink)];
    [self.LinkPickerImageView addGestureRecognizer:singleTap];
}

-(void)showLink{
    self.maskview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.maskview.backgroundColor = [UIColor blackColor];
    self.maskview.alpha = 0.3;
    [self.view addSubview:self.maskview];
    
    //添加点击手势
    self.maskview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [self.maskview addGestureRecognizer:singleTap];
    
    self.addchain =[[UIView alloc]init];
    
    self.addchain.frame = CGRectMake(self.mainScrollView.center.x-150, self.view.frame.size.height+100, 300, 220);
    self.addchain.alpha  = 0;
    self.addchain.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addchain];
    //实例化一个view
    [UIView animateWithDuration:0.5 animations:^{
        self.addchain.alpha = 1;
        self.addchain.frame = CGRectMake(self.mainScrollView.center.x-150, self.mainScrollView.center.y-110, 300, 220);
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
    [bt addTarget:self action:@selector(selectLink) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addchain addSubview:bt];

}

-(void)closeView{
    [self.addchain removeFromSuperview];
    [self.maskview removeFromSuperview];
}

-(void)selectLink{
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
        
        if([self.select_chain isEqualToString:@"否"]||!self.select_chain){//排除原来有外链又修改的情况
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
    if(![self.select_chain_context isEqualToString:@""]){
        self.v4.hidden = NO;
        self.chain_name.text =chainName.text;
        self.chain_address.text = chainText.text;
    }else{
        self.v4.hidden = YES;
    }

}

- (void)setImagePickerWithNeedHidden:(BOOL)needHidden {
    [self.ImagePickerImageView setHidden:needHidden];
    [self.ImagePickerImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImagePicker:)];
    [self.ImagePickerImageView addGestureRecognizer:singleTap];
    if(needHidden){
        self.isMainImg = @"N";
    }else{
        self.isMainImg = @"Y";
    }
}

-(void)showImagePicker:(UIGestureRecognizer *)gestureRecognizer {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
//    [self presentModalViewController:self.imagePicker animated:YES];
    [self presentViewController:self.imagePicker animated:YES completion:nil];

}

- (void)textViewDidChange:(UITextView *)textView {
    float textViewOldHeight = textView.frame.size.height;
    CGSize constraintSize;
    constraintSize.width = textView.frame.size.width;
    constraintSize.height = MAXFLOAT;
    
    CGSize sizeFrame = [textView sizeThatFits:constraintSize];
    
    textView.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y,textView.frame.size.width,sizeFrame.height);
    
    
    self.v2.frame = CGRectMake(self.v2.frame.origin.x, self.v2.frame.origin.y+sizeFrame.height-textViewOldHeight, self.v2.frame.size.width, self.v2.frame.size.height);

    self.postMainPicImageView.frame = CGRectMake(self.postMainPicImageView.frame.origin.x, self.postMainPicImageView.frame.origin.y+sizeFrame.height-textViewOldHeight, self.postMainPicImageView.frame.size.width, self.postMainPicImageView.frame.size.height);
    
    self.mainScrollView.contentSize = CGSizeMake(0, self.postMainPicImageView.frame.origin.y+self.postMainPicImageView.frame.size.height);

}

- (void)initMainScrollView {
    
    int t = self.navigationController.view.frame.size.width;;
    CGRect frame = self.view.frame;
    frame.size.width = t ;
    self.view.frame = frame;
    self.mainScrollView.frame = CGRectMake(self.mainScrollView.frame.origin.x , self.mainScrollView.frame.origin.y , self.view.frame.size.width, self.mainScrollView.frame.size.height);
    
    [self initForumName];
    [self initPostTitle];
    [self initLocation];
    [self initRepairType];
    [self initPostContent];
    [self initReporterName];
    [self initReporterPhone];
    [self initPostMainPic];
    [self initLink];
    
    
    [self.mainScrollView addSubview:self.forumNameLabel];
    [self.mainScrollView addSubview:self.v];
    [self.mainScrollView addSubview:self.v3];
    [self.mainScrollView addSubview:self.sv];
    [self.mainScrollView addSubview:self.postContentTextView];
    [self.mainScrollView addSubview:self.v2];
    [self.mainScrollView addSubview:self.postMainPicImageView];
    [self.mainScrollView addSubview:self.v4];
    
    
    self.mainScrollView.contentSize = CGSizeMake(0, self.postMainPicImageView.frame.origin.y+self.postMainPicImageView.frame.size.height);

}

- (void)initNavigationBar {
    
    if([_ED_FLAG isEqualToString:@"2"]){//编辑帖子
         self.navigationItem.title = @"编辑报修";
    }else{
         self.navigationItem.title = @"提交报修";
    }
    self.rightItem = [[UIBarButtonItem alloc]initWithTitle:@"上报" style:UIBarButtonItemStyleBordered  target:self action:@selector(reqReportRepair)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

#pragma mark------发帖前检查 lx 20150527
-(void)check:(PostInfo *)postInfo{
    //审核
    if([self.isCheck isEqualToString:@"Y"]){
        postInfo.need_check = @"是";
        postInfo.checked =@"否";
    }else{
        postInfo.need_check = @"否";
        postInfo.checked =@"是";
    }
    
    //外链
    if(![self.isChain isEqualToString:@"Y"]){
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
    postInfo.chain = self.select_chain;
    postInfo.chain_name = self.select_chain_context;
    postInfo.chain_url = self.select_chain_address;
    
    //图片
    if([self.isMainImg isEqualToString:@"Y"]){
        if(!self.select_img_name){
            postInfo.main_image_url = @"";
        }else{
            postInfo.main_image_url = self.select_img_name;
        }
    }else{
        postInfo.main_image_url = @"";
    }
    //报名
    postInfo.open_apply = @"否";
    postInfo.limit_apply_num = @"";
}

#pragma mark------发帖
- (void)reqReportRepair {
    
    self.rightItem.enabled = NO;
    [self hidenKeyboard];
    NSString *post_title = [self getPostTitle];//帖子标题
    NSString *post_text = [self getPostText];//故障位置
    NSString *post_text_1 = [self getPostText1];//故障描述
    NSString *post_text_2 = [self getPostText2];//联系人
    NSString *post_text_3 = [self getPostText3];//联系电话
    if(post_title && post_text && post_text_1 && post_text_2 && post_text_3){
        //发送网络调用
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        PostInfo *postInfo = [PostInfo new];
        [self check:postInfo];
        postInfo.community_id = [defaults valueForKey:@"CommunityID"];
        postInfo.forum_id = _forum_item.forum_id;
        postInfo.poster_id =[defaults valueForKey:@"UserID"];
        postInfo.post_title = post_title;
        postInfo.post_text = post_text;
        postInfo.post_text_1 = post_text_1;
        postInfo.post_text_2 = post_text_2;
        postInfo.post_text_3 = post_text_3;

        if(![_ED_FLAG isEqualToString:@"2"]){
        [StatusTool statusToolNewPostWithPostInfo:postInfo Success:^(id result){
            newPostItem *new = (newPostItem *)result;
            if([new.msg isEqualToString:@"发送成功"]){
                UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"发布成功！" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                
                if([postInfo.need_check isEqualToString:@"是"]){
                    alert1.message =@"请耐心等待审核...";
                }

                alert1.delegate = self;
                [alert1 show];
                alert_flag = @"s";
            }else{
                UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"发布失败！" message:@"请稍后再试..." delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                alert2.delegate = self;
                [alert2 show];
                alert_flag = @"f";
                self.rightItem.enabled = YES;
            }

        }failurs:^(NSError *error) {
            UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"发布失败！" message:@"网络异常..." delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert2.delegate = self;
            [alert2 show];
            alert_flag = @"f";
            self.rightItem.enabled = YES;
        }];
        }else{
            postInfo.post_id = _post_item.post_id;
            [StatusTool statusToolEditPostWithPostInfo:postInfo Success:^(id object) {
                editPostItem *new = (editPostItem *)object;
                if([new.msg isEqualToString:@"编辑成功"]){
                    UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"已发布！" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    if([postInfo.need_check isEqualToString:@"是"]){
                        alert1.message =@"请耐心等待审核...";
                    }

                    alert1.delegate = self;
                    [alert1 show];
                    alert_flag = @"s";
                }else{
                    UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"发布失败！" message:@"请稍后再试..." delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    alert2.delegate = self;
                    [alert2 show];
                    alert_flag = @"f";
                    self.rightItem.enabled = YES;
                }

            } failurs:^(NSError *error) {
                UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"编辑失败！" message:@"请稍后再试..." delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                alert2.delegate = self;
                [alert2 show];
                alert_flag = @"f";
                self.rightItem.enabled = YES;
            }];
        }
    }else{
        MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"报修信息不能为空！";
        hud.dimBackground = YES;
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        }completionBlock:^{
            [hud removeFromSuperview];
        }];
       self.rightItem.enabled = YES;
    }
}

#pragma mark------对话框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex ==0) {
        if([alert_flag isEqualToString:@"s"]){
            mend_pop_code = 1;
            [self.navigationController popViewControllerAnimated:NO];
            
        }
    }else{
        if([alert_flag isEqualToString:@"delete_img"]){
            self.select_img = nil;
            self.select_img_name = @"";
            //显示在UI中
            self.postMainPicImageView.image = nil;
        }else if([alert_flag isEqualToString:@"delete_chain"]){
            self.select_chain = @"否";
            self.select_chain_context = @"";
            self.select_chain_address = @"";
            //显示在UI中
            self.chain_name.text = nil;
            self.chain_address.text = nil;
            self.v4.hidden = YES;
        }
    }
}



- (NSString *)getPostText {
    NSString *str = [self.postLocationTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = str.length == 0 ? nil : str;
    return str;
}

- (NSString *)getPostText3 {
    NSString *str = [self.reporterPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = str.length == 0 ? nil : str;
    return str;
}

- (NSString *)getPostText2 {
    NSString *str = [self.reporterNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = str.length == 0 ? nil : str;
    return str;
}

- (NSString *)getPostText1 {
    NSInteger selectedIndex =[self.segmentedController selectedSegmentIndex];
    NSInteger lastIndex = [self.segmentedController numberOfSegments]-1;
    if(selectedIndex>=0){
        NSString *str = [self.segmentedController titleForSegmentAtIndex: [self.segmentedController selectedSegmentIndex]];
        if(selectedIndex == lastIndex){
            str = [self.postContentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        return str;
    }else{
        return nil;
    }
}

- (NSString *)getPostTitle {
    NSString *str = [self.postTitleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = str.length == 0 ? nil : str;
    return str;
}

- (void)initForumName {
    UIFont *font = [UIFont fontWithName:@"Arial" size:16.0f];
    self.forumNameLabel = [[UILabel alloc]init];
    self.forumNameLabel.text = _forum_item.forum_name;
    self.forumNameLabel.font = font;
    self.forumNameLabel.textAlignment = NSTextAlignmentCenter;
    self.forumNameLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 70);
}

- (void)initPostTitle {
    self.postTitleTextField = [[UITextField alloc]init];
    [self.postTitleTextField addTarget:self action:@selector(titleTextField_didEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    if([_ED_FLAG isEqualToString:@"2"]
        &&![_post_item.title isEqualToString:@""]&&_post_item.title!=nil){//编辑帖子
            self.postTitleTextField.text = _post_item.title;
        
    }else{//发帖
    self.postTitleTextField.placeholder = @"请输入标题……";
    }
    self.postTitleTextField.font = self.forumNameLabel.font;
    self.postTitleTextField.textAlignment = NSTextAlignmentLeft;
    self.postTitleTextField.frame = CGRectMake(8, 0, self.view.frame.size.width-8, 30);
    self.v= [[UIView alloc]init];
    self.v.frame = CGRectMake(0, self.forumNameLabel.frame.size.height, self.view.frame.size.width, self.postTitleTextField.frame.size.height);
    self.v.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.v addSubview:self.postTitleTextField];
}

-(void)titleTextField_didEndOnExit{
    [self.postLocationTextField becomeFirstResponder];
}

- (void)initLocation {
    self.postLocationTextField = [[UITextField alloc]init];
    
    self.postLocationTextField.delegate = self;
    if([_ED_FLAG isEqualToString:@"2"]
       &&![_post_item.post_text isEqualToString:@""]&&_post_item.post_text!=nil){//编辑帖子
        self.postLocationTextField.text = _post_item.post_text;
        
    }else{//发帖
    
    self.postLocationTextField.placeholder = @"请输入故障地点……";
    }
    self.postLocationTextField.font = self.forumNameLabel.font;
    self.postLocationTextField.textAlignment = NSTextAlignmentLeft;
    self.postLocationTextField.frame = CGRectMake(8, 0, self.view.frame.size.width-8, 30);
    self.v3= [[UIView alloc]init];
    self.v3.frame = CGRectMake(0, self.v.frame.origin.y+self.v.frame.size.height, self.view.frame.size.width, self.postLocationTextField.frame.size.height);
    self.v3.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.v3 addSubview:self.postLocationTextField];
}

- (void)initRepairType {
    self.sv = [[UIScrollView alloc]init];
    self.sv.frame = CGRectMake(0, self.v3.frame.origin.y+self.v3.frame.size.height, self.view.frame.size.width, 39);
    self.sv.showsHorizontalScrollIndicator = NO;
//    self.sv.backgroundColor = [UIColor redColor];
    [StatusTool statusToolLoadRepairTypeWithCommunityID:@"0001" ForumID:_forum_item.forum_id Success:^(NSArray *array) {
        NSMutableArray *repairTextArr = [[NSMutableArray alloc]init];
        for(RepairInfo *row in array){
            [repairTextArr addObject:row.repair_text];
        }
        [repairTextArr addObject:@"其他"];
        self.segmentedController = [[UISegmentedControl alloc] initWithItems:repairTextArr];
        self.segmentedController.frame = CGRectMake(5, 5, self.segmentedController.frame.size.width, self.segmentedController.frame.size.height);
//        CGFloat i = self.segmentedController.frame.size.height;
        self.segmentedController.segmentedControlStyle = UISegmentedControlSegmentCenter;
        [self.sv addSubview:self.segmentedController];
        self.sv.contentSize = CGSizeMake(self.segmentedController
                                         .frame.size.width+10, 0);
        [self.segmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        if([_ED_FLAG isEqualToString:@"2"]
           &&![_post_item.post_text_1 isEqualToString:@""]&&_post_item.post_text_1!=nil){//编辑帖子
            for(int i=0;i<[repairTextArr count];i++){
                if([_post_item.post_text_1 isEqualToString:[repairTextArr objectAtIndex:i]]){
                    self.segmentedController.selectedSegmentIndex = i;//设置初始选中状态
                    flag = 1;
                }
            }
            
            if(flag!=1){
                
            self.segmentedController.selectedSegmentIndex=[repairTextArr count]-1;//其他
                flag = 2;
               
            }
        }
        
        
    } failurs:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)segmentAction:(id)sender {
    NSInteger lastIndex = [sender numberOfSegments]-1;
    if ([sender selectedSegmentIndex]==lastIndex) {
        [self.postContentTextView setEditable:YES];
        [self.postContentTextView selectAll:self];
    }else{
        [self.postContentTextView setEditable:NO];
    }
}

- (void)initPostContent {
    self.postContentTextView = [[UITextView alloc]init];
    self.postContentTextView.delegate = self;
    self.postContentTextView.font = self.forumNameLabel.font;
    self.postContentTextView.textAlignment = NSTextAlignmentLeft;
    self.postContentTextView.frame = CGRectMake(4,self.sv.frame.origin.y+self.sv.frame.size.height, self.view.frame.size.width-4, 30);
    self.postContentTextView.delegate = self;
    self.postContentTextView.text = @"其他故障类型描述：";
    if(flag==1){
        if (_post_item.post_text_1 !=nil) {
            [self.postContentTextView.text stringByAppendingString:_post_item.post_text_1];
            [self.postContentTextView setEditable:YES];
        }
        
    }else{
        [self.postContentTextView setEditable:NO];
    }
    
//    [self.postContentTextView selectAll:self];

}

- (void)initReporterName {
    self.reporterNameTextField = [[UITextField alloc]init];
    [self.reporterNameTextField addTarget:self action:@selector(NameTextField_didEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    if([_ED_FLAG isEqualToString:@"2"]
       &&![_post_item.post_text_2 isEqualToString:@""]&&_post_item.post_text_2!=nil){//编辑帖子
        self.reporterNameTextField.text = _post_item.post_text_2;
        
    }else{//发帖
    self.reporterNameTextField.placeholder = @"请输入联系人姓名……";
    }
    self.reporterNameTextField.font = self.forumNameLabel.font;
    self.reporterNameTextField.textAlignment = NSTextAlignmentLeft;
    self.reporterNameTextField.frame = CGRectMake(8, 0, self.view.frame.size.width-8, 30);
    self.v2= [[UIView alloc]init];
    self.v2.frame = CGRectMake(0,self.postContentTextView.frame.origin.y+self.postContentTextView.frame.size.height, self.view.frame.size.width, 60);
    self.v2.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.v2 addSubview:self.reporterNameTextField];
}

-(void)NameTextField_didEndOnExit{
    [self.reporterPhoneTextField becomeFirstResponder];
}

- (void)initReporterPhone {
    self.reporterPhoneTextField = [[UITextField alloc]init];
    self.reporterPhoneTextField.delegate = self;
    if([_ED_FLAG isEqualToString:@"2"]
       &&![_post_item.post_text_3 isEqualToString:@""]&&_post_item.post_text_3!=nil){//编辑帖子
        self.reporterPhoneTextField.text = _post_item.post_text_3;
        
    }else{//发帖
    
      self.reporterPhoneTextField.placeholder = @"请输入联系人电话……";
    }
    self.reporterPhoneTextField.font = self.forumNameLabel.font;
    self.reporterPhoneTextField.textAlignment = NSTextAlignmentLeft;
    self.reporterPhoneTextField.frame = CGRectMake(8, 30, self.view.frame.size.width-8, 30);
    [self.v2 addSubview:self.reporterPhoneTextField];
}

- (void)initPostMainPic {
    self.postMainPicImageView = [[UIImageView alloc]init];
    self.postMainPicImageView.frame = CGRectMake(0, self.v2.frame.origin.y+self.v2.frame.size.height, self.view.frame.size.width, 158);
    if([_ED_FLAG isEqualToString:@"2"]){
        if(![_post_item.main_image_url isEqualToString:@""]&&_post_item.main_image_url!=nil){
            NSString *img_url = [NSString stringWithFormat:@"%@/topicpic/%@",API_HOST,self.select_img_name];
            
            //包含中文字符的string转换为nsurl
            NSURL *iurl = [NSURL URLWithString:[img_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

            [self.postMainPicImageView sd_setImageWithURL:iurl placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
               self.postMainPicImageView.image = image;
            }];

        }else{
            self.postMainPicImageView.hidden = YES;
        }
    }
    
    self.postMainPicImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteImg)];
    [self.postMainPicImageView addGestureRecognizer:singletap];
//    self.postMainPicImageView.image = [UIImage imageNamed:@"image_01"];
}

#pragma mark------删除图片
-(void)deleteImg{
    
    if(self.postMainPicImageView.image){
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除图片？" message:@"您确定删除该图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert_flag = @"delete_img";
    }
}




-(void)initLink{
    self.v4 = [[UIView alloc]init];
    self.v4.frame = CGRectMake(0, self.postMainPicImageView.frame.origin.y+self.postMainPicImageView.frame.size.height, self.view.frame.size.width, 60);
    UILabel *chain_name_label = [[UILabel alloc]init];
    chain_name_label.frame = CGRectMake(8, 0, 70, 30);
    chain_name_label.text = @"外链内容:";
    chain_name_label.font = self.forumNameLabel.font;
    [self.v4 addSubview:chain_name_label];
    self.chain_name = [[UILabel alloc]init];
    self.chain_name.frame = CGRectMake(80, 0, self.view.frame.size.width-70, 30);
    self.chain_name.font = self.forumNameLabel.font;
    [self.v4 addSubview:self.chain_name];
    
    UILabel *chain_address_label = [[UILabel alloc]initWithFrame:CGRectMake(8, 30, 70, 30)];
    chain_address_label.text = @"外链地址:";
    chain_address_label.font = self.forumNameLabel.font;
    [self.v4 addSubview:chain_address_label];
    self.chain_address = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, self.view.frame.size.width-70, 30)];
    self.chain_address.font = self.forumNameLabel.font;
    [self.v4 addSubview:self.chain_address];
    
    if([_ED_FLAG isEqualToString:@"2"]){
        if([_post_item.chain isEqualToString:@"是"]){
            self.chain_name.text = self.select_chain_context;
            self.chain_address.text = self.select_chain_address;
            self.v4.hidden = NO;
        }else{
            self.v4.hidden = YES;
        }
    }else{
        self.v4.hidden = YES;
    }
    
    self.v4.userInteractionEnabled = YES;
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteChain)];
    [self.v4 addGestureRecognizer:singletap];
}

#pragma mark------删除外链
-(void)deleteChain{
    
    if(self.v4.hidden==NO){
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除外链？" message:@"您确定删除该外链吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert_flag = @"delete_chain";
    }

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
