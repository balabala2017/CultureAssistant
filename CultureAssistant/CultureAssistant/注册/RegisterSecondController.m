//
//  RegisterSecondController.m
//  CultureAssistant
//


#import "RegisterSecondController.h"
#import "RegisterThirdController.h"

@interface RegisterSecondController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;

@property(nonatomic,strong)NSArray* sectionArray;
@property(nonatomic,strong)NSArray* titleArray1;
@property(nonatomic,strong)NSArray* titleArray2;

@property(nonatomic,strong)NSDictionary* titleDic1;
@property(nonatomic,strong)NSDictionary* titleDic2;

@property(nonatomic,strong)NSMutableArray* serviceTimes;
@property(nonatomic,strong)NSMutableArray* serviceTypes;

@property(nonatomic,strong)UIButton* nextBtn;

@property(nonatomic,strong)NSMutableDictionary* dictionary;//传递参数
@end

@implementation RegisterSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务意向与服务时间";
    
    self.serviceTimes = [NSMutableArray array];
    self.serviceTypes = [NSMutableArray array];

    
    VolunteerInfo* volunteer = [UserInfoManager sharedInstance].volunteer;
    [self.serviceTimes addObjectsFromArray:volunteer.serviceTimeList];
    [self.serviceTypes addObjectsFromArray:volunteer.serviceTypeList];
    
    self.sectionArray = @[@"———— 服务意向 ————",@"———— 服务时间 ————"];
    
    self.titleArray1 = @[@"盲人阅览室服务",//369
                         @"盲人读物邮寄、借送服务",//370
                         @"盲人读者到馆接送服务",//371
                         @"为盲人读书、讲电影等文化服务",//372
                         @"盲人公益文化活动和项目服务",//373
                         @"盲人读物出版服务",//374
                         @"盲人有声读物制作服务",//375
                         @"大字本读物出版服务",//376
                         @"文案撰写、整理及会务服务",//377
                         @"国际资料搜集整理及翻译服务",//378
                         @"盲文、电脑、音乐等教育培训服务",//379
                         @"其他服务"];//380
    
    
    self.titleDic1 = @{@"盲人阅览室服务":@"369",
                       @"盲人读物邮寄、借送服务":@"370",
                       @"盲人读者到馆接送服务":@"371",
                       @"为盲人读书、讲电影等文化服务":@"372",
                       @"盲人公益文化活动和项目服务":@"373",
                       @"盲人读物出版服务":@"374",
                       @"盲人有声读物制作服务":@"375",
                       @"大字本读物出版服务":@"376",
                       @"文案撰写、整理及会务服务":@"377",
                       @"国际资料搜集整理及翻译服务":@"378",
                       @"盲文、电脑、音乐等教育培训服务":@"379",
                       @"其他服务":@"380"
                       };
    
    //志愿者注册  服务时间 对应ID  "星期一","星期二","星期三","星期四","星期五","星期六","星期日","节假日"  D1~D7 节假日是D0
    self.titleArray2 = @[@"星期一",
                         @"星期二",
                         @"星期三",
                         @"星期四",
                         @"星期五",
                         @"星期六",
                         @"星期日",
                         @"节假日"];
    
    self.titleDic2 = @{@"星期一":@"D1",
                       @"星期二":@"D2",
                       @"星期三":@"D3",
                       @"星期四":@"D4",
                       @"星期五":@"D5",
                       @"星期六":@"D6",
                       @"星期日":@"D7",
                       @"节假日":@"D0"
                       };
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[RegisterBoxCell class] forCellReuseIdentifier:@"RegisterBoxCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RegisterButtonCell"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    self.nextBtn.backgroundColor = BaseColor;
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(onNextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.paramDic) {
        self.dictionary = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
    }else{
        self.dictionary = [NSMutableDictionary dictionary];
    }
    
}

#pragma mark-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RegisterTableHead* header = [[RegisterTableHead alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 22)];
    header.titleLable.text = self.sectionArray[section];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleArray1.count;
    }else{
        return self.titleArray2.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == self.titleArray2.count) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterButtonCell" forIndexPath:indexPath];
        [cell addSubview:self.nextBtn];
        return cell;
    }else{
        RegisterBoxCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterBoxCell" forIndexPath:indexPath];
        [cell.boxBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.section == 0) {
            cell.boxBtn.tag = 100+indexPath.row;
            cell.titleLabel.text = self.titleArray1[indexPath.row];
            
            NSString* string = [self.titleDic1 objectForKey:cell.titleLabel.text];
            if ([self.serviceTypes containsObject:string]) {
                cell.boxBtn.selected = YES;
            }else{
                cell.boxBtn.selected = NO;
            }
            
        }else{
            cell.boxBtn.tag = 200+indexPath.row;
            cell.titleLabel.text = self.titleArray2[indexPath.row];
            
            NSString* string = [self.titleDic2 objectForKey:cell.titleLabel.text];
            if ([self.serviceTimes containsObject:string]) {
                cell.boxBtn.selected = YES;
            }else{
                cell.boxBtn.selected = NO;
            }
            
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == self.titleArray2.count) return;
    
    //审核状态不可修改
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 1) {
        return ;
    }
        
    RegisterBoxCell* cell = (RegisterBoxCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.boxBtn.selected = !cell.boxBtn.selected;
    
    NSString* keyStr;
    NSString* valueStr;
    if (indexPath.section == 0) {
        keyStr = self.titleArray1[indexPath.row];
        valueStr = [self.titleDic1 objectForKey:keyStr];
        if (cell.boxBtn.selected) {
            if (![self.serviceTypes containsObject:valueStr]) {
                [self.serviceTypes addObject:valueStr];
            }
        }else{
            if ([self.serviceTypes containsObject:valueStr]) {
                [self.serviceTypes removeObject:valueStr];
            }
        }
    }else{
        keyStr = self.titleArray2[indexPath.row];
        valueStr = [self.titleDic2 objectForKey:keyStr];
        if (cell.boxBtn.selected) {
            if (![self.serviceTimes containsObject:valueStr]) {
                [self.serviceTimes addObject:valueStr];
            }
        }else{
            if ([self.serviceTimes containsObject:valueStr]) {
                [self.serviceTimes removeObject:valueStr];
            }
        }
    }
}

- (void)onTapButton:(UIButton *)button{
    
    //审核状态不可修改
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 1) {
        return ;
    }
    
    button.selected = !button.selected;
    
    NSString* keyStr;
    NSString* valueStr;
    if (button.tag <200) {
        keyStr = self.titleArray1[button.tag-100];
        valueStr = [self.titleDic1 objectForKey:keyStr];
        if (button.selected) {
            if (![self.serviceTypes containsObject:valueStr]) {
                [self.serviceTypes addObject:valueStr];
            }
        }else{
            if ([self.serviceTypes containsObject:valueStr]) {
                [self.serviceTypes removeObject:valueStr];
            }
        }
    }else{
        keyStr = self.titleArray2[button.tag-200];
        valueStr = [self.titleDic2 objectForKey:keyStr];
        if (button.selected) {
            if (![self.serviceTimes containsObject:valueStr]) {
                [self.serviceTimes addObject:valueStr];
            }
        }else{
            if ([self.serviceTimes containsObject:valueStr]) {
                [self.serviceTimes removeObject:valueStr];
            }
        }
    }
}

#pragma mark-
- (void)onNextStepAction:(id)sender{
    
    NSString* serviceType = @"";
    for (NSInteger i = 0 ; i < self.serviceTypes.count ; i++) {
        NSString* str = self.serviceTypes[i];
        if (i == 0) {
            serviceType = str;
        }else{
            serviceType = [[serviceType stringByAppendingString:@","] stringByAppendingString:str];
        }
    }
    
    [self.dictionary setObject:serviceType forKey:@"serviceTypes"];
    
    NSString* serviceTime = @"";
    for (NSInteger i = 0 ; i < self.serviceTimes.count ; i++) {
        NSString* str = self.serviceTimes[i];
        if (i == 0) {
            serviceTime = str;
        }else{
            serviceTime = [[serviceTime stringByAppendingString:@","] stringByAppendingString:str];
        }
    }
     [self.dictionary setObject:serviceTime forKey:@"serviceTimes"];
    
    RegisterThirdController* vc = [RegisterThirdController new];
    vc.paramDic = self.dictionary;
    vc.modifyVolunteer = self.modifyVolunteer;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
