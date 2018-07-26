//
//  PersonViewController.m
//  CultureAssistant
//


#import "PersonViewController.h"
#import "SettingViewController.h"
#import "AboutViewController.h"
#import "PersonCenterBtnView.h"

#import "ServiceRecordController.h"
#import "StarRecordController.h"
#import "EnrollRecordController.h"

#import "RegisterViewController.h"

#import "ValidateViewController.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView* topBgView;
@property(nonatomic,strong)UIView* topView;

@property(nonatomic,strong)UIView* headbgView;
@property(nonatomic,strong)UIImageView* headIcon;
@property(nonatomic,strong)UIImageView* verifiedIcon;

@property(nonatomic,strong)UILabel* userName;
@property(nonatomic,strong)UILabel* totalTimeLabel;

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSArray* dataSource;

@property(nonatomic,strong)NSMutableArray* starImgArray;
@property(nonatomic,assign)NSInteger starLevel;
@property(nonatomic,strong)PersonCenterBtnView* btnView;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topBgView = [UIView new];
    _topBgView.backgroundColor = BaseColor;
    [self.view addSubview:_topBgView];
    [_topBgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(0);
    }];

    self.dataSource = @[//@{@"title":@"志愿者信息",@"image":@"my_info"},
                        @{@"title":@"证书申请",@"image":@"my_apply"},
                        @{@"title":@"实名认证",@"image":@"my_validate"},
                        @{@"title":@"设置",@"image":@"my_setting"},
                        @{@"title":@"关于",@"image":@"my_about"}];
    
    self.starImgArray = [NSMutableArray array];
    
    [self createSubViews];
    
//    [self getVolunteerToUpdate];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVolunteerToUpdate) name:@"ModifySuccess_Notify" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([UserInfoManager sharedInstance].isAlreadyLogin)
    {
        _topView.userInteractionEnabled = NO;
    
        typeof(self) __weak wself = self;
        [[UserInfoManager sharedInstance] getUserCenterInfo:^(BOOL finished){
            if (finished)
            {
                [wself layoutView];
            }
        }];
    }
    else
    {
        _topView.userInteractionEnabled = YES;
        
        _headIcon.image = [UIImage imageNamed:@"my_header"];
        _headIcon.layer.masksToBounds = NO;
        _userName.text = @"登录/注册";
        
        _verifiedIcon.hidden = YES;

        [_btnView refreshContent];
    }
}

////修改志愿者信息前 先获取志愿者信息
//- (void)getVolunteerToUpdate{
//    [AFNetAPIClient GET:APIGetVolunteerInfo parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error){
//        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
//        if ([model.code isEqualToString:@"200"] && [model.result isKindOfClass:[NSDictionary class]]) {
//            NSDictionary* dic = (NSDictionary *)model.result;
//            VolunteerInfo* volunteer = [VolunteerInfo new];
//            if ([dic[@"volunteer"] objectForKey:@"id"] && ![[dic[@"volunteer"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
//                volunteer.id = [[dic[@"volunteer"] objectForKey:@"id"] stringValue];
//            }
//
//            if ([dic[@"org"] objectForKey:@"id"] && ![[dic[@"org"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
//                volunteer.orgId = [[dic[@"org"] objectForKey:@"id"] stringValue];
//            }
//            volunteer.areaName = [dic[@"org"] objectForKey:@"areaName"];
//            volunteer.orgName = [dic[@"org"] objectForKey:@"name"];
//
//            volunteer.realName = [dic[@"volunteer"] objectForKey:@"volunteName"];
//            if ([[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"id"] && ![[[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
//                volunteer.identityId = [[[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"id"] stringValue];
//            }
//            volunteer.sex = [[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"sex"];
//            volunteer.birthDay = [[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"birthDay"];
//
//            volunteer.educationName = [dic[@"volunteer"] objectForKey:@"educationName"];
//            if ([dic[@"volunteer"] objectForKey:@"education"] && ![[dic[@"volunteer"] objectForKey:@"education"] isKindOfClass:[NSNull class]]) {
//                volunteer.education = [[dic[@"volunteer"] objectForKey:@"education"] stringValue];
//            }
//
//            volunteer.certifNo = [[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"certifNo"];
//            if ([[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"certifType"] && ![[[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"certifType"] isKindOfClass:[NSNull class]]) {
//                volunteer.certifType = [[[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"certifType"] stringValue];
//            }
//
//            if ([[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"id"] && ![[[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
//                volunteer.otherId = [[[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"id"] stringValue];
//            }
//            volunteer.workUnit = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"workUnit"];
//            volunteer.workAddress = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"workAddress"];
//
//            if ([dic[@"volunteer"] objectForKey:@"ethnicity"] && ![[dic[@"volunteer"] objectForKey:@"ethnicity"] isKindOfClass:[NSNull class]]) {
//                volunteer.ethnicity = [[dic[@"volunteer"] objectForKey:@"ethnicity"] stringValue];
//            }
//
//            volunteer.nativePlace = [dic[@"volunteer"] objectForKey:@"nativePlace"];
//            volunteer.nativePlaceName = [dic[@"volunteer"] objectForKey:@"nativePlaceName"];
//
//            volunteer.domicile = [dic[@"volunteer"] objectForKey:@"domicile"];
//            if ([dic[@"volunteer"] objectForKey:@"political"] && ![[dic[@"volunteer"] objectForKey:@"political"] isKindOfClass:[NSNull class]]) {
//                volunteer.political = [[dic[@"volunteer"] objectForKey:@"political"] stringValue];
//            }
//
//            volunteer.faith = [dic[@"volunteer"] objectForKey:@"faith"];
//
//            volunteer.postCode = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"postCode"];
//            volunteer.job = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"job"];
//            volunteer.profession = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"profession"];
//
//            volunteer.school = [dic[@"volunteer"] objectForKey:@"school"];
//            volunteer.livePlace = [dic[@"volunteer"] objectForKey:@"livePlace"];
//
//            if ([[dic[@"volunteer"] objectForKey:@"speciality"] objectForKey:@"id"] && ![[[dic[@"volunteer"] objectForKey:@"speciality"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
//                volunteer.specialityId = [[[dic[@"volunteer"] objectForKey:@"speciality"] objectForKey:@"id"] stringValue];
//            }
//
//            volunteer.specialitys = [[dic[@"volunteer"] objectForKey:@"speciality"] objectForKey:@"specialitys"];
//
//            volunteer.hobby = [dic[@"volunteer"] objectForKey:@"hobby"];
//            volunteer.contactAddress = [dic[@"volunteer"] objectForKey:@"contactAddress"];
//            volunteer.zipCode = [dic[@"volunteer"] objectForKey:@"zipCode"];
//            volunteer.email = [dic[@"volunteer"] objectForKey:@"email"];
//            volunteer.telephone = [dic[@"volunteer"] objectForKey:@"telephone"];
//
//            if ([[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"id"] && ![[[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
//                volunteer.serviceDesireId = [[[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"id"] stringValue];
//            }
//            volunteer.serviceTypeList = [[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"serviceTypeList"];
//            volunteer.serviceTimeList = [[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"serviceTimeList"];
//
//            LibraryModel* library = [[LibraryModel alloc] initWithDictionary:dic[@"org"] error:nil];
//            volunteer.volunteerLibrary = library;
//
//            [UserInfoManager sharedInstance].volunteer = volunteer;
//        }
//    } failure:^(id JSON, NSError *error){
//
//    }];
//}

- (void)layoutView
{
    UserModel* user = [UserInfoManager sharedInstance].userModel;
    
    UserInfo* userInfo = [UserInfoManager sharedInstance].userModel.userinfo;
    if (userInfo.headerIconUrl.length > 0) {
        [_headIcon sd_setImageWithURL:[NSURL URLWithString:userInfo.headerIconUrl] placeholderImage:[UIImage imageNamed:@"my_header"]];
    }
    _headIcon.layer.masksToBounds = YES;
    _userName.text = userInfo.nickName;

    _verifiedIcon.hidden = [user.isIdentityVerified boolValue] == YES?NO:YES;
    
    if (user.totalServiceTime.length > 0) {
        _totalTimeLabel.text = [NSString stringWithFormat:@"%@小时",user.totalServiceTime];
    }
    
    NSInteger level = [user.starLevel integerValue];
    if (self.starLevel != level)
    {
        self.starLevel = level;
        for (UIImageView* imageView in self.starImgArray) {
            imageView.image = [UIImage imageNamed:@"star_icon"];
        }
        
        if (level>0 && level<=5) {
            for (NSInteger i = 0; i < level; i++) {
                UIImageView* imageView = self.starImgArray[i];
                imageView.image = [UIImage imageNamed:@"star1_icon"];
            }
        }
    }
    
    [_btnView refreshContent];
}

- (void)gotoLoginController:(UITapGestureRecognizer *)gesture{
    if (![UserInfoManager sharedInstance].isAlreadyLogin){
        NSString* string = @"LoginViewController";
        UIViewController* cv = [NSClassFromString(string) new];
        [self.navigationController pushViewController:cv animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (y<0) {
        [_topBgView mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(-y);
        }];
    }else{
        [_topBgView mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(0);
        }];
    }
}

#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 195;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell ;
   if (indexPath.row == 0){
        cell =  [tableView dequeueReusableCellWithIdentifier:@"PersonMidCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonMidCell"];
            _btnView = [[PersonCenterBtnView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 195)];
            
            typeof(self) __weak wself = self;
            _btnView.gotoPersonBehaviourVC = ^(NSInteger index){
                
                if (![UserInfoManager sharedInstance].isAlreadyLogin){
                    NSString* string = @"LoginViewController";
                    UIViewController* cv = [NSClassFromString(string) new];
                    [wself.navigationController pushViewController:cv animated:YES];
                    return;
                }
                
                EnrollRecordController* vc = [EnrollRecordController new];
                //0-已提交, 1-待审核, 2-审核通过/待发布（待参加）, 3-审核不通过, 4-取消审核; 5:服务中; 6:待评价; 7:待确定; 8:已确认
                switch (index) {
                    case 0:
                        vc.recordStatus = @"1";
                        break;
                    case 1:
                        vc.recordStatus = @"2";
                        break;
                    case 2:
                        vc.recordStatus = @"5";
                        break;
                    case 3:
                        vc.recordStatus = @"6";
                        break;
                    case 4:
                        vc.recordStatus = @"7";
                        break;
                    case 5:
                        vc.recordStatus = @"";
                        break;
                    default:
                        break;
                }
                [wself.navigationController pushViewController:vc animated:YES];
            };
            [_btnView refreshContent];
            [cell addSubview:_btnView];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonCell"];
            cell.backgroundColor = [UIColor clearColor];
            UIImageView* arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_icon"]];
            [cell.contentView addSubview:arrowIcon];
            [arrowIcon mas_remakeConstraints:^(MASConstraintMaker *make){
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell).offset(-20);
            }];
            UIView* line = [UIView new];
            line.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
            [cell.contentView addSubview:line];
            [line mas_remakeConstraints:^(MASConstraintMaker *make){
                make.left.right.bottom.equalTo(cell);
                make.height.equalTo(1);
            }];
        }

        cell.imageView.image = [UIImage imageNamed:self.dataSource[indexPath.row-1][@"image"]];
        cell.imageView.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = self.dataSource[indexPath.row-1][@"title"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 4) {
        AboutViewController *controller = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }

    if (![UserInfoManager sharedInstance].isAlreadyLogin){
        NSString* string = @"LoginViewController";
        UIViewController* cv = [NSClassFromString(string) new];
        [self.navigationController pushViewController:cv animated:YES];
        return;
    }
    switch (indexPath.row) {
//        case 1://志愿者信息
//        {
//            RegisterViewController * vc = [RegisterViewController new];
//            vc.modifyVolunteer = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
        case 1://评书申请
        {
            [self applyCertificate];
        }
            break;
        case 2://实名认证
        {
            if ([[UserInfoManager sharedInstance].userModel.auditFlag integerValue] == 2) {
                [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请先注册成为志愿者"]; return;
            }
            ValidateViewController* vc = [ValidateViewController new];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 3://设置
        {
            SettingViewController *controller = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }

}

- (void)applyCertificate{
    [AFNetAPIClient GET:APIApplyCertificate parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code isEqualToString:@"200"]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD MBProgressHUDWithView:self.view Str:JSON];
    }];
}

#pragma mark-
- (void)createSubViews{
    
    UIView* whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 259-64)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [whiteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoLoginController:)]];
    
    _topView = [UIView new];
    _topView.backgroundColor = BaseColor;
    [whiteView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(whiteView);
        make.height.equalTo(60);
    }];
    
    {
        _headbgView = [UIView new];
        _headbgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
        _headbgView.layer.cornerRadius = 55;
        _headbgView.layer.masksToBounds = YES;
        [whiteView addSubview:_headbgView];
        
        
        _headIcon = [UIImageView_SD new];
        _headIcon.backgroundColor = [UIColor whiteColor];
        _headIcon.contentMode = UIViewContentModeScaleToFill;
        _headIcon.image = [UIImage imageNamed:@"my_header"];
        _headIcon.layer.cornerRadius = 50;
        _headIcon.layer.masksToBounds = YES;
        [whiteView addSubview:_headIcon];
        
        
        _verifiedIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_verified"]];
        [whiteView addSubview:_verifiedIcon];
        _verifiedIcon.hidden = YES;
        
        _userName = [UILabel new];
        _userName.textColor = Color212121;
        _userName.textAlignment = NSTextAlignmentCenter;
        _userName.font = [UIFont systemFontOfSize:15];
        _userName.text = @"登录/注册";
        [whiteView addSubview:_userName];
        

        WeakObj(self);
        [_headbgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.width.equalTo(110);
            make.centerX.equalTo(whiteView.mas_centerX);
            make.top.equalTo(0);
        }];
        
        [_headIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.width.equalTo(100);
            make.centerX.equalTo(whiteView.mas_centerX);
            make.top.equalTo(5);
        }];
        
        [_verifiedIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(self.headIcon);
            make.right.equalTo(self.headIcon.right).offset(15);
        }];
        
        [_userName mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(wself.headbgView.mas_bottom).offset(7);
            make.height.equalTo(15);
            make.left.right.equalTo(whiteView);
        }];
        
        
        UILabel* scoreLabel = [UILabel new];
        scoreLabel.text = @"星级:";
        scoreLabel.font = [UIFont systemFontOfSize:13];
        scoreLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [whiteView addSubview:scoreLabel];
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(wself.userName.bottom).offset(20);
            make.left.equalTo(20);
        }];
        
        UIImageView* lastView = nil;
        for (int i = 0; i < 5; i++) {
            UIImageView* star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_icon"]];
            [whiteView addSubview:star];
            [self.starImgArray addObject:star];
            
            [star mas_makeConstraints:^(MASConstraintMaker *make){
                make.centerY.equalTo(scoreLabel);
                if (lastView) {
                    make.left.equalTo(lastView.right).offset(5);
                }else{
                    make.left.equalTo(scoreLabel.right).offset(5);
                }
            }];
            lastView = star;
        }
        
        _totalTimeLabel = [UILabel new];
        _totalTimeLabel.text = @"0小时";
        _totalTimeLabel.textColor = BaseColor;
        _totalTimeLabel.font = [UIFont systemFontOfSize:15];
        [whiteView addSubview:_totalTimeLabel];
        [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(whiteView.right).offset(-20);
            make.centerY.equalTo(scoreLabel);
        }];
        
        UIImageView* timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timer_icon"]];
        [whiteView addSubview:timeIcon];
        [timeIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(scoreLabel);
            make.right.equalTo(wself.totalTimeLabel.left).offset(-5);
        }];
        
        UILabel* timeLabel = [UILabel new];
        timeLabel.text = @"时长：";
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [whiteView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(wself.userName.bottom).offset(20);
            make.right.equalTo(timeIcon.left);
        }];

        UIButton* btn = [UIButton new];
        btn.tag = 1;
        [whiteView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(scoreLabel);
            make.right.equalTo(lastView);
            make.centerY.equalTo(scoreLabel);
            make.height.equalTo(30);
        }];
        [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        btn = [UIButton new];
        btn.tag = 2;
        [whiteView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(timeLabel);
            make.right.equalTo(wself.totalTimeLabel);
            make.centerY.equalTo(timeLabel);
            make.height.equalTo(30);
        }];
        [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.bottom).offset(-49);
    }];
    
    _tableView.tableHeaderView = whiteView;
    
}

- (void)onTapButton:(UIButton *)button{
    if (![UserInfoManager sharedInstance].isAlreadyLogin){
        NSString* string = @"LoginViewController";
        UIViewController* cv = [NSClassFromString(string) new];
        [self.navigationController pushViewController:cv animated:YES];
        return;
    }
    if (button.tag == 1) {
        StarRecordController* vc = [StarRecordController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ServiceRecordController* vc = [ServiceRecordController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
