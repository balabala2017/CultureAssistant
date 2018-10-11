//
//  FindPasswordViewController.m
//  CultureAssistant
//


#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()

@property(nonatomic,strong)CustomTextField* accountField;
@property(nonatomic,strong)CustomTextField* passwordField;
@property(nonatomic,strong)CustomTextField* rePasswordField;
@property(nonatomic,strong)CustomTextField* verifyCodeField;
@property(nonatomic,strong)UIButton* verifyCodeBtn;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)int times;
@property(nonatomic,assign)BOOL usePhoneCode;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    self.title = @"找回密码";
    [self createSubViews];
}

- (void)getVerifyCode:(UIButton *)button
{
    [self.view endEditing:YES];
    
    UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"获取验证码" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    typeof(self) __weak wself = self;
    [vc addAction:[UIAlertAction actionWithTitle:@"获取短信验证码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        wself.usePhoneCode = YES;
        [wself getPhoneCode];
    }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"获取邮箱验证码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        wself.usePhoneCode = NO;
        [wself getMailCode];
    }]];
    
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }]];
    
    [self presentViewController:vc animated:YES completion:nil];
}

//获取短信验证码
- (void)getPhoneCode
{
    if ([self.accountField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"手机号码不能为空"];
        return;
    }
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
        NSLog(@"检验码发送成功  %@",JSON);
        
    }failure:^(id JSON, NSError *error){
        [wself stopTimer];
        
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

//获取邮箱验证码
- (void)getMailCode
{
    if ([self.accountField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"手机号码不能为空"];
        return;
    }
    if (![NSString isPureNumandCharacters:self.accountField.text]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入正确的手机号码"];
        return;
    }
    [self.view endEditing:YES];
    
    
    if (!_timer) {
        self.verifyCodeBtn.titleLabel.text = @"180s";
        self.verifyCodeBtn.enabled = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        _times = 180;
    }
    

    NSDictionary* dic = @{
                          @"phone":self.accountField.text,
                          @"type":@"2"
                          };
    dic = [[RequestHelper sharedInstance] prepareRequestparameter:dic];
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient POST:APISendEmailVCode parameters:dic success:^(id JSON, NSError *error){
        NSLog(@"检验码发送成功  %@",JSON);
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"登录邮箱查收验证码"];
        
    }failure:^(id JSON, NSError *error){
        [wself stopTimer];
        
        DataModel* model = (DataModel *)JSON;
        if ([model isKindOfClass:[DataModel class]]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
    }];
}

- (void)onSureAction:(UIButton *)button{
    [self.view endEditing:YES];
    
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
    if (![self.passwordField.text isEqualToString:self.rePasswordField.text]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"两次输入的密码不一致"];
        return;
    }
    NSString* urlString ;
    NSDictionary* dic ;
    if (self.usePhoneCode) {
        urlString = APIFindPassword;
        
        dic = @{@"userName":self.accountField.text,
                @"userPwd":self.passwordField.text,
                @"smsCode":self.verifyCodeField.text,
                @"type":@"ios"};
    }else{
        urlString = APIResetPwdFromEmailVCode;
        
        dic = @{@"phone":self.accountField.text,
                @"password":self.passwordField.text,
                @"vCode":self.verifyCodeField.text
                };
    }
    
    dic = [[RequestHelper sharedInstance] prepareRequestparameter:dic];
    

    [AFNetAPIClient POST:urlString parameters:dic success:^(id JSON, NSError *error){
        
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"密码修改成功，请重新登录"];
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


#pragma mark-
- (void)createSubViews{
    UIFont* font = [UIFont systemFontOfSize:16];
    self.accountField = [CustomTextField textFieldWithPlaceholder:@"请输入手机号码" textFont:font];
    self.accountField.backgroundColor = [UIColor whiteColor];
    self.accountField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.accountField];
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view).offset(24);
        make.left.equalTo(self.view).offset(14);
        make.right.equalTo(self.view).offset(-14);
        make.height.equalTo(40);
    }];
    
    self.verifyCodeField = [CustomTextField textFieldWithPlaceholder:@"请输入验证码" textFont:font];
    self.verifyCodeField.backgroundColor = [UIColor whiteColor];
    self.verifyCodeField.keyboardType = UIKeyboardTypeNumberPad;
    self.verifyCodeField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.verifyCodeField];
    [self.verifyCodeField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.accountField.bottom).offset(10);
        make.left.height.equalTo(self.accountField);
        make.width.equalTo(SCREENWIDTH-28-10-100);
    }];
    
    self.verifyCodeBtn = [UIButton new];
    self.verifyCodeBtn.backgroundColor = [UIColor colorWithHexString:@"ece8e8"];
    self.verifyCodeBtn.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.verifyCodeBtn.layer.borderWidth = 1.f;
    self.verifyCodeBtn.layer.cornerRadius = 4;
    self.verifyCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    self.verifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.verifyCodeBtn];
    [self.verifyCodeBtn addTarget:self action:@selector(getVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.height.equalTo(self.verifyCodeField);
        make.right.equalTo(self.accountField);
        make.width.equalTo(100);
    }];
    

    
    self.passwordField = [CustomTextField textFieldWithPlaceholder:@"请输入新密码" textFont:font];
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.verifyCodeField.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.accountField);
    }];
    
    self.rePasswordField = [CustomTextField textFieldWithPlaceholder:@"请再次输入新密码" textFont:font];
    self.rePasswordField.backgroundColor = [UIColor whiteColor];
    self.rePasswordField.secureTextEntry = YES;
    [self.view addSubview:self.rePasswordField];
    [self.rePasswordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.passwordField.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.accountField);
    }];
    
    UIButton* sureBtn = [UIButton new];
    sureBtn.backgroundColor = BaseColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 4;
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(onSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.accountField);
        make.top.equalTo(self.rePasswordField.mas_bottom).offset(15);
        make.height.equalTo(@45);
    }];
}

- (void)dealloc{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
    }
}

@end
