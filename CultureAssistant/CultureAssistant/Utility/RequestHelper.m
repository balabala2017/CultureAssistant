//
//  RequestHelper.m
//  AgedCulture
//


#import "RequestHelper.h"

@implementation RequestHelper
+ (instancetype)sharedInstance
{
    static RequestHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RequestHelper alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (NSDictionary *)prepareRequestparameter:(NSDictionary *)dic
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString* sign = [self createHashString:dictionary];
    //除了发送验证码的接口需要 其他的全部去掉
//    [dictionary setObject:@"1001" forKey:@"siteId"];
    /*传参数需要注意三点
     1.appId token 不参与加密
     2.secretKey 放最后
     3.MD5 加密结果要小写
     */
    [dictionary setObject:twsm_appId forKey:@"appId"];
    if ([DeviceHelper sharedInstance].tokenCode) {
        [dictionary setObject:[DeviceHelper sharedInstance].tokenCode forKey:@"tokenCode"];
    }
    [dictionary setObject:sign forKey:@"sign"];
    
    //    NSLog(@"dictionary %@",dictionary);
    return dictionary;
}


- (NSString *)createHashString:(NSDictionary *)dict
{
    NSArray *keys = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString* tempString = @"";
    for (NSInteger index = 0 ; index < sortedArray.count ; index++)
    {
        NSString* key = sortedArray[index];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[dict objectForKey:key]]];
    }
    tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"secretKey=%@",twsm_secretKey]];
    
    //    NSLog(@"temp string %@",tempString);
    NSString* hashSting = [[tempString MD5Hash] lowercaseString];//加密结果小写 不然服务器校验不正确
    return hashSting;
}

@end
