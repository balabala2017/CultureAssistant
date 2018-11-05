//
//  RegisterThirdController.m
//  CultureAssistant
//


#import "RegisterThirdController.h"

@interface RegisterThirdController ()
@property(nonatomic,strong)UIButton* btn;
@end

@implementation RegisterThirdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"志愿者誓词";
    
    UILabel* lable = [UILabel new];
    lable.text = @"———— 服务协议 ————";
    lable.textColor = [UIColor colorWithHexString:@"999999"];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view);
        make.top.equalTo(10);
    }];
    
    NSString* string = @"我自愿成为一名助残志愿者，\n弘扬人道主义思想，\n践行志愿服务精神，\n不计报酬，尽己所能，\n为残联人士奉献爱心和力量！";
    
    NSDictionary *attrDict = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"666666"],
                               NSFontAttributeName : [UIFont systemFontOfSize:14]};
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:attrDict];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 5;
    
    NSRange range = NSMakeRange(0, attrStr.length);
    
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraph range:range];
    
    UILabel* textLabel = [UILabel new];
    textLabel.numberOfLines = 0;
    textLabel.attributedText = attrStr;
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(lable.bottom).offset(15);
        make.left.right.equalTo(self.view);
    }];
    
    
    _btn = [UIButton new];
    _btn.backgroundColor = BaseColor;
    [_btn setTitle:@"确认" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(onRegisterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.view);
        make.height.equalTo(40);
        make.bottom.equalTo(-HOME_INDICATOR_HEIGHT);
    }];
    //审核状态不可修改
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 1) {
        _btn.hidden = YES ;
    }
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"bdbdbd"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.height.equalTo(1);
        make.right.equalTo(self.view.right).offset(-15);
        make.bottom.equalTo(self.btn.top).offset(-70);
    }];
    
    UIButton* boxBtn = [UIButton new];
    [boxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [boxBtn setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
    [self.view addSubview:boxBtn];
    [boxBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.height.equalTo(30);
        make.top.equalTo(line.bottom);
        make.left.equalTo(line);
    }];
    boxBtn.selected = YES;
    
    lable = [UILabel new];
    lable.text = @"我已阅读并同意以上协议";
    lable.textColor = [UIColor colorWithHexString:@"666666"];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(boxBtn);
        make.left.equalTo(boxBtn.right).offset(5);
    }];

    
}

- (void)onRegisterAction:(id)sender
{
    if (self.modifyVolunteer)
    {
        [AFNetAPIClient POST:APIUpdateVolunteer parameters:[RequestParameters doUpdateVolunteer:self.paramDic[@"id"]
                                                                                       orgRefId:self.paramDic[@"orgId"]
                                                                                     identityId:self.paramDic[@"identityId"]
                                                                                   specialityId:self.paramDic[@"specialityId"]
                                                                                 serviceDesireId:self.paramDic[@"serviceDesireId"]
                                                                                        otherId:self.paramDic[@"otherId"]
                                                                                    realName:self.paramDic[@"realName"]
                                                                                         sex:self.paramDic[@"sex"]
                                                                                    birthDay:self.paramDic[@"birthDay"]
                                                                                  certifType:@"357"   //self.paramDic[@"certifType"]
                                                                                    certifNo:self.paramDic[@"certifNo"]
                                                                                   ethnicity:self.paramDic[@"ethnicity"]
                                                                                 nativePlace:self.paramDic[@"nativePlace"]
                                                                                    domicile:self.paramDic[@"domicile"]
                                                                                   livePlace:self.paramDic[@"livePlace"]
                                                                              contactAddress:self.paramDic[@"contactAddress"]
                                                                                     zipCode:self.paramDic[@"zipCode"]
                                                                                   telephone:self.paramDic[@"telephone"]
                                                                                       email:self.paramDic[@"email"]
                                                                                   political:self.paramDic[@"political"]
                                                                                       faith:self.paramDic[@"faith"]
                                                                                   education:self.paramDic[@"education"]
                                                                                      school:self.paramDic[@"school"]
                                                                                    postCode:self.paramDic[@"postCode"]
                                                                                         job:self.paramDic[@"job"]
                                                                                  profession:self.paramDic[@"profession"]
                                                                                    workUnit:self.paramDic[@"workUnit"]
                                                                                 specialitys:self.paramDic[@"specialitys"]
                                                                                       hobby:self.paramDic[@"hobby"]
                                                                                serviceTimes:self.paramDic[@"serviceTimes"]
                                                                                serviceTypes:self.paramDic[@"serviceTypes"]
                                                                                 workAddress:self.paramDic[@"workAddress"]
                                                                                  uploadJson:self.paramDic[@"uploadJson"]]
                  success:^(id JSON, NSError *error){
                     DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
                     if ([model.code isEqualToString:@"200"]) {
                         [MBProgressHUD MBProgressHUDWithView:self.view Str:@"信息修改成功"];
                         self.btn.hidden = YES ;
                         
                         [[UserInfoManager sharedInstance] getUserCenterInfo:^(BOOL finished){
                             if (finished) {

                             }
                         }];
                         
                         [self performSelector:@selector(backPriorPage) withObject:nil afterDelay:1.f];
                     }
                 }failure:^(id JSON, NSError *error){
                     DataModel* model = (DataModel *)JSON;
                     if ([model isKindOfClass:[DataModel class]]) {
                         [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
                     }
                 }];
    }
    else
    {
        [AFNetAPIClient POST:APIDoRegister parameters:[RequestParameters doRegisterWithOrgId:self.paramDic[@"orgId"]
                                                                                    realName:self.paramDic[@"realName"]
                                                                                         sex:self.paramDic[@"sex"]
                                                                                    birthDay:self.paramDic[@"birthDay"]
                                                                                  certifType:@"357"
                                                                                    certifNo:self.paramDic[@"certifNo"]
                                                                                   ethnicity:self.paramDic[@"ethnicity"]
                                                                                 nativePlace:self.paramDic[@"nativePlace"]
                                                                                    domicile:self.paramDic[@"domicile"]
                                                                                   livePlace:self.paramDic[@"livePlace"]
                                                                              contactAddress:self.paramDic[@"contactAddress"]
                                                                                     zipCode:self.paramDic[@"zipCode"]
                                                                                   telephone:self.paramDic[@"telephone"]
                                                                                       email:self.paramDic[@"email"]
                                                                                   political:self.paramDic[@"political"]
                                                                                       faith:self.paramDic[@"faith"]
                                                                                   education:self.paramDic[@"education"]
                                                                                      school:self.paramDic[@"school"]
                                                                                    postCode:self.paramDic[@"postCode"]
                                                                                         job:self.paramDic[@"job"]
                                                                                  profession:self.paramDic[@"profession"]
                                                                                    workUnit:self.paramDic[@"workUnit"]
                                                                                 specialitys:self.paramDic[@"specialitys"]
                                                                                       hobby:self.paramDic[@"hobby"]
                                                                                serviceTimes:self.paramDic[@"serviceTimes"]
                                                                                serviceTypes:self.paramDic[@"serviceTypes"]
                                                                                 workAddress:self.paramDic[@"workAddress"]
                                                                                  uploadJson:self.paramDic[@"uploadJson"]]
                 success:^(id JSON, NSError *error){
                     DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
                     if ([model.code isEqualToString:@"200"]) {
                         [MBProgressHUD MBProgressHUDWithView:self.view Str:@"注册信息提交成功,等待审核"];
                         self.btn.hidden = YES ;
                         
                         [[UserInfoManager sharedInstance] getUserCenterInfo:^(BOOL finished){
                             if (finished) {
                                 [UserInfoManager sharedInstance].userModel.auditFlag = @"1";
                             }
                         }];
                         
                         [self performSelector:@selector(registerSuccess) withObject:nil afterDelay:1.f];
                     }
                 }failure:^(id JSON, NSError *error){
                     DataModel* model = (DataModel *)JSON;
                     if ([model isKindOfClass:[DataModel class]]) {
                         [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
                     }
                 }];
    }
}

- (void)backPriorPage{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModifySuccess_Notify" object:nil];
    [self.navigationController popToViewController:self.navigationController.childViewControllers[0] animated:YES];
}

- (void)registerSuccess{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegisterSuccess_Notify" object:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
