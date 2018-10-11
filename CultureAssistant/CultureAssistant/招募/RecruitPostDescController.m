//
//  RecruitPostDescController.m
//  CultureAssistant
//

#import "RecruitPostDescController.h"
#import "RecruitEnrollResultController.h"

@interface RecruitPostDescController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate>

@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)NSArray* dataArray;

@property(nonatomic,strong)UIWebView* webView;
@property(nonatomic,assign)NSInteger index;
@end

@implementation RecruitPostDescController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择岗位";
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[RecruitPostDescCell class] forCellWithReuseIdentifier:@"RecruitPostDescCell"];
    
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    typeof(self) __weak wself = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself getEventPosts];
    }];
    
    
    if (self.eventId) {
        [self getEventPosts];
    }
}

- (void)getEventPosts{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakObj(self);
    [AFNetAPIClient GET:APIGetEventPosts parameters:[RequestParameters getEventsById:self.eventId] success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [wself.collectionView.mj_header endRefreshing];
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if([model.result isKindOfClass:[NSArray class]]){
            self.dataArray = [RecruitPost arrayOfModelsFromDictionaries:(NSArray *)model.result];
            [wself.collectionView reloadData];
        }
        
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [wself.collectionView.mj_header endRefreshing];
    }];
}



#pragma mark-
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecruitPost* recruitPost = self.dataArray[indexPath.item];
    return [RecruitPostDescCell SizeForRecruitPostDescCell:recruitPost];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"RecruitPostDescCell";
    RecruitPostDescCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.recruitPost = self.dataArray[indexPath.item];
    cell.enrollBtn.tag = indexPath.row;
    [cell.enrollBtn addTarget:self action:@selector(enrollRecruit:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark-
- (void)enrollRecruit:(UIButton *)button
{
    if (![UserInfoManager sharedInstance].isAlreadyLogin) {
        LoginViewController* vc = [LoginViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    RecruitPost *recruitPost = self.dataArray[button.tag];
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient POST:APIVolEventEnroll parameters:[RequestParameters volEventDoEnroll:recruitPost.eventId postId:recruitPost.id] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code intValue] == 200) {
            RecruitEnrollResultController* vc = [RecruitEnrollResultController new];
            vc.enrollFinishedHandler = ^{
                if (self.enrollSucessHandler) {
                    self.enrollSucessHandler();
                }
                [wself.navigationController popToRootViewControllerAnimated:YES];
            };
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [wself presentViewController:vc animated:YES completion:nil];
        }
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请先注册志愿者"];
        [self performSelector:@selector(gotoRegisterPage) withObject:nil afterDelay:1.f];
    }];
}

- (void)gotoRegisterPage{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Do_Not_Show_Register" object:nil];
}





@end
