//
//  RecruitListViewController.m
//  CultureAssistant
//


#import "RecruitListViewController.h"
#import "RecruitDetailController.h"



@interface RecruitListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,assign)NSInteger cpage;
@property(nonatomic,strong)NSMutableArray* dataArray;

@property(nonatomic,strong)NSString* serviceTypeID;
@property(nonatomic,strong)NSString* serviceObjectID;
@property(nonatomic,strong)NSString* recruitNumID;

@property(nonatomic,strong)BlankContentView* blankView;

@property(nonatomic,strong)NSString* areaCode;
@property(nonatomic,strong)NSString* orgId;
@end

@implementation RecruitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[RecruitViewCell class] forCellWithReuseIdentifier:@"RecruitViewCell"];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    typeof(self) __weak wself = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.cpage = 1;
        [wself.dataArray removeAllObjects];
        [wself getEventsList];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        wself.cpage ++;
        [wself getEventsList];
    }];

    self.blankView = [BlankContentView new];
    [_collectionView addSubview:self.blankView];
    [self.blankView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(wself.collectionView);
        make.width.height.equalTo(300);
    }];
    self.blankView.hidden = YES;

    
    self.serviceTypeID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceType];
    self.serviceObjectID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceObject];
    self.recruitNumID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryRecruitNum];
    
    self.areaCode = @"";
    self.orgId = @"";
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:LocationSelectedArea];
    if (array.count>2) {
        NSString* string = array[2];
        if ([string isEqualToString:CityModelKey]) {
            self.areaCode = array[0];
        }else{
            self.orgId = array[0];
        }
    }
    
    self.cpage = 1;
    self.dataArray = [NSMutableArray array];
    [self getEventsList];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStartQueryRecruit:) name:Start_Query_Recruit object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityLibrary:) name:Change_City_Library object:nil];
}

- (void)onStartQueryRecruit:(NSNotification *)notify
{
    self.serviceTypeID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceType];
    self.serviceObjectID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceObject];
    self.recruitNumID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryRecruitNum];
    
    self.cpage = 1;
    [self.dataArray removeAllObjects];
    [self getEventsList];
}

- (void)changeCityLibrary:(NSNotification *)notify
{
    NSDictionary* dictionary = notify.userInfo;
    if ([dictionary objectForKey:SelectedCityKey]) {
        CityModel* city = [dictionary objectForKey:SelectedCityKey];
        if (city.ORG_ID.length > 0) {
            self.areaCode = @"";
            self.orgId = city.ORG_ID;
        }else{
            self.areaCode = city.AREA_CODE;
            self.orgId = @"";
        }
        
    }else if ([dictionary objectForKey:SelectedLibraryKey]){
        LibraryModel* library = [dictionary objectForKey:SelectedLibraryKey];
        self.areaCode = @"";
        self.orgId = library.id;
    }
    self.cpage = 1;
    [self.dataArray removeAllObjects];
    [self getEventsList];
}

//activeState 活动状态(0:预热中; 1:报名中; 2:进行中; 3:已结束; 4:已结项; 5:已取消)
- (void)getEventsList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ChannelModel *channel = [DeviceHelper sharedInstance].recruitChannel;
    [AFNetAPIClient GET:APIGetEvents parameters:[RequestParameters getEventsByChannelId:channel.ID.length>0?channel.ID:@"8"
                                                                                  cpage:[NSString stringWithFormat:@"%ld",(long)_cpage]
                                                                               pageSize:PAGESIZE
                                                                                   type:channel.CHANNEL_TYPE.length>0?channel.CHANNEL_TYPE:@"6"
                                                                            activeState:self.activeState.length>0?self.activeState:@""
                                                                           serviceTypes:self.serviceTypeID.length >0?self.serviceTypeID:@""
                                                                         serviceObjects:self.serviceObjectID.length>0?self.serviceObjectID:@""
                                                                            recruitNums:self.recruitNumID.length>0?self.recruitNumID:@""
                                                                               areaCode:self.areaCode
                                                                                  orgId:self.orgId] success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DataModel *model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]])
        {
            ArticleList* pageMode = [ArticleList ArticleListWithDictionary:(NSDictionary *)model.result];
            
            [self.dataArray addObjectsFromArray:pageMode.list];
            self.blankView.hidden = self.dataArray.count>0?YES:NO;
            
            if ([pageMode.lastPage boolValue] == YES) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.collectionView.mj_footer endRefreshing];
            }
            [self.collectionView reloadData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.collectionView.mj_header endRefreshing];
        
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark-
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDTH-7)/2, (275/370.f)*(SCREENWIDTH-7)/2+110);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"RecruitViewCell";
    RecruitViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.recruitItem = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ArticleItem* item = self.dataArray[indexPath.item];
    RecruitDetailController* vc = [[RecruitDetailController alloc] init];
    vc.eventId = item.PLATFORM_ARTICAL_ID;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (scrollView.contentOffset.y <= 0 ) {
//        if (self.scrollHandler) {
//            self.scrollHandler(@"down");
//        }
//    }else if(scrollView.contentOffset.y > 0 ){
//        if (self.scrollHandler) {
//            self.scrollHandler(@"up");
//        }
//    }
}

#pragma mark-

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
