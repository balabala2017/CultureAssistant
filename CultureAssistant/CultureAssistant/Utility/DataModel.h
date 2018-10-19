//
//  DataModel.h
//  AgedCulture
//


#import "JSONModel.h"

@interface DataModel : JSONModel

@property (nonatomic,strong)NSObject<Optional> * result;
@property (nonatomic,strong)NSString<Optional> * code;
@property (nonatomic,strong)NSString<Optional> * msg;

@end

//详情数据结构不同  共同的数据字段 点赞  收藏
@interface DetailRootModel : DataModel

@property(nonatomic,strong)NSString<Optional> * isExpired;
@property(nonatomic,strong)NSString<Optional> * likeCount;
@property(nonatomic,strong)NSString<Optional> * isLike;
@property(nonatomic,strong)NSString<Optional> * commentCount;
@property(nonatomic,strong)NSString<Optional> * isCollect;

@end

#pragma mark- 服务对象、性别、政治面貌等
@interface InitDictData : JSONModel
@property(nonatomic,strong)NSString<Optional> * id;
@property(nonatomic,strong)NSString<Optional> * name;
@property(nonatomic,strong)NSString<Optional> * pcode;
@property(nonatomic,strong)NSString<Optional> * pname;

@property(nonatomic,strong)NSString<Optional> * frameSize;
@end

#pragma mark- 频道
@interface ChannelModel : JSONModel

@property (nonatomic,strong)NSString<Optional> * JUMP_URL;
@property (nonatomic,strong)NSString<Optional> * NAME;
@property (nonatomic,strong)NSString<Optional> * CHANNEL_TYPE;
@property (nonatomic,strong)NSString<Optional> * IMG_URL;
@property (nonatomic,strong)NSString<Optional> * ID;
@property (nonatomic,strong)NSString<Optional> * SITE_NAME;
@property (nonatomic,strong)NSString<Optional> * SITE_ID;
@property (nonatomic,strong)NSString<Optional> * PARENT_NAME;
@property (nonatomic,strong)NSString<Optional> * PARENT_CHANNEL_ID;


@property (nonatomic,strong)NSString<Optional> * name;
@property (nonatomic,strong)NSString<Optional> * id;

@end

@interface ChannelListModel : JSONModel

@property (nonatomic,strong)NSObject<Optional> * list;
+ (ChannelListModel *)channelListModelWithJson:(NSDictionary *)json;
@end

#pragma mark- 城市
@interface CityModel : JSONModel

@property(nonatomic,strong)NSString<Optional> * PARENT_AREA_ID;
@property(nonatomic,strong)NSString<Optional> * AREA_NAME;
@property(nonatomic,strong)NSString<Optional> * AREA_CODE;
@property(nonatomic,strong)NSString<Optional> * AREA_LEVEL;
@property(nonatomic,strong)NSString<Optional> * AREA_ID;
@property(nonatomic,strong)NSString<Optional> * PINYIN;
@property(nonatomic,strong)NSString<Optional> * IS_HOT;

//热门
@property(nonatomic,strong)NSString<Optional> * SHOW_NAME;
@property(nonatomic,strong)NSString<Optional> * ID;
@property(nonatomic,strong)NSString<Optional> * ORG_ID;//有值的时候 代表是场馆

@end

#pragma mark- 场馆
@interface LibraryModel : JSONModel
@property(nonatomic,strong)NSString<Optional> * areaCode;
@property(nonatomic,strong)NSString<Optional> * code;
@property(nonatomic,strong)NSString<Optional> * areaName;
@property(nonatomic,strong)NSString<Optional> * name;
@property(nonatomic,strong)NSString<Optional> * fullName;
@property(nonatomic,strong)NSString<Optional> * areaId;
@property(nonatomic,strong)NSString<Optional> * id;
@property(nonatomic,strong)NSString<Optional> * parentId;
@end


#pragma mark- banner
@interface BannerItem : JSONModel
@property(nonatomic,strong)NSString<Optional> * SUMMARY;
@property(nonatomic,strong)NSString<Optional> * IMG_URL;
@property(nonatomic,strong)NSString<Optional> * CHANNEL_ID;
@property(nonatomic,strong)NSString<Optional> * OBJECT_TYPE;
@property(nonatomic,strong)NSString<Optional> * AREA_CODE;
@property(nonatomic,strong)NSString<Optional> * OBJECT_ID;
@property(nonatomic,strong)NSString<Optional> * SITE_ID;
@property(nonatomic,strong)NSString<Optional> * ADD_TIME;
@property(nonatomic,strong)NSString<Optional> * CATALOG_ID;
@property(nonatomic,strong)NSString<Optional> * JUMP_URL;
@property(nonatomic,strong)NSString<Optional> * ID;
@property(nonatomic,strong)NSString<Optional> * ARTICLE_ID;
@property(nonatomic,strong)NSString<Optional> * TYPE;
@end

@interface BannerList : JSONModel

@property(nonatomic,strong)NSString<Optional> * lastPage;
@property(nonatomic,strong)NSString<Optional> * pageSize;
@property(nonatomic,strong)NSString<Optional> * pageNumber;
@property(nonatomic,strong)NSString<Optional> * firstPage;
@property(nonatomic,strong)NSString<Optional> * totalRow;
@property(nonatomic,strong)NSString<Optional> * totalPage;
@property(nonatomic,strong)NSArray<Optional> * list; //存放BannerItem
+ (BannerList *)BannerListWithDictionary:(NSDictionary *)json;
@end

#pragma mark- 资讯 + 招募

@interface ArticleItem : JSONModel

@property (nonatomic,strong)NSString<Optional> * ATTACH_JSONSTR;
@property (nonatomic,strong)NSString<Optional> * COVER_IMG_URL;
@property (nonatomic,strong)NSString<Optional> * PLATFORM_ARTICAL_ID;
@property (nonatomic,strong)NSString<Optional> * ARTICLE_TYPE;//新闻类型：0-普通新闻，1-多图新闻，2-视频新闻 -1推广
@property (nonatomic,strong)NSString<Optional> * ID;
@property (nonatomic,strong)NSString<Optional> * LABEL;
@property (nonatomic,strong)NSString<Optional> * COMMENT_COUNT;
@property (nonatomic,strong)NSString<Optional> * LIKE_COUNT;
@property (nonatomic,strong)NSString<Optional> * PUBLISH_TIME;
@property (nonatomic,strong)NSString<Optional> * TYPE;
@property (nonatomic,strong)NSString<Optional> * TITLE;
@property (nonatomic,strong)NSString<Optional> * READ_COUNT;

//招募
@property (nonatomic,strong)NSString<Optional> * SERVICE_OBJECTS;
@property (nonatomic,strong)NSString<Optional> * SERVICE_OBJECT_NAMES;
@property (nonatomic,strong)NSString<Optional> * SERVICE_TYPE_NAMES;
@property (nonatomic,strong)NSString<Optional> * RECRUIT_NUM;
@property (nonatomic,strong)NSString<Optional> * ACTIVE_STATE;//活动状态(0:预热中; 1:报名中; 2:进行中; 3:已结束; 4:已结项; 5:已取消)
@property (nonatomic,strong)NSString<Optional> * CURR_RECRUIT_NUM;
@property (nonatomic,strong)NSString<Optional> * AREA_NAME;
@property (nonatomic,strong)NSString<Optional> * RECRUIT_PERCENT;
@property (nonatomic,strong)NSString<Optional> * ADDRESS;
@property (nonatomic,strong)NSString<Optional> * RECRUIT_END_TIME;//报名中的报名结束时间
@property (nonatomic,strong)NSString<Optional> * RECRUIT_START_TIME;//预热中的报名开始时间
@property (nonatomic,strong)NSString<Optional> * START_TIME;
@property (nonatomic,strong)NSString<Optional> * END_TIME;//进行中的报名结束时间
@end


@interface ArticleList : JSONModel

@property (nonatomic,strong)NSString<Optional> * firstCallTime;//当cpage=1时，firstCallTime不传，后台会返回firstCallTime给客户端，之后的cpage!=1时，客户端每次都带上此参数
@property (nonatomic,assign)NSString<Optional> * lastPage;
@property (nonatomic,strong)NSString<Optional> * pageSize;
@property (nonatomic,strong)NSString<Optional> * pageNumber;
@property (nonatomic,assign)NSString<Optional> * firstPage;
@property (nonatomic,strong)NSArray<Optional> * list;       //存放ArticleItem
@property (nonatomic,strong)NSString<Optional> * totalRow;
@property (nonatomic,strong)NSString<Optional> * totalPage;

+ (ArticleList *)ArticleListWithDictionary:(NSDictionary *)json;
@end


#pragma mark- 资讯详情
@interface ArticleDetail : JSONModel
@property (nonatomic,strong)NSString<Optional> * ATTACH_JSONSTR;
@property (nonatomic,strong)NSString<Optional> * COVER_IMG_URL;
@property (nonatomic,strong)NSString<Optional> * PLATFORM_ARTICAL_ID;
@property (nonatomic,strong)NSString<Optional> * ARTICLE_TYPE;//新闻类型：0-普通新闻，1-多图新闻，2-视频新闻 -1推广
@property (nonatomic,strong)NSString<Optional> * ID;
@property (nonatomic,strong)NSString<Optional> * LABEL;
@property (nonatomic,strong)NSString<Optional> * COMMENT_COUNT;
@property (nonatomic,strong)NSString<Optional> * LIKE_COUNT;
@property (nonatomic,strong)NSString<Optional> * PUBLISH_TIME;
@property (nonatomic,strong)NSString<Optional> * TYPE;
@property (nonatomic,strong)NSString<Optional> * TITLE;
@property (nonatomic,strong)NSString<Optional> * READ_COUNT;

@property (nonatomic,strong)NSString<Optional> * ADD_TIME;
@property (nonatomic,strong)NSString<Optional> * AREA_CODE;
@property (nonatomic,strong)NSString<Optional> * AUTHOR;
@property (nonatomic,strong)NSString<Optional> * CONTENT;
@property (nonatomic,strong)NSString<Optional> * CONTENT_ORAGINAL;
@property (nonatomic,strong)NSString<Optional> * C_TYPE;
@property (nonatomic,strong)NSString<Optional> * END_TIME;
@property (nonatomic,strong)NSString<Optional> * H5_URL;
@property (nonatomic,strong)NSString<Optional> * LAST_MODIFY_TIME;
@property (nonatomic,strong)NSString<Optional> * ORAGINAL_IMG_URL;
@property (nonatomic,strong)NSString<Optional> * PC_URL;
@property (nonatomic,strong)NSString<Optional> * PLATFORM_ID;
@property (nonatomic,strong)NSString<Optional> * PUBLISH_STATUS;
@property (nonatomic,strong)NSString<Optional> * RECRUIT_END_TIME;
@property (nonatomic,strong)NSString<Optional> * SOURCE;
@property (nonatomic,strong)NSString<Optional> * START_TIME;
@property (nonatomic,strong)NSString<Optional> * SUMMARY;
@end

#pragma mark- 招募详情
//报名信息
@interface  RecruitEventApply: JSONModel
@property (nonatomic,strong)NSString<Optional> * statu;//0-已提交, 1-待审核, 2-审核通过/待发布, 3-审核不通过, 4-取消审核; 5:服务中; 6:待评价; 7:待确定; 8:已确认
@end

@interface  RecruitServiceRec: JSONModel
@property (nonatomic,strong)NSString<Optional> *serviceStartTime;
@property (nonatomic,strong)NSString<Optional> *serviceEndTime;
@end

//活动服务意愿信息
@interface  RecruitEventDesire: JSONModel
@property (nonatomic,strong)NSString<Optional> * serviceObjectNames;//服务对象
@property (nonatomic,strong)NSString<Optional> * serviceTypeNames;//服务类别
@end

//活动联系人
@interface RecruitEventLink : JSONModel
@property (nonatomic,strong)NSString<Optional> * id;
@property (nonatomic,strong)NSString<Optional> * phone;
@property (nonatomic,strong)NSString<Optional> * address;
@property (nonatomic,strong)NSString<Optional> * email;
@property (nonatomic,strong)NSString<Optional> * name;
@property (nonatomic,strong)NSString<Optional> * qq;
@property (nonatomic,strong)NSString<Optional> * mobile;
@property (nonatomic,strong)NSString<Optional> * wechat;
@end



@interface  RecruitDetail: JSONModel
@property (nonatomic,strong)NSString<Optional> * questionId;

@property (nonatomic,strong)NSString<Optional> * eventPhoto;//活动图片
@property (nonatomic,strong)NSString<Optional> * activeState;//状态
@property (nonatomic,strong)NSString<Optional> * eventName;
@property (nonatomic,strong)NSString<Optional> * eventAddr;
@property (nonatomic,strong)NSString<Optional> * serviceTime;//服务时间
@property (nonatomic,strong)NSString<Optional> * planRecruitNum;//计划人数
@property (nonatomic,strong)NSString<Optional> * hasRecruitNum;//已招人数
@property (nonatomic,strong)NSDictionary<Optional> * eventDesire;//活动服务意愿信息 里面包含服务对象
@property (nonatomic,strong)NSString<Optional> * recruitEndDate;//招募截止时间

@property (nonatomic,strong)NSString<Optional> * eventDesc;//活动详情(json串，列表)
@property (nonatomic,strong)NSArray<Optional> * eventDescs;//活动详情(这里是个正常的字符串)
@property (nonatomic,strong)NSDictionary<Optional> * eventLink;//活动联系人信息
@property (nonatomic,strong)NSArray<Optional> *eventDynamics;//活动动态

@property (nonatomic,strong)NSString<Optional> *eventStartDate;//服务开始时间
@property (nonatomic,strong)NSString<Optional> *eventEndDate;//服务结束时间

@property (nonatomic,strong)NSString<Optional> * applyFlag;//是否报名（bool型）
@property (nonatomic,strong)NSString<Optional> * answerFlag;//是否回答了问卷

@property (nonatomic,strong)NSDictionary<Optional> * serviceRec;//是否开始计时（对象类型，为空则还未开始计时）是否开始计时（根据对象serviceRec的serviceStartTime和serviceEndTime是否有值来判断是否开始计时）
@property (nonatomic,strong)NSDictionary<Optional> * eventApply;//报名信息
@property (nonatomic,strong)NSString<Optional> * recruitRate;//百分比

@property (nonatomic,strong)RecruitEventDesire<Optional> * desire;//对应eventDesire
@property (nonatomic,strong)RecruitEventLink<Optional> * linker;//对应eventLink
@property (nonatomic,strong)RecruitEventApply<Optional> * apply;//对应eventApply
@property (nonatomic,strong)RecruitServiceRec<Optional> * service;//对应serviceRec

+ (RecruitDetail *)RecruitDetailWithDictionary:(NSDictionary *)json;
@end

//招募动态
@interface  RecruitDynamic: JSONModel
@property (nonatomic,strong)NSString<Optional> * title;
@property (nonatomic,strong)NSString<Optional> * content;
@end


//招募职位描述
@interface  RecruitPost: JSONModel
@property (nonatomic,strong)NSString<Optional> * id;
@property (nonatomic,strong)NSString<Optional> * planRecruitNum;
@property (nonatomic,strong)NSString<Optional> * eventId;
@property (nonatomic,strong)NSString<Optional> * postName;
@property (nonatomic,strong)NSString<Optional> * postCondion;
@property (nonatomic,strong)NSString<Optional> * postDesc;
@property (nonatomic,strong)NSString<Optional> * hasRecruitNum;
@end

#pragma mark- 服务记录
@interface  ServiceRecord: JSONModel
@property (nonatomic,strong)NSString<Optional> * serviceStartTime;//服务时间
@property (nonatomic,strong)NSString<Optional> * eventName;
@property (nonatomic,strong)NSString<Optional> * totalServiceTime;//服务时长
@property (nonatomic,strong)NSString<Optional> * statu;//1-待审核, 2-审核通过/待发布, 3-审核不通过, 4-取消审核
@end


#pragma mark- 星级记录
@interface  StarRecord: JSONModel
@property (nonatomic,strong)NSString<Optional> * starDesc;
@property (nonatomic,strong)NSString<Optional> * starLevel;
@property (nonatomic,strong)NSString<Optional> * id;
@end

#pragma mark- 我的报名

@interface  EventDesireModel: JSONModel
@property (nonatomic,strong)NSString<Optional> * id;
@property (nonatomic,strong)NSString<Optional> * serviceObjects;
@property (nonatomic,strong)NSString<Optional> * serviceObjectList;
@property (nonatomic,strong)NSString<Optional> * eventId;
@property (nonatomic,strong)NSString<Optional> * serviceTypeList;
@property (nonatomic,strong)NSString<Optional> * serviceTypes;
@property (nonatomic,strong)NSString<Optional> * serviceObjectNames;
@property (nonatomic,strong)NSString<Optional> * serviceTypeNames;//服务类别
@end


@interface  VolEventModel: JSONModel
@property (nonatomic,strong)NSString<Optional> * activeState;
@property (nonatomic,strong)NSString<Optional> * eventPhoto;
@property (nonatomic,strong)NSString<Optional> * eventName;
@property (nonatomic,strong)NSString<Optional> * eventAddr;
@property (nonatomic,strong)NSString<Optional> * questionId;
@property (nonatomic,strong)NSString<Optional> * planRecruitNum;//招募人数
@property (nonatomic,strong)NSString<Optional> * hasRecruitNum;//已招募人数
@property (nonatomic,strong)NSString<Optional> * eventStartDate;//开始时间
@property (nonatomic,strong)NSString<Optional> * eventEndDate;//结束时间
@property (nonatomic,strong)NSString<Optional> * recruitRate;//进度
@property (nonatomic,strong)NSString<Optional> * recruitEndDate;//报名结束时间
@property (nonatomic,strong)NSString<Optional> * recruitStartDate;//报名开始时间
@property (nonatomic,strong)NSString<Optional> * id;

@property (nonatomic,strong)NSDictionary<Optional> *eventDesire;
@property (nonatomic,strong)EventDesireModel<Optional> *eventDesireObj;


+ (VolEventModel *)VolEventModelWithDictionary:(NSDictionary *)json;
@end

@interface  MyEnrollModel: JSONModel
@property (nonatomic,strong)NSString<Optional> * statu;
@property (nonatomic,strong)NSDictionary<Optional> * volEvent;
@property (nonatomic,strong)VolEventModel<Optional> * volEventObj;

+ (MyEnrollModel *)MyEnrollModelWithDictionary:(NSDictionary *)json;
@end



#pragma mark- 志愿者信息
@interface  VolunteerModel: JSONModel
@property (nonatomic,strong)NSString<Optional> * createUserImg;
@property (nonatomic,strong)NSString<Optional> * createUserName;
@end

#pragma mark- 问卷

@interface  QuestionOption: JSONModel
@property (nonatomic,strong)NSString<Optional> * options;//A
@property (nonatomic,strong)NSString<Optional> * candidateAnswer;//70周年
@property (nonatomic,strong)NSString<Optional> * topicId;
@property (nonatomic,strong)NSString<Optional> * resultId;
@end

@interface  QuestionTopic: JSONModel
@property (nonatomic,strong)NSString<Optional> * topicTypeId;//topicTypeId=1是单选题 其他的为多选
@property (nonatomic,strong)NSString<Optional> * score; //题目总共多少分
@property (nonatomic,strong)NSString<Optional> * topicId;
@property (nonatomic,strong)NSArray<Optional> * results; //存放 选项 QuestionOption
@property (nonatomic,strong)NSString<Optional> * topicName;//2016年是纪念长征胜利多少周年？

+ (QuestionTopic *)QuestionTopicWithDictionary:(NSDictionary *)json;
@end

@interface  QuestionList: JSONModel
@property (nonatomic,strong)NSString<Optional> * minute;
@property (nonatomic,strong)NSString<Optional> * stopTime;

@property (nonatomic,strong)NSArray<Optional> * topics;//存放 QuestionTopic  数组的个数决定了页数
+ (QuestionList *)QuestionListWithDictionary:(NSDictionary *)json;
@end





#pragma mark-

@interface HotKeyItem : JSONModel
@property(nonatomic,strong)NSString<Optional> * ID;
@property(nonatomic,strong)NSString<Optional> * HIT_COUNT;
@property(nonatomic,strong)NSString<Optional> * ADD_TIME;
@property(nonatomic,strong)NSString<Optional> * KEY;
@property(nonatomic,strong)NSString<Optional> * TYPE;
@property(nonatomic,strong)NSString<Optional> * newsFrame;
@end

@interface HotKeys : JSONModel
@property(nonatomic,strong)NSString<Optional> * name;
@property(nonatomic,strong)NSString<Optional> * type;
@property(nonatomic,strong)NSArray<Optional> * hotKeys;
@property(nonatomic,strong)NSArray<Optional> * sonSearchType;//资源里面有 视频 音频 图片 电子书
+ (NSArray *)HotKeysWithDictionary:(NSDictionary *)json;
@end

#pragma mark-
@interface UploadImageModel : JSONModel

@property(nonatomic,strong)NSString<Optional> * remoteUrl;
@property(nonatomic,strong)NSString<Optional> * fileMd5;
@property(nonatomic,strong)NSString<Optional> * oldName;
@property(nonatomic,strong)NSString<Optional> * name;
@property(nonatomic,strong)NSString<Optional> * url;
@end

#pragma mark-  志愿者
@interface VolunteerInfo : JSONModel
@property(nonatomic,strong)NSString<Optional> * id;

@property(nonatomic,strong)NSString<Optional> * orgId;//机构id
@property(nonatomic,strong)NSString<Optional> * areaName;//地区
@property(nonatomic,strong)NSString<Optional> * orgName;//场馆名称

@property(nonatomic,strong)NSString<Optional> * realName;//姓名
@property(nonatomic,strong)NSString<Optional> * identityId;//身份信息主键ID

@property(nonatomic,strong)NSString<Optional> * sex;//性别
@property(nonatomic,strong)NSString<Optional> * birthDay;//出生年月

@property(nonatomic,strong)NSString<Optional> * educationName;//学历
@property(nonatomic,strong)NSString<Optional> * education;//学历id

@property(nonatomic,strong)NSString<Optional> * certifNo;//证件号码
@property(nonatomic,strong)NSString<Optional> * certifType;//证件类型id

@property(nonatomic,strong)NSString<Optional> * otherId;// 其他信息主键ID
@property(nonatomic,strong)NSString<Optional> * workUnit;//工作单位
@property(nonatomic,strong)NSString<Optional> * workAddress;//单位地址

@property(nonatomic,strong)NSString<Optional> * ethnicity;//民族

@property(nonatomic,strong)NSString<Optional> * nativePlace;//籍贯 areacode
@property(nonatomic,strong)NSString<Optional> * nativePlaceName;//籍贯名称

@property(nonatomic,strong)NSString<Optional> * domicile;//户籍所在地
@property(nonatomic,strong)NSString<Optional> * political;//政治面貌
@property(nonatomic,strong)NSString<Optional> * faith;//宗教信仰

@property(nonatomic,strong)NSString<Optional> * postCode;//职称
@property(nonatomic,strong)NSString<Optional> * job;//职务
@property(nonatomic,strong)NSString<Optional> * profession;//职业

@property(nonatomic,strong)NSString<Optional> * school;//毕业学校及专业
@property(nonatomic,strong)NSString<Optional> * livePlace;//居住地址

@property(nonatomic,strong)NSString<Optional> * specialityId;//个人特长信息主键ID
@property(nonatomic,strong)NSString<Optional> * specialitys;//个人特长

@property(nonatomic,strong)NSString<Optional> * hobby;//爱好
@property(nonatomic,strong)NSString<Optional> * contactAddress;//联系地址
@property(nonatomic,strong)NSString<Optional> * zipCode;//邮编
@property(nonatomic,strong)NSString<Optional> * email;//邮箱
@property(nonatomic,strong)NSString<Optional> * telephone;//联系电话

@property(nonatomic,strong)NSString<Optional> * serviceDesireId;//服务意愿信息主键ID
@property(nonatomic,strong)NSArray<Optional> * serviceTypeList;//服务意向数组
@property(nonatomic,strong)NSArray<Optional> * serviceTimeList;//服务时间数组

//注册完成后用到
@property(nonatomic,strong)NSString<Optional> * registerDate;//注册日期
@property(nonatomic,strong)NSString<Optional> * volunteNo;//志愿者编号
@property(nonatomic,strong)NSString<Optional> * verifyRemark;//auditFlag=3时 审核不通过

@property(nonatomic,strong)LibraryModel<Optional> * volunteerLibrary;//修改页面用到

@property(nonatomic,strong)NSArray<Optional> * certifPhotos;//身份证件信息

@end


#pragma mark- 扫描结果
@interface ScanResult : JSONModel
@property(nonatomic,strong)NSString<Optional> * type;
@property(nonatomic,strong)NSString<Optional> * id;
@property(nonatomic,strong)NSString<Optional> * msg;
@end

#pragma mark-  用户
@interface UserInfo : JSONModel

@property(nonatomic,strong)NSString<Optional> * id;
@property(nonatomic,strong)NSString<Optional> * headerIconUrl;
@property(nonatomic,strong)NSString<Optional> * birthday;
@property(nonatomic,strong)NSString<Optional> * nickName;
@property(nonatomic,strong)NSString<Optional> * userName;
@property(nonatomic,strong)NSString<Optional> * trueName;
@property(nonatomic,strong)NSString<Optional> * phoneNum;
@property(nonatomic,strong)NSString<Optional> * sex;
@property(nonatomic,strong)NSString<Optional> * score;
@property(nonatomic,strong)NSString<Optional> * mail;
@end

@interface UserModel : JSONModel

@property(nonatomic,strong)NSString<Optional> * starLevel;
@property(nonatomic,strong)NSString<Optional> * toStayInNum;
@property(nonatomic,strong)NSString<Optional> * identifiedNum;
@property(nonatomic,strong)NSString<Optional> * evaluateNum;
@property(nonatomic,strong)NSString<Optional> * inServiceNum;
@property(nonatomic,strong)NSString<Optional> * totalServiceTime;
@property(nonatomic,strong)NSString<Optional> * eventApplyNum;
@property(nonatomic,strong)NSString<Optional> * auditFlag;
@property(nonatomic,strong)NSString<Optional> * volunteerFlag;
@property(nonatomic,strong)NSString<Optional> * pendingNum;
@property(nonatomic,strong)NSString<Optional> * isIdentityVerified;// 是否实名认证

@property(nonatomic,strong)UserInfo<Optional> * userinfo;
@property(nonatomic,strong)NSDictionary<Optional> * user;
@property(nonatomic,strong)NSString<Optional> * tokenCode;

+ (UserModel *)userModelWithJson:(NSDictionary *)json;
@end

@interface UserInfoManager : NSObject

@property(nonatomic,strong)UserModel* userModel;
@property(nonatomic,assign)BOOL isAlreadyLogin;
@property(nonatomic,strong)VolunteerInfo* volunteer;

+ (UserInfoManager *)sharedInstance;
//登录后保存用户信息
- (void)saveUserinfo:(NSDictionary *)jsonDic;
//退出后删除用户信息
- (void)deleteUserInfo;
//用户是否已经登录 如果登录直接显示登录状态
- (BOOL)isAlreadyLogin;

- (void)getUserCenterInfo:(void (^)(BOOL finished))success;
@end
