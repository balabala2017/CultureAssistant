//
//  Header.h
//  CultureAssistant
//


#ifndef Header_h
#define Header_h


//获取指定站点下的所有频道列表
#define APIGetChannels @"/api/braille/channel/getChannelsBy"

#pragma mark- 城市
//热门城市
#define APIGetVisitHistorys  @"/api/braille/area/getVisitHistorys"
//获取所有有效省份列表  包含热门访问+城市列表
#define APIGetProvinces @"/api/braille/area/getProvinces"
//根据行政地区代码获取机构列表
#define APIGetOrgs @"/api/braille/org/getOrgsBy"
//增加组织机构或地区的访问记录 -- 选完地区或分馆给后台发送的trac，访问的多了就会变成热门访问
#define APISetVisitHistory  @"/api/braille/area/setVisitHistory"


#pragma mark- 资讯
//获取banner列表
#define APIGetBanners       @"/api/braille/banner/getBannersBy"
//获取资讯信息列表
#define APIGetArticles      @"/api/braille/article/getArticlesBy"
//获取资讯详情
#define APIGetArticleDetail @"/api/braille/article/getArticleBy"

#pragma mark- 招募
//获取志愿活动列表-招募
#define APIGetEvents @"/api/braille/volEvent/getEventsBy"
//获取招募详情
#define APIGetEventDetail @"/api/braille/volEvent/getEventBy"
//获取岗位信息
#define APIGetEventPosts  @"/api/braille/volEvent/getEventPosts"
//报名招募活动
#define APIVolEventEnroll  @"/api/braille/volEvent/doEnroll"

//活动计时开始
#define APISignInEvent  @"/api/braille/volEvent/signInEvent"
//活动计时结束  服务记录ID可在 活动计时开始接口或招募活动详情接口中获取
#define APISignOutEvent  @"/api/braille/volEvent/signOutEvent"
//获取招募活动动态信息
#define APIGetEventDynamics  @"/api/braille/volEvent/getEventDynamics"
//获取活动报名人员列表
#define APIGetEventApplys  @"/api/braille/volEvent/getEventApplys"

#pragma mark- 问卷
//获取问卷详情
#define APIGetQuestion @"/api/braille/question/getQuestionBy"
//提交答案
#define APIQuestionDoCommit  @"/api/braille/question/doCommit"

#pragma mark- 注册
//获取注册志愿者的信息  学历、政治面貌等
#define APIGetInitDictData @"/api/braille/volunteer/getInitDictData"
//志愿者注册
#define APIDoRegister @"/api/braille/volunteer/doRegister"
//获取当前志愿者的星级记录信息
#define APIGetUserStarRec @"/api/braille/volunteer/getUserStarRec"
//获取当前志愿者的服务记录信息
#define APIGetUserServiceRec @"/api/braille/volunteer/getUserServiceRec"
//获取全国地区列表-注册时 选择户籍要用到
#define APIGetAreaList @"/api/braille/area/getAreasByPid"
//获取我的报名活动
#define APIGetUserApplys @"/api/braille/volEvent/getJoinEventByUserId"
//获取带有场馆的城市
#define APIGetProvincesByArea @"/api/braille/area/getProvincesByArea"
//通过手机号发送该账号下绑定的邮箱的验证码
#define APISendEmailVCode @"/trunk/api/login/sendEmailVCode"
//通过邮箱验证码来重置密码
#define APIResetPwdFromEmailVCode @"/trunk/api/login/resetPwdFromEmailVCode"

#pragma mark- 以下是老接口

#pragma mark- 搜索
//获取热门关键字
#define APIGetHotSearch   @"/api/braille/search/getHostSearch"
//搜索数据接口
#define APIDoSearch   @"/api/braille/search/doSearch"

#pragma mark- 个人中心
//注册
#define APIUserRegister     @"/api/login/toRegister"
//登录
#define APIUserLogin        @"/api/login/toLogin"
//短信验证码
#define APIRegisterSendSms  @"/api/login/registerSendSms"
//重置密码
#define APIFindPassword     @"/api/login/toForget"
//刷新token
#define APIRefreshTokenCode @"/api/login/toRefreshTokenCode"
//注册校验用户是否存在
#define APICheckByUserName @"/api/login/checkByUserName"
//修改手机号码
#define APIUpdatePhoneNum    @"/api/user/updatePhone"
//修改手机号时 需要获取校验码
#define APIUpdatePhoneNumSendSms   @"/api/login/sendSms"
//修改用户信息
#define APIUpdateUserInfo   @"/api/user/update"


//获取用户信息
#define APIUserCenter  @"/api/braille/user/toUserCenter"
//申请评书
#define APIApplyCertificate  @"/api/braille/volunteer/applyCertificate"
//上传公共接口
#define APIUplaodFile  @"/api/upload/uplaodFile"

//获取志愿者信息
#define APIGetVolunteerInfo  @"/api/braille/volunteer/toUpdate"
//更新志愿者信息  理论上参数和注册一样
#define APIUpdateVolunteer  @"/api/braille/volunteer/doUpdate"

//实名认证
#define APIUploadVerifiedInfo  @"/api/braille/volunteer/uploadVerifiedInfo"
#define APIGetCertifiedInfo  @"/api/braille/volunteer/getCertifiedInfo"
//开始或结束活动计时
#define APISignEvent  @"/api/braille/volEvent/signEvent"

#pragma mark- 域名


#define Formal_URL @"http://apiwhzm.blc.org.cn"

#define AFNetAPIBaseURLString Formal_URL


#endif /* Header_h */
