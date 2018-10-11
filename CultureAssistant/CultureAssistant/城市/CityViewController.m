//
//  CityViewController.m
//  CultureAssistant
//


#import "CityViewController.h"
#import "CustomElementView.h"
#import "ULBCollectionViewFlowLayout.h"
#import "LibraryViewController.h"

@interface CityViewController ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UIView* searchView;
@property (nonatomic,strong)CustomTextField * searchField;

@property (nonatomic,strong)UILabel * gpsLabel;
@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSArray * allCityKeys;
@property (nonatomic,strong)NSMutableDictionary * allCityDic;

@property (nonatomic,strong)NSArray * cityList;//存放请求回来的城市列表

@property (nonatomic,strong)NSArray * searchResultList;
@property (nonatomic,assign)BOOL isSearchResult;

@property (nonatomic,strong)CityModel * selectedItem;
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLocationCity:) name:@"Get_LOCATION_CITY" object:nil];
    
    self.allCityKeys = @[@"历史访问",@"热门访问",@"所有城市"];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray * historyCityList = [userdefaults objectForKey:LocationHistoryArea];
    if (![historyCityList isKindOfClass:[NSArray class]]) {
        historyCityList = [NSArray array];
    }else{
        NSMutableArray * _mArr = [NSMutableArray array];
        for (NSArray * elem in historyCityList) {
            CityModel * item = [CityModel new];
            if ([elem[2] isEqualToString:CityModelKey]) {
                item.AREA_CODE = elem[0];
                item.AREA_NAME = elem[1];
                item.SHOW_NAME = elem[1];
            }else{
                item.ORG_ID = elem[0];
                item.SHOW_NAME = elem[1];
                item.AREA_NAME = elem[3];
            }
            [_mArr addObject:item];
        }
        historyCityList = _mArr;
    }
    self.allCityDic =[NSMutableDictionary dictionaryWithObjects:@[historyCityList,@[],@[]] forKeys:@[@"历史访问",@"热门访问",@"所有城市"]] ;
    self.cityList = [self.allCityDic objectForKey:self.allCityKeys.lastObject];
    
    [self createSubViews];

    
    [self getProvincesByArea];
    
    [self getVisitHistorys];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_searchField removeFromSuperview];
    [_searchView removeFromSuperview];
}

//获取带有场馆的城市
- (void)getProvincesByArea{
    [AFNetAPIClient GET:APIGetProvincesByArea parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error) {
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray *)model.result;
            array = [CityModel arrayOfModelsFromDictionaries:array error:nil];
            
            NSMutableArray* mArray = [NSMutableArray new];
            [mArray addObjectsFromArray:array];
            
            CityModel* wholeCountry = [CityModel new];
            wholeCountry.AREA_NAME = @"全国";
            wholeCountry.SHOW_NAME = @"全国";
            wholeCountry.AREA_CODE = @"0";
            wholeCountry.ORG_ID = @"0";
            
            [mArray insertObject:wholeCountry atIndex:0];
            
            [self.allCityDic setValue:mArray forKey:self.allCityKeys[2]];
            self.cityList = mArray;
            [self.collectionView reloadData];
        }
    } failure:^(id JSON, NSError *error) {
        
    }];
}

//热门城市
- (void)getVisitHistorys{

    [AFNetAPIClient GET:APIGetVisitHistorys parameters:[RequestParameters requesetWithPage:@"1" pageSize:@"100"] success:^(id JSON, NSError *error) {
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = (NSDictionary *)model.result;
            NSArray* array = dic[@"list"];
            
            NSArray * cityList = [CityModel arrayOfModelsFromDictionaries:array];
            [self.allCityDic setValue:cityList forKey:self.allCityKeys[1]];
            [self.collectionView reloadData];
        }
        
    } failure:^(id JSON, NSError *error) {

    }];
}

- (void)showLocationCity:(NSNotification *)notify{
    NSDictionary* dic = notify.userInfo;
    self.gpsLabel.attributedText = [self  customNSMutableAttributedString:[NSString stringWithFormat:@"%@ GPS定位",dic[@"LocationCity"]]];
}

#pragma mark - UICollectionViewDataSource
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout colorForSectionAtIndex:(NSInteger)section{
    if (self.isSearchResult) {
        return [UIColor whiteColor];
    }
    if (section <2) {
        return [UIColor colorWithWhite:.9 alpha:1.f];
    }
    return [UIColor whiteColor];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.isSearchResult) {
        return 1;
    }
    return 3;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size={0,0};
    if (self.isSearchResult) {
        return size;
    }
    if (section <2) {
        size= CGSizeMake(SCREENWIDTH, 30);
    }
    return size;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchResult) {
        if (kind == UICollectionElementKindSectionHeader)
            return nil;
    }
    CityHeaderView *reusableview = nil;
    if (indexPath.section <2)
    {
        if (kind == UICollectionElementKindSectionHeader) {
            reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CityHeaderView" forIndexPath:indexPath];
            [reusableview title:self.allCityKeys[indexPath.section]];
        }
    }
    return reusableview;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isSearchResult) {
        return self.searchResultList.count;
    }
    NSArray * arr =[self.allCityDic objectForKey:self.allCityKeys[section]];
    return arr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchResult)
    {
        CityItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityItemCell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        CityModel * item = self.searchResultList[indexPath.row];
        [cell cityItem:item];
        typeof(self) __weak wself = self;
        cell.seletctCityHandle = ^(CityModel * city,NSIndexPath* indexPath){
            [wself selectCity:city indexPath:indexPath];
        };
        return cell;
    }
    else
    {
        if (indexPath.section<2) {
            CitySquareCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CitySquareCell" forIndexPath:indexPath];
            NSArray * cityList = [self.allCityDic objectForKey:self.allCityKeys[indexPath.section]];
            CityModel * item = cityList[indexPath.row];
            [cell title:item.SHOW_NAME];
            return cell;
        }
        else
        {
            CityItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CityItemCell" forIndexPath:indexPath];
            cell.indexPath = indexPath;
            CityModel * item = self.cityList[indexPath.row];
            [cell cityItem:item];
            typeof(self) __weak wself = self;
            cell.showLibraryHandle = ^(CityModel * city){
                [wself showLibrary:city];
            };
            cell.seletctCityHandle = ^(CityModel * city,NSIndexPath* indexPath){
                [wself selectCity:city indexPath:indexPath];
            };
            return cell;
        }
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.isSearchResult) {
        return 0;
    }
    if (section==2) {
        return 0;
    }
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.isSearchResult) {
        return 0;
    }
    if (section==2) {
        return 0;
    }
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchResult) {
        return CGSizeMake(collectionView.bounds.size.width-30, 40);
    }
    CGSize size = CGSizeMake(0,0);
    if (indexPath.section<2)
    {
        NSArray * cityList = [self.allCityDic objectForKey:self.allCityKeys[indexPath.section]];
        CityModel * item = cityList[indexPath.row];
        CGRect rect;
        
        rect = [item.SHOW_NAME boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        CGFloat width = rect.size.width+10;
        size = CGSizeMake(width, 30);
        
    }
    else
    {
        size = CGSizeMake(collectionView.bounds.size.width-30, 40);
    }
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.isSearchResult) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    if (section<2) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchResult || indexPath.section<2)
    {
        CityModel * item = nil;
        if (self.isSearchResult)
        {
            item = self.searchResultList[indexPath.row];
        }
        else
        {
            NSArray * cityList = [self.allCityDic objectForKey:self.allCityKeys[indexPath.section]];
            item = cityList[indexPath.row];
        }
        [self selectCity:item indexPath:indexPath];
    }
}

#pragma mark-
- (void)selectCity:(CityModel *)city indexPath:(NSIndexPath *)indexPath
{
    _selectedItem = city;
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    //说明是场馆
    if (_selectedItem.ORG_ID.length > 0) {
        [userdefaults setObject:@[_selectedItem.ORG_ID,_selectedItem.SHOW_NAME,LibraryModelKey,_selectedItem.AREA_NAME] forKey:LocationSelectedArea];
    }else{
        [userdefaults setObject:@[_selectedItem.AREA_CODE,_selectedItem.AREA_NAME.length>0?_selectedItem.AREA_NAME:_selectedItem.SHOW_NAME,CityModelKey,_selectedItem.AREA_NAME.length>0?_selectedItem.AREA_NAME:_selectedItem.SHOW_NAME] forKey:LocationSelectedArea];
    }
    [userdefaults synchronize];

    [[NSNotificationCenter defaultCenter] postNotificationName:Change_City_Library object:nil userInfo:@{SelectedCityKey:_selectedItem}];
    
    NSArray * cityList = [userdefaults objectForKey:LocationHistoryArea];
    NSMutableArray * _mArr = [NSMutableArray arrayWithArray:cityList];
    if ([cityList isKindOfClass:[NSArray class]])
    {
        for (NSArray * cityItem in _mArr)
        {
            NSString * cityCode = cityItem[0];
            NSString * cityName = cityItem[1];
            NSString * cityType = cityItem[2];
            if (_selectedItem.ORG_ID.length > 0){
                if ([cityType isEqualToString:LibraryModelKey] && [cityCode isEqualToString:_selectedItem.ORG_ID]&&[cityName isEqualToString:_selectedItem.SHOW_NAME]) {
                    [_mArr removeObject:cityItem];
                    break;
                }
            }else{
                if ([cityType isEqualToString:CityModelKey] && [cityCode isEqualToString:_selectedItem.AREA_CODE]&&[cityName isEqualToString:_selectedItem.AREA_NAME]) {
                    [_mArr removeObject:cityItem];
                    break;
                }
            }
        }
    }
    if (_selectedItem.ORG_ID.length > 0) {
       [_mArr insertObject:@[_selectedItem.ORG_ID,_selectedItem.SHOW_NAME,LibraryModelKey,_selectedItem.AREA_NAME.length>0?_selectedItem.AREA_NAME:_selectedItem.SHOW_NAME] atIndex:0];
    }else{
        [_mArr insertObject:@[_selectedItem.AREA_CODE,_selectedItem.AREA_NAME.length>0?_selectedItem.AREA_NAME:_selectedItem.SHOW_NAME,CityModelKey,_selectedItem.AREA_NAME.length>0?_selectedItem.AREA_NAME:_selectedItem.SHOW_NAME] atIndex:0];
    }
    
    NSMutableArray * historyList = [NSMutableArray array];
    for (int i=0; i<_mArr.count; i++) {
        if (i<8) {
            [historyList addObject:_mArr[i]];
        }
    }

    [userdefaults setObject:historyList forKey:LocationHistoryArea];
    [userdefaults synchronize];
    
    _mArr = [NSMutableArray array];
    for (NSArray * elem in historyList) {
        CityModel * item = [CityModel new];
        item.AREA_CODE = elem[0];
        item.AREA_NAME = elem[1];
        [_mArr addObject:item];
    }
    
    [self.allCityDic setObject:_mArr forKey:self.allCityKeys[0]];
    
    //发送trac
    [self setVisitHistory:city.AREA_CODE areaName:city.AREA_NAME.length>0?city.AREA_NAME:city.SHOW_NAME];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLibrary:(CityModel *)city
{
    LibraryViewController* vc = [LibraryViewController new];
    vc.cityModel = city;
    vc.selectedLibraryFinished = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc animated:YES completion:nil];
}

//code--地区或组织机构code 传省级名称  不管你选的是省还是分馆
- (void)setVisitHistory:(NSString *)code areaName:(NSString *)areaName{
    if (code.length <= 0 || areaName.length <= 0) return;
    
    [AFNetAPIClient POST:APISetVisitHistory parameters:[RequestParameters setVisitHistory:code areaName:areaName] success:^(id JSON, NSError *error){
        
    }failure:^(id JSON, NSError *error){
        
    }];
}


#pragma mark-
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length==0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入关键字"];
    }
    else
    {
        //添加搜索框中是否包含特殊字符
        NSString *keyWordRegex = @"^[A-Za-z0-9\u4E00-\u9FA5_-]+$";
        NSPredicate *keyWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", keyWordRegex];
        if (![keyWordTest evaluateWithObject:textField.text]) {
            [textField resignFirstResponder];
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"关键字中含有特殊字符"];
            return NO;
        }
        [self searchWithKey:textField.text ];
    }
    [textField resignFirstResponder];
    return YES;
}

-(void)searchBtnClick
{
    [self textFieldShouldReturn:_searchField];
}

-(void)searchWithKey:(NSString *)string
{
    NSMutableArray * _mArr = [NSMutableArray array];
    for (CityModel * item in [self.allCityDic objectForKey:self.allCityKeys.lastObject]) {
        if ([item.AREA_NAME rangeOfString:string].length>0 || [item.PINYIN rangeOfString:string].length>0) {
            [_mArr addObject:item];
        }
    }
    if ([_mArr count]==0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"没搜索到您要查找的城市"];
    }
    else
    {
        self.isSearchResult = YES;
        self.searchResultList = _mArr;
        [_collectionView reloadData];
    }
}

#pragma mark-
- (void)createSubViews{
    //顶部搜索部分
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(44+10, 5, SCREENWIDTH - 64, 34)];
    [self.navigationController.navigationBar addSubview:_searchView];
    _searchView.backgroundColor = [UIColor clearColor];
    _searchView.layer.cornerRadius = 20;
    _searchView.layer.borderWidth = 0.5;
    _searchView.clipsToBounds = YES;
    _searchView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    WeakObj(self);
    _searchField = [CustomTextField new];
    _searchField.backgroundColor = [UIColor whiteColor];
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.font = [UIFont systemFontOfSize:16];
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView * imagev = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 20)];
    imagev.image = [UIImage imageNamed:@"search_icon"];
    _searchField.leftView = imagev;
    _searchField.placeholder = @"请输入你要搜索的文字";
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.delegate = self;
    [_searchView addSubview:_searchField];
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(wself.searchView);
    }];
    
    //展示选中城市部分
    UIView * _topV = [UIView new];
    [self.view addSubview:_topV];
    [_topV makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(60);
    }];
    UIView * _lineV = [UIView new];
    _lineV.backgroundColor = BaseColor;
    [_topV addSubview:_lineV];
    [_lineV makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(_topV);
        make.height.equalTo(1);
    }];
    
    
    _gpsLabel = [UILabel labelWithText:nil textAlign:NSTextAlignmentLeft textFont:[UIFont systemFontOfSize:15]];
    _gpsLabel.attributedText = [self  customNSMutableAttributedString:[NSString stringWithFormat:@"%@ GPS定位",self.locationCity.length>0? self.locationCity:@"全国"]];
    [_topV addSubview:_gpsLabel];
    [_gpsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_topV);
        make.left.equalTo(_topV).offset(10);
        make.right.equalTo(_topV).offset(-10);
    }];
    
    ULBCollectionViewFlowLayout *flowLayout=[[ULBCollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置横向还是竖向
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0 ,0) collectionViewLayout:flowLayout];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView registerClass:[CityHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CityHeaderView"];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerClass:[CitySquareCell class] forCellWithReuseIdentifier:@"CitySquareCell"];
    [_collectionView registerClass:[CityItemCell class] forCellWithReuseIdentifier:@"CityItemCell"];
    
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topV.bottom);
        make.left.right.bottom.equalTo(self.view);
        
    }];

}

#pragma mark-
- (NSMutableAttributedString *)customNSMutableAttributedString:(NSString *)string
{
    NSRange range = [string rangeOfString:@" "];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  _gpsLabel.font,NSFontAttributeName,
                                  [UIColor blackColor],NSForegroundColorAttributeName,
                                  nil] range:NSMakeRange(0, range.location+1)];
    
    [attributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  _gpsLabel.font,NSFontAttributeName,
                                  [UIColor grayColor],NSForegroundColorAttributeName,
                                  nil] range:NSMakeRange(range.location+1, string.length-range.location-1)];
    
    return attributedStr;
}
#pragma mark-
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
