//
//  DeviceHelper.m
//  AgedCulture
//


#import "DeviceHelper.h"
#include <sys/param.h>
#include <sys/mount.h>
#import "Reachability.h"
#import "NSObject+WHC_Model.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation DeviceHelper

+ (instancetype)sharedInstance
{
    static DeviceHelper *deviceInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceInstance = [[DeviceHelper alloc] init];
        deviceInstance.deviceID = [DeviceHelper keyChain:DeviceIDKey];
        if (!deviceInstance.deviceID) {
            deviceInstance.deviceID = [[UIDevice currentDevice].identifierForVendor UUIDString];
            [DeviceHelper saveKeychain:DeviceIDKey value:deviceInstance.deviceID];
        }
    });
    return deviceInstance;
}


- (id)init{
    if (self = [super init]) {
    
        self.serviceObjects = [NSMutableArray array];
        self.recruitNums = [NSMutableArray array];
        self.serviceTypes = [NSMutableArray array];
    }
    return self;
}


- (void)getInitDictData{
    [AFNetAPIClient GET:APIGetInitDictData parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = (NSDictionary *)model.result;
            
            NSArray* array ;
            InitDictData* allData;
            
            NSObject* obj = dic[@"serviceObjects"];
            if ([obj isKindOfClass:[NSArray class]]) {
                array = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
                [self.serviceObjects addObjectsFromArray:array];
                
                allData = [[InitDictData alloc] init];
                allData.name = @"全部";
                allData.id = @"0";
                [self.serviceObjects insertObject:allData atIndex:0];
                
                [self getInitDictDataFrame:self.serviceObjects];
            }
            obj = dic[@"workConditions"];
            if ([obj isKindOfClass:[NSArray class]]) {
                self.workConditions = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
            }
            obj = dic[@"recruitNums"];
            if ([obj isKindOfClass:[NSArray class]]) {
                array = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
                [self.recruitNums addObjectsFromArray:array];
                
                allData = [[InitDictData alloc] init];
                allData.name = @"全部";
                allData.id =  @"0";
                [self.recruitNums insertObject:allData atIndex:0];
                
                [self getInitDictDataFrame:self.recruitNums];
            }
            obj = dic[@"sexs"];
            if ([obj isKindOfClass:[NSArray class]]) {
                self.sexs = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
            }
            obj = dic[@"specialitys"];
            if ([obj isKindOfClass:[NSArray class]]) {
                self.specialitys = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
            }
            obj = dic[@"politicals"];
            if ([obj isKindOfClass:[NSArray class]]) {
                self.politicals = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
            }
            obj = dic[@"serviceTypes"];
            if ([obj isKindOfClass:[NSArray class]]) {
                array = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
                [self.serviceTypes addObjectsFromArray:array];
                
                allData = [[InitDictData alloc] init];
                allData.name = @"全部";
                allData.id = @"0";
                [self.serviceTypes insertObject:allData atIndex:0];
                
                [self getInitDictDataFrame:self.serviceTypes];
            }
            obj = dic[@"educations"];
            if ([obj isKindOfClass:[NSArray class]]) {
                self.educations = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
            }
            obj = dic[@"certifTypes"];
            if ([obj isKindOfClass:[NSArray class]]) {
                self.certifTypes = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
            }
            obj = dic[@"ethnicitys"];
            if ([obj isKindOfClass:[NSArray class]]) {
                self.ethnicitys = [InitDictData arrayOfModelsFromDictionaries:(NSArray *)obj];
            }
            
            
        }
    }failure:^(id JSON, NSError *error){
        
    }];
}

-(void)getAreaList:(void (^)(BOOL finished))finish
{
    [AFNetAPIClient GET:APIGetProvinces parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error) {
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray *)model.result;
            array = [CityModel arrayOfModelsFromDictionaries:array error:nil];
            self.citys = array;
            finish(YES);
        }
        
    } failure:^(id JSON, NSError *error) {

    }];
}


-(void)getInitDictDataFrame:(NSArray *)array
{
    CGFloat width = 0;
    CGFloat height = 28;
    CGFloat positonX = 10;
    CGFloat positionY = 10;
    
    CGFloat sumWidth = 10;
    
    CGFloat maxWidth = SCREENWIDTH-20;
    
    for (InitDictData * dictData in array) {
        
        CGRect rect = [dictData.name boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        
        width = rect.size.width + 50;
        
        if (width>maxWidth) {
            width = maxWidth+10;
        }
        
        if ((sumWidth + width)>maxWidth) {
            positonX = 10;
            positionY += 10+28;
            sumWidth = width;
        }
        else{
            positonX = sumWidth;
            sumWidth += width;
        }
        
        NSString * rectStr = NSStringFromCGRect(CGRectMake(positonX, positionY, width-20, height));
        dictData.frameSize =  rectStr;
    }
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}
+ (NSString *)keychainErrorToString: (NSInteger)error {
    NSString *msg = [NSString stringWithFormat:@"%ld",(long)error];
    switch (error) {
        case errSecSuccess:
            msg = NSLocalizedString(@"SUCCESS", nil);
            break;
        case errSecDuplicateItem:
            msg = NSLocalizedString(@"ERROR_ITEM_ALREADY_EXISTS", nil);
            break;
        case errSecItemNotFound :
            msg = NSLocalizedString(@"ERROR_ITEM_NOT_FOUND", nil);
            break;
        case -26276: // this error will be replaced by errSecAuthFailed
            msg = NSLocalizedString(@"ERROR_ITEM_AUTHENTICATION_FAILED", nil);
            
        default:
            break;
    }
    return msg;
}
+ (void)saveKeychain:(NSString *)key value:(id)sValue
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:sValue] forKey:(__bridge id)kSecValueData];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)keychainQuery,NULL);
    [self keychainErrorToString:status];
}
+ (id)keyChain:(NSString *)key
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {}
        @finally {}
    }
    if (keyData)CFRelease(keyData);
    return ret;
}

+ (long long)freeDiskSpace{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace;
}

#pragma mark-
+(NSString *)getDiskSize
{
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    NSString *fullNamespace = @"AFNetApiClient";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *_diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    float folderSize = 0.00;
    if ([_fileManager fileExistsAtPath:_diskCachePath]) {
        NSArray *childerFiles=[_fileManager subpathsAtPath:_diskCachePath];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[_diskCachePath stringByAppendingPathComponent:fileName];
            long long size=[_fileManager attributesOfItemAtPath:absolutePath error:nil].fileSize;
            folderSize += size;
        }
    }
    
    NSString *audioPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"AudioData"];
    if ([_fileManager fileExistsAtPath:audioPath]) {
        NSArray *childerFiles=[_fileManager subpathsAtPath:audioPath];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[audioPath stringByAppendingPathComponent:fileName];
            long long size=[_fileManager attributesOfItemAtPath:absolutePath error:nil].fileSize;
            folderSize += size;
        }
    }
    
    folderSize+=[[SDImageCache sharedImageCache] getSize];
    
    folderSize = folderSize/1024.0/1024.0;
    
    return [NSString stringWithFormat:@"%.2fMB",folderSize];
}

+(void)clearDisk
{
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    NSString *fullNamespace = @"AFNetApiClient";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *_diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    if ([_fileManager fileExistsAtPath:_diskCachePath]) {
        NSArray *childerFiles=[_fileManager subpathsAtPath:_diskCachePath];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[_diskCachePath stringByAppendingPathComponent:fileName];
            [_fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    fullNamespace = @"com.hackemist.SDWebImageCache.default";
    _diskCachePath = [paths[0] stringByAppendingPathComponent:fullNamespace];
    if ([_fileManager fileExistsAtPath:_diskCachePath]) {
        NSArray *childerFiles=[_fileManager subpathsAtPath:_diskCachePath];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[_diskCachePath stringByAppendingPathComponent:fileName];
            [_fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    
    NSString *audioPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"AudioData"];
    if ([_fileManager fileExistsAtPath:audioPath]) {
        NSArray *childerFiles=[_fileManager subpathsAtPath:audioPath];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[audioPath stringByAppendingPathComponent:fileName];
            [_fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    //删除自己缓存
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
    
    //清除内存中的图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    //清除磁盘的缓存
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[[SDWebImageManager sharedManager] imageCache] cleanDisk];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (Network_Status)checkNetworkState
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没有网络");
            return Not_Reachable;
            break;
        case ReachableViaWWAN:
            NSLog(@"使用手机自带网络进行上网");
            return ReachableVia_WWAN;
            break;
        case ReachableViaWiFi:
            NSLog(@"有wifi");
            return ReachableVia_WiFi;
            break;
    }
}

/*
 {
 
 sysAppId:“”，   客户端ID               8d1da37fe9294024a4306c14abf53ac5
 sysSite:“”，    站点id    空着
 sysParentSite： 父站点id   空着
 sysDevid：      设备号id               deviceID
 sysDevType：    设备号类型  iphone      [[UIDevice currentDevice] model]
 sysVersion：    软件版本                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
 sysOs：         操作系统版本             [[UIDevice currentDevice] systemVersion]
 sysAgent：      浏览器标示              tianwen-culture-cloud-ios
 sysReferer：               空着
 sysDpi：        设备分辨率  750*480     NSStringFromCGRect([UIScreen mainScreen].bounds)
 sysNet：        网络类型    wifi 4g  3g
 sysAppMarket：  市场来源                appstore
 sysCookieId：
 sysIP：         网络IP地址  空着
 sysUid：        用户id   用户未登录的情况下为空
 }
 
 */

- (NSString *)getLogParams
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:twsm_appId forKey:@"sysAppId"];
    [dic setObject:self.deviceID forKey:@"sysDevid"];
    [dic setObject:[[UIDevice currentDevice] model] forKey:@"sysDevType"];
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [dic setObject:version forKey:@"sysVersion"];
    [dic setObject:[NSString stringWithFormat:@"iOS %@",[[UIDevice currentDevice] systemVersion]] forKey:@"sysOs"];
    [dic setObject:@"tianwen-culture-cloud-ios" forKey:@"sysAgent"];
    NSString* screen = [NSString stringWithFormat:@"%ld*%ld",(long)[UIScreen mainScreen].bounds.size.height,(long)[UIScreen mainScreen].bounds.size.width];
    [dic setObject:screen forKey:@"sysDpi"];
    NSString* netState = [DeviceHelper getNetconnType];
    if (netState.length > 0) {
        [dic setObject:netState forKey:@"sysNet"];
    }
    [dic setObject:@"AppStore" forKey:@"sysAppMarket"];
    if (self.sessionId.length > 0) {
        [dic setObject:self.sessionId forKey:@"sysCookieId"];
    }
    if ([UserInfoManager sharedInstance].isAlreadyLogin) {
        NSString* userID = [UserInfoManager sharedInstance].userModel.userinfo.id;
        [dic setObject:userID forKey:@"sysUid"];
    }
    
    [dic setObject:VERSIONCODE forKey:@"sysVersionCode"];
    
    NSString *jsonString = [dic whc_Json];
    
    return jsonString;
}


//+(NSString *)getNetWorkStates
//{
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
//    NSString *state = [[NSString alloc]init];
//    int netType = 0;
//
//    for (id child in children)
//    {
//        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
//        {
//            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
//
//            switch (netType) {
//                case 0:
//                    state = @"无网络";
//                    break;
//                case 1:
//                    state = @"2G";
//                    break;
//                case 2:
//                    state = @"3G";
//                    break;
//                case 3:
//                    state = @"4G";
//                    break;
//                case 5:
//                    state = @"WIFI";
//                    break;
//                default:
//                    break;
//            }
//        }
//    }
//    return state;
//}

+ (NSString *)getNetconnType{
    
    NSString *netconnType = @"";
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}
@end
