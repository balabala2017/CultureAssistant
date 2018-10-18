//
//  SettingViewController.m
//  CultureAssistant
//

#import "SettingViewController.h"
#import "ModifyPasswordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VPImageCropperViewController.h"
#import "EditViewController.h"

@interface SettingViewController ()

@property(nonatomic,strong)UIImageView* headerIcon;
@property(nonatomic,strong)UILabel* phoneLabel;
@property(nonatomic,strong)UILabel* nicknameLabel;
@property(nonatomic,strong)UIButton* maleBtn;
@property(nonatomic,strong)UIButton* femaleBtn;
@property(nonatomic,strong)UILabel* cacheLabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    
    [self createSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userModel.userinfo;
    if (userInfo.headerIconUrl) {
        [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:userInfo.headerIconUrl] placeholderImage:[UIImage imageNamed:@"my_header"]];
    }
    self.phoneLabel.text = userInfo.phoneNum;
    self.nicknameLabel.text = userInfo.nickName;
    if ([userInfo.sex isEqualToString:@"male"]) {
        self.maleBtn.selected = YES;
        self.femaleBtn.selected = NO;
    }else if([userInfo.sex isEqualToString:@"female"]){
        self.maleBtn.selected = NO;
        self.femaleBtn.selected = YES;
    }
}

- (void)editBasicInfo:(UIButton *)button
{
    EditViewController * vc = [EditViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)onSelectSexAction:(UIButton *)button{
    NSString* sexString;
    if (10 == button.tag) {
        self.maleBtn.selected = YES;
        self.femaleBtn.selected = NO;
        sexString = @"male";
    }else{
        self.maleBtn.selected = NO;
        self.femaleBtn.selected = YES;
        sexString = @"female";
    }
    
    [AFNetAPIClient POST:APIUpdateUserInfo parameters:[RequestParameters updateSex:sexString userid:[UserInfoManager sharedInstance].userModel.userinfo.id] success:^(id JSON, NSError *error){
        [[UserInfoManager sharedInstance] getUserCenterInfo:^(BOOL finished){
            
        }];
    }failure:^(id JSON, NSError *error){
        
    }];
}

- (void)modifyPassword:(UITapGestureRecognizer *)gesture{
    ModifyPasswordViewController* controller = [ModifyPasswordViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clearCache:(UITapGestureRecognizer *)gesture{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DeviceHelper clearDisk];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"清除成功"];
            self.cacheLabel.text = @"0.0MB";
        });
    });
}


- (void)onLogoutAction:(UIButton *)button{

    UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"确认退出当前账号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    typeof(self) __weak wself = self;
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [wself logoutAccount];
    }]];
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)logoutAccount{
    [[UserInfoManager sharedInstance] deleteUserInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark-
- (void)createSubViews{
    SettingCellView* cell1 = [SettingCellView new];
    cell1.titleLabel.text = @"基本信息";
    [self.view addSubview:cell1];
    [cell1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(44);
    }];
    [cell1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBasicInfo:)]];
    

    SettingCellView* cell6 = [SettingCellView new];
    cell6.titleLabel.text = @"密码修改";
    [cell6 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyPassword:)]];
    [self.view addSubview:cell6];
    [cell6 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cell1.bottom);
        make.left.right.height.equalTo(cell1);
    }];

    
    SettingCellView* cell7 = [SettingCellView new];
    cell7.titleLabel.text = @"释放缓存";
    [cell7 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearCache:)]];

    [self.view addSubview:cell7];
    [cell7 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cell6.bottom);
        make.left.right.height.equalTo(cell1);
    }];
    {
        self.cacheLabel = [UILabel new];
        self.cacheLabel.font = [UIFont systemFontOfSize:16];
        self.cacheLabel.textAlignment = NSTextAlignmentRight;
        [cell7 addSubview:self.cacheLabel];
        [self.cacheLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(cell7.right).offset(-47);
            make.centerY.equalTo(cell7.centerY);
        }];
        
        self.cacheLabel.text = [DeviceHelper getDiskSize];

    }
    

    UIButton* logoutBtn = [UIButton new];
    logoutBtn.layer.cornerRadius = 2.f;
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor colorWithHexString:@"434343"] forState:UIControlStateNormal];
    logoutBtn.layer.borderColor = [UIColor colorWithHexString:@"d7d7d7"].CGColor;
    logoutBtn.layer.borderWidth = 1.f;
    logoutBtn.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    [logoutBtn addTarget:self action:@selector(onLogoutAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cell7.bottom).offset(34);
        make.left.equalTo(self.view.left).offset(15);
        make.right.equalTo(self.view.right).offset(-15);
        make.height.equalTo(44);
    }];
}
@end
