//
//  ValidateViewController.m
//  CultureAssistant
//
//  Created by zhu yingmin on 2018/6/22.
//  Copyright © 2018年 天闻. All rights reserved.
//

#import "ValidateViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RegisterThirdController.h"

@interface ValidateViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate>
@property(nonatomic,strong)UIImageView* cardFrontView;
@property(nonatomic,strong)UIImageView* cardBackView;
@property(nonatomic,assign)BOOL isFront;

@property(nonatomic,assign)BOOL hasFront;
@property(nonatomic,assign)BOOL hasBack;

@property(nonatomic,strong)NSMutableDictionary* dictionary;//传递参数
@property(nonatomic,strong)NSMutableArray* mutableArray;
@end

@implementation ValidateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    self.title = @"实名认证";
    
    self.mutableArray = [[NSMutableArray alloc] initWithCapacity:2];
    [self.mutableArray addObject:[NSDictionary dictionary]];
    [self.mutableArray addObject:[NSDictionary dictionary]];
    
    
    if (self.paramDic) {
        self.dictionary = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
    }else{
        self.dictionary = [NSMutableDictionary dictionary];
    }
    
    [self setupUI];
}


- (void)tapCardFrontView:(UITapGestureRecognizer *)gesture
{
    self.isFront = YES;
    UIActionSheet* sheeet = [[UIActionSheet alloc] initWithTitle:@"上传人像页"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照",@"从相册选取", nil];
    [sheeet showInView:self.view];
}

- (void)tapCardBackView:(UITapGestureRecognizer *)gesture
{
    self.isFront = NO;
    UIActionSheet* sheeet = [[UIActionSheet alloc] initWithTitle:@"上传国徽页"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照",@"从相册选取", nil];
    [sheeet showInView:self.view];
}

#pragma mark-
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (0 == buttonIndex){//相机
        [self takePhoto];
    }else if (1 == buttonIndex){//相册
        [self openPhotoLib];
    }
}

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
//    camera.allowsEditing = YES;
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

//拍照 获取照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"%s  \n%@",__func__,info);
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

    UIImage* originalImg = info[UIImagePickerControllerOriginalImage];
    UIImage *userImage = [Utility fixOrientation:originalImg];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(originalImg, nil, nil, nil);
    }
    if (self.isFront) {
        _cardFrontView.image = userImage;
        self.hasFront = YES;
        for (UIView* subView in _cardFrontView.subviews) {
            [subView removeFromSuperview];
        }
        
        [self uploadImage:_cardFrontView.image success:^(id JSON){
            NSDictionary* dic = [Utility dictionaryWithJsonString:JSON];
            [self.mutableArray replaceObjectAtIndex:0 withObject:dic];
            
        } failure:^(id JSON){

        }];

    }
    else
    {
        _cardBackView.image = userImage;
        self.hasBack = YES;
        for (UIView* subView in _cardBackView.subviews) {
            [subView removeFromSuperview];
        }
        
        [self uploadImage:_cardBackView.image success:^(id JSON){
            NSDictionary* dic = [Utility dictionaryWithJsonString:JSON];
            [self.mutableArray replaceObjectAtIndex:1 withObject:dic];
            
        } failure:^(id JSON){
            
        }];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"%s",__func__);
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//上传图片
- (void)uploadImage:(UIImage *)image success:(void (^)(id JSON))success failure:(void (^)(id JSON))failure
{
    NSString* imageHash = [image UIImageToMD5];

    [AFNetAPIClient PostMediaData:APIUplaodFile parameters:[RequestParameters uploadFile:@"1" md5:imageHash coverType:@"3"] mediaData:@[ImageFile,image] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        success(model.result);
    }failure:^(id JSON, NSError *error){
        failure(JSON);
    }];
}

- (void)tapButtonAction:(UIButton *)button
{
    if (!self.modifyVolunteer)
    {
        if (!self.hasFront) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请添加人像页"];return;
        }
        if (!self.hasBack) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请添加国徽页"];return;
        }
    }

    NSDictionary* dictionary = @{@"values":self.mutableArray};
    
    NSData *data= [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *base64Encode = [data base64EncodedStringWithOptions:0];
    
    [self.dictionary setObject:base64Encode forKey:@"uploadJson"];
    
    
    RegisterThirdController* vc = [RegisterThirdController new];
    vc.paramDic = self.dictionary;
    vc.modifyVolunteer = self.modifyVolunteer;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- init
- (void)setupUI
{
    UIButton* button = [UIButton new];
    button.backgroundColor = BaseColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(-HOME_INDICATOR_HEIGHT);
        make.height.equalTo(44);
    }];
    
    
    
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = Color666666;
    label.text = @"拍摄/上传您的身份证";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(10);
        make.centerX.equalTo(self.view);
    }];
    
    
    label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = BaseColor;
    label.text = @"信息仅用于实名认证，盲图APP保障您的信息安全";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(button.top).offset(-20);
    }];
    
    _cardFrontView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sfz_01"]];
    [self.view addSubview:_cardFrontView];
    [_cardFrontView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(270, 170));
        make.centerX.equalTo(self.view);
        make.top.equalTo(50);
    }];
    {
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_camera"]];
        [_cardFrontView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.cardFrontView);
            make.top.equalTo(30);
        }];

        UILabel* label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = @"拍摄人像页";
        [_cardFrontView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.cardFrontView);
            make.top.equalTo(imgView.bottom).offset(20);
        }];
    }
    
    _cardBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sfz_02"]];
    [self.view addSubview:_cardBackView];
    [_cardBackView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(270, 170));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.cardFrontView.bottom).offset(20);
    }];
    {
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_camera"]];
        [_cardBackView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.cardBackView);
            make.top.equalTo(30);
        }];

        UILabel* label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = @"拍摄国徽页";
        [_cardBackView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.cardBackView);
            make.top.equalTo(imgView.bottom).offset(20);
        }];
    }

    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] != 2)
    {
        _cardFrontView.userInteractionEnabled = YES;
        _cardBackView.userInteractionEnabled = YES;
        
        [_cardFrontView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCardFrontView:)]];
        [_cardBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCardBackView:)]];
    }

    
    VolunteerInfo* volunteer = [UserInfoManager sharedInstance].volunteer;
    NSArray * array = volunteer.certifPhotos;
    
    typeof(self) __weak wself = self;
    if (array.count > 0) {
        NSDictionary* dic = array[0];
        [self.mutableArray replaceObjectAtIndex:0 withObject:dic];
        
        [self.cardFrontView sd_setImageWithURL:[NSURL URLWithString:dic[@"remoteUrl"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
            
            wself.hasFront = YES;
            for (UIView* subView in wself.cardFrontView.subviews) {
                [subView removeFromSuperview];
            }
        }];
    }
    if (array.count > 1) {
        NSDictionary* dic = array[1];
        [self.mutableArray replaceObjectAtIndex:1 withObject:dic];
        
        [self.cardBackView sd_setImageWithURL:[NSURL URLWithString:dic[@"remoteUrl"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL){
            
            wself.hasBack = YES;
            for (UIView* subView in wself.cardBackView.subviews) {
                [subView removeFromSuperview];
            }
        }];
        
    }
}



@end
