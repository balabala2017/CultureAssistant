//
//  DataModel.m
//  AgedCulture
//


#import "DataModel.h"

@implementation DataModel

@end

@implementation DetailRootModel

@end
#pragma mark- 服务对象、性别、政治面貌等
@implementation InitDictData

@end

#pragma mark- 频道
@implementation ChannelModel

@end

@implementation ChannelListModel

+ (ChannelListModel *)channelListModelWithJson:(NSDictionary *)json
{
    ChannelListModel *model = [[ChannelListModel alloc] initWithDictionary:json error:nil];
    if ([model.list isKindOfClass:[NSArray class]]) {
        model.list = [ChannelModel arrayOfModelsFromDictionaries:(NSArray *)model.list error:nil];
    }
    return model;
}

@end



#pragma mark- 城市
@implementation CityModel

@end

#pragma mark- 场馆
@implementation LibraryModel

@end
#pragma mark- banner
@implementation BannerItem

@end

@implementation BannerList

+ (BannerList *)BannerListWithDictionary:(NSDictionary *)json
{
    BannerList* banner = [[BannerList alloc] initWithDictionary:json error:nil];
    if ([banner.list isKindOfClass:[NSArray class]]) {
        banner.list = [BannerItem arrayOfModelsFromDictionaries:banner.list];
    }
    return banner;
}
@end

#pragma mark- 资讯
@implementation ArticleItem

@end

@implementation ArticleList

+ (ArticleList *)ArticleListWithDictionary:(NSDictionary *)json{
    ArticleList *model = [[ArticleList alloc] initWithDictionary:json error:nil];
    NSMutableArray* tempArray = [NSMutableArray array];
    if ([model.list isKindOfClass:[NSArray class]]) {
        for (NSDictionary* dic in model.list) {
            ArticleItem* item = [[ArticleItem alloc] initWithDictionary:dic error:nil];
            if (item.RECRUIT_START_TIME.length>0) {
                item.RECRUIT_START_TIME = [item.RECRUIT_START_TIME stringByAppendingString:@" 00:00:00"];
            }
            if (item.RECRUIT_END_TIME.length>0) {
                item.RECRUIT_END_TIME = [item.RECRUIT_END_TIME stringByAppendingString:@" 23:59:59"];
            }
            if (item) {
                [tempArray addObject:item];
            }
        }
        model.list = tempArray;
    }
    return model;
}
@end
#pragma  mark- 资讯详情
@implementation ArticleDetail

@end

#pragma  mark- 招募详情
@implementation RecruitEventApply

@end

@implementation RecruitServiceRec

@end

@implementation RecruitEventDesire

@end

@implementation RecruitEventLink

@end

@implementation RecruitDetail
+ (RecruitDetail *)RecruitDetailWithDictionary:(NSDictionary *)json{
    RecruitDetail* detail = [[RecruitDetail alloc] initWithDictionary:json error:nil];
    if ([detail.eventDesire isKindOfClass:[NSDictionary class]]) {
        RecruitEventDesire* desire = [[RecruitEventDesire alloc] initWithDictionary:detail.eventDesire error:nil];
        if (desire) {
            detail.desire = desire;
        }
    }
    if ([detail.eventLink isKindOfClass:[NSDictionary class]]) {
        RecruitEventLink* linker = [[RecruitEventLink alloc] initWithDictionary:detail.eventLink error:nil];
        if (linker) {
            detail.linker = linker;
        }
    }
    if ([detail.eventApply isKindOfClass:[NSDictionary class]]) {
        RecruitEventApply* apply = [[RecruitEventApply alloc] initWithDictionary:detail.eventApply error:nil];
        if (apply) {
            detail.apply = apply;
        }
    }
    if ([detail.serviceRec isKindOfClass:[NSDictionary class]]) {
        RecruitServiceRec* service = [[RecruitServiceRec alloc] initWithDictionary:detail.serviceRec error:nil];
        if (service) {
            detail.service = service;
        }
    }
    return detail;
}
@end

@implementation RecruitDynamic

@end

@implementation RecruitPost

@end

#pragma mark- 服务记录
@implementation ServiceRecord

@end

#pragma mark- 星级记录
@implementation  StarRecord

@end


#pragma mark- 我的报名
@implementation  EventDesireModel

@end

@implementation  VolEventModel
+ (VolEventModel *)VolEventModelWithDictionary:(NSDictionary *)json{
    VolEventModel* model = [[VolEventModel alloc] initWithDictionary:json error:nil];
    if ([model.eventDesire isKindOfClass:[NSDictionary class]]) {
        EventDesireModel* desire = [[EventDesireModel alloc] initWithDictionary:model.eventDesire error:nil];
        if (desire) {
            model.eventDesireObj = desire;
        }
    }
    return model;
}
@end

@implementation  MyEnrollModel
+ (MyEnrollModel *)MyEnrollModelWithDictionary:(NSDictionary *)json{
    MyEnrollModel* model = [[MyEnrollModel alloc] initWithDictionary:json error:nil];
    if ([model.volEvent isKindOfClass:[NSDictionary class]]) {
        VolEventModel* event = [VolEventModel VolEventModelWithDictionary:model.volEvent];
        if (event) {
            if (event.recruitStartDate.length > 0) {
                event.recruitStartDate = [event.recruitStartDate stringByAppendingString:@" 00:00:00"];
            }
            if (event.recruitEndDate.length > 0) {
                event.recruitEndDate = [event.recruitEndDate stringByAppendingString:@" 23:59:59"];
            }
            model.volEventObj = event;
        }
    }
    return model;
}
@end

#pragma mark- 志愿者信息
@implementation  VolunteerModel

@end

#pragma mark- 问卷

@implementation  QuestionOption
@end

@implementation  QuestionTopic
+ (QuestionTopic *)QuestionTopicWithDictionary:(NSDictionary *)json{
    QuestionTopic* question = [[QuestionTopic alloc] initWithDictionary:json error:nil];
    if ([question.results isKindOfClass:[NSArray class]]) {
        question.results = [QuestionOption arrayOfModelsFromDictionaries:question.results];
    }
    return question;
}
@end

@implementation QuestionList
+ (QuestionList *)QuestionListWithDictionary:(NSDictionary *)json{
    QuestionList* list = [[QuestionList alloc] initWithDictionary:json error:nil];
    NSMutableArray* array = [NSMutableArray array];
    if ([list.topics isKindOfClass:[NSArray class]]) {
        for (NSDictionary* dic in list.topics) {
            QuestionTopic* topic = [QuestionTopic QuestionTopicWithDictionary:dic];
            if (topic) {
                [array addObject:topic];
            }
        }
        list.topics = array;
    }
    return list;
}
@end

#pragma mark-
@implementation HotKeyItem

@end

@implementation HotKeys

+ (NSArray *)HotKeysWithDictionary:(NSDictionary *)json
{
    DataModel * model = [[DataModel alloc] initWithString:(NSString *)json error:nil];
    NSMutableArray* hotKeyArray = [NSMutableArray array];
    if ([model.result isKindOfClass:[NSArray class]])
    {
        for (NSDictionary* dic in (NSArray *)model.result)
        {
            HotKeys * elem = [[HotKeys alloc] initWithDictionary:dic error:nil];
            if ([elem.hotKeys isKindOfClass:[NSArray class]])
            {
                NSMutableArray* itemArray = [NSMutableArray array];
                for (NSDictionary* hotKeyDic in elem.hotKeys) {
                    HotKeyItem* item = [[HotKeyItem alloc] initWithDictionary:hotKeyDic error:nil];
                    if (item) {
                        [itemArray addObject:item];
                    }
                }
                elem.hotKeys = itemArray;
            }
            
            if (elem) {
                [hotKeyArray addObject:elem];
            }
            
            if ([elem.sonSearchType isKindOfClass:[NSArray class]]) {
                NSMutableArray* itemArray = [NSMutableArray array];
                for (NSDictionary* dic in elem.sonSearchType)
                {
                    HotKeys * elem = [[HotKeys alloc] initWithDictionary:dic error:nil];
                    if (elem) {
                        [itemArray addObject:elem];
                    }
                }
                elem.sonSearchType = itemArray;
            }
        }
    }
    return hotKeyArray;
}

@end

#pragma mark-
@implementation UploadImageModel

@end
#pragma mark- 志愿者
@implementation VolunteerInfo

@end


#pragma mark- 用户
@implementation UserInfo

@end

@implementation UserModel

+ (UserModel *)userModelWithJson:(NSDictionary *)json{
    UserModel *mode = [[UserModel alloc] initWithDictionary:json error:nil];
    if ([mode.user isKindOfClass:[NSDictionary class]]) {
        mode.userinfo = [[UserInfo alloc] initWithDictionary:mode.user error:nil];
    }
    return mode;
}
@end


@implementation UserInfoManager

+ (UserInfoManager *)sharedInstance {
    static UserInfoManager * s_instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        s_instance = [[UserInfoManager alloc] init];
        
    });
    return s_instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userModel.userinfo = nil;
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:BackupUserInfo]) {
            NSString* jsonString = [userDefaults objectForKey:BackupUserInfo];
            
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            
            if (dic) {
                self.userModel = [UserModel userModelWithJson:dic];
            }
        }
        
        [NSTimer scheduledTimerWithTimeInterval:10*60 target:self selector:@selector(refreshTokenCode) userInfo:nil repeats:YES];
        
    }
    return self;
}

- (void)saveUserinfo:(NSDictionary *)jsonDic{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString* string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:string forKey:BackupUserInfo];
    [userDefaults synchronize];
}


- (void)deleteUserInfo{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:BackupUserInfo];
    [userDefaults removeObjectForKey:LocalUserPassword];

    [userDefaults synchronize];
    
    self.userModel = nil;
    self.isAlreadyLogin = NO;
}

- (BOOL)isAlreadyLogin{
    if (self.userModel == nil) {
        return NO;
    }
    return YES;
}

//tokenCode 有效时间  30分钟
- (void)refreshTokenCode{
    if (self.userModel == nil) return;
    
    [AFNetAPIClient POST:APIRefreshTokenCode parameters:[RequestParameters commonRequestParameter] showLoading:NO success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSString class]]) {
            NSString* jsonString = (NSString *)model.result;
            if (jsonString.length > 0) {
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                [DeviceHelper sharedInstance].tokenCode = [dic objectForKey:@"tokenCode"];
            }
        }
    }failure:^(id JSON, NSError *error){
        
    }];
}

- (void)getUserCenterInfo:(void (^)(BOOL finished))success{
    
    [AFNetAPIClient GET:APIUserCenter parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code intValue] == 200 && [model.result isKindOfClass:[NSDictionary class]]) {
            
            self.userModel = [UserModel userModelWithJson:(NSDictionary *)model.result];

            [self saveUserinfo:(NSDictionary *)model.result];
            success(YES);
        }
    }failure:^(id JSON, NSError *error){
        
    }];
}


@end
