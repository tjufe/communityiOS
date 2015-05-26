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

@interface NewPostEditViewController ()

@property(strong,nonatomic) UIImageView *postMainPicImageView;
@property(strong,nonatomic) UILabel *forumNameLabel;
@property(strong,nonatomic) UITextField *postTitleTextField;
@property(strong,nonatomic) UIView *v;
@property(strong,nonatomic) UITextField *postLocationTextField;
@property(strong,nonatomic) UIView *v3;
@property(strong,nonatomic) UITextView *postContentTextView;
@property(strong,nonatomic) UITextField *reporterNameTextField;
@property(strong,nonatomic) UITextField *reporterPhoneTextField;
@property(strong,nonatomic) UIView *v2;
@property(strong,nonatomic) UIScrollView *sv;
@property(strong,nonatomic) UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UIImageView *ImagePickerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *LinkPickerImageView;

@property (nonatomic ,strong) UIImagePickerController *imagePicker;

@end

@implementation NewPostEditViewController

NSString * const m_site_addchain = @"是否提供外链功能";
NSString * const m_site_addmainimg = @"主帖是否包含主图";
NSString * const KEY_SITE_VALUE_YES = @"是";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigationBar];
    [self initMainScrollView];
    [self initFooterToolbar];
}

- (void)initFooterToolbar {
    for (NSArray *row  in _forum_item.ForumSetlist) {
        forumSetItem *fs = [forumSetItem createItemWitparametes:row];
        if([fs.site_name rangeOfString:m_site_addchain].location!=NSNotFound){
            [self setLinkPickerWithNeedHidden:[fs.site_value rangeOfString:KEY_SITE_VALUE_YES].location == NSNotFound];
        }else if([fs.site_name rangeOfString:m_site_addmainimg].location!=NSNotFound){
            [self setImagePickerWithNeedHidden:[fs.site_value rangeOfString:KEY_SITE_VALUE_YES].location == NSNotFound];
        }
    }
}

- (void)setLinkPickerWithNeedHidden:(BOOL)needHidden {
    [self.LinkPickerImageView setHidden:needHidden];
}

- (void)setImagePickerWithNeedHidden:(BOOL)needHidden {
    [self.ImagePickerImageView setHidden:needHidden];
    [self.ImagePickerImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImagePicker:)];
    [self.ImagePickerImageView addGestureRecognizer:singleTap];
}

-(void)showImagePicker:(UIGestureRecognizer *)gestureRecognizer {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self presentModalViewController:self.imagePicker animated:YES];

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
    [self initForumName];
    [self initPostTitle];
    [self initLocation];
    [self initRepairType];
    [self initPostContent];
    [self initReporterName];
    [self initReporterPhone];
    [self initPostMainPic];
    
    
    [self.mainScrollView addSubview:self.forumNameLabel];
    [self.mainScrollView addSubview:self.v];
    [self.mainScrollView addSubview:self.v3];
    [self.mainScrollView addSubview:self.sv];
    [self.mainScrollView addSubview:self.postContentTextView];
    [self.mainScrollView addSubview:self.v2];
    [self.mainScrollView addSubview:self.postMainPicImageView];
    
    self.mainScrollView.contentSize = CGSizeMake(0, self.postMainPicImageView.frame.origin.y+self.postMainPicImageView.frame.size.height);

}

- (void)initNavigationBar {
    self.navigationItem.title = @"提交报修";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"上报" style:UIBarButtonItemStyleBordered  target:self action:@selector(reqReportRepair)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)reqReportRepair {
    NSString *post_title = [self getPostTitle];//帖子标题
    NSString *post_text = [self getPostText];//故障位置
    NSString *post_text_1 = [self getPostText1];//故障描述
    NSString *post_text_2 = [self getPostText2];//联系人
    NSString *post_text_3 = [self getPostText3];//联系电话
    if(post_title && post_text && post_text_1 && post_text_2 && post_text_3){
        //发送网络调用
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        PostInfo *postInfo = [PostInfo new];
        postInfo.community_id = [defaults valueForKey:@"CommunityID"];
        postInfo.forum_id = _forum_item.forum_id;
        postInfo.poster_id =[defaults valueForKey:@"UserID"];
        postInfo.post_title = post_title;
        postInfo.main_image_url = @"";
        postInfo.post_text_1 = post_text_1;
        postInfo.post_text_2 = post_text_2;
        postInfo.post_text_3 = post_text_3;
        postInfo.chain = @"否";
        postInfo.chain_name = @"";
        postInfo.chain_url = @"";
        postInfo.open_apply = @"否";
        postInfo.need_check = @"否";
        postInfo.checked = @"是";
        [StatusTool statusToolNewPostWithPostInfo:postInfo Success:^(id result){
            
        }failurs:^(NSError *error) {
            
        }];
    }else{
        
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
    UIFont *font = [UIFont fontWithName:@"Arial" size:12.0f];
    self.forumNameLabel = [[UILabel alloc]init];
    self.forumNameLabel.text = _forum_item.forum_name;
    self.forumNameLabel.font = font;
    self.forumNameLabel.textAlignment = UITextAlignmentCenter;
    self.forumNameLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
}

- (void)initPostTitle {
    self.postTitleTextField = [[UITextField alloc]init];
    self.postTitleTextField.placeholder = @"请输入标题……";
    self.postTitleTextField.font = self.forumNameLabel.font;
    self.postTitleTextField.textAlignment = UITextAlignmentLeft;
    self.postTitleTextField.frame = CGRectMake(8, 0, self.view.frame.size.width-8, 30);
    self.v= [[UIView alloc]init];
    self.v.frame = CGRectMake(0, self.forumNameLabel.frame.size.height, self.view.frame.size.width, self.postTitleTextField.frame.size.height);
    self.v.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.v addSubview:self.postTitleTextField];
}

- (void)initLocation {
    self.postLocationTextField = [[UITextField alloc]init];
    self.postLocationTextField.placeholder = @"请输入故障地点……";
    self.postLocationTextField.font = self.forumNameLabel.font;
    self.postLocationTextField.textAlignment = UITextAlignmentLeft;
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
    self.postContentTextView.font = self.forumNameLabel.font;
    self.postContentTextView.textAlignment = UITextAlignmentLeft;
    self.postContentTextView.frame = CGRectMake(4,self.sv.frame.origin.y+self.sv.frame.size.height, self.view.frame.size.width-4, 30);
    self.postContentTextView.delegate = self;
    self.postContentTextView.text = @"其他故障类型描述：";
    [self.postContentTextView setEditable:NO];
//    [self.postContentTextView selectAll:self];

}

- (void)initReporterName {
    self.reporterNameTextField = [[UITextField alloc]init];
    self.reporterNameTextField.placeholder = @"请输入联系人姓名……";
    self.reporterNameTextField.font = self.forumNameLabel.font;
    self.reporterNameTextField.textAlignment = UITextAlignmentLeft;
    self.reporterNameTextField.frame = CGRectMake(8, 0, self.view.frame.size.width-8, 30);
    self.v2= [[UIView alloc]init];
    self.v2.frame = CGRectMake(0,self.postContentTextView.frame.origin.y+self.postContentTextView.frame.size.height, self.view.frame.size.width, 60);
    self.v2.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    [self.v2 addSubview:self.reporterNameTextField];
}

- (void)initReporterPhone {
    self.reporterPhoneTextField = [[UITextField alloc]init];
    self.reporterPhoneTextField.placeholder = @"请输入联系人电话……";
    self.reporterPhoneTextField.font = self.forumNameLabel.font;
    self.reporterPhoneTextField.textAlignment = UITextAlignmentLeft;
    self.reporterPhoneTextField.frame = CGRectMake(8, 30, self.view.frame.size.width-8, 30);
    [self.v2 addSubview:self.reporterPhoneTextField];
}

- (void)initPostMainPic {
    self.postMainPicImageView = [[UIImageView alloc]init];
    self.postMainPicImageView.frame = CGRectMake(0, self.v2.frame.origin.y+self.v2.frame.size.height, self.view.frame.size.width, 158);
    self.postMainPicImageView.image = [UIImage imageNamed:@"image_01"];
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
