//
//  DeviceHelper.h
//  AgedCulture
//


#import <Foundation/Foundation.h>

#define DeviceIDKey @"deviceID"

typedef NS_ENUM(NSInteger, Network_Status) {
    Not_Reachable = 0,
    ReachableVia_WiFi = 2,
    ReachableVia_WWAN = 1
};


@interface DeviceHelper : NSObject

@property (nonatomic, strong) NSString *deviceID;
//统计
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *logParams;

@property (nonatomic, strong) NSMutableArray *serviceObjects;//服务对象
@property (nonatomic, strong) NSMutableArray *recruitNums;    //招募人数
@property (nonatomic, strong) NSMutableArray *serviceTypes;   //服务类别

@property (nonatomic, strong) NSArray *workConditions; //职业
@property (nonatomic, strong) NSArray *sexs;           //性别
@property (nonatomic, strong) NSArray *specialitys;    //特长
@property (nonatomic, strong) NSArray *politicals;     //政治面貌
@property (nonatomic, strong) NSArray *educations;     //学历
@property (nonatomic, strong) NSArray *certifTypes;    //证件类型
@property (nonatomic, strong) NSArray *ethnicitys;     //民族

@property (nonatomic, strong) NSArray *citys;     //缓存城市列表

@property (nonatomic, strong) ChannelModel *recruitChannel;     //招募频道

@property (nonatomic, strong) NSString *tokenCode;

@property (nonatomic, strong) CityModel *locationCity;     //定位城市

+ (instancetype)sharedInstance;

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (NSString *)keychainErrorToString:(NSInteger)error;
+ (void)saveKeychain:(NSString *)key value:(id)sValue;
+ (id)keyChain:(NSString *)key;
//剩余空间
+ (long long)freeDiskSpace;

+(NSString *)getDiskSize;
+(void)clearDisk;

- (Network_Status)checkNetworkState;
- (NSString *)getLogParams;

//注册 招募 用到的数据
- (void)getInitDictData;
//多处用到城市列表
-(void)getAreaList:(void (^)(BOOL finished))finish;
@end
