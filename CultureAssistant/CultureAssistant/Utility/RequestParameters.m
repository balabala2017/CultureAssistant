//
//  RequestParameters.m
//  AgedCulture
//


#import "RequestParameters.h"
#import "RequestHelper.h"

@implementation RequestParameters

#pragma mark- 公共参数
+ (NSDictionary *)commonRequestParameter{
    NSDictionary* dic = @{};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

+ (NSDictionary *)requesetWithPage:(NSString *)cpage pageSize:(NSString *)pageSize{
    NSDictionary* dic = @{@"cpage":cpage,@"pageSize":pageSize};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

#pragma mark- 频道
//获取指定站点下的所有频道列表
+ (NSDictionary *)getChannelsBy:(NSString *)channelType{
    NSDictionary* dic = @{@"channelType":channelType};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

#pragma mark- 城市
//根据行政地区代码获取机构列表
+ (NSDictionary *)getOrgsByAreaCode:(NSString *)areaCode areaName:(NSString *)areaName{
    NSDictionary* dic = @{@"areaCode":areaCode,@"areaName":areaName};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

//增加组织机构或地区的访问记录 
+ (NSDictionary *)setVisitHistory:(NSString *)code areaName:(NSString *)areaName{
    NSDictionary* dic = @{@"code":code,@"name":areaName};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
#pragma mark- 资讯
//获取banner列表 
+ (NSDictionary *)getBannersByChannelId:(NSString *)channelId
                                   type:(NSString *)type
                                  cpage:(NSString *)cpage
                               pageSize:(NSString *)pageSize
                               areaCode:(NSString *)areaCode
                                  orgId:(NSString *)orgId
                             objectType:(NSString *)objectType
                               visibled:(NSString *)visibled{
    NSDictionary* dic = @{@"channelId":channelId,
                          @"type":type,
                          @"cpage":cpage,
                          @"pageSize":pageSize,
//                          @"areaCode":areaCode,
//                          @"orgId":orgId,
                          @"objectType":objectType,
                          @"visibled":visibled};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
//获取资讯信息列表
+ (NSDictionary *)getArticlesByChannelId:(NSString *)channelId
                                   cpage:(NSString *)cpage
                                pageSize:(NSString *)pageSize
                                areaCode:(NSString *)areaCode
                                   orgId:(NSString *)orgId
{
    NSDictionary* dic = @{@"channelId":channelId,
//                          @"areaCode":areaCode,
//                          @"orgId":orgId
                          @"cpage":cpage,
                          @"pageSize":pageSize};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
//获取资讯详情
+ (NSDictionary *)getArticleById:(NSString *)articleId{
    NSDictionary* dic = @{@"id":articleId};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
#pragma mark- 招募
//获取志愿活动列表 -招募列表
+ (NSDictionary *)getEventsByChannelId:(NSString *)channelId
                                 cpage:(NSString *)cpage
                              pageSize:(NSString *)pageSize
                                  type:(NSString *)type
                           activeState:(NSString *)activeState
                          serviceTypes:(NSString *)serviceTypes
                        serviceObjects:(NSString *)serviceObjects
                           recruitNums:(NSString *)recruitNums
                              areaCode:(NSString *)areaCode
                                 orgId:(NSString *)orgId
{
    NSDictionary* dic = @{@"channelId":channelId,
                          @"cpage":cpage,
                          @"pageSize":pageSize,
                          @"type":type,
                          @"activeState":activeState,
                          @"serviceTypes":serviceTypes,
                          @"serviceObjects":serviceObjects,
                          @"recruitNums":recruitNums,
                          @"areaCode":areaCode,
                          @"orgId":orgId
                          };
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
    
}
//招募详情+获取岗位+活动计时开始
+ (NSDictionary *)getEventsById:(NSString *)detailId{
    NSDictionary* dic = @{@"eventId":detailId};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

//获取活动报名人员列表 
+ (NSDictionary *)getEventApplys:(NSString *)eventId cpage:(NSString *)cpage pageSize:(NSString *)pageSize{
    NSDictionary* dic = @{@"eventId":eventId,@"cpage":cpage,@"pageSize":pageSize};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}


//招募报名
+ (NSDictionary *)volEventDoEnroll:(NSString *)eventId postId:(NSString *)postId{
    NSDictionary* dic = @{@"eventId":eventId,@"postId":postId};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}


//活动计时结束  服务记录ID可在 活动计时开始接口或招募活动详情接口中获取
+ (NSDictionary *)signOutEvent:(NSString *)recId{
    NSDictionary* dic = @{@"recId":recId};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
#pragma mark- 志愿者
//注册
+ (NSDictionary *)doRegisterWithOrgId:(NSString *)orgId            // *  所属机构(下拉框选择)
                             realName:(NSString *)realName         // * 真实姓名
                                  sex:(NSString *)sex              // * 性别 男-0；女-1
                             birthDay:(NSString *)birthDay         // * 出生年月日
                           certifType:(NSString *)certifType       // * 证件类型(下拉菜单选择)
                             certifNo:(NSString *)certifNo         // * 证件号码
                            ethnicity:(NSString *)ethnicity        //民族(下拉菜单选择)
                          nativePlace:(NSString *)nativePlace      // * 籍贯(省市县三级级联菜单,传送对应的县级别的areaCode)
                             domicile:(NSString *)domicile         //户籍所在地
                            livePlace:(NSString *)livePlace        //居住地址
                       contactAddress:(NSString *)contactAddress   //联系地址
                              zipCode:(NSString *)zipCode          //邮编
                            telephone:(NSString *)telephone        //联系电话
                                email:(NSString *)email            //邮箱
                            political:(NSString *)political        //政治面貌(下拉菜单选择)
                                faith:(NSString *)faith            //宗教信仰
                            education:(NSString *)education        // * 学历(下拉菜单选择)
                               school:(NSString *)school           //毕业学校
                             postCode:(NSString *)postCode         //职称(下拉菜单选择)
                                  job:(NSString *)job              //职务
                           profession:(NSString *)profession       //职业
                             workUnit:(NSString *)workUnit         //工作单位
                          specialitys:(NSString *)specialitys      //个人特长(复选框,多选,存储每个选项的ID,ID间用英文的, 进行分割)
                                hobby:(NSString *)hobby            //爱好
                         serviceTimes:(NSString *)serviceTimes     //可参与服务时间(复选框,多选,存储每个选项的ID,ID间用英文的, 进行分割)
                         serviceTypes:(NSString *)serviceTypes     //服务类别(复选框,多选,存储每个选项的ID,ID间用英文的, 进行分割)
                          workAddress:(NSString *)workAddress      //工作单位
                           uploadJson:(NSString *)uploadJson       //证件图片信息
{
    NSDictionary* dic = @{@"refType":@"VOLUNTEER",
                          @"orgId":orgId.length>0?orgId:@"",
                          @"volunteName":realName.length>0?realName:@"",
                          @"sex":sex.length>0?sex:@"",
                          @"birthDay":birthDay.length>0?birthDay:@"",
                          @"certifType":certifType.length>0?certifType:@"",
                          @"certifNo":certifNo.length>0?certifNo:@"",
                          @"ethnicity":ethnicity.length>0?ethnicity:@"",
                          @"nativePlace":nativePlace.length>0?nativePlace:@"",
                          @"domicile":domicile.length>0?domicile:@"",
                          @"livePlace":livePlace.length>0?livePlace:@"",
                          @"contactAddress":contactAddress.length>0?contactAddress:@"",
                          @"zipCode":zipCode.length>0?zipCode:@"",
                          @"telephone":telephone.length>0?telephone:@"",
                          @"email":email.length>0?email:@"",
                          @"political":political.length>0?political:@"",
                          @"faith":faith.length>0?faith:@"",
                          @"education":education.length>0?education: @"",
                          @"school":school.length>0?school:@"",
                          @"postCode":postCode.length>0?postCode:@"",
                          @"job":job.length>0?job:@"",
                          @"profession":profession.length>0?profession:@"",
                          @"workUnit":workUnit.length>0?workUnit:@"",
                          @"specialitys":specialitys.length>0?specialitys:@"",
                          @"hobby":hobby.length>0?hobby:@"",
                          @"serviceTimes":serviceTimes.length>0?serviceTimes:@"",
                          @"serviceTypes":serviceTypes.length>0?serviceTypes:@"",
                          @"workAddress":workAddress.length>0?workAddress:@"",
                          @"uploadJson":uploadJson.length>0?uploadJson:@""
                          };
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

//更新志愿者信息
+ (NSDictionary *)doUpdateVolunteer:(NSString *)volunteerId//志愿者id
                                orgRefId:(NSString *)orgRefId            // *  所属机构(下拉框选择)
                             identityId:(NSString *)identityId    // 身份信息主键ID
                        specialityId:(NSString *)specialityId    //个人特长信息主键ID
                        serviceDesireId:(NSString *)serviceDesireId    //服务意愿信息主键ID
                                otherId:(NSString *)otherId    // 其他信息主键ID
                             realName:(NSString *)realName         // * 真实姓名
                                  sex:(NSString *)sex              // * 性别 男-0；女-1
                             birthDay:(NSString *)birthDay         // * 出生年月日
                           certifType:(NSString *)certifType       // * 证件类型(下拉菜单选择)
                             certifNo:(NSString *)certifNo         // * 证件号码
                            ethnicity:(NSString *)ethnicity        //民族(下拉菜单选择)
                          nativePlace:(NSString *)nativePlace      // * 籍贯(省市县三级级联菜单,传送对应的县级别的areaCode)
                             domicile:(NSString *)domicile         //户籍所在地
                            livePlace:(NSString *)livePlace        //居住地址
                       contactAddress:(NSString *)contactAddress   //联系地址
                              zipCode:(NSString *)zipCode          //邮编
                            telephone:(NSString *)telephone        //联系电话
                                email:(NSString *)email            //邮箱
                            political:(NSString *)political        //政治面貌(下拉菜单选择)
                                faith:(NSString *)faith            //宗教信仰
                            education:(NSString *)education        // * 学历(下拉菜单选择)
                               school:(NSString *)school           //毕业学校
                             postCode:(NSString *)postCode         //职称(下拉菜单选择)
                                  job:(NSString *)job              //职务
                           profession:(NSString *)profession       //职业
                             workUnit:(NSString *)workUnit         //工作单位
                          specialitys:(NSString *)specialitys      //个人特长(复选框,多选,存储每个选项的ID,ID间用英文的, 进行分割)
                                hobby:(NSString *)hobby            //爱好
                         serviceTimes:(NSString *)serviceTimes     //可参与服务时间(复选框,多选,存储每个选项的ID,ID间用英文的, 进行分割)
                         serviceTypes:(NSString *)serviceTypes     //服务类别(复选框,多选,存储每个选项的ID,ID间用英文的, 进行分割)
                          workAddress:(NSString *)workAddress      //工作单位
                           uploadJson:(NSString *)uploadJson       //证件图片信息
{
    NSDictionary* dic = @{@"refType":@"VOLUNTEER",
                          @"id":volunteerId.length>0?volunteerId:@"",
                          @"orgRefId":orgRefId.length>0?orgRefId:@"",
                          @"identityId":identityId.length>0?identityId:@"",
                          @"specialityId":specialityId.length>0?specialityId:@"",
                          @"serviceDesireId":serviceDesireId.length>0?serviceDesireId:@"",
                          @"otherId":otherId.length>0?otherId:@"",
                          @"volunteName":realName.length>0?realName:@"",
                          @"sex":sex.length>0?sex:@"",
                          @"birthDay":birthDay.length>0?birthDay:@"",
                          @"certifType":certifType.length>0?certifType:@"",
                          @"certifNo":certifNo.length>0?certifNo:@"",
                          @"ethnicity":ethnicity.length>0?ethnicity:@"",
                          @"nativePlace":nativePlace.length>0?nativePlace:@"",
                          @"domicile":domicile.length>0?domicile:@"",
                          @"livePlace":livePlace.length>0?livePlace:@"",
                          @"contactAddress":contactAddress.length>0?contactAddress:@"",
                          @"zipCode":zipCode.length>0?zipCode:@"",
                          @"telephone":telephone.length>0?telephone:@"",
                          @"email":email.length>0?email:@"",
                          @"political":political.length>0?political:@"",
                          @"faith":faith.length>0?faith:@"",
                          @"education":education.length>0?education: @"",
                          @"school":school.length>0?school:@"",
                          @"postCode":postCode.length>0?postCode:@"",
                          @"job":job.length>0?job:@"",
                          @"profession":profession.length>0?profession:@"",
                          @"workUnit":workUnit.length>0?workUnit:@"",
                          @"specialitys":specialitys.length>0?specialitys:@"",
                          @"hobby":hobby.length>0?hobby:@"",
                          @"serviceTimes":serviceTimes.length>0?serviceTimes:@"",
                          @"serviceTypes":serviceTypes.length>0?serviceTypes:@"",
                          @"workAddress":workAddress.length>0?workAddress:@"",
                          @"uploadJson":uploadJson.length>0?uploadJson:@""
                          };
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

//获取地区列表
+ (NSDictionary *)getAreaListWithPid:(NSString *)pid pcode:(NSString *)pcode level:(NSString *)level{
    NSDictionary* dic = @{@"pid":pid,@"pcode":pcode,@"level":level};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

#pragma mark- 问卷
//获取问卷详情
+ (NSDictionary *)getQuestion:(NSString *)questionId{
    NSDictionary* dic = @{@"questionId":questionId};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

#pragma mark- 实名认证
+ (NSDictionary *)uploadVerifiedInfo:(NSString *)uploadJson;{
    NSDictionary* dic = @{@"uploadJson":uploadJson};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
#pragma mark- 以下是老接口

#pragma mark- 搜索
//搜索数据接口
/*
 type:0:资讯; 6:招募 (全部类型不用传)
 */
+ (NSDictionary *)doSearchType:(NSString *)type key:(NSString *)key cpage:(NSString *)cpage pageSize:(NSString *)pageSize{
    NSDictionary* dic = @{@"cpage":cpage,@"pageSize":pageSize,@"type":type,@"key":key};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

#pragma mark- 个人中心
//注册校验用户是否存在
+ (NSDictionary *)checkByUserName:(NSString *)userName{
    NSDictionary* dic = @{@"userName":userName};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
//注册
+ (NSDictionary *)toRegister:(NSString *)userName userPwd:(NSString *)userPwd smsCode:(NSString *)smsCode type:(NSString *)type{
    NSDictionary* dic = @{@"userName":userName,@"userPwd":userPwd,@"smsCode":smsCode,@"type":type};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

/*
 4.type类型
 用户注册来源类型标示：1. 或者没值就代表本系统pc;2.微信公众账号;3.微信账号;4.qq账号;5.新浪微博账号;6.ios;7.android
 */
//本地登录
+ (NSDictionary *)toLogin:(NSString *)userName userPwd:(NSString *)userPwd type:(NSString *)type{
    NSDictionary* dic = @{@"userName":userName,@"userPwd":userPwd,@"type":type};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

//获取验证码
+ (NSDictionary *)sendSms:(NSString *)userName{
    NSDictionary* dictionary = [[RequestHelper sharedInstance] prepareRequestparameter:@{@"userName":userName}];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    [dic setObject:@"1001" forKey:@"siteId"];
    return dic;
}
//重置密码
+ (NSDictionary *)findPasswordWith:(NSString *)userName userPwd:(NSString *)userPwd smsCode:(NSString *)smsCode{
    NSDictionary* dic = @{@"userName":userName,@"userPwd":userPwd,@"smsCode":smsCode};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

//修改手机号码时获取短信校验码
+ (NSDictionary *)updatePhoneNumSendSms:(NSString *)phoneNum{
    NSDictionary* dic = @{@"phoneNum":phoneNum};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
//修改手机号码
+ (NSDictionary *)updatePhoneNum:(NSString *)id phoneNum:(NSString *)phoneNum smsCode:(NSString *)smsCode{
    NSDictionary* dic = @{@"id":id,@"phoneNum":phoneNum,@"smsCode":smsCode};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

//修改密码
+ (NSDictionary *)updatePassword:(NSString *)oldPwd userPwd:(NSString *)userPwd userid:(NSString *)userid{
    NSDictionary* dic = @{@"oldPwd":oldPwd,@"userPwd":userPwd,@"id":userid};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}

//修改昵称
+ (NSDictionary *)updateNickname:(NSString *)nickName userid:(NSString *)userid{
    NSDictionary* dic = @{@"nickName":nickName,@"id":userid};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
//修改用户头像
+ (NSDictionary *)updateUserHead:(NSString *)headerIconUrl userid:(NSString *)userid{
    NSDictionary* dic = @{@"headerIconUrl":headerIconUrl,@"id":userid};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
//修改用户性别
+ (NSDictionary *)updateSex:(NSString *)sex userid:(NSString *)userid{
    NSDictionary* dic = @{@"sex":sex,@"id":userid};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
//获取用户信息
+ (NSDictionary *)getUserById:(NSString *)userId{
    NSDictionary* dic = @{@"userId":userId};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
//上传文件 coverType 0默认按视频规格压缩 1是视频封面 2是音频封面 3是图片封面
+ (NSDictionary *)uploadFile:(NSString *)optType md5:(NSString *)md5 coverType:(NSString *)coverType{
    NSDictionary* dic = @{@"appId":twsm_appId,@"tokenCode":[DeviceHelper sharedInstance].tokenCode,
                          @"optType":optType,@"md5":md5,@"coverType":coverType};
    return dic;
}
//获取我的报名活动
+ (NSDictionary *)getUserApplysWithStatu:(NSString *)statu cpage:(NSString *)cpage pageSize:(NSString *)pageSize{
    NSDictionary* dic = @{@"statu":statu,@"cpage":cpage,@"pageSize":pageSize};
    return [[RequestHelper sharedInstance] prepareRequestparameter:dic];
}
@end
