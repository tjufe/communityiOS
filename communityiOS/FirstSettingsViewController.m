//
//  FirstSettingsViewController.m
//  communityiOS
//
//  Created by Sunxiaoyuan on 15/4/13.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//

#import "FirstSettingsViewController.h"

@interface FirstSettingsViewController ()<UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *potraitBtn;
- (IBAction)setPoraitAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *portraitImage;

@end

@implementation FirstSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initPortraitWithImage:(UIImage *)image{
    
    self.portraitImage.layer.masksToBounds = YES;
    [self.portraitImage.layer setCornerRadius:self.portraitImage.frame.size.width/2];
    self.portraitImage.contentMode = UIViewContentModeScaleAspectFill;
    self.portraitImage.image = image;
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
        UIImagePickerController *imagePicker;
        imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.delegate = self;
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [self presentModalViewController:imagePicker animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消相机拍摄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker;
        imagePicker = [[UIImagePickerController alloc]init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            NSLog(@"模拟器无法打开相机");
        }
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
        [self presentModalViewController:imagePicker animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
  
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self initPortraitWithImage:chosenImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
}

@end
