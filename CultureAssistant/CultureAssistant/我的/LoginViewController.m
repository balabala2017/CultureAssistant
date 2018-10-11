//
//  LoginViewController.m
//  CultureAssistant
//


#import "LoginViewController.h"
#import "SignInViewController.h"
#import "ModifyPhoneNumViewController.h"
#import "FindPasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)CustomTextField* accountField;
@property(nonatomic,strong)CustomTextField* passwordField;
@property(nonatomic,strong)UIButton* loginBtn;
@end

@implementation LoginViewController

- (void)dealloc{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户登录";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    
     [self createSubViews];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.fromRegisterPage) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Do_Not_Show_Register" object:nil];
    }
}


#pragma mark- 登录
- (void)loginAccount:(UIButton *)button{
    [self.view endEditing:YES];
    
    if ([self.accountField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"账号不能为空"];
        return;
    }
    if (![NSString isPureNumandCharacters:self.accountField.text]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入正确的手机号码"];
        return;
    }
    //监测用户是否存在
    [self checkByUserName:self.accountField.text];
}

- (void)checkByUserName:(NSString *)userName
{
    typeof(self) __weak wself = self;
    [AFNetAPIClient POST:APICheckByUserName parameters:[RequestParameters checkByUserName:self.accountField.text] success:^(id JSON, NSError *error){
        
        
    }failure:^(id JSON, NSError *error){
        DataModel* model = (DataModel *)JSON;
        if ([model isKindOfClass:[DataModel class]] && [model.code isEqualToString:@"000005"])//用户不存在
        {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
        else if ([model isKindOfClass:[DataModel class]] && [model.code isEqualToString:@"000007"])//用户已经存在
        {
            [wself loginUserAccount];
        }
    }];
}

- (void)loginUserAccount{
    if ([self.passwordField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"密码不能为空"];
        return;
    }
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient POST:APIUserLogin parameters:[RequestParameters toLogin:self.accountField.text userPwd:self.passwordField.text type:@"6"] success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if (200 == [model.code integerValue])
        {
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.passwordField.text forKey:LocalUserPassword];
            [userDefaults synchronize];
            
            if ([model.result isKindOfClass:[NSString class]]) {

                NSString* jsonString = (NSString *)model.result;
                if (jsonString.length > 0) {
                    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                         
                                                                        options:NSJSONReadingMutableContainers
                                         
                                                                          error:&err];

                    [DeviceHelper sharedInstance].tokenCode = [dic objectForKey:@"tokenCode"];
                    
                    [UserInfoManager sharedInstance].isAlreadyLogin = YES;
                    
                    [[UserInfoManager sharedInstance] getUserCenterInfo:^(BOOL finished){
                        if (finished) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_volunteer_info" object:nil];
                            
                            if (wself.loginSuccess) {
                                wself.loginSuccess();
                            }
                            if (self.fromRegisterPage) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"Do_Not_Show_Register" object:nil];
                            }
                            [wself.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            }
        }
    }failure:^(id JSON, NSError *error){
        DataModel* model = (DataModel *)JSON;
        [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
    }];
}



#pragma mark-
- (void)gotoRegisterAccount:(UIButton *)button{
    SignInViewController* controller = [[SignInViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoFindPassword:(UIButton *)button{
    FindPasswordViewController* controller = [[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark-

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark-
- (void)createSubViews{
    UIScrollView* scrollV = [UIScrollView new];
    [self.view addSubview:scrollV];
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    UIFont* font = [UIFont systemFontOfSize:16];
    self.accountField = [CustomTextField textFieldWithPlaceholder:@"请输入手机号码" textFont:font];
    self.accountField.backgroundColor = [UIColor whiteColor];
    self.accountField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountField.returnKeyType = UIReturnKeyNext;
    [scrollV addSubview:self.accountField];
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view).offset(24);
        make.left.equalTo(self.view).offset(14);
        make.right.equalTo(self.view).offset(-14);
        make.height.equalTo(40);
    }];
    
    self.passwordField = [CustomTextField textFieldWithPlaceholder:@"请输入6-18位密码" textFont:font];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.delegate = self;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    [scrollV addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.accountField.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.accountField);
    }];
    
    
    UIButton* registerBtn = [UIButton new];
    [registerBtn setTitle:@"用户注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithHexString:@"e83e0b"] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = font;
    registerBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [scrollV addSubview:registerBtn];
    [registerBtn addTarget:self action:@selector(gotoRegisterAccount:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.passwordField.mas_bottom).offset(5);
        make.left.equalTo(self.passwordField);
        make.width.equalTo(@100);
        make.height.equalTo(@44);
    }];
    
    
    
    UIButton* forgetBtn = [UIButton new];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor colorWithHexString:@"bababa"] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = font;
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [scrollV addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(gotoFindPassword:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.passwordField.mas_bottom).offset(5);
        make.right.equalTo(self.passwordField.mas_right);
        make.width.equalTo(@100);
        make.height.equalTo(@44);
    }];
    
    
    self.loginBtn = [UIButton new];
    self.loginBtn.backgroundColor = BaseColor;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 4;
    [scrollV addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(loginAccount:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.accountField);
        make.top.equalTo(forgetBtn.mas_bottom).offset(10);
        make.height.equalTo(@45);
    }];
}

@end
