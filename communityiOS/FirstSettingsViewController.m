
//
//  FirstSettingsViewController.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/13.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "FirstSettingsViewController.h"
#import "APIClient.h"
#import "AFHTTPRequestOperationManager.h"
#import "StatusTool.h"
#import "APIAddress.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface FirstSettingsViewController ()<UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *potraitBtn;
- (IBAction)setPoraitAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *portraitImage;
@property (nonatomic ,strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *authButton;
@property (weak, nonatomic) IBOutlet UILabel *authLabel;
@end

@implementation FirstSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPortraitWithImage:[self loadImageOfDoc]];
    [self initAuthUI];
    
}

#pragma mark--------初始化实名认证相关控件
- (void)initAuthUI {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strUserPermission = [defaults valueForKey:@"UserPermission"];
    if(strUserPermission!=nil){
        if([strUserPermission compare:@"认证用户"] == NSOrderedSame){
            self.authLabel.text = @"已认证";
            [self.authButton setEnabled:NO];
        }
    }
}

//刷新昵称
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nickNameLabel.text = [defaults valueForKey:@"UserNickname"];
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

- (IBAction)setPoraitAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"您可以选择以下方法" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self pickImageFromAlbum];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相机拍摄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self pickImageFromCamera];
        }
        

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
  
}

#pragma mark--------从用户相册获取活动图片

- (void)pickImageFromAlbum{
     self.imagePicker = [[UIImagePickerController alloc] init];
     self.imagePicker.delegate = self;
     self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  //从媒体库选择图片
     self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
     self.imagePicker.allowsEditing = YES;
     [[UIApplication sharedApplication]setStatusBarHidden:YES];
//     [self presentModalViewController:self.imagePicker animated:YES];
    [self presentViewController:self.imagePicker  animated:YES completion:nil];
   }

#pragma mark--------从摄像头获取活动图片

- (void)pickImageFromCamera{
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.imagePicker.allowsEditing = YES;
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
//        [self presentModalViewController:self.imagePicker animated:YES];
        [self presentViewController:self.imagePicker  animated:YES completion:nil];

}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    //获得编辑过的图片
    UIImage* chosenImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    //保存到本地documents中
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [[NSString alloc]initWithString:[defaults valueForKey:@"UserID"]];
    NSData * data = UIImageJPEGRepresentation(chosenImage, 1);
    NSString * userImage = [[NSString alloc]initWithFormat:@"%@.jpg",user_id ];
    [self saveImage:data WithName:userImage];
    //显示在UI中
    [self initPortraitWithImage:chosenImage];
    //这里要上传头像图片
    [self uploadPersonImginitWithImage:chosenImage];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
#pragma mark--------------UIImagePickerViewController  delegate

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

#pragma mark---------------保存图片到document
- (void)saveImage:(NSData *)imageData WithName:(NSString *)imageName{
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

#pragma mark -------------------------从本地读取头像图片
-(UIImage *)loadImageOfDoc{
    
    NSString *user_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserID"];
    NSString * userPortraitImage = [[NSString alloc]initWithFormat:@"%@.jpg",user_id ];
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:userPortraitImage];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExits = [fileManager fileExistsAtPath:fullPathToFile];
    if (fileExits) {
        return[UIImage imageWithContentsOfFile:fullPathToFile];
    }else{
        return [UIImage imageNamed:@"icon_acatar_default_r"];
    }
    
    
}


#pragma mark---------------将头像切割成圆形
-(void)initPortraitWithImage:(UIImage *)image{
    
    self.portraitImage.layer.masksToBounds = YES;
    [self.portraitImage.layer setCornerRadius:self.portraitImage.frame.size.width/2];
    self.portraitImage.contentMode = UIViewContentModeScaleAspectFill;
    self.portraitImage.image = image;
}


#pragma mark--------------    上传头像图片
-(void)uploadPersonImginitWithImage:(UIImage *)image{
    
        NSURL *baseUrl = [NSURL URLWithString:API_HOST];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:API_PORTRAIT_UPLOAD parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSData *data = UIImageJPEGRepresentation(image, 1);
            NSString * fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:data name:@"uploadfile" fileName:fileName mimeType:@"image/jpeg"];
        
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (responseObject != nil) {
                [self refreshDB:responseObject[@"photourl"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (error != nil) {
                //to do
            }
        }];
    
}

#pragma  mark-------------------刷新数据库
-(void)refreshDB:(NSString *)guid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [[NSString alloc]initWithString:[defaults valueForKey:@"UserID"]];
    [StatusTool statusToolRefreshUserImageWithUserID:user_id ImageGUID:guid Success:^(id object) {
        NSData *data = [[NSData alloc] initWithData:object];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([[result valueForKey:@"status"] isEqualToString:@"OK"]) {
            
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hud];
            hud.labelText = @"设置成功";
            hud.mode = MBProgressHUDModeText;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
            }];
        }else{
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hud];
            hud.labelText = @"请查看您的网络";
            hud.mode = MBProgressHUDModeText;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
            }];
        }
     } failurs:^(NSError *error) {

        // to do wrong deals
     }];
   
}

@end
