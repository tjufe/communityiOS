//
//  UserCenterLoggedViewController.m
//  communityiOS
//
//  Created by 何茂馨 on 15/4/1.
//  Copyright (c) 2015年 &#20309;&#33538;&#39336;. All rights reserved.
//


#import "LoginNavigationController.h"
#import "UIViewController+Create.h"
#import "UserCenterLoggedViewController.h"
#import "PPRevealSideViewController.h"
#import "UIImageView+WebCache.h"

#import "PostListViewController.h"
#import "UserJoinPostListViewController.h"

#import "APIClient.h"
#import "AuthTableViewController.h"
#import "APIAddress.h"

@interface UserCenterLoggedViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *authIcon;
@property (strong, nonatomic) IBOutlet UIButton *authBtn;
- (IBAction)authAction:(id)sender;

@end

@implementation UserCenterLoggedViewController

#pragma mark------我的话题 lx20150504
- (IBAction)go2myPostList:(id)sender {
    PostListViewController *poLVC = [PostListViewController createFromStoryboardName:@"PostList" withIdentifier:@"PostListID"];
    poLVC.filter_flag = @"我发起的";
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:poLVC];
//    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(go2main)];
//    poLVC.navigationItem.leftBarButtonItem=leftBtn;
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 20, 10, 20);
    [btn setImage:[UIImage imageNamed:@"back"] forState: UIControlStateNormal];
    [btn addTarget:self action:@selector(go2main) forControlEvents:UIControlEventTouchUpInside];
    UINavigationController *nav = [[UINavigationController alloc]init];
    UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithCustomView:btn];
    poLVC.navigationItem.leftBarButtonItem =leftBtn;
    
   [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
    [nav pushViewController:poLVC animated:YES];
}

-(void)go2main{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:view];
    [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
}

#pragma mark------我参与的 lx20150505
- (IBAction)go2myEnjoyPostList:(id)sender {
//    UncheckPostListViewController *unPLVC = [UncheckPostListViewController
//        createFromStoryboardName:@"UncheckPostList" withIdentifier:@"uncheck"];
    UINavigationController  *unPLVC = [UINavigationController createFromStoryboardName:@"UserJoinPostList" withIdentifier:@"myIn"];
    [self.revealSideViewController popViewControllerWithNewCenterController:unPLVC animated:YES];
}

#pragma mark------待审核话题 lx20150504
- (IBAction)go2uncheckPostList:(id)sender {
    PostListViewController *poLVC = [PostListViewController createFromStoryboardName:@"PostList" withIdentifier:@"PostListID"];
    poLVC.filter_flag = @"待审核";
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 20, 10, 20);
    [btn setImage:[UIImage imageNamed:@"back"] forState: UIControlStateNormal];
    [btn addTarget:self action:@selector(go2main) forControlEvents:UIControlEventTouchUpInside];
    UINavigationController *nav = [[UINavigationController alloc]init];
    UIBarButtonItem *leftBtn =[[UIBarButtonItem alloc]initWithCustomView:btn];
    poLVC.navigationItem.leftBarButtonItem =leftBtn;
    
    [self.revealSideViewController popViewControllerWithNewCenterController:nav animated:YES];
    [nav pushViewController:poLVC animated:YES];

}


- (IBAction)go2settings:(id)sender {
    UINavigationController *vc=[UINavigationController createFromStoryboardName:@"Settings" withIdentifier:@"Settings"];
    
    //    [self presentModalViewController:vc animated:YES];
    
    [self.revealSideViewController popViewControllerWithNewCenterController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [defaults valueForKey:@"PhoneNumber"];
    if(phoneNumber!=nil){
        NSString *userNickname = [defaults valueForKey:@"UserNickname"];
        NSString *headPortraitUrl = [defaults valueForKey:@"HeadPortraitUrl"];
        NSString *user_id = [defaults valueForKey:@"UserID"];
        _labelNickname.text = userNickname;
        NSString * userPortraitImage = [[NSString alloc]initWithFormat:@"%@.jpg",user_id ];
        NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:userPortraitImage];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExits = [fileManager fileExistsAtPath:fullPathToFile];
        if (fileExits) {
            [self initPortraitWithImage:[UIImage imageWithContentsOfFile:fullPathToFile]];
        } else {
            //从服务器下载头像,并存储到本地
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",API_PROTRAIT_DOWNLOAD,headPortraitUrl];
            NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlStr, NULL,CFSTR("!*'();@&=+$,?%#[]-"), kCFStringEncodingUTF8 ));
            NSURL *portraitDownLoadUrl = [NSURL URLWithString:escapedUrlString];
            [self.imgAvatar sd_setImageWithURL:portraitDownLoadUrl placeholderImage:[UIImage imageNamed:@"icon_acatar_default_r"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSData *imageData = UIImageJPEGRepresentation(image, 1);
                [self saveImage:imageData WithName:fullPathToFile];
                [self initPortraitWithImage:image];
            }];
        }
        //判断是否是管理员，显示“实名认证”图标
//        if ([[NSString stringWithString:[defaults valueForKey:@"UserPermission"]]isEqualToString:@"管理员"]) {
//            self.authIcon.hidden = NO;
//            self.authBtn.hidden = NO;
//        }

    }
}

#pragma mark---------------将头像切割成圆形
-(void)initPortraitWithImage:(UIImage *)image{
    
    self.imgAvatar.layer.masksToBounds = YES;
    [self.imgAvatar.layer setCornerRadius:self.imgAvatar.frame.size.width/2];
    self.imgAvatar.contentMode = UIViewContentModeScaleAspectFill;
    self.imgAvatar.image = image;
}

#pragma mark---------------保存图片到document
- (void)saveImage:(NSData *)imageData WithName:(NSString *)imageName{
    NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
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

- (IBAction)authAction:(id)sender {
    
}
@end
