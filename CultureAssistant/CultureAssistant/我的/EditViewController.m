//
//  EditViewController.m
//  CultureAssistant
//
//  Created by zhu yingmin on 2018/10/10.
//  Copyright © 2018年 天闻. All rights reserved.
//

#import "EditViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VPImageCropperViewController.h"

@interface EditViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UIPopoverControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIImageView* headerIcon;
@property(nonatomic,strong)UITextField* phoneField;
@property(nonatomic,strong)UITextField* nickNameField;
@property(nonatomic,strong)UITextField* mailField;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self setupMainUI];
}

- (void)onTapButton:(UIButton *)button
{

    typeof(self) __weak wself = self;
    UserModel* userModel = [UserInfoManager sharedInstance].userModel;
    
    NSDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:userModel.userinfo.id forKey:@"id"];
    if ([_phoneField.text length] > 0) {
        [dic setValue:_phoneField.text forKey:@"phoneNum"];
    }
    if ([_nickNameField.text length] > 0) {
        [dic setValue:_nickNameField.text forKey:@"nickName"];
    }
    if ([_mailField.text length] > 0) {
        if ([NSString validateEmail:_mailField.text]) {
            [dic setValue:_mailField.text forKey:@"mail"];
        }else{
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入正确的邮箱"];
        }
    }
    
    dic = [[RequestHelper sharedInstance] prepareRequestparameter:dic];
    
    
    [AFNetAPIClient POST:APIUpdateUserInfo parameters:dic success:^(id JSON, NSError *error){
        
        [[UserInfoManager sharedInstance] getUserCenterInfo:^(BOOL finished){
            if (finished) {
                [wself.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }failure:^(id JSON, NSError *error){
        DataModel* model = (DataModel *)JSON;
        if ([model isKindOfClass:[DataModel class]]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userModel.userinfo;
    if (userInfo.headerIconUrl) {
        [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:userInfo.headerIconUrl] placeholderImage:[UIImage imageNamed:@"my_header"]];
    }
    _phoneField.text = userInfo.phoneNum;
    _nickNameField.text = userInfo.nickName;
    if ([userInfo.mail length] > 0) {
        _mailField.text = userInfo.mail;
    }
}

- (void)modifyUserHeadIcon:(UITapGestureRecognizer *)gesture{
    
    UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"修改头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    typeof(self) __weak wself = self;
    [vc addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [wself takePhoto];
    }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [wself openPhotoLib];
    }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }]];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark-
-(void)takePhoto
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                    message:@"请在系统【设置】-【隐私】设置文化助盲应用权限"
                                   delegate:nil
                          cancelButtonTitle:@"好"
                          otherButtonTitles: nil] show];
        
        return;
    }
    
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.delegate = self;
    camera.allowsEditing = YES;
    camera.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    //检查摄像头是否支持摄像机模式
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //UI 显示样式，显示的格式确定
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"摄像头不存在"];
        return;
    }
    //拍摄照片的清晰度，只有在照相机模式下可用
    camera.videoQuality = UIImagePickerControllerQualityTypeLow;
    [self presentViewController:camera animated:YES completion:nil];
}

-(void)openPhotoLib
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    controller.mediaTypes = mediaTypes;
    controller.delegate = self;
    [self presentViewController:controller
                       animated:YES
                     completion:^(void){
                         NSLog(@"Picker View Controller is presented");
                     }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage* originalImg = info[ UIImagePickerControllerOriginalImage];
    UIImage *userImage = [Utility fixOrientation:originalImg];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(originalImg, nil, nil, nil);
    }
    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:userImage cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
    imgEditorVC.view.backgroundColor=[UIColor blackColor];
    imgEditorVC.delegate = self;
    
    [self presentViewController:imgEditorVC animated:YES completion:^{
        
    }];
}
#pragma mark- VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    self.tabBarController.tabBar.hidden = NO;
    //编辑图片后，上传头像图片
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [self uploadUserHeadImage:editedImage];
        
    }];
}
//取消的方法
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    self.tabBarController.tabBar.hidden = NO;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//上传用户头像
- (void)uploadUserHeadImage:(UIImage *)image
{
    NSString* imageHash = [image UIImageToMD5];
    typeof(self) __weak wself = self;
    
    [AFNetAPIClient PostMediaData:APIUplaodFile parameters:[RequestParameters uploadFile:@"1" md5:imageHash coverType:@"3"] mediaData:@[ImageFile,image] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        UploadImageModel* imageModel = [[UploadImageModel alloc] initWithString:(NSString *)model.result error:nil];
        [wself updateUserHead:imageModel.url];
    }failure:^(id JSON, NSError *error){
        
    }];
}

- (void)updateUserHead:(NSString *)urlString{
    
    [AFNetAPIClient POST:APIUpdateUserInfo parameters:[RequestParameters updateUserHead:urlString userid:[UserInfoManager sharedInstance].userModel.userinfo.id] success:^(id JSON, NSError *error){
        [[UserInfoManager sharedInstance] getUserCenterInfo:^(BOOL finished){
            if (finished) {
                UserInfo* userInfo = [UserInfoManager sharedInstance].userModel.userinfo;
                if (userInfo.headerIconUrl) {
                    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:userInfo.headerIconUrl] placeholderImage:[UIImage imageNamed:@"my_header"]];
                }
            }
        }];
    }failure:^(id JSON, NSError *error){
        
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _phoneField) {
        return NO;
    }
    return YES;
}

#pragma mark-
- (void)setupMainUI
{
    SettingCellView* cell1 = [SettingCellView new];
    cell1.titleLabel.text = @"头像";
    [self.view addSubview:cell1];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(74);
    }];
    {
        self.headerIcon = [UIImageView_SD new];
        self.headerIcon.image = [UIImage imageNamed:@"my_header"];
        self.headerIcon.layer.masksToBounds = YES;
        self.headerIcon.layer.cornerRadius = 55/2.0;
        self.headerIcon.userInteractionEnabled = YES;
        [cell1 addSubview:self.headerIcon];
        [self.headerIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyUserHeadIcon:)]];
        [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(cell1).offset(-40);
            make.centerY.equalTo(cell1.centerY);
            make.height.width.equalTo(55);
        }];
    }
    
    SettingCellView* cell2 = [SettingCellView new];
    cell2.titleLabel.text = @"手机号码";
    cell2.arrowView.hidden = YES;
    [self.view addSubview:cell2];
    [cell2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cell1.bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(44);
    }];
    {
        _phoneField = [UITextField new];
        _phoneField.delegate = self;
        _phoneField.font = [UIFont systemFontOfSize:16];
        _phoneField.placeholder = @"输入手机号码";
        _phoneField.textAlignment = NSTextAlignmentRight;
        [cell2 addSubview:_phoneField];
        [_phoneField mas_makeConstraints:^(MASConstraintMaker * make){
            make.centerY.equalTo(cell2);
            make.height.equalTo(40);
            make.width.equalTo(SCREENWIDTH-100);
            make.right.equalTo(-10);
        }];
    }
    
    SettingCellView* cell3 = [SettingCellView new];
    cell3.titleLabel.text = @"昵称";
    cell3.arrowView.hidden = YES;
    [self.view addSubview:cell3];
    [cell3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cell2.bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(44);
    }];
    {
        _nickNameField = [UITextField new];
        _nickNameField.font = [UIFont systemFontOfSize:16];
        _nickNameField.placeholder = @"输入昵称";
        _nickNameField.textAlignment = NSTextAlignmentRight;
        [cell3 addSubview:_nickNameField];
        [_nickNameField mas_makeConstraints:^(MASConstraintMaker * make){
            make.centerY.equalTo(cell3);
            make.height.equalTo(40);
            make.width.equalTo(SCREENWIDTH-100);
            make.right.equalTo(-10);
        }];
    }
    
    SettingCellView* cell4 = [SettingCellView new];
    cell4.titleLabel.text = @"邮箱";
    cell4.arrowView.hidden = YES;
    [self.view addSubview:cell4];
    [cell4 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cell3.bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(44);
    }];
    {
        _mailField = [UITextField new];
        _mailField.font = [UIFont systemFontOfSize:16];
        _mailField.placeholder = @"输入邮箱";
        _mailField.textAlignment = NSTextAlignmentRight;
        [cell4 addSubview:_mailField];
        [_mailField mas_makeConstraints:^(MASConstraintMaker * make){
            make.centerY.equalTo(cell4);
            make.height.equalTo(40);
            make.width.equalTo(SCREENWIDTH-100);
            make.right.equalTo(-10);
        }];
    }
}
@end
