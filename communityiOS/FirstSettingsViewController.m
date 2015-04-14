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

@interface FirstSettingsViewController ()<UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *potraitBtn;
- (IBAction)setPoraitAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *portraitImage;
@property (nonatomic ,strong) UIImagePickerController *imagePicker;

@end

@implementation FirstSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

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
        
        [self pickImageFromCamera];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
  
}

#pragma mark--------从用户相册获取活动图片
- (void)pickImageFromAlbum{
      self.imagePicker = [[UIImagePickerController alloc] init];
     self.imagePicker.delegate = self;
     self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
      self.imagePicker.allowsEditing = YES;
     [[UIApplication sharedApplication]setStatusBarHidden:YES];
     [self presentModalViewController:self.imagePicker animated:YES];
   }

#pragma mark--------从摄像头获取活动图片
- (void)pickImageFromCamera{
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.imagePicker.allowsEditing = YES;
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [self presentModalViewController:self.imagePicker animated:YES];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    //获得编辑过的图片
    UIImage* chosenImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
    //保存到本地documents中
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [[NSString alloc]initWithString:[defaults valueForKey:@"UserID"]];
    NSString *userImage = [[NSString alloc]initWithFormat:@"%@.jpg",user_id];
    [self saveImage:chosenImage WithName:userImage];
    //显示在UI中
    [self initPortraitWithImage:chosenImage];
    //这里要上传头像图片
    [self uploadPersonImginitWithImage:chosenImage];
    
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

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
        NSData* imageData = UIImageJPEGRepresentation(tempImage,0.2);
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        // Now we get the full path to the file
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
        // and then we write it out
        [imageData writeToFile:fullPathToFile atomically:NO];
}

//将头像切割成圆形
-(void)initPortraitWithImage:(UIImage *)image{
    
    self.portraitImage.layer.masksToBounds = YES;
    [self.portraitImage.layer setCornerRadius:self.portraitImage.frame.size.width/2];
    self.portraitImage.contentMode = UIViewContentModeScaleAspectFill;
    self.portraitImage.image = image;
}


//上传头像图片
-(void)uploadPersonImginitWithImage:(UIImage *)image{

     NSURL *baseUrl = [NSURL URLWithString:@"http://192.168.1.109/sq/upload.php"];
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
       
        //刷新数据库，post
        [self refreshDB:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

-(void)refreshDB:(id)object{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id = [[NSString alloc]initWithString:[defaults valueForKey:@"UserID"]];
    
    [StatusTool statusToolRefreshUserImageWithUserID:user_id ImageGUID:(NSString *)object Success:^(id object) {
        // to do right
    } failurs:^(NSError *error) {
        // to do error
    }];
   
}

@end
