//
//  ModifyNicknameViewController.m
//  CultureAssistant
//


#import "ModifyNicknameViewController.h"

@interface ModifyNicknameViewController ()
@property(nonatomic,strong)CustomTextField* nicknameField;
@end

@implementation ModifyNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    self.title = @"修改昵称";
    
    UIFont* font = [UIFont systemFontOfSize:16];
    self.nicknameField = [CustomTextField textFieldWithPlaceholder:@"请输入昵称" textFont:font];
    self.nicknameField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nicknameField];
    [self.nicknameField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view).offset(24);
        make.left.equalTo(self.view).offset(14);
        make.right.equalTo(self.view).offset(-14);
        make.height.equalTo(@40);
    }];
    
    UILabel* label = [UILabel new];
    label.text = @"请输入2-20个字符";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithWhite:139/255.0 alpha:1.0];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.nicknameField.mas_left).offset(10);
        make.top.equalTo(self.nicknameField.mas_bottom).offset(5);
        make.height.equalTo(@13);
    }];
    
    UIButton* sureBtn = [UIButton new];
    sureBtn.backgroundColor = BaseColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 4;
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(onSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.nicknameField);
        make.top.equalTo(label.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];
}

- (void)onSureAction:(UIButton *)button{
    [self.nicknameField resignFirstResponder];
    
    if ([self.nicknameField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入昵称"];
        return;
    }
    if([self.nicknameField.text length] > 20 || [self.nicknameField.text length] < 2){
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入2-20个字符"];
        return;
    }
    typeof(self) __weak wself = self;
    UserModel* userModel = [UserInfoManager sharedInstance].userModel;
    [AFNetAPIClient POST:APIUpdateUserInfo parameters:[RequestParameters updateNickname:self.nicknameField.text userid:userModel.userinfo.id] success:^(id JSON, NSError *error){
        
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
@end
