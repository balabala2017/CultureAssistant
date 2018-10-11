//
//  SettingViewController.m
//  CultureAssistant
//

#import "SettingViewController.h"
#import "ModifyPasswordViewController.h"
#import "ModifyNicknameViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VPImageCropperViewController.h"
#import "AuthenticationViewController.h"
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


- (void)modifyPhoneNumber:(UITapGestureRecognizer *)gesture{
    AuthenticationViewController* controller = [AuthenticationViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)modifyNickname:(UITapGestureRecognizer *)gesture{
    ModifyNicknameViewController* controller = [ModifyNicknameViewController new];
    [self.navigationController pushViewController:controller animated:YES];
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
    {
//        self.headerIcon = [UIImageView_SD new];
//        self.headerIcon.image = [UIImage imageNamed:@"my_header"];
//        self.headerIcon.layer.masksToBounds = YES;
//        self.headerIcon.layer.cornerRadius = 55/2.0;
//        self.headerIcon.userInteractionEnabled = YES;
//        [cell1 addSubview:self.headerIcon];
//        [self.headerIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyUserHeadIcon:)]];
//        [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make){
//            make.right.equalTo(cell1).offset(-40);
//            make.centerY.equalTo(cell1.centerY);
//            make.height.width.equalTo(55);
//        }];
    }
    
    
//    SettingCellView* cell3 = [SettingCellView new];
//    cell3.titleLabel.text = @"昵称";
//    [cell3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyNickname:)]];
//    [self.view addSubview:cell3];
//    [cell3 mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(cell1.mas_bottom);
//        make.left.right.equalTo(cell1);
//        make.height.equalTo(@44);
//    }];
//    
//    {
//        self.nicknameLabel = [UILabel new];
//        self.nicknameLabel.textAlignment = NSTextAlignmentRight;
//        self.nicknameLabel.font = [UIFont systemFontOfSize:16];
//        [cell3 addSubview:self.nicknameLabel];
//        [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make){
//            make.right.equalTo(cell3.mas_right).offset(-47);
//            make.centerY.equalTo(cell3.mas_centerY);
//            make.width.equalTo(@200);
//            make.height.equalTo(@20);
//        }];
//    }
//    SettingCellView* cell4 = [SettingCellView new];
//    cell4.titleLabel.text = @"性别";
//    cell4.arrowView.hidden = YES;
//    [self.view addSubview:cell4];
//    [cell4 mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(cell3.mas_bottom);
//        make.left.right.height.equalTo(cell3);
//    }];
//    {
//        
//        self.femaleBtn = [UIButton new];
//        self.femaleBtn.tag = 11;
//        [self.femaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.femaleBtn setTitle:@"女" forState:UIControlStateNormal];
//        self.femaleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [self.femaleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
//        [self.femaleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
//        [self.femaleBtn setImage:[UIImage imageNamed:@"sex_unselect"] forState:UIControlStateNormal];
//        [self.femaleBtn setImage:[UIImage imageNamed:@"sex_selected"] forState:UIControlStateSelected];
//        [self.femaleBtn addTarget:self action:@selector(onSelectSexAction:) forControlEvents:UIControlEventTouchUpInside];
//        [cell4 addSubview:self.femaleBtn];
//        [self.femaleBtn mas_makeConstraints:^(MASConstraintMaker *make){
//            make.width.height.equalTo(@44);
//            make.right.equalTo(cell4.mas_right).offset(-47);
//            make.centerY.equalTo(cell4.mas_centerY);
//        }];
//        
//        
//        self.maleBtn = [UIButton new];
//        self.maleBtn.tag = 10;
//        [self.maleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.maleBtn setTitle:@"男" forState:UIControlStateNormal];
//        self.maleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [self.maleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
//        [self.maleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
//        [self.maleBtn setImage:[UIImage imageNamed:@"sex_unselect"] forState:UIControlStateNormal];
//        [self.maleBtn setImage:[UIImage imageNamed:@"sex_selected"] forState:UIControlStateSelected];
//        [self.maleBtn addTarget:self action:@selector(onSelectSexAction:) forControlEvents:UIControlEventTouchUpInside];
//        [cell4 addSubview:self.maleBtn];
//        [self.maleBtn mas_makeConstraints:^(MASConstraintMaker *make){
//            make.width.height.equalTo(self.femaleBtn);
//            make.centerY.equalTo(cell4.mas_centerY);
//            make.right.equalTo(self.femaleBtn.mas_left).offset(-10);
//        }];
//        
//        self.maleBtn.selected = YES;
//    }
    
//    UIView* lineView;
    
//    SettingCellView* cell5 = [SettingCellView new];
//    cell5.titleLabel.text = @"手机号码";
//    [self.view addSubview:cell5];
//    cell5.arrowView.hidden = YES;
////    cell5.lineView.hidden = YES;
////    [cell5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyPhoneNumber:)]];
//    [cell5 mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(cell1.mas_bottom);
//        make.left.right.equalTo(cell1);
//        make.height.equalTo(44);
//    }];
    {
//        self.phoneLabel = [UILabel new];
//        self.phoneLabel.font = [UIFont systemFontOfSize:16];
//        self.phoneLabel.textAlignment = NSTextAlignmentRight;
//        [cell5 addSubview:self.phoneLabel];
//        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make){
//            make.right.equalTo(cell5.right).offset(-47);
//            make.centerY.equalTo(cell5.centerY);
//            make.width.equalTo(200);
//            make.height.equalTo(20);
//        }];
        
//        lineView = [UIView new];
//        lineView.backgroundColor = [UIColor colorWithWhite:232/255.f alpha:1.f];
//        [cell5 addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
//            make.left.right.bottom.equalTo(cell5);
//            make.height.equalTo(@1);
//        }];
    }
    
//    UIView* gapView = [UIView new];
//    gapView.backgroundColor = [UIColor colorWithWhite:244/255.f alpha:1.f];
//    [self.view addSubview:gapView];
//    [gapView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.right.equalTo(self.view);
//        make.height.equalTo(@8);
//        make.top.equalTo(cell5.mas_bottom);
//    }];
    
    SettingCellView* cell6 = [SettingCellView new];
    cell6.titleLabel.text = @"密码修改";
    [cell6 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyPassword:)]];
    [self.view addSubview:cell6];
    [cell6 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cell1.bottom);
        make.left.right.height.equalTo(cell1);
    }];
//    {
//        lineView = [UIView new];
//        lineView.backgroundColor = [UIColor colorWithWhite:232/255.f alpha:1.f];
//        [cell6 addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
//            make.left.right.top.equalTo(cell6);
//            make.height.equalTo(@1);
//        }];
//    }
    
    SettingCellView* cell7 = [SettingCellView new];
    cell7.titleLabel.text = @"释放缓存";
    [cell7 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearCache:)]];
//    cell7.lineView.hidden = YES;
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
        
//        lineView = [UIView new];
//        lineView.backgroundColor = [UIColor colorWithWhite:232/255.f alpha:1.f];
//        [cell7 addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
//            make.left.right.bottom.equalTo(cell7);
//            make.height.equalTo(1);
//        }];
    }
    
//    gapView = [UIView new];
//    gapView.backgroundColor = [UIColor colorWithWhite:244/255.f alpha:1.f];
//    [self.view addSubview:gapView];
//    [gapView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.left.right.equalTo(self.view);
//        make.height.equalTo(8);
//        make.top.equalTo(cell7.mas_bottom);
//    }];
    
    
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
