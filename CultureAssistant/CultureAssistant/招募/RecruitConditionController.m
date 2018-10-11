//
//  RecruitConditionController.m
//  CultureAssistant
//


#import "RecruitConditionController.h"

@interface RecruitConditionController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableView;

@property(nonatomic,strong)NSArray* sectionArray;
@property(nonatomic,strong)NSArray* serviceTypes;
@property(nonatomic,strong)NSArray* serviceObjects;
@property(nonatomic,strong)NSArray* recruitNums;

//传递给上一页进行查询
@property(nonatomic,strong)NSString* serviceTypeID;
@property(nonatomic,strong)NSString* serviceObjectID;
@property(nonatomic,strong)NSString* recruitNumID;
@end

@implementation RecruitConditionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"招募查询";
    
    UIButton* btn = [UIButton new];
    btn.backgroundColor = BaseColor;
    [btn setTitle:@"查询" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(44);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(-HOME_INDICATOR_HEIGHT);
    }];
    [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.serviceTypeID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceType];
    self.serviceObjectID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceObject];
    self.recruitNumID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryRecruitNum];
    
    self.sectionArray = @[@"服务类别:",@"服务对象:",@"招募人数:"];
    self.serviceTypes = [DeviceHelper sharedInstance].serviceTypes;
    self.serviceObjects = [DeviceHelper sharedInstance].serviceObjects;
    self.recruitNums = [DeviceHelper sharedInstance].recruitNums;

    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[RecruitConditonCell class] forCellReuseIdentifier:@"RecruitConditonCell"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(btn.top);
    }];
}

- (void)onTapButton:(id)sender{
    NSString* serviceType = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceType];
    NSString* serviceObject = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceObject];
    NSString* recruitNum = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryRecruitNum];
    
    if (![serviceType isEqualToString:self.serviceTypeID] ||
        ![serviceObject isEqualToString:self.serviceObjectID] ||
        ![recruitNum isEqualToString:self.recruitNumID]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.serviceTypeID.length>0?self.serviceTypeID:@""  forKey:RecruitQueryServiceType];
        [[NSUserDefaults standardUserDefaults] setObject:self.serviceObjectID.length>0?self.serviceObjectID:@"" forKey:RecruitQueryServiceObject];
        [[NSUserDefaults standardUserDefaults] setObject:self.recruitNumID.length>0?self.recruitNumID:@"" forKey:RecruitQueryRecruitNum];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Start_Query_Recruit object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RecruitConditonHead* header = [[RecruitConditonHead alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    header.titleLabel.text = self.sectionArray[section];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = 50;
    CGRect rect;
    InitDictData * dictData;
    switch (indexPath.section) {
        case 0:
            dictData = [self.serviceTypes lastObject];
            
            rect = CGRectFromString(dictData.frameSize);
            height = rect.origin.y + rect.size.height + 10;
            break;
        case 1:
            dictData = [self.serviceObjects lastObject];
            
            rect = CGRectFromString(dictData.frameSize);
            height = rect.origin.y + rect.size.height + 10;
            break;
        case 2:
            dictData = [self.recruitNums lastObject];
            
            rect = CGRectFromString(dictData.frameSize);
            height = rect.origin.y + rect.size.height + 10;
            break;
            
        default:
            break;
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecruitConditonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RecruitConditonCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    typeof(self) __weak wself = self;
    cell.selecteInitData = ^(NSString* dataId,NSString* dataType){
        [wself selectedCondition:dataId type:dataType];
    };
    switch (indexPath.section) {
        case 0:
            cell.dataArray = self.serviceTypes;
            break;
        case 1:
            cell.dataArray = self.serviceObjects;
            break;
        case 2:
            cell.dataArray = self.recruitNums;
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark-
- (void)selectedCondition:(NSString *)dataId type:(NSString *)dataType{
    
    if ([dataType isEqualToString:RecruitQueryServiceType]) {
        self.serviceTypeID = dataId;
    }else if ([dataType isEqualToString:RecruitQueryServiceObject]){
        self.serviceObjectID = dataId;
    }else if ([dataType isEqualToString:RecruitQueryRecruitNum]){
        self.recruitNumID = dataId;
    }
}

@end
