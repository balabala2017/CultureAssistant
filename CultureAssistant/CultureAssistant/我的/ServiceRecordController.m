//
//  ServiceRecordController.m
//  CultureAssistant
//


#import "ServiceRecordController.h"

@interface ServiceRecordController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)NSInteger cpage;

@property(nonatomic,strong)UILabel * totalServiceLabel;
@property(nonatomic,strong)NSString * totalServiceTime;//总服务时长

@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation ServiceRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务记录";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = Colorebebeb;
    [self createSubViews];

    
    self.cpage = 1;
    self.dataArray = [NSMutableArray array];
    
    [self getServicRecord];
}

- (void)getServicRecord{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:APIGetUserServiceRec parameters:[RequestParameters requesetWithPage:[NSString stringWithFormat:@"%ld",(long)self.cpage] pageSize:PAGESIZE] success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]]) {
            wself.totalServiceLabel.text = [NSString stringWithFormat:@"总服务时长:%@小时(已审核)",[(NSDictionary *)model.result objectForKey:@"totalServiceTime"]];
            
            NSDictionary* dic = [(NSDictionary *)model.result objectForKey:@"page"];
            NSArray* array = dic[@"result"];
            if ([array isKindOfClass:[NSArray class]]) {
                array = [ServiceRecord arrayOfModelsFromDictionaries:array];
                [self.dataArray addObjectsFromArray:array];
               
                if (self.dataArray.count == [dic[@"totalCount"] integerValue]) {
                     [wself.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                     [wself.tableView.mj_footer endRefreshing];
                }
                 [wself.tableView reloadData];
            }
        }
        [wself.tableView.mj_header endRefreshing];
        
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD MBProgressHUDWithView:self.view Str:JSON];
    }];
}

#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceRecordCell" forIndexPath:indexPath];
    cell.serviceRecord = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark-

- (void)createSubViews{
    UIView* colorView = [UIView new];
    colorView.backgroundColor = BaseColor;
    [self.view addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(125-64);
    }];
    
    UIView* topView = [UIView new];
    topView.layer.cornerRadius = 8;
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.equalTo(10);
        make.right.equalTo(self.view.right).offset(-10);
        make.height.equalTo(90);
    }];
    {
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock_icon"]];
        [topView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(35);
            make.centerY.equalTo(topView);
        }];
        
        _totalServiceLabel = [UILabel new];
        if (SCREENWIDTH < 375) {
            _totalServiceLabel.font = [UIFont systemFontOfSize:15];
        }else{
            _totalServiceLabel.font = [UIFont systemFontOfSize:17];
        }
        _totalServiceLabel.textColor = BaseColor;
        _totalServiceLabel.text = @"总服务时长: 0小时(已审核)";
        [topView addSubview:_totalServiceLabel];
        [_totalServiceLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(topView);
            make.left.equalTo(imgView.right).offset(15);
        }];
    }
    
    UILabel* label = [UILabel new];
    label.text = @"服务记录";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    [self.view addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView.bottom).offset(12);
        make.left.equalTo(10);
    }];
    
    
    UIView* whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.bottom).offset(12);
        make.left.equalTo(10);
        make.right.equalTo(self.view.right).offset(-10);
        make.bottom.equalTo(self.view.bottom).offset(-10);
    }];
    
    ServiceRecordHead* head = [ServiceRecordHead new];
    [whiteView addSubview:head];
    [head mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(whiteView);
        make.height.equalTo(34);
    }];
    
    
    _tableView = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[ServiceRecordCell class] forCellReuseIdentifier:@"ServiceRecordCell"];
    [whiteView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(whiteView);
        make.top.equalTo(head.bottom);
    }];
    
    typeof(self) __weak wself = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself.tableView.mj_header endRefreshing];
        
        wself.cpage = 1;
        [wself.dataArray removeAllObjects];
        [wself getServicRecord];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{
        [wself.tableView.mj_footer endRefreshing];
        
        wself.cpage ++;
        [wself getServicRecord];
    }];

}

@end
