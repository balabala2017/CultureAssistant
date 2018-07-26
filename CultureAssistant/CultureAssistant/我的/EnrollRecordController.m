//
//  EnrollRecordController.m
//  CultureAssistant
//


#import "EnrollRecordController.h"
#import "RecruitDetailController.h"

@interface EnrollRecordController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,assign)NSInteger cpage;
@property(nonatomic,strong)NSMutableArray* dataArray;
@property(nonatomic,strong)BlankContentView* blankView;
@end

@implementation EnrollRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的报名";
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
    
    self.cpage = 1;
    self.dataArray = [NSMutableArray array];
    
    typeof(self) __weak wself = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.cpage = 1;
        [wself.dataArray removeAllObjects];
        [wself getUserApplys];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        wself.cpage ++;
        [wself getUserApplys];
    }];

    self.blankView = [BlankContentView new];
    [_collectionView addSubview:self.blankView];
    [self.blankView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(wself.collectionView);
        make.width.height.equalTo(300);
    }];
    self.blankView.hidden = YES;
    
    if (self.recordStatus) {
        [self getUserApplys];
    }
}

- (void)getUserApplys{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [AFNetAPIClient GET:APIGetUserApplys parameters:[RequestParameters getUserApplysWithStatu:self.recordStatus cpage:[NSString stringWithFormat:@"%ld",(long)_cpage] pageSize:PAGESIZE] success:^(id JSON, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DataModel *model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]]) {
            NSArray* array = [(NSDictionary *)model.result objectForKey:@"result"];
            for (NSDictionary* dic in array) {
                MyEnrollModel* myEnroll = [MyEnrollModel MyEnrollModelWithDictionary:dic];
                if (myEnroll) {
                    [self.dataArray addObject:myEnroll];
                }
            }
            if (array.count == 0) {
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
    self.blankView.hidden = self.dataArray.count>0?YES:NO;
    return self.dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"RecruitViewCell";
    RecruitViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.myEnroll = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    MyEnrollModel* item = self.dataArray[indexPath.item];
    RecruitDetailController* vc = [RecruitDetailController new];
    vc.eventId = item.volEventObj.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
