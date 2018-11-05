//
//  RegisterViewController.m
//  CultureAssistant
//


#import "RegisterViewController.h"
#import "RegisterSecondController.h"
#import "RegisterDropTableView.h"
#import "VolunteerInfoView.h"
#import "RegisterFaultViewController.h"

@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UITableView* tableView;

@property(nonatomic,strong)NSArray* sectionArray;
@property(nonatomic,strong)NSArray* titleArray;

@property(nonatomic,strong)UIButton* nextBtn;

@property(nonatomic,strong)UITextField* areaTextField;//地区
@property(nonatomic,strong)UITextField* libraryTextField;//场馆
@property(nonatomic,strong)CityModel* tempCity;
@property(nonatomic,strong)LibraryModel* tempLibrary;

@property(nonatomic,strong)UITextField* nameTextField;//姓名
@property(nonatomic,strong)UITextField* sexTextField;//性别
@property(nonatomic,strong)UITextField* birthdayTextField;//出生年月
@property(nonatomic,strong)UITextField* educationTextField;//学历
@property(nonatomic,strong)UITextField* workUnitTextField;//工作单位
@property(nonatomic,strong)UITextField* workAddressTextField;//单位地址
@property(nonatomic,strong)UITextField* certifTypeTextField;//证件类型
@property(nonatomic,strong)UITextField* certifNoTextField;//证件号码

@property(nonatomic,strong)UITextField* ethnicityTextField;//民族
@property(nonatomic,strong)UITextField* nativePlaceTextField;//籍贯
@property(nonatomic,strong)UITextField* domicileTextField;//户籍所在地
@property(nonatomic,strong)UITextField* politicalTextField;//政治面貌
@property(nonatomic,strong)UITextField* faithTextField;//宗教信仰
@property(nonatomic,strong)UITextField* jobTextField;//职务
@property(nonatomic,strong)UITextField* postCodeTextField;//职称
@property(nonatomic,strong)UITextField* professionTextField;//职业
@property(nonatomic,strong)UITextField* schoolTextField;//毕业学校及专业
@property(nonatomic,strong)UITextField* livePlaceTextField;//住址
@property(nonatomic,strong)UITextField* hobbyTextField;//爱好
@property(nonatomic,strong)UITextField* contactAddressTextField;//联系地址
@property(nonatomic,strong)UITextField* zipCodeTextField;//邮编
@property(nonatomic,strong)UITextField* emailTextField;//邮箱
@property(nonatomic,strong)UITextField* telephoneTextField;//联系电话


@property(nonatomic,strong)UIPickerView* pickerView;
@property(nonatomic,strong)UIDatePicker* datePicker;

@property(nonatomic,strong)NSArray* dataArray;
@property(nonatomic,strong)UITextField* tempTextField;

@property(nonatomic,strong)RegisterDropTableView* dropTable;
@property(nonatomic,assign)BOOL showLibrary;
@property(nonatomic,assign)BOOL showAddress;//选择籍贯

@property(nonatomic,strong)NSMutableDictionary* dictionary;//传递参数

@property(nonatomic,strong)NSString* educationId;//学历id
@property(nonatomic,strong)NSString* certifType;//证件类型id
@property(nonatomic,strong)NSString* ethnicity;//民族id
@property(nonatomic,strong)NSString* political;//政治面貌id
@property(nonatomic,strong)NSString* postCode;//职称id

@property(nonatomic,strong)InitDictData* sexData;//性别
@property(nonatomic,strong)InitDictData* educationData;//学历
@property(nonatomic,strong)InitDictData* certifTypeData;//证件类型
@property(nonatomic,strong)InitDictData* ethnicityData;//民族
@property(nonatomic,strong)InitDictData* politicalData;//政治面貌
@property(nonatomic,strong)InitDictData* postCodeData;//职称

@property(nonatomic,strong)CityModel* province;
@property(nonatomic,strong)CityModel* city;
@property(nonatomic,strong)CityModel* county;

@property(nonatomic,strong)NSArray* provinceArray;
@property(nonatomic,strong)NSArray* cityArray;
@property(nonatomic,strong)NSArray* countyArray;

@property(nonatomic,strong)NSMutableArray* skillArray;//用来记录skill的id

@property(nonatomic,strong)NSArray* provinces;//带有场馆的城市
@property(nonatomic,strong)NSArray* librarys;//场馆

@property(nonatomic,strong)VolunteerInfoView* infoView;
@property(nonatomic,assign)BOOL modifyVolunteer;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.skillArray = [NSMutableArray array];
    self.dictionary = [NSMutableDictionary dictionary];
    
    [self initDictionaryData];
    
    self.titleArray = @[@"地区：",
                        @"场馆：",
                        @"姓名：",
                        @"性别：",
                        @"学历：",
                        @"证件类型：",
                        @"证件号码：",
                        @"出生年月：",
                        @"工作单位：",
                        @"单位地址：",
                        @"民族：",
                        @"籍贯：",
                        @"户籍所在地：",
                        @"政治面貌：",
                        @"宗教信仰：",
                        @"职称：",
                        @"职务：",
                        @"职业：",
                        @"毕业学校及专业：",
                        @"住址：",
                        @"特长：请选择（多选）",
                        @"爱好：",
                        @"联系地址：",
                        @"邮编：",
                        @"邮箱：",
                        @"联系电话："];
    
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[RegisterButtonCell class] forCellReuseIdentifier:@"RegisterButtonCell"];
    [_tableView registerClass:[RegisterSkillCell class] forCellReuseIdentifier:@"RegisterSkillCell"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.bottom).offset(-49);
    }];
    
   
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 2)
    {
        _infoView = [VolunteerInfoView new];
        typeof(self) __weak wself = self;
        _infoView.removeInfoViewToModify = ^{
            [wself.infoView removeFromSuperview];
            wself.infoView = nil;
            
            wself.modifyVolunteer = YES;
            [wself.tableView reloadData];
        };
        [self.view addSubview:_infoView];
        [_infoView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(-TAB_BAR_HEIGHT);
        }];
    }
    else if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 3)
    {
        self.modifyVolunteer = YES;
        
        RegisterFaultViewController* vc = [RegisterFaultViewController new];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:nil];
    }
    
    self.nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    self.nextBtn.backgroundColor = BaseColor;
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(onNextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //审核状态不可修改
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 1) {
        [self.nextBtn setTitle:@"审核中，不允许修改" forState:UIControlStateNormal];
        self.nextBtn.enabled = NO;
    }else{
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.nextBtn.enabled = YES;
    }


    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;

    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];

    
    //获取全国省份
    [self getAreaList:@"" pcode:@"" level:@"1"];
    
    
    NSString * cityName = @"";
    NSString * cityType = @"";
    NSArray * cityInfo = [[NSUserDefaults standardUserDefaults] objectForKey:LocationSelectedArea];
    if ([cityInfo isKindOfClass:[NSArray class]])
    {
        cityName = cityInfo[1];
        cityType = cityInfo[2];
        
        //如果是全国，注册页面，地区显示定位的地区。
        //如果是选择了场馆或者地区，地区显示选择的地区或者场馆所在地区
        if ([cityName isEqualToString:@"全国"])
        {
            CityModel* city = [DeviceHelper sharedInstance].locationCity;
            self.tempCity = city;
            self.areaTextField.text = city.AREA_NAME;
            if (city) {
                [self getOrganization:city.AREA_CODE areaName:@""];
            }
        }
        else if ([cityType isEqualToString:LibraryModelKey])
        {
            CityModel* city = [CityModel new];
            city.AREA_NAME = cityInfo[3];
            self.tempCity = city;
            self.areaTextField.text = cityInfo[3];
            
            LibraryModel* library = [LibraryModel new];
            library.id = cityInfo[0];
            library.name = cityInfo[1];
            self.tempLibrary = library;
            self.libraryTextField.text = cityInfo[1];
            
            [self getOrganization:@"" areaName:cityInfo[3]];
            
        }else{
            CityModel* city = [CityModel new];
            city.AREA_NAME = cityInfo[1];
            city.AREA_CODE = cityInfo[0];
            self.tempCity = city;
            self.areaTextField.text = cityInfo[1];
            
            if (city) {
                [self getOrganization:city.AREA_CODE areaName:@""];
            }
        }
    }
    else
    {
        CityModel* city = [DeviceHelper sharedInstance].locationCity;
        self.tempCity = city;
        self.areaTextField.text = city.AREA_NAME;
        if (city) {
            [self getOrganization:city.AREA_CODE areaName:@""];
        }
    }
    
    if (self.modifyVolunteer) self.tempCity = nil;
    
    [self getProvincesByArea];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityLibrary:) name:Change_City_Library object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeliveryCheckState:) name:@"delivery_check_state" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshPageContent:) name:@"Logout_Account" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshPageContent:) name:@"GetVolunteerInfo_Finish" object:nil];
}

- (void)onDeliveryCheckState:(NSNotification *)notify
{
    NSDictionary* dic = [notify userInfo];
    if ([dic[@"checkState"] intValue] == 2)
    {
        if (_infoView != nil) return;
        
        _infoView = [VolunteerInfoView new];
        typeof(self) __weak wself = self;
        _infoView.removeInfoViewToModify = ^{
            
            [wself.infoView removeFromSuperview];
            wself.infoView = nil;
            
            wself.modifyVolunteer = YES;
            [wself.tableView reloadData];
        };
        [self.view addSubview:_infoView];
        [self.view bringSubviewToFront:_infoView];
        [_infoView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(-TAB_BAR_HEIGHT);
        }];
    }
    else if ([dic[@"checkState"] intValue] == 3)
    {
        RegisterFaultViewController* vc = [RegisterFaultViewController new];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:NO completion:nil];
    }
}

- (void)backButtonClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)freshPageContent:(NSNotification *)notify{
    
    [self initDictionaryData];

    //审核状态不可修改
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 1) {
        [self.nextBtn setTitle:@"审核中，不允许修改" forState:UIControlStateNormal];
        self.nextBtn.enabled = NO;
    }else{
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.nextBtn.enabled = YES;
    }
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //审核状态不可修改
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 1) {
        [self.nextBtn setTitle:@"审核中，不允许修改" forState:UIControlStateNormal];
        self.nextBtn.enabled = NO;
    }else{
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.nextBtn.enabled = YES;
    }
    
    [self.tableView reloadData];
}
#pragma mark-
- (void)changeCityLibrary:(NSNotification *)notify{
    NSDictionary* dictionary = notify.userInfo;
    if ([dictionary objectForKey:SelectedCityKey]) {
        CityModel* city = [dictionary objectForKey:SelectedCityKey];
        if (city.ORG_ID.length > 0) {
            
            LibraryModel* library = [LibraryModel new];
            library.id = city.ORG_ID;
            library.name = city.SHOW_NAME;
            
            self.tempLibrary = library;
            self.libraryTextField.text = city.SHOW_NAME;
            
            self.areaTextField.text = city.AREA_NAME;
            
            [self getOrganization:@"" areaName:city.AREA_NAME];
        }else{
            self.tempCity = city;
            self.areaTextField.text = city.AREA_NAME;
            
            self.tempLibrary = nil;
            self.libraryTextField.text = @"";
            
            [self getOrganization:city.AREA_CODE areaName:@""];
        }
    }else if ([dictionary objectForKey:SelectedLibraryKey]){
        LibraryModel* library = [dictionary objectForKey:SelectedLibraryKey];

        self.tempLibrary = library;
        self.libraryTextField.text = library.name;
        
        self.areaTextField.text = library.areaName;
        
        [self getOrganization:@"" areaName:library.areaName];
    }
}


- (void)initDictionaryData
{

    [self.dictionary setObject:@"" forKey:@"orgId"];
    [self.dictionary setObject:@"" forKey:@"realName"];
    [self.dictionary setObject:@"" forKey:@"sex"];
    [self.dictionary setObject:@"" forKey:@"birthDay"];
    [self.dictionary setObject:@"" forKey:@"education"];
    [self.dictionary setObject:@"" forKey:@"certifType"];
    [self.dictionary setObject:@"" forKey:@"certifNo"];
    
    [self.dictionary setObject:@"" forKey:@"workUnit"];
    [self.dictionary setObject:@"" forKey:@"workAddress"];
    [self.dictionary setObject:@"" forKey:@"ethnicity"];
    [self.dictionary setObject:@"" forKey:@"nativePlace"];
    [self.dictionary setObject:@"" forKey:@"domicile"];
    [self.dictionary setObject:@"" forKey:@"political"];
    [self.dictionary setObject:@"" forKey:@"faith"];
    [self.dictionary setObject:@"" forKey:@"postCode"];
    [self.dictionary setObject:@"" forKey:@"job"];
    [self.dictionary setObject:@"" forKey:@"profession"];
    [self.dictionary setObject:@"" forKey:@"school"];
    [self.dictionary setObject:@"" forKey:@"livePlace"];
    [self.dictionary setObject:@"" forKey:@"specialitys"];
    [self.dictionary setObject:@"" forKey:@"hobby"];
    [self.dictionary setObject:@"" forKey:@"contactAddress"];
    [self.dictionary setObject:@"" forKey:@"zipCode"];
    [self.dictionary setObject:@"" forKey:@"email"];
    [self.dictionary setObject:@"" forKey:@"telephone"];
    
    self.tempLibrary = nil;
    self.sexData = nil;
    self.educationData = nil;
    self.certifTypeData = nil;
    self.ethnicityData = nil;
    self.politicalData = nil;
    self.postCodeData = nil;
    
    [self.skillArray  removeAllObjects];
    
    VolunteerInfo* volunteer = [UserInfoManager sharedInstance].volunteer;
    if (volunteer)
    {
        self.tempLibrary = volunteer.volunteerLibrary;
        
        if (volunteer.id && ![volunteer.id isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.id.length>0?volunteer.id:@"" forKey:@"id"];
        }
        
        if (volunteer.orgId && ![volunteer.orgId isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.orgId.length>0?volunteer.orgId:@"" forKey:@"orgId"];
        }
        
        if (volunteer.identityId && ![volunteer.identityId isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.identityId.length>0?volunteer.identityId:@"" forKey:@"identityId"];
        }
        
        if (volunteer.specialityId && ![volunteer.specialityId isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.specialityId.length>0?volunteer.specialityId:@"" forKey:@"specialityId"];
        }
        
        if (volunteer.serviceDesireId && ![volunteer.serviceDesireId isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.serviceDesireId.length>0?volunteer.serviceDesireId:@"" forKey:@"serviceDesireId"];
        }
        
        
        if (volunteer.otherId && ![volunteer.otherId isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.otherId.length>0?volunteer.otherId:@"" forKey:@"otherId"];
        }
        
        if (volunteer.realName && ![volunteer.realName isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.realName.length>0?volunteer.realName:@"" forKey:@"realName"];
        }
    
        if (volunteer.sex && ![volunteer.sex isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.sex.length>0?volunteer.sex:@"" forKey:@"sex"];
        }
        if (volunteer.birthDay && ![volunteer.birthDay isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.birthDay.length>0?volunteer.birthDay:@"" forKey:@"birthDay"];
        }
    
        if (volunteer.education && ![volunteer.education isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.education.length>0?volunteer.education:@"" forKey:@"education"];
        }
        
        if (volunteer.certifType && ![volunteer.certifType isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.certifType.length>0?volunteer.certifType:@"" forKey:@"certifType"];
        }
        
        if (volunteer.certifNo && ![volunteer.certifNo isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.certifNo.length>0?volunteer.certifNo:@"" forKey:@"certifNo"];
        }
        
        if (volunteer.workUnit && ![volunteer.workUnit isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.workUnit.length>0?volunteer.workUnit:@"" forKey:@"workUnit"];
        }
        if (volunteer.workAddress && ![volunteer.workAddress isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.workAddress.length>0?volunteer.workAddress:@"" forKey:@"workAddress"];
        }

        if (volunteer.ethnicity && ![volunteer.ethnicity isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.ethnicity.length>0?volunteer.ethnicity:@"" forKey:@"ethnicity"];
        }
        
        if (volunteer.nativePlace && ![volunteer.nativePlace isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.nativePlace.length>0?volunteer.nativePlace:@"" forKey:@"nativePlace"];
        }
        
        if (volunteer.nativePlaceName && ![volunteer.nativePlaceName isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.nativePlaceName.length>0?volunteer.nativePlaceName:@"" forKey:@"nativePlaceName"];
        }
        
        if (volunteer.domicile && ![volunteer.domicile isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.domicile.length>0?volunteer.domicile:@"" forKey:@"domicile"];
        }
        
        if (volunteer.political && ![volunteer.political isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.political.length>0?volunteer.political:@"" forKey:@"political"];
        }
        
        if (volunteer.faith && ![volunteer.faith isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.faith.length>0?volunteer.faith:@"" forKey:@"faith"];
        }
        
        if (volunteer.postCode && ![volunteer.postCode isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.postCode.length>0?volunteer.postCode:@"" forKey:@"postCode"];
        }
        
        if (volunteer.job && ![volunteer.job isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.job.length>0?volunteer.job:@"" forKey:@"job"];
        }
        
        if (volunteer.profession && ![volunteer.profession isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.profession.length>0?volunteer.profession:@"" forKey:@"profession"];
        }
        
        if (volunteer.school && ![volunteer.school isKindOfClass:[NSNull class]]) {
             [self.dictionary setObject:volunteer.school.length>0?volunteer.school:@"" forKey:@"school"];
         }
        
        if (volunteer.livePlace && ![volunteer.livePlace isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.livePlace.length>0?volunteer.livePlace:@"" forKey:@"livePlace"];
        }
        
        if (volunteer.specialitys && ![volunteer.specialitys isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.specialitys.length>0?volunteer.specialitys:@"" forKey:@"specialitys"];
        }
        
        if (volunteer.hobby && ![volunteer.hobby isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.hobby.length>0?volunteer.hobby:@"" forKey:@"hobby"];
        }
        
        if (volunteer.contactAddress && ![volunteer.contactAddress isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.contactAddress.length>0?volunteer.contactAddress:@"" forKey:@"contactAddress"];
        }
        
        if (volunteer.zipCode && ![volunteer.zipCode isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.zipCode.length>0?volunteer.zipCode:@"" forKey:@"zipCode"];
        }
        
        if (volunteer.email && ![volunteer.email isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.email.length>0?volunteer.email:@"" forKey:@"email"];
        }
        if (volunteer.telephone && ![volunteer.telephone isKindOfClass:[NSNull class]]) {
            [self.dictionary setObject:volunteer.telephone.length>0?volunteer.telephone:@"" forKey:@"telephone"];
        }
        
        
        if (volunteer.specialitys.length > 0) {
            NSArray* array = [volunteer.specialitys componentsSeparatedByString:@","];
            [self.skillArray addObjectsFromArray:array];
        }
        
        if (volunteer.sex && ![volunteer.sex isKindOfClass:[NSNull class]]) {
            for (InitDictData* data in [DeviceHelper sharedInstance].sexs) {
                if ([volunteer.sex isEqualToString:data.id]) {
                    self.sexData = data;
                    break;
                }
            }
        }

        if (volunteer.education && ![volunteer.education isKindOfClass:[NSNull class]]) {
            for (InitDictData* data in [DeviceHelper sharedInstance].educations) {
                if ([volunteer.education intValue] == [data.id intValue]) {
                    self.educationData = data;
                    break;
                }
            }
        }
        
        if (volunteer.certifType && ![volunteer.certifType isKindOfClass:[NSNull class]]) {
            for (InitDictData* data in [DeviceHelper sharedInstance].certifTypes) {
                if ([volunteer.certifType intValue] == [data.id intValue]) {
                    self.certifTypeData = data;
                    break;
                }
            }
        }
        
        if (volunteer.ethnicity && ![volunteer.ethnicity isKindOfClass:[NSNull class]]) {
            for (InitDictData* data in [DeviceHelper sharedInstance].ethnicitys) {
                if ([volunteer.ethnicity intValue] == [data.id intValue]) {
                    self.ethnicityData = data;
                    break;
                }
            }
        }

        if (volunteer.political && ![volunteer.political isKindOfClass:[NSNull class]]) {
            for (InitDictData* data in [DeviceHelper sharedInstance].politicals) {
                if ([volunteer.political intValue] == [data.id intValue]) {
                    self.politicalData = data;
                    break;
                }
            }
        }

        if (volunteer.postCode && ![volunteer.postCode isKindOfClass:[NSNull class]]) {
            for (InitDictData* data in [DeviceHelper sharedInstance].workConditions) {
                if ([volunteer.postCode intValue] == [data.id intValue]) {
                    self.postCodeData = data;
                    break;
                }
            }
        }
    }
}

//获取带有场馆的城市
- (void)getProvincesByArea{
    [AFNetAPIClient GET:APIGetProvincesByArea parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error) {
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray *)model.result;
            self.provinces = [CityModel arrayOfModelsFromDictionaries:array error:nil];
        }
    } failure:^(id JSON, NSError *error) {

    }];
}

//根据城市请求场馆
- (void)getOrganization:(NSString *)areaCode areaName:(NSString *)areaName
{
    if (areaCode.length <= 0) areaCode = @"";
    if (areaName.length <= 0) areaName = @"";

    [AFNetAPIClient GET:APIGetOrgs parameters:[RequestParameters getOrgsByAreaCode:areaCode areaName:areaName] success:^(id JSON, NSError *error) {

        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSArray class]]) {
            self.librarys = [LibraryModel arrayOfModelsFromDictionaries:(NSArray *)model.result];
            if (self.librarys.count>0) {
                self.showLibrary = YES;
            }else{
                self.showLibrary = NO;
            }
        }
        
    } failure:^(id JSON, NSError *error) {

    }];
}


-(void)getAreaList:(NSString *)pid pcode:(NSString *)pcode level:(NSString *)level
{
    typeof(self) __weak wself = self;
    
    [AFNetAPIClient GET:APIGetAreaList parameters:[RequestParameters getAreaListWithPid:pid pcode:pcode level:level] success:^(id JSON, NSError *error) {
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSArray class]]) {
            switch ([level intValue]) {
                case 1:
                {
                    self.provinceArray = [CityModel arrayOfModelsFromDictionaries:(NSArray *)model.result];
                    [self.pickerView reloadComponent:0];
                    
                    if (self.provinceArray.count > 0 && self.cityArray.count<=0) {
                        self.province = [self.provinceArray firstObject];
                        [wself getAreaList:self.province.AREA_ID pcode:self.province.AREA_CODE level:@"2"];
                        [self.pickerView reloadComponent:1];
                    }
                }
                    break;
                case 2:
                    self.cityArray = [CityModel arrayOfModelsFromDictionaries:(NSArray *)model.result];
                    [self.pickerView reloadComponent:1];
                    
                    if (self.cityArray.count > 0 && self.countyArray.count<=0) {
                        self.city = [self.cityArray firstObject];
                        [wself getAreaList:self.city.AREA_ID pcode:self.city.AREA_CODE level:@"3"];
                    }
                    break;
                case 3:
                    self.countyArray = [CityModel arrayOfModelsFromDictionaries:(NSArray *)model.result];
                    [self.pickerView reloadComponent:2];
                    break;
                default:
                    break;
            }
            
        }
        
    } failure:^(id JSON, NSError *error) {
        
    }];
}



#pragma mark-
- (void)dateChanged
{
    NSDate *theDate = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSString* string = self.dictionary[@"birthDay"];
    if (string.length <= 0) {
        self.birthdayTextField.text = [dateFormatter stringFromDate:theDate];
        [self.dictionary setObject:self.birthdayTextField.text forKey:@"birthDay"];
    }
}

#pragma mark-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 20) {
        return [RegisterSkillCell heightForRegisterSkillCell];
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.titleArray.count){
        RegisterButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterButtonCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = BaseColor;
        [cell addSubview:self.nextBtn];
        return cell;
    }
    else if (indexPath.row == 20){
        RegisterSkillCell* skillCell = [tableView dequeueReusableCellWithIdentifier:@"RegisterSkillCell" forIndexPath:indexPath];
        skillCell.specialitys = self.skillArray;
        typeof(self) __weak wself = self;
        skillCell.selectedSkillHandler = ^(BOOL selected,NSString * skillId){
            [wself recordSkillId:selected skill:skillId];
        };
        return skillCell;
    }
    else
    {
        RegisterTableCell* cell = [[RegisterTableCell alloc] init];
        cell.showSelectBtn = NO;
        
        NSString* tempString;
        
        cell.titleLabel.text = self.titleArray[indexPath.row];
        cell.textField.delegate = self;
        cell.showStar = NO;
        switch (indexPath.row) {
            case 0:{//地区
                if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] != 2) {
                    cell.showSelectBtn = YES;
                }
                cell.showStar = YES;
                self.areaTextField = cell.textField;
                if (self.tempCity) {
                    self.areaTextField.text = self.tempCity.AREA_NAME;
                }
                else if (self.modifyVolunteer) {
                    self.areaTextField.text = [UserInfoManager sharedInstance].volunteer.areaName;
                }
                
            }
                break;
            case 1:{//场馆
                if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] != 2) {
                    cell.showSelectBtn = YES;
                }
                cell.showStar = YES;
                self.libraryTextField = cell.textField;
                self.libraryTextField.inputView = self.pickerView;
                
               if (self.tempLibrary) {
                    self.libraryTextField.text = self.tempLibrary.name;
               }else if (self.modifyVolunteer) {
                   self.libraryTextField.text = [UserInfoManager sharedInstance].volunteer.orgName;
               }
            }
                break;
            case 2:{//姓名
                cell.showStar = YES;
                self.nameTextField = cell.textField;
                tempString = self.dictionary[@"realName"];
                if (tempString.length > 0) {
                    self.nameTextField.text = tempString;
                }
            }
                break;
            case 3:{//性别
                if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] != 2) {
                    cell.showSelectBtn = YES;
                }
                cell.showStar = YES;
                self.sexTextField = cell.textField;
                self.sexTextField.inputView = self.pickerView;
                if (self.sexData) {
                    self.sexTextField.text = self.sexData.name;
                }
            }
                break;

            case 4:{//学历
                if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] != 2) {
                    cell.showSelectBtn = YES;
                }
                cell.showStar = YES;
                self.educationTextField = cell.textField;
                self.educationTextField.inputView = self.pickerView;
                if (self.educationData) {
                    self.educationTextField.text = self.educationData.name;
                }
            }
                break;

            case 5:{//证件类型
                cell.showStar = YES;
                cell.textField.text = @"居民身份证";
                self.certifTypeTextField = cell.textField;

            }
                break;
            case 6:{//证件号码
                cell.showStar = YES;
                self.certifNoTextField = cell.textField;
                tempString = self.dictionary[@"certifNo"];
                if (tempString.length > 0) {
                    self.certifNoTextField.text = tempString;
                }
            }
                break;
            case 7:{//出生年月日
                cell.showStar = YES;
                self.birthdayTextField = cell.textField;
                tempString = self.dictionary[@"birthDay"];
                if (tempString.length > 0) {
                    self.birthdayTextField.text = tempString;
                }
            }
                break;
                
                
            case 8:{//工作单位
                self.workUnitTextField = cell.textField;
                
                tempString = self.dictionary[@"workUnit"];
                if (tempString.length > 0) {
                    self.workUnitTextField.text = tempString;
                }
            }
                break;
            case 9:{//单位地址
                self.workAddressTextField = cell.textField;
                
                tempString = self.dictionary[@"workAddress"];
                if (tempString.length > 0) {
                    self.workAddressTextField.text = tempString;
                }
            }
                break;
            case 10:{//民族
                self.ethnicityTextField = cell.textField;
                self.ethnicityTextField.inputView = self.pickerView;
                cell.showSelectBtn = YES;
                
                if (self.ethnicityData) {
                    self.ethnicityTextField.text = self.ethnicityData.name;
                }
            }
                break;
            case 11:{//籍贯
                self.nativePlaceTextField = cell.textField;
                self.nativePlaceTextField.inputView = self.pickerView;
                cell.showSelectBtn = YES;
                
                tempString = self.dictionary[@"domicile"];
                if (tempString.length > 0) {
                    self.nativePlaceTextField.text = tempString;
                }
                else
                {
                    NSString* provinceName = @"";
                    NSString* cityName = @"";
                    NSString* countyName = @"";
                    if (self.province) {
                        provinceName = self.province.AREA_NAME;
                    }
                    if (self.city) {
                        cityName = self.city.AREA_NAME;
                    }
                    if (self.county) {
                        countyName = self.county.AREA_NAME;
                    }
                    tempString =  [[provinceName stringByAppendingString:cityName] stringByAppendingString:countyName];
                    if (tempString.length > 0) {
                        self.nativePlaceTextField.text = tempString;
                    }
                }

            }
                break;
            case 12:{//户籍所在地
                self.domicileTextField = cell.textField;
                tempString = self.dictionary[@"domicile"];
                if (tempString.length > 0) {
                    self.domicileTextField.text = tempString;
                }
            }
                break;
            case 13:{//政治面貌
                self.politicalTextField = cell.textField;
                self.politicalTextField.inputView = self.pickerView;
                cell.showSelectBtn = YES;
                if (self.politicalData) {
                    self.politicalTextField.text = self.politicalData.name;
                }
            }
                break;
            case 14:{//宗教信仰
                self.faithTextField = cell.textField;
                tempString = self.dictionary[@"faith"];
                if (tempString.length > 0) {
                    self.faithTextField.text = tempString;
                }
            }
                break;
            case 15:{//职称
                self.postCodeTextField = cell.textField;
                self.postCodeTextField.inputView = self.pickerView;
                cell.showSelectBtn = YES;
                if (self.postCodeData) {
                    self.postCodeTextField.text = self.postCodeData.name;
                }
            }
                break;
            case 16:{//职务
                self.jobTextField = cell.textField;
                tempString = self.dictionary[@"job"];
                if (tempString.length > 0) {
                    self.jobTextField.text = tempString;
                }
            }
                break;
            case 17:{//职业
                self.professionTextField = cell.textField;
                tempString = self.dictionary[@"profession"];
                if (tempString.length > 0) {
                    self.professionTextField.text = tempString;
                }
            }
                break;
            case 18:{//毕业学校及专业
                self.schoolTextField = cell.textField;
                tempString = self.dictionary[@"school"];
                if (tempString.length > 0) {
                    self.schoolTextField.text = tempString;
                }
            }
                break;
            case 19:{//住址
                self.livePlaceTextField = cell.textField;
                tempString = self.dictionary[@"livePlace"];
                if (tempString.length > 0) {
                    self.livePlaceTextField.text = tempString;
                }
            }
                break;
            case 21:{//爱好
                self.hobbyTextField = cell.textField;
                tempString = self.dictionary[@"hobby"];
                if (tempString.length > 0) {
                    self.hobbyTextField.text = tempString;
                }
            }
                break;
            case 22:{//联系地址
                self.contactAddressTextField = cell.textField;
                tempString = self.dictionary[@"contactAddress"];
                if (tempString.length > 0) {
                    self.contactAddressTextField.text = tempString;
                }
            }
                break;
            case 23:{//邮编
                self.zipCodeTextField = cell.textField;
                tempString = self.dictionary[@"zipCode"];
                if (tempString.length > 0) {
                    self.zipCodeTextField.text = tempString;
                }
            }
                break;
            case 24:{//邮箱
                self.emailTextField = cell.textField;
                tempString = self.dictionary[@"email"];
                if (tempString.length > 0) {
                    self.emailTextField.text = tempString;
                }
            }
                break;
            case 25:{//联系电话
                self.telephoneTextField = cell.textField;
                tempString = self.dictionary[@"telephone"];
                if (tempString.length > 0) {
                    self.telephoneTextField.text = tempString;
                }
            }
                break;
            default:
                break;
        }
        

        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 1) {
        return NO;
    }
    
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 2
        &&( textField == self.areaTextField
        || textField == self.libraryTextField
        || textField == self.nameTextField
        || textField == self.sexTextField
        || textField == self.educationTextField)) {
        return NO;
    }
    
    
    
    if (textField == self.birthdayTextField || textField == self.certifTypeTextField) return NO;
    
    if (textField == self.certifNoTextField){
        self.birthdayTextField.text = @"";
        [self.dictionary setObject:@"" forKey:@"birthDay"];
    }
    
    
    self.showAddress = NO;
    self.tempTextField = textField;
    
    self.showLibrary = NO;
    
    if (textField == self.areaTextField)
    {
        [self showDropTable];
        return NO;
    }
    else if (textField == self.libraryTextField)
    {
        self.showLibrary = YES;
        if (self.librarys.count>0)
        {
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            
            if (!self.tempLibrary) {
                LibraryModel* library = self.librarys[0];
                self.tempLibrary = library;
                self.libraryTextField.text = library.name;
                [self.dictionary setObject:library.id forKey:@"orgId"];
            }else{
                for (NSInteger i = 0; i < self.librarys.count; i++) {
                    LibraryModel* library = self.librarys[i];
                    if ([library.id intValue] == [self.tempLibrary.id intValue]) {
                        [self.pickerView selectRow:i inComponent:0 animated:NO];
                        break;
                    }
                }
            }
            return YES;
        }else{
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"没有相应的图书馆"];
            return NO;
        }
        
    }
    else if (textField == self.sexTextField)
    {
        self.dataArray = [DeviceHelper sharedInstance].sexs;
        [self.pickerView reloadAllComponents];
        
        if (self.dataArray.count > 0 ) {
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            
            if (!self.sexData) {
                self.sexData = self.dataArray[0];
                self.sexTextField.text = self.sexData.name;
                
                if ([self.sexData.name isEqualToString:@"男"]) {
                    [self.dictionary setObject:@"0" forKey:@"sex"];
                }else{
                    [self.dictionary setObject:@"1" forKey:@"sex"];
                }
            }else{
                for (NSInteger i = 0; i < self.dataArray.count; i++) {
                    InitDictData* data = self.dataArray[i];
                    if ([data.id intValue] == [self.sexData.id intValue]) {
                        [self.pickerView selectRow:i inComponent:0 animated:NO];
                        break;
                    }
                }
            }
        }
    }

    else if (textField == self.educationTextField)
    {
        self.dataArray = [DeviceHelper sharedInstance].educations;
        [self.pickerView reloadAllComponents];
        
        if (self.dataArray.count > 0)
        {
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            
            if (!self.educationData) {
                InitDictData* data = self.dataArray[0];
                self.educationData = data;
                self.educationTextField.text = data.name;
                [self.dictionary setObject:self.educationData.id forKey:@"education"];
            }else{
                for (NSInteger i = 0; i < self.dataArray.count; i++) {
                    InitDictData* data = self.dataArray[i];
                    if ([data.id intValue] == [self.educationData.id intValue]) {
                        [self.pickerView selectRow:i inComponent:0 animated:NO];
                        break;
                    }
                }
            }
        }
    }

    else if (textField == self.politicalTextField)
    {
        self.dataArray = [DeviceHelper sharedInstance].politicals;
        [self.pickerView reloadAllComponents];
        
        
        if (self.dataArray.count > 0 )
        {
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            
            if (!self.politicalData) {
                InitDictData* data = self.dataArray[0];
                self.politicalData = data;
                self.politicalTextField.text = data.name;
                [self.dictionary setObject:self.politicalData.id forKey:@"political"];
            }else{
                for (NSInteger i = 0; i < self.dataArray.count; i++) {
                    InitDictData* data = self.dataArray[i];
                    if ([data.id intValue] == [self.politicalData.id intValue]) {
                        [self.pickerView selectRow:i inComponent:0 animated:NO];
                        break;
                    }
                }
            }
        }
    }
    else if (textField == self.ethnicityTextField)
    {
        self.dataArray = [DeviceHelper sharedInstance].ethnicitys;
        [self.pickerView reloadAllComponents];
        
        if (self.dataArray.count > 0)
        {
            [self.pickerView selectRow:0 inComponent:0 animated:NO];
            
            if (!self.ethnicityData) {
                InitDictData* data = self.dataArray[0];
                self.ethnicityData = data;
                self.ethnicityTextField.text = data.name;
                [self.dictionary setObject:self.ethnicityData.id forKey:@"ethnicity"];
            }else{
                for (NSInteger i = 0; i < self.dataArray.count; i++) {
                    InitDictData* data = self.dataArray[i];
                    if ([data.id intValue] == [self.ethnicityData.id intValue]) {
                        [self.pickerView selectRow:i inComponent:0 animated:NO];
                        break;
                    }
                }
            }
        }
    }
    else if (textField == self.nativePlaceTextField)
    {
        self.showAddress = YES;
        
        [self.pickerView reloadAllComponents];
    }
    else if (textField == self.postCodeTextField)
    {
        self.dataArray = [DeviceHelper sharedInstance].workConditions;
        [self.pickerView reloadAllComponents];
        
         if (self.dataArray.count > 0) {
             [self.pickerView selectRow:0 inComponent:0 animated:NO];
             
             if (!self.postCodeData) {
                 InitDictData* data = self.dataArray[0];
                 self.postCodeData = data;
                 self.postCodeTextField.text = data.name;
                 [self.dictionary setObject:self.postCodeData.id forKey:@"postCode"];
             }else{
                 for (NSInteger i = 0; i < self.dataArray.count; i++) {
                     InitDictData* data = self.dataArray[i];
                     if ([data.id intValue] == [self.postCodeData.id intValue]) {
                         [self.pickerView selectRow:i inComponent:0 animated:NO];
                         break;
                     }
                 }
             }
         }
    }
    NSLog(@"%s  %@",__func__,textField.text);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%s  %@",__func__,textField.text);
    
    
    if (textField == self.certifNoTextField)
    {
        if (self.certifNoTextField.text.length > 0) {
            BOOL flag = [NSString validateIdentityCard:self.certifNoTextField.text];
            if (flag) {
                [self.dictionary setObject:self.certifNoTextField.text forKey:@"certifNo"];
                NSString* birthday = [NSString extractBirthday:self.certifNoTextField.text];
                self.birthdayTextField.text = birthday;
                [self.dictionary setObject:self.birthdayTextField.text forKey:@"birthDay"];
            }else{
                [self.dictionary setObject:self.certifNoTextField.text forKey:@"certifNo"];
                [MBProgressHUD MBProgressHUDWithView:self.view Str:@"证件号码不规范"];
                return;
            }
        }else{
            [self.dictionary setObject:@"" forKey:@"certifNo"];
        }
    }
    else if (textField == self.nameTextField && self.nameTextField.text.length > 0){
        [self.dictionary setObject:self.nameTextField.text forKey:@"realName"];
    }
    else if (textField == self.workUnitTextField && self.workUnitTextField.text.length > 0){
        [self.dictionary setObject:self.workUnitTextField.text forKey:@"workUnit"];
    }
    else if (textField == self.workAddressTextField && self.workAddressTextField.text.length > 0){
        [self.dictionary setObject:self.workAddressTextField.text forKey:@"workAddress"];
    }
    else if (textField == self.domicileTextField && self.domicileTextField.text.length > 0){
        [self.dictionary setObject:self.domicileTextField.text forKey:@"domicile"];
    }
    else if (textField == self.faithTextField && self.faithTextField.text.length > 0){
        [self.dictionary setObject:self.faithTextField.text forKey:@"faith"];
    }
    else if (textField == self.jobTextField && self.jobTextField.text.length > 0){
        [self.dictionary setObject:self.jobTextField.text forKey:@"job"];
    }
    else if (textField == self.professionTextField && self.professionTextField.text.length > 0){
        [self.dictionary setObject:self.professionTextField.text forKey:@"profession"];
    }
    else if (textField == self.schoolTextField && self.schoolTextField.text.length > 0){
        [self.dictionary setObject:self.schoolTextField.text forKey:@"school"];
    }
    else if (textField == self.livePlaceTextField && self.livePlaceTextField.text.length > 0){
        [self.dictionary setObject:self.livePlaceTextField.text forKey:@"livePlace"];
    }
    else if (textField == self.hobbyTextField && self.hobbyTextField.text.length > 0){
        [self.dictionary setObject:self.hobbyTextField.text forKey:@"hobby"];
    }
    else if (textField == self.contactAddressTextField && self.contactAddressTextField.text.length > 0){
        [self.dictionary setObject:self.contactAddressTextField.text forKey:@"contactAddress"];
    }
    else if (textField == self.zipCodeTextField && self.zipCodeTextField.text.length > 0){
        [self.dictionary setObject:self.zipCodeTextField.text forKey:@"zipCode"];
    }
    else if (textField == self.emailTextField && self.emailTextField.text.length > 0){
        [self.dictionary setObject:self.emailTextField.text forKey:@"email"];
    }
    else if (textField == self.telephoneTextField && self.telephoneTextField.text.length > 0){
        [self.dictionary setObject:self.telephoneTextField.text forKey:@"telephone"];
    }
}

- (void)showDropTable{
    _dropTable = [RegisterDropTableView new];
    typeof(self) __weak wself = self;
    _dropTable.closeHandler = ^{
        [wself.dropTable removeFromSuperview];
        wself.dropTable = nil;
    };
    _dropTable.selectCityHandler = ^(CityModel* city){
        [wself.dropTable removeFromSuperview];
        wself.dropTable = nil;
        
        wself.tempCity = city;
        wself.areaTextField.text = city.AREA_NAME;
        
        [wself getOrganization:city.AREA_CODE areaName:@""];
    };
    _dropTable.cityArray = self.provinces;
    [self.view addSubview:_dropTable];
    [_dropTable mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark- UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.showAddress) {
        return 3;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.showAddress)
    {
        switch (component) {
            case 0:
                return self.provinceArray.count;
                break;
            case 1:
                return self.cityArray.count;
                break;
            case 2:
                return self.countyArray.count;
                break;
            default:
                break;
        }
    }
    else if (self.showLibrary) {
        return self.librarys.count;
    }
    return self.dataArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.showAddress)
    {
        CityModel* city;
        switch (component) {
            case 0:
                city = self.provinceArray[row];
                break;
            case 1:
                city = self.cityArray[row];
                break;
            case 2:
                city = self.countyArray[row];
                break;
            default:
                break;
        }
        return city.AREA_NAME;
    }
    else if (self.showLibrary)
    {
        LibraryModel* library = self.librarys[row];
        return library.name;
    }
    else
    {
        InitDictData* data = self.dataArray[row];
        return data.name;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%s",__func__);
    if (self.showAddress)
    {
        switch (component) {
            case 0:
                if (row < self.provinceArray.count) {
                    self.province = self.provinceArray[row];
                    [self getAreaList:self.province.AREA_ID pcode:self.province.AREA_CODE level:@"2"];
                }
                break;
            case 1:
                if (row < self.cityArray.count) {
                    self.city = self.cityArray[row];
                    [self getAreaList:self.city.AREA_ID pcode:self.city.AREA_CODE level:@"3"];
                }
                break;
            case 2:
                if (row < self.countyArray.count) {
                    self.county = self.countyArray[row];
                }
                break;
            default:
                break;
        }
        NSString* provinceName = @"";
        NSString* cityName = @"";
        NSString* countyName = @"";
        NSString* areaCode = @"";
        if (self.province) {
            provinceName = self.province.AREA_NAME;
        }
        if (self.city) {
            cityName = self.city.AREA_NAME;
        }
        if (self.county) {
            countyName = self.county.AREA_NAME;
        }
        areaCode = [NSString stringWithFormat:@"%@,%@,%@",
                    self.province.AREA_CODE.length>0?self.province.AREA_CODE:@"",
                    self.city.AREA_CODE.length>0?self.city.AREA_CODE:@"",
                    self.county.AREA_CODE.length>0?self.county.AREA_CODE:@""];
        [self.dictionary setObject:areaCode forKey:@"nativePlace"];
        
        self.nativePlaceTextField.text = [[provinceName stringByAppendingString:cityName] stringByAppendingString:countyName];
        [self.dictionary setObject:self.nativePlaceTextField.text.length>0?self.nativePlaceTextField.text:@"" forKey:@"nativePlaceName"];
        
    }
    else if (self.tempTextField == self.sexTextField)
    {
        InitDictData* data = self.dataArray[row];
        self.sexData = data;
        self.tempTextField.text = data.name;
        
        if ([self.sexData.name isEqualToString:@"男"]) {
            [self.dictionary setObject:@"0" forKey:@"sex"];
        }else{
            [self.dictionary setObject:@"1" forKey:@"sex"];
        }
    }
    else if (self.tempTextField == self.educationTextField)
    {
        InitDictData* data = self.dataArray[row];
        self.educationData = data;
        self.tempTextField.text = data.name;
        [self.dictionary setObject:self.educationData.id forKey:@"education"];
    }
    else if (self.tempTextField == self.certifTypeTextField)
    {
        InitDictData* data = self.dataArray[row];
        self.certifTypeData = data;
        self.tempTextField.text = data.name;
        [self.dictionary setObject:self.certifTypeData.id forKey:@"certifType"];
    }
    else if (self.tempTextField == self.ethnicityTextField)
    {
        InitDictData* data = self.dataArray[row];
        self.ethnicityData = data;
        self.tempTextField.text = data.name;
        [self.dictionary setObject:self.ethnicityData.id forKey:@"ethnicity"];
    }
    else if (self.tempTextField == self.politicalTextField)
    {
        InitDictData* data = self.dataArray[row];
        self.politicalData = data;
        self.tempTextField.text = data.name;
        [self.dictionary setObject:self.politicalData.id forKey:@"political"];
    }
    else if (self.tempTextField == self.postCodeTextField)
    {
        InitDictData* data = self.dataArray[row];
        self.postCodeData = data;
        self.tempTextField.text = data.name;
        [self.dictionary setObject:self.postCodeData.id forKey:@"postCode"];
    }
    else if (self.tempTextField == self.libraryTextField)
    {
        LibraryModel* library = self.librarys[row];
        self.tempLibrary = library;
        self.tempTextField.text = library.name;
        [self.dictionary setObject:library.id forKey:@"orgId"];
    }
    else
    {
        InitDictData* data = self.dataArray[row];
        self.tempTextField.text = data.name;
    }

}

#pragma mark-
- (void)recordSkillId:(BOOL)flag skill:(NSString *)skillId
{
    if (flag) {
        if (![self.skillArray containsObject:skillId]) {
            [self.skillArray addObject:skillId];
        }
    }else{
        if ([self.skillArray containsObject:skillId]) {
            [self.skillArray removeObject:skillId];
        }
    }
}

#pragma mark-
- (void)onNextStepAction:(id)sender{
    [self.view endEditing:YES];
    
    NSString* tempString;
    
    if (!self.tempLibrary) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请选择场馆"];return;
    }
    tempString = self.dictionary[@"realName"];
    if (tempString.length <= 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入姓名"];return;
    }
    if (!self.sexData) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请选择性别"];return;
    }

    if (!self.educationData) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请选择学历"];return;
    }

    tempString = self.dictionary[@"certifNo"];
    if (tempString.length <= 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请填写证件号码"];return;
    }
    tempString = self.dictionary[@"zipCode"];
    if (tempString.length > 0 && ![NSString isValidZipcode:tempString]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请填写正确的邮编"];return;
    }
    tempString = self.dictionary[@"telephone"];
    if (tempString.length > 0 && ![NSString isPureNumandCharacters:tempString]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请填写正确的手机号码"];return;
    }
    tempString = self.dictionary[@"email"];
    if (tempString.length > 0 && ![NSString validateEmail:tempString]) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请填写正确的邮箱"];return;
    }

    tempString = self.dictionary[@"birthDay"];
    if (tempString.length <= 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请填写正确的身份证号码"];return;
    }
    
    //个人特长(复选框,多选,存储每个选项的ID,ID间用英文的, 进行分割)
    NSString * skill = @"";
    for (NSInteger i = 0 ; i < self.skillArray.count ; i++) {
        NSString* str = self.skillArray[i];
        if (i == 0) {
            skill = str;
        }else{
            skill = [[skill stringByAppendingString:@","] stringByAppendingString:str];
        }
    }
    [self.dictionary setObject:skill forKey:@"specialitys"];

    
    RegisterSecondController* vc = [RegisterSecondController new];
    vc.paramDic = self.dictionary;
    vc.modifyVolunteer = self.modifyVolunteer;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
