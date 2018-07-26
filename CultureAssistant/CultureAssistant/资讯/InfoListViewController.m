//
//  InfoListViewController.m
//  CultureAssistant
//


#import "InfoListViewController.h"
#import "NewsDetailViewController.h"
#import "ImagesNewsDetailController.h"


@interface InfoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSArray* topArray;
@property(nonatomic,strong)NSMutableArray* listArray;
@property(nonatomic,assign)NSInteger pageIndex;
@property(nonatomic,strong)BannerList* banners;

@property(nonatomic,strong)NSString* areaCode;
@property(nonatomic,strong)NSString* orgId;

@property(nonatomic,strong)BlankContentView* blankView;
@end

@implementation InfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
    
    self.listArray = [NSMutableArray array];
    
    self.pageIndex = 1;
    
    self.tableView = [UITableView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[InfoTopImageCell class] forCellReuseIdentifier:@"InfoTopImageCell"];
    [self.tableView registerClass:[InfoADImageCell class] forCellReuseIdentifier:@"InfoADImageCell"];
    [self.tableView registerClass:[InfoCommonCell class] forCellReuseIdentifier:@"InfoCommonCell"];
    [self.tableView registerClass:[InfoTextCell class] forCellReuseIdentifier:@"InfoTextCell"];
    [self.tableView registerClass:[InfoImagesCell class] forCellReuseIdentifier:@"InfoImagesCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];

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
    
    typeof(self) __weak wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.pageIndex = 1;
        [wself getBannerList:wself.channelid];
        [wself getArticleLsit:wself.channelid];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{
        wself.pageIndex++ ;
        [wself getArticleLsit:wself.channelid];
    }];
    
    self.blankView = [BlankContentView new];
    [self.tableView addSubview:self.blankView];
    [self.blankView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.width.height.equalTo(300);
    }];
    self.blankView.hidden = YES;
    
    
    if (self.channelid) {
        [self getBannerList:self.channelid];
        [self getArticleLsit:self.channelid];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityLibrary:) name:Change_City_Library object:nil];
}


- (void)setChannelid:(NSString *)channelid{
    _channelid = channelid;
}


- (void)getBannerList:(NSString *)channelid{
    if (channelid.length <= 0) return;
    
    [AFNetAPIClient GET:APIGetBanners parameters:[RequestParameters getBannersByChannelId:channelid type:@"1" cpage:@"1" pageSize:@"4" areaCode:@"" orgId:@"" objectType:@"0" visibled:@"1"] success:^(id JSON, NSError *error){
        DataModel *model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]]){
            self.banners = [BannerList BannerListWithDictionary:(NSDictionary *)model.result];
            if(self.banners.list.count>0 || self.listArray.count>0){
                self.blankView.hidden = YES;
            }else{
                self.blankView.hidden = NO;
            }
            [self.tableView reloadData];
        }
    }failure:^(id JSON, NSError *error){
        
    }];
}


- (void)getArticleLsit:(NSString *)channelid
{
    if (channelid.length <= 0) return;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [AFNetAPIClient GET:APIGetArticles parameters:[RequestParameters getArticlesByChannelId:self.channelid cpage:[NSString stringWithFormat:@"%ld",self.pageIndex] pageSize:PAGESIZE areaCode:@"" orgId:@""] success:^(id JSON, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel *model = [[DataModel alloc] initWithString:JSON error:nil];
        
        if ([model.result isKindOfClass:[NSDictionary class]])
        {
            ArticleList* pageMode = [ArticleList ArticleListWithDictionary:(NSDictionary *)model.result];

            if (self.pageIndex == 1)
            {
                [self.listArray removeAllObjects];
                [self.listArray addObjectsFromArray:pageMode.list];
            }else{
                [self.listArray addObjectsFromArray:pageMode.list];
            }
            
            [self.tableView.mj_header endRefreshing];
            
            if ([pageMode.lastPage boolValue] == YES) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            if(self.banners.list.count>0 || self.listArray.count>0){
                self.blankView.hidden = YES;
            }else{
                self.blankView.hidden = NO;
            }
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView.mj_header endRefreshing];
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark-
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.banners.list.count >0){
            return SCREENWIDTH*37/75.0;
        }else{
            return 0.0;
        }
    }else{
        ArticleItem *item = self.listArray[indexPath.row-1];
        
        switch ([item.ARTICLE_TYPE integerValue]) {
            case -1://推广
            {
                return [InfoADImageCell heightForCell:item];
            }
                break;
            case 0://普通新闻
            case 2://视频新闻
            {
                if (item.COVER_IMG_URL.length > 0) {
                    return [InfoCommonCell heightForCell];
                }else{
                    return [InfoTextCell heightForCell:item];
                }
            }
                break;
            case 1://多图新闻
            {
                return [InfoImagesCell heightForCell:item];
            }
                break;
            default:
                break;
        }
        return [InfoTableViewCell heightForCell:item];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count + 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0)
    {
        InfoTopImageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTopImageCell"];
        typeof(self) __weak wself = self;
        cell.gotoArticleDetail = ^(BannerItem* model){
            [wself tapBannerToDetail:model];
        };
        if (self.banners) {
            cell.imagesArray = self.banners.list;
        }
        return cell;
    }
    else
    {
        ArticleItem *item = self.listArray[indexPath.row-1];
        
        switch ([item.ARTICLE_TYPE integerValue]) {
            case -1://广告新闻
            {
                InfoADImageCell* cell;
                cell = (InfoADImageCell *)[tableView dequeueReusableCellWithIdentifier:@"InfoADImageCell"];
                [cell setContent:item];
                return cell;
            }
                break;
            case 0://普通新闻
            case 2://视频新闻
            {
                InfoTableViewCell* cell;
                if (item.COVER_IMG_URL.length > 0) {
                    cell = (InfoCommonCell *)[tableView dequeueReusableCellWithIdentifier:@"InfoCommonCell"];
                }else{
                    cell = (InfoTextCell *)[tableView dequeueReusableCellWithIdentifier:@"InfoTextCell"];
                }
                [cell setContent:item];
                return cell;
            }
                break;
            case 1://多图新闻
            {
                InfoImagesCell *cell = (InfoImagesCell *)[tableView dequeueReusableCellWithIdentifier:@"InfoImagesCell"];
                [cell setContent:item];
                return cell;
            }
                break;
                
            default:
                break;
        }
        
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) return;

    //推广里面包含：资讯，资源，活动（活动包含：答题，招募，会议，征集，展览）
    ArticleItem* newItem = self.listArray[indexPath.row-1];
    switch ([newItem.ARTICLE_TYPE integerValue]) {
        case -1://推广
        {
            switch ([newItem.TYPE intValue]) {
                case 0://普通新闻
                {
                    NewsDetailViewController* detailController = [NewsDetailViewController new];
                    detailController.detailId = newItem.ID;
                    [self.navigationController pushViewController:detailController animated:YES];
                }
                    break;
                case 1://多图新闻
                {
                    ImagesNewsDetailController* detailController = [ImagesNewsDetailController new];
                    detailController.detailId = newItem.ID;
                    [self.navigationController pushViewController:detailController animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 0://普通新闻
        case 2://视频新闻
        {
            NewsDetailViewController* detailController = [NewsDetailViewController new];
            detailController.detailId = newItem.ID;
            [self.navigationController pushViewController:detailController animated:YES];
        }
            break;
        case 1://多图新闻
        {
            ImagesNewsDetailController* detailController = [ImagesNewsDetailController new];
            detailController.detailId = newItem.ID;
            [self.navigationController pushViewController:detailController animated:YES];
        }
            break;

        default:
            break;
    }
    
}

#pragma mark-
- (void)tapBannerToDetail:(BannerItem *)newItem
{
    switch ([newItem.OBJECT_TYPE integerValue]) {
        case -1://推广
        {
            switch ([newItem.TYPE intValue]) {
                case 0://普通新闻
                {
                    NewsDetailViewController* detailController = [NewsDetailViewController new];
                    detailController.detailId = newItem.ID;
                    [self.navigationController pushViewController:detailController animated:YES];
                }
                    break;
                case 1://多图新闻
                {
                    ImagesNewsDetailController* detailController = [ImagesNewsDetailController new];
                    detailController.detailId = newItem.ID;
                    [self.navigationController pushViewController:detailController animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 0://普通新闻
        case 2://视频新闻
        {
            NewsDetailViewController* detailController = [NewsDetailViewController new];
            detailController.detailId = newItem.OBJECT_ID;
            [self.navigationController pushViewController:detailController animated:YES];
        }
            break;
        case 1://多图新闻
        {
            ImagesNewsDetailController* detailController = [ImagesNewsDetailController new];
            detailController.detailId = newItem.OBJECT_ID;
            [self.navigationController pushViewController:detailController animated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark-

- (void)changeCityLibrary:(NSNotification *)notify{
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
    [self getBannerList:_channelid];
    [self getArticleLsit:_channelid];
}

#pragma mark-
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
