//
//  ModifyPhoneNumViewController.m
//  CultureAssistant
//


#import "ModifyPhoneNumViewController.h"

@interface ModifyPhoneNumViewController ()

@property(nonatomic,strong)CustomTextField* accountField;
@property(nonatomic,strong)CustomTextField* verifyCodeField;
@property(nonatomic,strong)UIButton* verifyCodeBtn;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)int times;
@end

@implementation ModifyPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    if (self.openid.length > 0) {
        self.title = @"绑定手机号码";
    }else{
        self.title = @"修改手机号码";
    }
    
    [self createSubViews];
}

- (void)getVerifyCode:(UIButton *)button{
    [self.accountField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    
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
    
    [AFNetAPIClient POST:APIUpdatePhoneNumSendSms parameters:[RequestParameters updatePhoneNumSendSms:self.accountField.text] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code integerValue] != 200) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"验证码发送失败，请重新获取"];
            self.verifyCodeBtn.enabled = YES;
            self.verifyCodeBtn.titleLabel.text =@"获取验证码";
            [self stopTimer];
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

- (void)onSureAction:(UIButton *)button{
    if (self.openid.length > 0){

    }else{
        [self modifyPhoneNumAction];
    }
}

- (void)modifyPhoneNumAction
{
    [self.accountField resignFirstResponder];
    [self.verifyCodeField resignFirstResponder];
    
    if ([self.accountField.text length] == 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"账号不能为空"];
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
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient POST:APIUpdatePhoneNum parameters:[RequestParameters updatePhoneNum:[UserInfoManager sharedInstance].userModel.userinfo.id phoneNum:self.accountField.text smsCode:self.verifyCodeField.text] success:^(id JSON, NSError *error){
        [[UserInfoManager sharedInstance] getUserCenterInfo:^(BOOL finished){
            if (finished) {
                [wself.navigationController popToViewController:self.navigationController.childViewControllers[2] animated:YES];
            }
        }];
        
    }failure:^(id JSON, NSError *error){
        DataModel* model = (DataModel *)JSON;
        if ([model isKindOfClass:[DataModel class]]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
    }];
    
}



#pragma mark-
- (void)createSubViews{
    UIFont* font = [UIFont systemFontOfSize:16];
    self.accountField = [CustomTextField textFieldWithPlaceholder:@"请输入正确的手机号码" textFont:font];
    self.accountField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.accountField];
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view).offset(24);
        make.left.equalTo(self.view).offset(14);
        make.right.equalTo(self.view).offset(-14);
        make.height.equalTo(40);
    }];
    
    self.verifyCodeField = [CustomTextField textFieldWithPlaceholder:@"请输入短信验证码" textFont:font];
    self.verifyCodeField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.verifyCodeField];
    [self.verifyCodeField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.accountField.mas_bottom).offset(10);
        make.left.height.equalTo(self.accountField);
        make.width.equalTo(200);
    }];
    
    self.verifyCodeBtn = [UIButton new];
    self.verifyCodeBtn.backgroundColor = [UIColor colorWithRed:231/255.f green:226/255.f blue:226/255.f alpha:1.f];
    self.verifyCodeBtn.layer.borderColor = [UIColor colorWithWhite:154/255.f alpha:1.f].CGColor;
    self.verifyCodeBtn.layer.borderWidth = 1.f;
    self.verifyCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.verifyCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.verifyCodeBtn.titleLabel.font = font;
    [self.view addSubview:self.verifyCodeBtn];
    [self.verifyCodeBtn addTarget:self action:@selector(getVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.verifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.height.equalTo(self.verifyCodeField);
        make.right.equalTo(self.accountField);
        make.width.equalTo(@100);
    }];
    
    UIButton* sureBtn = [UIButton new];
    sureBtn.backgroundColor = BaseColor;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.openid.length > 0) {
        [sureBtn setTitle:@"登录" forState:UIControlStateNormal];
    }else{
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    sureBtn.layer.cornerRadius = 4;
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(onSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.accountField);
        make.top.equalTo(self.verifyCodeField.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];
}

@end
