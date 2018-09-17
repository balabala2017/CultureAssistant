//
//  MainViewController.m
//  CultureAssistant
//


#import "MainViewController.h"
#import "SearchViewController.h"
#import "CityViewController.h"
#import "InfoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "RecruitConditionController.h"

#import "CustomNavigationController.h"

@interface MainViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UIButton *locationButton;
@property(nonatomic,strong)UIView* blueView;
@property(nonatomic,strong)InfoViewController* infoVC;

//一旦请求失败 反复请求三次
@property(nonatomic,assign)NSInteger requestChannelCount;
@property(nonatomic,assign)NSInteger requestSubChannelCount;
@property(nonatomic,assign)BOOL networkFailed;

@property(nonatomic,strong)CLLocationManager* locationManager;
@property(nonatomic,strong)NSString* locationCity;

@property(nonatomic,strong)UIBarButtonItem *cityItem;
@property(nonatomic,strong)UIBarButtonItem *searchItem;
@property(nonatomic,strong)UIBarButtonItem *filterItem;

@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,strong)NSMutableArray* barItemArray;

@property(nonatomic,strong)UILabel* titleLabel;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
    _networkFailed = NO;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 68, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"文化助盲";
    self.navigationItem.titleView = label;
    self.titleLabel = label;
    
    
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationButton.titleLabel.font = [UIFont systemFontOfSize:9];
    self.locationButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    NSString * cityName = @"全国";
    NSArray * cityInfo = [[NSUserDefaults standardUserDefaults] objectForKey:LocationSelectedArea];
    NSString * locationCityName = nil;
    if ([cityInfo isKindOfClass:[NSArray class]]) {
        locationCityName = cityInfo[1];
    }
    if (locationCityName.length>0) {
        cityName = locationCityName;
    }
    if (cityName.length > 5) {
        [self.locationButton setTitle:[cityName substringWithRange:NSMakeRange(0, 5)] forState:UIControlStateNormal];
    }else{
        [self.locationButton setTitle:cityName forState:UIControlStateNormal];
    }
//    CGRect rect = [@"湖南盲图馆" boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.locationButton.titleLabel.font} context:nil];
//    self.locationButton.frame = CGRectMake(0, 0, rect.size.width+24, 44);
    self.locationButton.frame = CGRectMake(0, 0, 46+24, 44);
    [self.locationButton setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    [self.locationButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.locationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, -10, 0)];
    self.locationButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.locationButton addTarget:self action:@selector(locationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.cityItem = [[UIBarButtonItem alloc]initWithCustomView:self.locationButton];
    
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 30, 44);
    [searchButton setImage:[UIImage imageNamed:@"right_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = self.searchItem;
    
    
    //招募
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame = CGRectMake(0, 0, 30, 44);
    [filterButton setImage:[UIImage imageNamed:@"filter_icon"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.filterItem = [[UIBarButtonItem alloc]initWithCustomView:filterButton];

    
    
    NSArray* vc = @[@"InfoViewController",
                    @"RegisterViewController",
                    @"RecruitViewController",
                    @"PersonViewController"];
    
    NSArray* title = @[@"资讯",
                       @"注册",
                       @"招募",
                       @"我的"];
    
    NSArray* image = @[@"tab_item0",
                       @"tab_item1",
                       @"tab_item2",
                       @"tab_item3"];
    
    NSArray* selectedImage = @[@"tab_item0_selected",
                               @"tab_item1_selected",
                               @"tab_item2_selected",
                               @"tab_item3_selected"];
    
    _blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH/4.0, TabBarHeight)];
    _blueView.backgroundColor = [UIColor colorWithHexString:@"1976d2"];
    [self.tabBar addSubview:_blueView];
    {
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBar_arrow"]];
        [_blueView addSubview:imgView];
        imgView.frame = CGRectMake((SCREENWIDTH/4.0-12)/2.0, 0, 12, 5);
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:13.0f],
                                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"4a4a4a"]
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:13.0f],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateSelected];
    
    _barItemArray =  [NSMutableArray array];
    NSMutableArray* array = [NSMutableArray array];
    for (NSInteger i = 0; i < vc.count; i++)
    {
        NSString* string = vc[i];
        CustomViewController* controller = [NSClassFromString(string) new];
        if (0 == i) {
            self.infoVC = (InfoViewController *)controller;
        }
        UITabBarItem* barItem = [[UITabBarItem alloc]initWithTitle:title[i] image:[UIImage imageNamed:image[i]] selectedImage:[[UIImage imageNamed:selectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        barItem.tag = i;
        controller.tabBarItem = barItem;
        [_barItemArray addObject:barItem];
        [array addObject:controller];
        
    }
    self.viewControllers = array;
    
    
    [self getChannelList];
    
    [[DeviceHelper sharedInstance] getInitDictData];
    [[DeviceHelper sharedInstance] getAreaList:^(BOOL finished){
        
    }];
    
    
//    self.selectIndex = 0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocationCity:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSelectedCity:) name:Change_City_Library object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(donotShowRegister:) name:@"Do_Not_Show_Register" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRegisterSucess:) name:@"RegisterSuccess_Notify" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVolunteerToUpdate) name:@"refresh_volunteer_info" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVolunteerToUpdate) name:@"ModifySuccess_Notify" object:nil];
}

//- (void)viewWillLayoutSubviews{
//    CGRect tabFrame = self.tabBar.frame;
//    tabFrame.size.height = TabBarHeight;
//    tabFrame.origin.y = self.view.frame.size.height - TabBarHeight;
//    self.tabBar.frame = tabFrame;
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_networkFailed == YES) {
        [self getChannelList];
    }
}

//资讯页面的频道
- (void)getChannelList{
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:APIGetChannels parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error) {
        wself.networkFailed = NO;
        DataModel* data = [[DataModel alloc] initWithString:JSON error:nil];
        if ([data.result isKindOfClass:[NSDictionary class]]) {
            ChannelListModel* channelList = [ChannelListModel channelListModelWithJson:(NSDictionary *)data.result];
            NSMutableArray* array = [NSMutableArray array];
            NSArray* tempArr = (NSArray *)channelList.list;
            
            for (NSInteger i = 0; i < tempArr.count; i++) {
                ChannelModel *model = tempArr[i];
                if ([model.PARENT_NAME isEqualToString:@"资讯"]) {
                    [array addObject:model];
                }
                if (i == tempArr.count-1) {
                    wself.infoVC.subChannelsArr = array;
                }
                if ([model.PARENT_NAME isEqualToString:@"招募"]) {
                    [DeviceHelper sharedInstance].recruitChannel = model;
                }
            }
        }

    }failure:^(id JSON, NSError *error) {
        wself.networkFailed = YES;
        wself.requestChannelCount ++;
        if (wself.requestChannelCount < 3) {
            [wself getChannelList];
        }
    }];
}



#pragma mark-
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //1.未登录，弹出登录页面   2.登录未注册，显示注册页面  3.登录并注册，提示已注册过
    /*
        auditFlag 1-待审核, 2-审核通过/待发布, 3-审核不通过, 4-取消审核
        盲图的  /api/braille/user/toUserCenter  这个接口增加这个字段
        要同时判断auditFlag volunteerFlag两个字段
        先判断volunteerFlag（是否注册过）
        如果注册过  判断auditFlag的值 点击注册志愿者给出相应提示
        如果没出测过， 就可以让用户走注册流程
     */
    if (1 == item.tag)
    {
        if (![UserInfoManager sharedInstance].isAlreadyLogin){
            [self performSelector:@selector(showLoginView) withObject:nil afterDelay:.1f];
            return;
        }else{
            if ([[UserInfoManager sharedInstance].userModel.volunteerFlag boolValue] == YES) {
                if ([[UserInfoManager sharedInstance].userModel.auditFlag length] > 0) {
                    [[NSNotificationCenter  defaultCenter] postNotificationName:@"delivery_check_state" object:nil userInfo:@{@"checkState":[UserInfoManager sharedInstance].userModel.auditFlag}];
                }
                
//                switch ([[UserInfoManager sharedInstance].userModel.auditFlag intValue]) {
//                    case 1:
//                        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"待审核"];
//                        break;
//                    case 2:
//                        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"审核通过/待发布"];
//                        break;
//                    case 3:
//                        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"审核不通过"];
//                        break;
//                    case 4:
//                        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"取消审核"];
//                        break;
//                    default:
//                        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"你已经是志愿者了"];
//                        break;
//                }
//                [self performSelector:@selector(testFunction) withObject:nil afterDelay:.1f];
//                return;
            }
        }
    }

    self.selectIndex = item.tag;

    _blueView.frame = CGRectMake(item.tag*SCREENWIDTH/4.0, 0, SCREENWIDTH/4.0, 49);

    switch (item.tag) {
        case 0:
            self.titleLabel.text = @"文化助盲";
            break;
        case 1:
            self.titleLabel.text = @"注册";
            break;
        case 2:
            self.titleLabel.text = @"招募";
            break;
        case 3:
            self.titleLabel.text = @"个人中心";
            break;

        default:
            break;
    }

    switch (item.tag) {
        case 0:
        case 1:
        {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = self.searchItem;
        }
            break;
        case 2:
        {
            self.navigationItem.leftBarButtonItem = self.cityItem;
            self.navigationItem.rightBarButtonItem = self.filterItem;
        }
            break;
        case 3:
        {
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
        }
            break;
            
        default:
            break;
    }
}

- (void)showLoginView{
    LoginViewController* loginVC = [[LoginViewController alloc] init];
    loginVC.fromRegisterPage = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)testFunction{
//    self.selectedIndex = self.selectIndex;
}

- (void)locationButtonClicked:(UIButton *)button{
    CityViewController* controller = [CityViewController new];
    controller.locationCity = self.locationCity;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)searchButtonClicked:(UIButton *)button{
    SearchViewController* controller = [SearchViewController new];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)filterButtonClicked:(UIButton *)button{
    RecruitConditionController* controller = [RecruitConditionController new];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark- NSNotification
- (void)showSelectedCity:(NSNotification *)notify{
    NSDictionary* dic = notify.userInfo;
    NSString* cityNameStr = @"";
    if ([dic objectForKey:SelectedCityKey]) {
        CityModel* city = dic[SelectedCityKey];
        if (city.ORG_ID.length > 0) {
//            [self.locationButton setTitle:city.SHOW_NAME forState:UIControlStateNormal];
            cityNameStr = city.SHOW_NAME;
        }else{
//            [self.locationButton setTitle:city.AREA_NAME forState:UIControlStateNormal];
            cityNameStr = city.AREA_NAME;
        }
    }else{
        LibraryModel* library = dic[SelectedLibraryKey];
//        [self.locationButton setTitle:library.name forState:UIControlStateNormal];
        cityNameStr = library.name;
    }
    if (cityNameStr.length > 5) {
        [self.locationButton setTitle:[cityNameStr substringWithRange:NSMakeRange(0, 5)] forState:UIControlStateNormal];
    }else{
        [self.locationButton setTitle:cityNameStr forState:UIControlStateNormal];
    }
}

- (void)startLocationCity:(NSNotification *)notify{
    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1000.0f;
    }
    //定位服务是否可用
    BOOL enable=[CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    int status=[CLLocationManager authorizationStatus];
    if(!enable || status<3){
        //请求权限
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)donotShowRegister:(NSNotification *)notify{
    if (![UserInfoManager sharedInstance].isAlreadyLogin){
        self.selectedIndex = self.selectIndex;
    }
    else
    {
//        if ([[UserInfoManager sharedInstance].userModel.volunteerFlag boolValue] == YES) {
//            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"您已是志愿者了"];
//            [self performSelector:@selector(testFunction) withObject:nil afterDelay:.1f];
//            return;
//        }
        self.selectedIndex = 1;
        _blueView.frame = CGRectMake(SCREENWIDTH/4.0, 0, SCREENWIDTH/4.0, 49);
        
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = self.searchItem;
    }
}

- (void)onRegisterSucess:(NSNotification *)notify{
    //注册完成  变成待审核状态
    [UserInfoManager sharedInstance].userModel.auditFlag = @"1";
    
    self.selectedIndex = 0;
    _blueView.frame = CGRectMake(0.0, 0, SCREENWIDTH/4.0, 49);
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = self.searchItem;
}

#pragma mark-
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    //获取所在地城市名
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
         for(CLPlacemark *placemark in placemarks)
         {
             self.locationCity = [placemark.addressDictionary objectForKey:@"City"];
             
             NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
             NSArray * cityInfo = [userdefaults objectForKey:LocationSelectedArea];
             if (!cityInfo) {
                 [self.locationButton setTitle:self.locationCity forState:UIControlStateNormal];
                 
                 if ([DeviceHelper sharedInstance].citys.count > 0) {
                     for (CityModel* city in [DeviceHelper sharedInstance].citys) {
                         if ([city.AREA_NAME isEqualToString:self.locationCity]) {
                             [userdefaults setObject:@[city.AREA_CODE,city.AREA_NAME,CityModelKey,city.AREA_NAME] forKey:LocationSelectedArea];
                             [userdefaults synchronize];
                             [DeviceHelper sharedInstance].locationCity = city;
                             break;
                         }
                     }
                 }else{
                     [[DeviceHelper sharedInstance] getAreaList:^(BOOL finished){
                         if (finished) {
                             for (CityModel* city in [DeviceHelper sharedInstance].citys) {
                                 if ([city.AREA_NAME isEqualToString:self.locationCity]) {
                                     [userdefaults setObject:@[city.AREA_CODE,city.AREA_NAME,CityModelKey,city.AREA_NAME] forKey:LocationSelectedArea];
                                     [userdefaults synchronize];
                                     [DeviceHelper sharedInstance].locationCity = city;
                                     break;
                                 }
                             }
                         }
                     }];
                 }
             }
             if ([DeviceHelper sharedInstance].citys.count > 0) {
                 for (CityModel* city in [DeviceHelper sharedInstance].citys) {
                     if ([city.AREA_NAME isEqualToString:self.locationCity]) {
                         [DeviceHelper sharedInstance].locationCity = city;
                         break;
                     }
                 }
             }else{
                 [[DeviceHelper sharedInstance] getAreaList:^(BOOL finished){
                     if (finished) {
                         for (CityModel* city in [DeviceHelper sharedInstance].citys) {
                             if ([city.AREA_NAME isEqualToString:self.locationCity]) {
                                 [DeviceHelper sharedInstance].locationCity = city;
                                 break;
                             }
                         }
                     }
                 }];
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"Get_LOCATION_CITY" object:nil userInfo:@{@"LocationCity":self.locationCity}];
         }
     }];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    
    switch([error code]) {
        case kCLErrorDenied:
        {
            errorString = @"Access to Location Services denied by user";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"前往设置打开定位功能" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorLocationUnknown:
            errorString = @"Location data unavailable";
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }

    if (errorString) {
        NSLog(@"定位失败信息  %@",errorString);

    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

//修改志愿者信息前 先获取志愿者信息
- (void)getVolunteerToUpdate
{
    if (![[UserInfoManager sharedInstance].userModel.volunteerFlag boolValue]) return;
    
    //修改完成  变成待审核状态
    [UserInfoManager sharedInstance].userModel.auditFlag = @"1";
    
    [AFNetAPIClient GET:APIGetVolunteerInfo parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code isEqualToString:@"200"] && [model.result isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = (NSDictionary *)model.result;
            VolunteerInfo* volunteer = [VolunteerInfo new];
            if ([dic[@"volunteer"] objectForKey:@"id"] && ![[dic[@"volunteer"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
                volunteer.id = [[dic[@"volunteer"] objectForKey:@"id"] stringValue];
            }
            
            if ([dic[@"org"] objectForKey:@"id"] && ![[dic[@"org"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
                volunteer.orgId = [[dic[@"org"] objectForKey:@"id"] stringValue];
            }
            volunteer.areaName = [dic[@"org"] objectForKey:@"areaName"];
            volunteer.orgName = [dic[@"org"] objectForKey:@"name"];
            
            volunteer.realName = [dic[@"volunteer"] objectForKey:@"volunteName"];
            if ([[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"id"] && ![[[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
                volunteer.identityId = [[[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"id"] stringValue];
            }
            volunteer.sex = [[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"sex"];
            volunteer.birthDay = [[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"birthDay"];
            
            volunteer.educationName = [dic[@"volunteer"] objectForKey:@"educationName"];
            if ([dic[@"volunteer"] objectForKey:@"education"] && ![[dic[@"volunteer"] objectForKey:@"education"] isKindOfClass:[NSNull class]]) {
                volunteer.education = [[dic[@"volunteer"] objectForKey:@"education"] stringValue];
            }
            
            volunteer.certifNo = [[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"certifNo"];
            if ([[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"certifType"] && ![[[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"certifType"] isKindOfClass:[NSNull class]]) {
                volunteer.certifType = [[[dic[@"volunteer"] objectForKey:@"identity"] objectForKey:@"certifType"] stringValue];
            }
            
            if ([[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"id"] && ![[[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
                volunteer.otherId = [[[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"id"] stringValue];
            }
            volunteer.workUnit = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"workUnit"];
            volunteer.workAddress = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"workAddress"];
            
            if ([dic[@"volunteer"] objectForKey:@"ethnicity"] && ![[dic[@"volunteer"] objectForKey:@"ethnicity"] isKindOfClass:[NSNull class]]) {
                volunteer.ethnicity = [[dic[@"volunteer"] objectForKey:@"ethnicity"] stringValue];
            }
            
            volunteer.nativePlace = [dic[@"volunteer"] objectForKey:@"nativePlace"];
            volunteer.nativePlaceName = [dic[@"volunteer"] objectForKey:@"nativePlaceName"];
            
            volunteer.domicile = [dic[@"volunteer"] objectForKey:@"domicile"];
            if ([dic[@"volunteer"] objectForKey:@"political"] && ![[dic[@"volunteer"] objectForKey:@"political"] isKindOfClass:[NSNull class]]) {
                volunteer.political = [[dic[@"volunteer"] objectForKey:@"political"] stringValue];
            }
            
            volunteer.faith = [dic[@"volunteer"] objectForKey:@"faith"];
            
            volunteer.postCode = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"postCode"];
            volunteer.job = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"job"];
            volunteer.profession = [[dic[@"volunteer"] objectForKey:@"other"] objectForKey:@"profession"];
            
            volunteer.school = [dic[@"volunteer"] objectForKey:@"school"];
            volunteer.livePlace = [dic[@"volunteer"] objectForKey:@"livePlace"];
            
            if ([[dic[@"volunteer"] objectForKey:@"speciality"] objectForKey:@"id"] && ![[[dic[@"volunteer"] objectForKey:@"speciality"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
                volunteer.specialityId = [[[dic[@"volunteer"] objectForKey:@"speciality"] objectForKey:@"id"] stringValue];
            }
            
            volunteer.specialitys = [[dic[@"volunteer"] objectForKey:@"speciality"] objectForKey:@"specialitys"];
            
            volunteer.hobby = [dic[@"volunteer"] objectForKey:@"hobby"];
            volunteer.contactAddress = [dic[@"volunteer"] objectForKey:@"contactAddress"];
            volunteer.zipCode = [dic[@"volunteer"] objectForKey:@"zipCode"];
            volunteer.email = [dic[@"volunteer"] objectForKey:@"email"];
            volunteer.telephone = [dic[@"volunteer"] objectForKey:@"telephone"];
            
            if ([[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"id"] && ![[[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
                volunteer.serviceDesireId = [[[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"id"] stringValue];
            }
            volunteer.serviceTypeList = [[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"serviceTypeList"];
            volunteer.serviceTimeList = [[dic[@"volunteer"] objectForKey:@"serviceDesire"] objectForKey:@"serviceTimeList"];
            
            volunteer.registerDate = [dic[@"volunteer"] objectForKey:@"registerDate"];
            volunteer.volunteNo = [dic[@"volunteer"] objectForKey:@"volunteNo"];
            volunteer.verifyRemark = [dic[@"volunteer"] objectForKey:@"verifyRemark"];
            
            LibraryModel* library = [[LibraryModel alloc] initWithDictionary:dic[@"org"] error:nil];
            volunteer.volunteerLibrary = library;
            
            [UserInfoManager sharedInstance].volunteer = volunteer;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetVolunteerInfo_Finish" object:nil];
        }
    } failure:^(id JSON, NSError *error){
        
    }];
}
#pragma mark-
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
