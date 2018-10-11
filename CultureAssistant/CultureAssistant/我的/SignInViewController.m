//
//  SignInViewController.m
//  CultureAssistant
//


#import "SignInViewController.h"

@interface SignInViewController ()
@property(nonatomic,strong)CustomTextField* accountField;
@property(nonatomic,strong)CustomTextField* passwordField;
@property(nonatomic,strong)CustomTextField* rePasswordField;

@property(nonatomic,strong)CustomTextField* verifyCodeField;
@property(nonatomic,strong)UIButton* loginBtn;
@property(nonatomic,strong)UIButton* verifyCodeBtn;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)int times;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户注册";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self createSubviews];
    
}

- (void)getVerifyCode:(UIButton *)button{
    [self.view endEditing:YES];
    
    if ([self.accountField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"手机号码不能为空"];
        return;
    }
    
    [self checkByUserName:self.accountField.text];
}

- (void)checkByUserName:(NSString *)userName
{
    typeof(self) __weak wself = self;
    [AFNetAPIClient POST:APICheckByUserName parameters:[RequestParameters checkByUserName:userName] success:^(id JSON, NSError *error){
        
        
    }failure:^(id JSON, NSError *error){
        DataModel* model = (DataModel *)JSON;
        if ([model isKindOfClass:[DataModel class]] && [model.code isEqualToString:@"000005"])//用户不存在
        {
            [wself continueSignIn];
        }
        else if ([model isKindOfClass:[DataModel class]] && [model.code isEqualToString:@"000007"])//用户已经存在
        {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"账户已存在"];
        }
    }];
}


- (void)continueSignIn{
    if (![NSString isPureNumandCharacters:self.accountField.text]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入正确的手机号码"];
        return;
    }
    if (!_timer) {
        self.verifyCodeBtn.titleLabel.text = @"180s";
        self.verifyCodeBtn.enabled = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        _times = 180;
    }
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient POST:APIRegisterSendSms parameters:[RequestParameters sendSms:self.accountField.text] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code integerValue] != 200) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"验证码发送失败，请重新获取"];
            self.verifyCodeBtn.enabled = YES;
            self.verifyCodeBtn.titleLabel.text =@"获取验证码";
            [wself stopTimer];
        }
    }failure:^(id JSON, NSError *error){
        DataModel* model = (DataModel *)JSON;
        if ([model isKindOfClass:[DataModel class]]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
    }];
}


- (void)onTimer
{
    _times--;
    self.verifyCodeBtn.titleLabel.text = [NSString stringWithFormat:@"剩余%ds",_times];
    self.verifyCodeBtn.enabled = NO;
    if (_times == 0) {
        self.verifyCodeBtn.enabled = YES;
        self.verifyCodeBtn.titleLabel.text =@"获取验证码";
        [self stopTimer];
    }
}

//废弃定时器
- (void)stopTimer
{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
        _times = 180;
    }
}

- (void)onRegisterAction:(UIButton *)sender{
    
    [self.accountField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    if ([self.accountField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"手机号码不能为空"];
        return;
    }
    if (![NSString isPureNumandCharacters:self.accountField.text]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入正确的手机号码"];
        return;
    }
    if ([self.verifyCodeField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"验证码不能为空"];
        return;
    }
    if ([self.passwordField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"密码不能为空"];
        return;
    }
    if ([self.passwordField.text length] > 20 || [self.passwordField.text length] < 4) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入4-20位密码"];
        return;
    }
    [AFNetAPIClient POST:APIUserRegister parameters:[RequestParameters toRegister:self.accountField.text userPwd:self.passwordField.text smsCode:self.verifyCodeField.text type:@"6"] success:^(id JSON, NSError *error){
        
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"注册成功"];

        [self performSelector:@selector(backPrePage) withObject:nil afterDelay:1.f];
    }failure:^(id JSON, NSError *error){
        DataModel* model = (DataModel *)JSON;
        if ([model isKindOfClass:[DataModel class]]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
    }];
}

- (void)backPrePage{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
- (void)createSubviews{
    UIFont* font = [UIFont systemFontOfSize:16];
    self.accountField = [CustomTextField textFieldWithPlaceholder:@"请输入手机号" textFont:font];
    self.accountField.backgroundColor = [UIColor whiteColor];
    self.accountField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.accountField];
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(24);
        make.left.equalTo(14);
        make.right.equalTo(self.view.right).offset(-14);
        make.height.equalTo(40);
    }];
    
    UILabel* label = [self hintTextLabel];
    label.text = @"请正确填写手机号码";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.accountField.left).offset(12);
        make.top.equalTo(self.accountField.bottom).offset(5);
    }];
    

    self.passwordField = [CustomTextField textFieldWithPlaceholder:@"请输入密码" textFont:font];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.bottom).offset(15);
        make.left.right.height.equalTo(self.accountField);
    }];
    
    label = [self hintTextLabel];
    label.text = @"密码长度6-18位，字母区分大小写，请勿输入特殊字符";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.accountField.left).offset(12);
        make.top.equalTo(self.passwordField.bottom).offset(5);
    }];
    
    self.rePasswordField = [CustomTextField textFieldWithPlaceholder:@"请再次输入密码" textFont:font];
    self.rePasswordField.backgroundColor = [UIColor whiteColor];
    self.rePasswordField.secureTextEntry = YES;
    [self.view addSubview:self.rePasswordField];
    [self.rePasswordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.bottom).offset(15);
        make.left.right.height.equalTo(self.accountField);
    }];
    
    label = [self hintTextLabel];
    label.text = @"密码长度6-18位，字母区分大小写，请勿输入特殊字符";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.accountField.left).offset(12);
        make.top.equalTo(self.rePasswordField.bottom).offset(5);
    }];
    
    self.verifyCodeField = [CustomTextField textFieldWithPlaceholder:@"请输入验证码" textFont:font];
    self.verifyCodeField.backgroundColor = [UIColor whiteColor];
    self.verifyCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.verifyCodeField];
    [self.verifyCodeField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.bottom).offset(15);
        make.left.height.equalTo(self.accountField);
        make.left.right.height.equalTo(self.accountField);
    }];
    
    self.verifyCodeBtn = [UIButton new];
    self.verifyCodeBtn.backgroundColor = [UIColor colorWithHexString:@"81d4f9"];
    self.verifyCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.verifyCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.verifyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.verifyCodeBtn.layer.cornerRadius = 4;
    self.verifyCodeBtn.titleLabel.font = font;
    [self.view addSubview:self.verifyCodeBtn];
    [self.verifyCodeBtn addTarget:self action:@selector(getVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.verifyCodeField.right).offset(-3);
        make.centerY.equalTo(self.verifyCodeField);
        make.width.equalTo(90);
        make.height.equalTo(33);
    }];
    
    label = [self hintTextLabel];
    label.text = @"请输入短信密码，以确保正确";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.verifyCodeField.left).offset(12);
        make.top.equalTo(self.verifyCodeField.bottom).offset(5);
    }];
    
    
    self.loginBtn = [UIButton new];
    self.loginBtn.backgroundColor = BaseColor;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 4;
    [self.view addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(onRegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.accountField);
        make.top.equalTo(label.bottom).offset(33);
        make.height.equalTo(45);
    }];
}

- (UILabel *)hintTextLabel{
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithHexString:@"9a9a9a"];
    return label;
}
@end
