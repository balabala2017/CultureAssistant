//
//  ModifyPasswordViewController.m
//  CultureAssistant
//


#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()
@property(nonatomic,strong)CustomTextField* passwordField1;
@property(nonatomic,strong)CustomTextField* passwordField2;
@property(nonatomic,strong)CustomTextField* passwordField3;
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    self.title = @"修改密码";
    
    UIFont* font = [UIFont systemFontOfSize:16];
    self.passwordField1 = [CustomTextField textFieldWithPlaceholder:@"请输入原始密码" textFont:font];
    self.passwordField1.backgroundColor = [UIColor whiteColor];
    self.passwordField1.secureTextEntry = YES;
    [self.view addSubview:self.passwordField1];
    [self.passwordField1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(24);
        make.left.equalTo(14);
        make.right.equalTo(self.view).offset(-14);
        make.height.equalTo(40);
    }];
    
    UILabel* label = [self hintTextLabel];
    label.text = @"请输入6-18位密码";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.passwordField1.left).offset(10);
        make.top.equalTo(self.passwordField1.bottom).offset(5);
    }];
    
    self.passwordField2 = [CustomTextField textFieldWithPlaceholder:@"请输入新密码" textFont:font];
    self.passwordField2.backgroundColor = [UIColor whiteColor];
    self.passwordField2.secureTextEntry = YES;
    [self.view addSubview:self.passwordField2];
    [self.passwordField2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.mas_bottom).offset(15);
        make.left.right.height.equalTo(self.passwordField1);
        
    }];
    
    label = [self hintTextLabel];
    label.text = @"请输入6-18位密码";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.passwordField2.bottom).offset(5);
        make.left.equalTo(self.passwordField1.left).offset(10);
    }];
    
    self.passwordField3 = [CustomTextField textFieldWithPlaceholder:@"请再次输入新密码" textFont:font];
    self.passwordField3.backgroundColor = [UIColor whiteColor];
    self.passwordField3.secureTextEntry = YES;
    [self.view addSubview:self.passwordField3];
    [self.passwordField3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.bottom).offset(15);
        make.left.right.height.equalTo(self.passwordField1);
        
    }];
    
    label = [self hintTextLabel];
    label.text = @"请输入6-18位密码";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.passwordField3.bottom).offset(5);
        make.left.equalTo(self.passwordField1).offset(10);
    }];
    
    UIButton* sureBtn = [UIButton new];
    sureBtn.backgroundColor = BaseColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 4;
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(onSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.passwordField1);
        make.top.equalTo(label.mas_bottom).offset(24);
        make.height.equalTo(45);
    }];
}

- (UILabel *)hintTextLabel{
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"9a9a9a"];
    return label;
}

- (void)onSureAction:(UIButton *)button{
    [self.passwordField1 resignFirstResponder];
    [self.passwordField2 resignFirstResponder];
    [self.passwordField3 resignFirstResponder];
    
    if ([self.passwordField1.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入原密码"];
        return;
    }
    if ([self.passwordField2.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入新密码"];
        return;
    }
    if ([self.passwordField2.text length] > 18 || [self.passwordField2.text length] < 6) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入6-18位密码"];
        return;
    }
    if ([self.passwordField3.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入确认密码"];
        return;
    }
    if ([self.passwordField3.text length] > 18 || [self.passwordField2.text length] < 6) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入6-18位确认密码"];
        return;
    }
    if (![self.passwordField2.text isEqualToString:self.passwordField3.text]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"新密码和确认密码不同"];
        return;
    }
    
    [AFNetAPIClient POST:APIUpdateUserInfo parameters:[RequestParameters updatePassword:self.passwordField1.text userPwd:self.passwordField2.text userid:[UserInfoManager sharedInstance].userModel.userinfo.id] showLoading:NO success:^(id JSON, NSError *error){
        
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"密码修改成功"];
        [self performSelector:@selector(onBackToLogin) withObject:nil afterDelay:1.f];
        
    }failure:^(id JSON, NSError *error){
        DataModel* model = (DataModel *)JSON;
        if ([model isKindOfClass:[DataModel class]]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
    }];
    
}

- (void)onBackToLogin{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
