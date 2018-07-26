//
//  LibraryViewController.m
//  CultureAssistant
//


#import "LibraryViewController.h"

@interface LibraryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSArray* dataArray;
@property(nonatomic,strong)LibraryModel* library;
@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
    
    if (self.cityModel) {
        _titleLabel.text = self.cityModel.AREA_NAME;
        if ([self.cityModel.AREA_NAME isEqualToString:@"全国"]) {
            [self getOrganization:@"" areaName:@""];
        }else{
            [self getOrganization:self.cityModel.AREA_CODE areaName:@""];
        }
    }
}

- (void)getOrganization:(NSString *)areaCode areaName:(NSString *)areaName{
    if (areaCode.length <= 0) areaCode = @"";
    if (areaName.length <= 0) areaName = @"";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetAPIClient GET:APIGetOrgs parameters:[RequestParameters getOrgsByAreaCode:areaCode areaName:areaName] success:^(id JSON, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSArray class]]) {
            self.dataArray = [LibraryModel arrayOfModelsFromDictionaries:(NSArray *)model.result];
            [self.tableView reloadData];
        }
        
    } failure:^(id JSON, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)createSubViews
{
    UIView* maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.3];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMaskView:)]];
    
    
    UIView* whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 6;
    whiteView.layer.masksToBounds = YES;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.view);
        make.height.equalTo(430);
        make.left.equalTo(20);
        make.right.equalTo(self.view.right).offset(-20);
    }];
    
    UIView* colorView = [UIView new];
    colorView.backgroundColor = BaseColor;
    [whiteView addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(60);
        make.top.left.right.equalTo(whiteView);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"黑龙江分馆支馆";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [colorView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(colorView);
    }];
    
    UIButton* closeBtn = [UIButton new];
    [closeBtn setImage:[[UIImage imageNamed:@"circle_close"] imageWithColor:[UIColor whiteColor]]forState:UIControlStateNormal];
    [colorView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.height.equalTo(44);
        make.top.right.equalTo(colorView);
    }];
    [closeBtn addTarget:self action:@selector(onTapCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* sureBtn = [UIButton new];
    sureBtn.backgroundColor = BaseColor;
    sureBtn.layer.cornerRadius = 20;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [whiteView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(40);
        make.bottom.equalTo(whiteView.bottom).offset(-10);
        make.left.equalTo(70);
        make.right.equalTo(whiteView.right).offset(-70);
    }];
    [sureBtn addTarget:self action:@selector(onTapSureButton:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[LibraryCell class] forCellReuseIdentifier:@"LibraryCell"];
    [whiteView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(colorView.bottom);
        make.left.right.equalTo(whiteView);
        make.bottom.equalTo(sureBtn.top);
    }];
    _tableView.tableFooterView=[[UIView alloc]init];
}

- (void)onTapMaskView:(UITapGestureRecognizer *)gesture{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapCloseBtn:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapSureButton:(id)sender{
    if (self.library)
    {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        
        [self setVisitHistory:self.library.code areaName:self.library.areaName];
        
        
        NSArray * cityList = [userdefaults objectForKey:LocationHistoryArea];
        NSMutableArray * _mArr = [NSMutableArray arrayWithArray:cityList];
        if ([cityList isKindOfClass:[NSArray class]])
        {
            for (NSArray * cityItem in _mArr)
            {
                NSString * cityCode = cityItem[0];
                NSString * cityName = cityItem[1];
                NSString * cityType = cityItem[2];
                if ([cityType isEqualToString:LibraryModelKey] && [cityCode isEqualToString:self.library.id]&&[cityName isEqualToString:self.library.name]) {
                    [_mArr removeObject:cityItem];
                    break;
                }
            }
        }
        [_mArr insertObject:@[self.library.id,self.library.name,LibraryModelKey,self.library.areaName] atIndex:0];
        
        NSMutableArray * historyList = [NSMutableArray array];
        for (int i=0; i<_mArr.count; i++) {
            if (i<8) {
                [historyList addObject:_mArr[i]];
            }
        }
        [userdefaults setObject:historyList forKey:LocationHistoryArea];
        //添加为定位
        [userdefaults setObject:@[self.library.id,self.library.name,LibraryModelKey,self.library.areaName] forKey:LocationSelectedArea];
        [userdefaults synchronize];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:Change_City_Library object:nil userInfo:@{SelectedLibraryKey:self.library}];
    }

    [self dismissViewControllerAnimated:YES completion:^{
        if (self.selectedLibraryFinished && self.library) {
            self.selectedLibraryFinished();
        }
    }];
}

#pragma mark-
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryCell" forIndexPath:indexPath];
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    }
    LibraryModel* model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.fullName;
    cell.choosed = NO;
    if ([model.code isEqualToString:self.library.code]) {
        cell.choosed = YES;
    }
    
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:LocationSelectedArea];
    if (array.count > 2) {
        NSString* string = array[2];
        if ([string isEqualToString:LibraryModelKey]) {
            if ([model.name isEqualToString:array[1]]) {
                cell.choosed = YES;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.library = self.dataArray[indexPath.row];
    
    NSArray* array = [tableView visibleCells];
    for (LibraryCell* cell in array) {
        cell.choosed = NO;
    }
    
    LibraryCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.choosed = YES;
}

#pragma mark-
//code--地区或组织机构code 传省级名称  不管你选的是省还是分馆
- (void)setVisitHistory:(NSString *)code areaName:(NSString *)areaName{
    if (code.length <= 0 || areaName.length <= 0) return;
    
    [AFNetAPIClient POST:APISetVisitHistory parameters:[RequestParameters setVisitHistory:code areaName:areaName] showLoading:NO success:^(id JSON, NSError *error){
        
    }failure:^(id JSON, NSError *error){
        
    }];
}
@end
