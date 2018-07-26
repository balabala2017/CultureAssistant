//
//  StarRecordController.m
//  CultureAssistant
//


#import "StarRecordController.h"

@interface StarRecordController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView* collectionView;

@property(nonatomic,assign)NSInteger cpage;
@property(nonatomic,strong)NSMutableArray* dataArray;
@end

@implementation StarRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"星级";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREENWIDTH-20, 50);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[StarLevelCell class] forCellWithReuseIdentifier:@"StarLevelCell"];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    typeof(self) __weak wself = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.cpage = 1;
        [wself.dataArray removeAllObjects];
        [wself getStartRecord];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{
        wself.cpage ++;
        [wself getStartRecord];
    }];
    
    self.cpage = 1;
    self.dataArray = [NSMutableArray array];
    [self getStartRecord];
    
}

- (void)getStartRecord{
    WeakObj(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetAPIClient GET:APIGetUserStarRec parameters:[RequestParameters requesetWithPage:[NSString stringWithFormat:@"%ld",(long)self.cpage] pageSize:PAGESIZE] success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]]) {
            NSArray* array = [(NSDictionary *)model.result objectForKey:@"result"];
            if ([array isKindOfClass:[NSArray class]]) {
                array = [StarRecord arrayOfModelsFromDictionaries:array];
                [self.dataArray addObjectsFromArray:array];
                
                [wself.collectionView reloadData];
            }
            
            NSInteger totalCount = [[(NSDictionary *)model.result objectForKey:@"totalCount"] integerValue];
            if (self.dataArray.count == totalCount) {
                [wself.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [wself.collectionView.mj_footer endRefreshing];
            }
        }else{
            [wself.collectionView.mj_footer endRefreshing];
        }
        [wself.collectionView.mj_header endRefreshing];
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD MBProgressHUDWithView:self.view Str:JSON];
        
        [wself.collectionView.mj_header endRefreshing];
        [wself.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark-
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"StarLevelCell";
    StarLevelCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.starRecord = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

}

@end
