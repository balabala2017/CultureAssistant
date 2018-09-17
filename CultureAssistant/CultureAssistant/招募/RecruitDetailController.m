//
//  RecruitDetailController.m
//  CultureAssistant
//


#import "RecruitDetailController.h"
#import "RecruitPostDescController.h"
#import "RecruitDetailTopView.h"
#import "RecruitDetailBottomView.h"
#import "QuestionViewController.h"

@interface RecruitDetailController ()
@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,strong)RecruitDetailTopView* topView;
@property(nonatomic,strong)RecruitDetailBottomView* bottomView;

@property(nonatomic,strong)RecruitDetail* detail;

@property(nonatomic,strong)UIView* btnView;
@property(nonatomic,strong)UIButton* signBtn;
@property(nonatomic,strong)NSString* serviceId;//服务记录ID可在 活动计时开始接口或招募活动详情接口中获取

@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)int times;
@end

@implementation RecruitDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
    
    if (self.eventId) {
        [self getEventDetail];
        [self.bottomView getEventApplys:self.eventId];
        [self.bottomView getEventDynamics:self.eventId];
    }
}

- (void)onTapBackBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)onTapButton:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"填写问卷"]) {
        QuestionViewController* vc = [QuestionViewController new];
        vc.questionId = self.detail.questionId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([button.titleLabel.text isEqualToString:@"我要报名"]){
        RecruitPostDescController* vc = [RecruitPostDescController new];
        vc.eventId = self.eventId;
        vc.enrollSucessHandler = ^{
            self.signBtn.enabled = NO;
            [self.signBtn setTitle:@"待审核" forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([button.titleLabel.text isEqualToString:@"开始计时"]){
        [self signInEvent:self.eventId];
        _times = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        
    }
    
    if (_times > 0){
        [self stopTimer];
        [self signOutEvent:self.serviceId];
        [self.signBtn setTitle:@"开始计时" forState:UIControlStateNormal];
    }
}

- (void)onTimer
{
    ++_times;
    int h = 0;
    int m = 0;
    int s = 0;
    h = _times/3600;
    m = _times%3600/60;
    s = _times - h*3600 - m*60;
    
    NSString* string = [NSString stringWithFormat:@"已开始%d时%d分%d秒",h,m,s];
    [self.signBtn setTitle:string forState:UIControlStateNormal];
}

- (void)stopTimer
{
    if(_timer != nil){
        [_timer invalidate];
        _timer = nil;
        _times = 0;
    }
}


/*
 招募详情逻辑 接口：/api/braille[表情]olEvent/getEventBy
 获取招募详情 字段applyFlag 是否报名（bool型）
 字段serviceRec 是否开始计时（对象类型，为空则还未开始计时）
 是否开始计时（根据对象serviceRec的serviceStartTime和serviceEndTime是否有值来判断是否开始计时）
 逻辑：
 1、未报名且活动未开始=》可报名
 2、未报名且活动已开始=》不可报名
 3、已报名且活动开始未结束且未开始计时=》点击开始计时
 4、已报名且活动开始未结束且已开始计时=》点击结束计时
 5、已报名且活动结束且计时结束=》判断是否需要问卷调查
 
 
  字段activeState 活动状态
 活动状态(0:预热中; 1:报名中; 2:进行中; 3:已结束; 4:已结项; 5:已取消)
 
 1、预热中、已结束、已结项的活动，没有我要报名按钮。
 2、预热中指还未开始报名的活动，进行中指开始活动报名的，但是未到活动报名结束日期的活动，已结束指已经过了活动结束日期的活动，已结项指已经过了活动结束日期，并且服务时长、问卷调查等后续工作已经完成的活动。
 3、进行中的活动，需要先报名，报名后显示待审核状态，后台审核通过后，显示报名成功状态，报名成功的志愿者到活动开始日期时，按钮变成活动开始按钮，提示活动服务时长开始计时，此时按钮变成活动结束按钮，点击后，提示活动服务时长停止计时，等待管理人员确认。
 4、进行中的活动，当报名人数已满时，显示已报满状态。
 5、已结束的活动，已报名的人员进入时，如果后台设置了需要填写调查问卷，那么按钮变成填写调查问卷按钮，调查问卷填写完成后，活动详情页面，显示待确认的服务时长，如果后台没有设置调查问卷，直接显示待确认的服务时长。已填写完问卷调查，进入时显示待确认的服务时长。
 6、已结项的活动，已报名人员进入时，显示确认的服务时长。
 
 */


- (void)getEventDetail{
    if (self.eventId.length <= 0) return;
    
    [AFNetAPIClient GET:APIGetEventDetail parameters:[RequestParameters getEventsById:self.eventId] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]]) {
            self.detail = [RecruitDetail RecruitDetailWithDictionary:(NSDictionary *)model.result];
            self.topView.recruitDetail = self.detail;
            self.bottomView.recruitDetail = self.detail;

            //activeState 活动状态(0:预热中; 1:报名中; 2:进行中; 3:已结束; 4:已结项; 5:已取消)
            //预热中、已结束、已结项的活动，没有我要报名按钮。

            switch ([self.detail.activeState integerValue])
            {
                case 0://预热中  不显示
                case 5://已取消
                {
                    self.signBtn.hidden = YES;
                    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make){
                        make.bottom.equalTo(self.view);
                    }];
                }
                    break;
                case 1://报名中
                {
                    //eventApply中的statu   0-已提交, 1-待审核, 2-审核通过/待发布, 3-审核不通过, 4-取消审核; 5:服务中; 6:待评价; 7:待确定; 8:已确认
                    
                   // 1.未报名：显示“我要报名",点击跳转岗位列表；
                    //2.已报名未审核，显示“待审核”，不能点击；
                    //3.已报名已审核，显示“待参加”，不能点击

                    if (![self.detail.applyFlag boolValue]) {
                        if ([self.detail.planRecruitNum intValue] - [self.detail.hasRecruitNum intValue] > 0) {
                            [self.signBtn setTitle:@"我要报名" forState:UIControlStateNormal];
                        }else{
                            self.signBtn.enabled = NO;
                            [self.signBtn setTitle:@"已报满" forState:UIControlStateNormal];
                        }
                    }
                    else
                    {
                        self.signBtn.enabled = NO;
                        if (self.detail.apply)
                        {
                            switch ([self.detail.apply.statu intValue]) {
                                case 0:
                                    [self.signBtn setTitle:@"已提交" forState:UIControlStateNormal];
                                    break;
                                case 1:
                                    [self.signBtn setTitle:@"待审核" forState:UIControlStateNormal];
                                    break;
                                case 2:
                                    [self.signBtn setTitle:@"待参加" forState:UIControlStateNormal];
                                    break;
                                case 3:
                                    [self.signBtn setTitle:@"审核不通过" forState:UIControlStateNormal];
                                    break;
                                case 4:
                                    [self.signBtn setTitle:@"取消审核" forState:UIControlStateNormal];
                                    break;
                                case 5:
                                    [self.signBtn setTitle:@"服务中" forState:UIControlStateNormal];
                                    break;
                                case 6:
                                    [self.signBtn setTitle:@"待评价" forState:UIControlStateNormal];
                                    break;
                                case 7:
                                    [self.signBtn setTitle:@"待确定" forState:UIControlStateNormal];
                                    break;
                                case 8:
                                    [self.signBtn setTitle:@"已确认" forState:UIControlStateNormal];
                                    break;
                                    
                                default:
                                    break;
                            }
                        }
                    }
                }
                    break;
                case 2://进行中
                {
                    //1.未开始：显示“开始计时”，点击开始计时；
                    //2.正在计时：显示“已开始xx小时xx分xx秒”，点击结束计时，点击后恢复到未开始状态
                
                    if ( [self.detail.applyFlag boolValue] && self.detail.apply){
                        [self.signBtn setTitle:@"开始计时" forState:UIControlStateNormal];
                    }else{
                        self.btnView.hidden = YES;
                        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make){
                            make.bottom.equalTo(self.view);
                        }];
                    }
                }
                    break;
                    case 3://已结束
                {
                    //1.如果已参加服务且有问卷调查并未参与问卷调查：显示“参与问卷调查”，点击跳转到问卷调查
                    //2.如果已参加服务且有问卷调查且已参与问卷调查：显示“服务时长xx时xx分”，不能点击
                    //3.如果已参加且没有问卷调查：显示“服务时长xx时xx分”，不能点击
                    //4.如果未参加服务或未报名，不显示按钮
                    
                    if (self.detail.service && self.detail.questionId.length > 0 && [self.detail.answerFlag boolValue] == false)
                    {
                        [self.signBtn setTitle:@"填写问卷" forState:UIControlStateNormal];
                    }
                    else if((self.detail.service && [self.detail.answerFlag boolValue] == true)||(self.detail.service && self.detail.questionId.length <= 0))
                    {
                        self.signBtn.enabled = NO;
                        
                        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        
                        NSDate* startDate = [dateFormatter dateFromString:self.detail.service.serviceStartTime];
                        NSDate* endDate = [dateFormatter dateFromString:self.detail.service.serviceEndTime];
                        
                        NSTimeInterval begin = [startDate timeIntervalSince1970];
                        NSTimeInterval end = [endDate timeIntervalSince1970];
                        
                        int interval = end - begin;
                        
                        int h = 0;
                        int m = 0;
                        int s = 0;
                        h = interval/3600;
                        m = interval%3600/60;
                        s = interval - h*3600 - m*60;
                        
                        NSString* string = [NSString stringWithFormat:@"服务时长%d时%d分%d秒",h,m,s];
                        [self.signBtn setTitle:string forState:UIControlStateNormal];
                        
                    }else{
                        self.btnView.hidden = YES;
                        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make){
                            make.bottom.equalTo(self.view);
                        }];
                    }
                }
                    break;
                case 4://已结项
                {
                    //1.有参加服务：显示“服务时长xx时xx分”，不能点击
                    //2.没有参加服务：不显示按钮
                    if((self.detail.service && [self.detail.answerFlag boolValue] == true)||(self.detail.service && self.detail.questionId.length <= 0))
                    {
                        self.signBtn.enabled = NO;
                        
                        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        
                        NSDate* startDate = [dateFormatter dateFromString:self.detail.service.serviceStartTime];
                        NSDate* endDate = [dateFormatter dateFromString:self.detail.service.serviceEndTime];
                        
                        NSTimeInterval begin = [startDate timeIntervalSince1970];
                        NSTimeInterval end = [endDate timeIntervalSince1970];
                        
                        int interval = end - begin;
                        
                        int h = 0;
                        int m = 0;
                        int s = 0;
                        h = interval/3600;
                        m = interval%3600/60;
                        s = interval - h*3600 - m*60;
                        
                        NSString* string = [NSString stringWithFormat:@"服务时长%d时%d分%d秒",h,m,s];
                        [self.signBtn setTitle:string forState:UIControlStateNormal];
                        
                    }else{
                        self.btnView.hidden = YES;
                        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make){
                            make.bottom.equalTo(self.view);
                        }];
                    }
                }
                    break;
                default:
                    break;
            }
            
            
        }
    }failure:^(id JSON, NSError *error){
        
    }];
}

//活动计时开始
- (void)signInEvent:(NSString *)eventId{
    if (eventId.length <= 0) return;
    
    [AFNetAPIClient GET:APISignInEvent parameters:[RequestParameters getEventsById:eventId] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code isEqualToString:@"200"]) {
            self.serviceId = [NSString stringWithFormat:@"%@",model.result];
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
        
    }failure:^(id JSON, NSError *error){
        
    }];
}

//服务记录ID可在 活动计时开始接口或招募活动详情接口中获取
- (void)signOutEvent:(NSString *)recId{
    if (recId.length <= 0) return;
    
    [AFNetAPIClient GET:APISignOutEvent parameters:[RequestParameters signOutEvent:recId] success:^(id JSON, NSError *error){
        
    }failure:^(id JSON, NSError *error){
        
    }];
}


#pragma mark-
- (void)createSubViews{
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(-20);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-40);
    }];
    
    _topView = [RecruitDetailTopView new];
    [_scrollView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.equalTo(0);
        make.width.equalTo(SCREENWIDTH);
        make.height.equalTo(200+SCREENWIDTH*564/750.f);
    }];
    WeakObj(self);
    _bottomView = [RecruitDetailBottomView new];
    [_scrollView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(wself.topView.bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(SCREENHEIGHT-110);
    }];
    
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(wself.bottomView);
    }];
    

    UIImageView* barView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_black"]];
    [self.view addSubview:barView];
    [barView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(NAVIGATION_BAR_HEIGHT);
    }];
    
    UIButton* backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(STATUS_BAR_HEIGHT);
        make.left.equalTo(20);
        make.width.height.equalTo(44);
    }];
    [backBtn addTarget:self action:@selector(onTapBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _btnView = [UIView new];
    _btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_btnView];
    [_btnView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(44+HOME_INDICATOR_HEIGHT);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    _signBtn = [UIButton new];
    _signBtn.backgroundColor = BaseColor;
    [_signBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    [_signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnView addSubview:_signBtn];
    [_signBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(44);
        make.top.left.right.equalTo(self.btnView);
    }];
    [_signBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

@end
