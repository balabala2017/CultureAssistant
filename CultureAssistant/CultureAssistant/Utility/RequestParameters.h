//
//  RequestParameters.h
//  AgedCulture
//


#import <Foundation/Foundation.h>

@interface RequestParameters : NSObject

#pragma mark- 公共参数
+ (NSDictionary *)commonRequestParameter;

+ (NSDictionary *)requesetWithPage:(NSString *)cpage pageSize:(NSString *)pageSize;
#pragma mark- 频道
//获取指定站点下的所有频道列表
+ (NSDictionary *)getChannelsBy:(NSString *)channelType;
#pragma mark- 城市
//根据行政地区代码获取机构列表
//areaCode: 行政地区代码(如果不送则获取所有的)
//根据行政地区代码获取机构列表
+ (NSDictionary *)getOrgsByAreaCode:(NSString *)areaCode areaName:(NSString *)areaName;
//增加组织机构或地区的访问记录
+ (NSDictionary *)setVisitHistory:(NSString *)code areaName:(NSString *)areaName;

#pragma mark- 资讯
//获取banner列表
+ (NSDictionary *)getBannersByChannelId:(NSString *)channelId
                                   type:(NSString *)type
                                  cpage:(NSString *)cpage
                               pageSize:(NSString *)pageSize
                               areaCode:(NSString *)areaCode
                                  orgId:(NSString *)orgId
                             objectType:(NSString *)objectType
                               visibled:(NSString *)visibled;
//获取资讯信息列表
+ (NSDictionary *)getArticlesByChannelId:(NSString *)channelId
                                   cpage:(NSString *)cpage
                                pageSize:(NSString *)pageSize
                                areaCode:(NSString *)areaCode
                                   orgId:(NSString *)orgId;
//获取资讯详情
+ (NSDictionary *)getArticleById:(NSString *)articleId;

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
                                 orgId:(NSString *)orgId;
//招募详情 + 获取岗位
+ (NSDictionary *)getEventsById:(NSString *)detailId;

//获取活动报名人员列表
+ (NSDictionary *)getEventApplys:(NSString *)eventId cpage:(NSString *)cpage pageSize:(NSString *)pageSize;

//报名招募活动
+ (NSDictionary *)volEventDoEnroll:(NSString *)eventId postId:(NSString *)postId;

//活动计时结束  服务记录ID可在 活动计时开始接口或招募活动详情接口中获取
+ (NSDictionary *)signOutEvent:(NSString *)recId;
#pragma mark- 志愿者
//注册
+ (NSDictionary *)doRegisterWithOrgId:(NSString *)orgId            //记录类型(送固定的值: VOLUNTEER 表示是志愿者)
                             realName:(NSString *)realName         //所属机构(下拉框选择)
                                  sex:(NSString *)sex              //性别 男-0；女-1
                             birthDay:(NSString *)birthDay         //出生年月日
                           certifType:(NSString *)certifType       //证件类型(下拉菜单选择)
                             certifNo:(NSString *)certifNo         //证件号码
                            ethnicity:(NSString *)ethnicity        //民族(下拉菜单选择)
                          nativePlace:(NSString *)nativePlace      //籍贯(省市县三级级联菜单,传送对应的县级别的areaCode)
                             domicile:(NSString *)domicile         //户籍所在地
                            livePlace:(NSString *)livePlace        //居住地址
                       contactAddress:(NSString *)contactAddress   //联系地址
                              zipCode:(NSString *)zipCode          //邮编
                            telephone:(NSString *)telephone        //联系电话
                                email:(NSString *)email            //邮箱
                            political:(NSString *)political        //政治面貌(下拉菜单选择)
                                faith:(NSString *)faith            //宗教信仰
                            education:(NSString *)education        //学历(下拉菜单选择)
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
                           uploadJson:(NSString *)uploadJson ;      //证件图片信息

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
                         uploadJson:(NSString *)uploadJson ;      //证件图片信息

//获取地区列表
+ (NSDictionary *)getAreaListWithPid:(NSString *)pid pcode:(NSString *)pcode level:(NSString *)level;
#pragma mark- 问卷
//获取问卷详情
+ (NSDictionary *)getQuestion:(NSString *)questionId;

#pragma mark- 实名认证
+ (NSDictionary *)uploadVerifiedInfo:(NSString *)uploadJson;

#pragma mark- 以下是老接口

#pragma mark- 搜索
//搜索数据接口
+ (NSDictionary *)doSearchType:(NSString *)type key:(NSString *)key cpage:(NSString *)cpage pageSize:(NSString *)pageSize;
#pragma mark- 个人中心
//注册校验用户是否存在
+ (NSDictionary *)checkByUserName:(NSString *)userName;
//注册
+ (NSDictionary *)toRegister:(NSString *)userName userPwd:(NSString *)userPwd smsCode:(NSString *)smsCode type:(NSString *)type;
//本地登录
+ (NSDictionary *)toLogin:(NSString *)userName userPwd:(NSString *)userPwd type:(NSString *)type;
//获取验证码
+ (NSDictionary *)sendSms:(NSString *)userName;
//重置密码
+ (NSDictionary *)findPasswordWith:(NSString *)userName userPwd:(NSString *)userPwd smsCode:(NSString *)smsCode;
//修改手机号码时获取短信校验码
+ (NSDictionary *)updatePhoneNumSendSms:(NSString *)phoneNum;
//修改手机号码
+ (NSDictionary *)updatePhoneNum:(NSString *)id phoneNum:(NSString *)phoneNum smsCode:(NSString *)smsCode;

//修改昵称
+ (NSDictionary *)updateNickname:(NSString *)nickName userid:(NSString *)userid;
//修改用户头像
+ (NSDictionary *)updateUserHead:(NSString *)headerIconUrl userid:(NSString *)userid;
//修改用户性别
+ (NSDictionary *)updateSex:(NSString *)sex userid:(NSString *)userid;
//获取用户信息
+ (NSDictionary *)getUserById:(NSString *)userId;
//修改密码
+ (NSDictionary *)updatePassword:(NSString *)oldPwd userPwd:(NSString *)userPwd userid:(NSString *)userid;
//上传文件 coverType 0默认按视频规格压缩 1是视频封面 2是音频封面 3是图片封面
+ (NSDictionary *)uploadFile:(NSString *)optType md5:(NSString *)md5 coverType:(NSString *)coverType;
//获取我的报名活动
+ (NSDictionary *)getUserApplysWithStatu:(NSString *)statu cpage:(NSString *)cpage pageSize:(NSString *)pageSize;

@end
