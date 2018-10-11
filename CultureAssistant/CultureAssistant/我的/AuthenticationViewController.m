//
//  AuthenticationViewController.m
//  CultureAssistant
//


#import "AuthenticationViewController.h"
#import "ModifyPhoneNumViewController.h"

@interface  AuthenticationViewController ()

@property(nonatomic,strong)CustomTextField* passwordField;
@end

@implementation AuthenticationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    self.title = @"验证身份";
    
    UILabel* label = [UILabel new];
    label.text = @"请输入登录密码，进行身份验证";
    label.textColor = [UIColor colorWithWhite:102/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view).offset(14);
        make.right.equalTo(self.view).offset(-14);
        make.height.equalTo(@12);
    }];
    
    UIFont* font = [UIFont systemFontOfSize:16];
    self.passwordField = [CustomTextField textFieldWithPlaceholder:@"请输入密码" textFont:font];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(14);
        make.right.equalTo(self.view).offset(-14);
        make.height.equalTo(@40);
    }];
    
    UIButton* button = [UIButton new];
    button.backgroundColor = BaseColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    button.layer.cornerRadius = 4;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.passwordField);
        make.top.equalTo(self.passwordField.mas_bottom).offset(10);
        make.height.equalTo(@45);
    }];
}

- (void)tapButtonAction:(UIButton *)button
{
    
    if ([self.passwordField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"密码不能为空"];
        return;
    }
    [AFNetAPIClient POST:APIUserLogin parameters:[RequestParameters toLogin:[UserInfoManager sharedInstance].userModel.userinfo.userName userPwd:self.passwordField.text type:@"6"] success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if (200 == [model.code integerValue])
        {
            ModifyPhoneNumViewController* controller = [ModifyPhoneNumViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }failure:^(id JSON, NSError *error){
        DataModel* model = (DataModel *)JSON;
        if ([model isKindOfClass:[DataModel class]]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
    }];
    
}
@end
