//
//  SearchViewController.m
//  CultureAssistant
//


#import "SearchViewController.h"
#import "SearchView.h"

#import "RecruitDetailController.h"
#import "NewsDetailViewController.h"
#import "ImagesNewsDetailController.h"

@interface SearchViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)SearchView * searchView;

@property (nonatomic,strong) NSArray * hotKeyArr;      //热词
@property (nonatomic,strong) NSArray * historyKeyArr;  //搜索历史

@property (nonatomic,strong) NSMutableArray * searchNewsArr;

@property (nonatomic,strong) NSDictionary * hotNewsAllDic;

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *searchFiledView;
@property (nonatomic,strong)UIButton *typeBtn;
@property (nonatomic,strong)CustomTextField * searchField;
@property (nonatomic,strong)TypeView *typeView;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)NSArray* typeArray;

@property (nonatomic,strong)NSString* searchType;//0:资讯; 6:招募 (全部类型不用传)

@property (nonatomic,assign)BOOL showDetail;//用来判断是否移除顶部搜索框
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _searchType = @"";
    
    [self createSubViews];
    
    [self getHotNews];
    [self getHistoryNews];
    
    self.searchNewsArr = [NSMutableArray array];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _typeBtn.hidden = NO;
    _searchField.hidden = NO;
    _lineView.hidden = NO;
    _searchFiledView.hidden = NO;
    _topView.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _typeBtn.hidden = YES;
    _searchField.hidden = YES;
    _lineView.hidden = YES;
    _searchFiledView.hidden = YES;
    _topView.hidden = YES;
}

-(void)getHotNews
{
    [AFNetAPIClient GET:APIGetHotSearch parameters:[RequestParameters commonRequestParameter] success:^(id JSON, NSError *error) {
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSArray class]]) {
            self.hotKeyArr = [HotKeyItem arrayOfModelsFromDictionaries:(NSArray *)model.result];
            
            [self getHotKeysFrame:self.hotKeyArr withFlag:1];
        }

    } failure:^(id JSON, NSError *error) {
        
    }];
    
}

-(void)getHotKeysFrame:(NSArray *)hotList withFlag:(NSInteger)flag
{
    CGFloat width = 0;
    CGFloat height = 35;
    CGFloat positonX = 0;
    CGFloat positionY = 0;
    
    CGFloat sumWidth = 0;
    
    CGFloat maxWidth = self.view.bounds.size.width-20;
    
    for (NSInteger i = 0; i < hotList.count; i++)
    {
        HotKeyItem * item = hotList[i];
        
        CGRect rect = [item.KEY boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        width = rect.size.width+50;
        
        if (width>maxWidth) {
            width = maxWidth+10;
        }
        
        if ((sumWidth + width)>maxWidth) {
            positonX = 0;
            positionY += 45;
            sumWidth = width;
        }
        else{
            positonX = sumWidth;
            sumWidth += width;
        }
        
        NSString * rectStr = NSStringFromCGRect(CGRectMake(positonX, positionY, width-10, height));
        item.newsFrame =  rectStr;
        
        if (i == hotList.count-1 ) {
            if (flag == 1) {
                [_searchView showHotNewsWithData:hotList];
            }else{
                [_searchView showHistoryNewsWithData:hotList];
            }
        }
    }
}

-(void)getHistoryNews
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *  historyKeys = [userdefaults objectForKey:SearchHistoryKey];
    NSMutableArray * mArr = [NSMutableArray array];
    
    for (int i=0; i<historyKeys.count; i++)
    {
        HotKeyItem * item = [HotKeyItem new];
        NSString * title = historyKeys[i];
        item.KEY = title;
        
        [mArr addObject:item];
        
    }
    self.historyKeyArr = mArr;
    
    [self getHotKeysFrame:self.historyKeyArr withFlag:2];
    
    
}


- (void)typeSelect:(UIButton *)sender
{
    //选择搜索类型
    if (_typeView) {
        if (_typeView.isShow) {
            [_typeView hidden];
        }
        else{
            [_typeView show];
        }
    }
    else
    {
        _typeView = [TypeView new];
        _typeView.frame = self.view.bounds;
        _typeView.delegate = self;
        [self.view addSubview:_typeView];
    }
}

- (void)doSearch:(NSArray *)arr
{
    [_searchField resignFirstResponder];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *  historyKeys = [userdefaults objectForKey:SearchHistoryKey];
    
    if (historyKeys == nil || historyKeys.count == 0) {
        historyKeys = [NSMutableArray arrayWithObject:arr[0]];
    }
    else
    {
        NSMutableArray * _mArr = [NSMutableArray arrayWithArray:historyKeys];
        
        for (NSString * key in _mArr) {
            if ([key isEqualToString:arr[0]]) {
                [_mArr removeObject:key];
                break;
            }
        }
        historyKeys = [NSMutableArray arrayWithObject:arr[0]];
        [historyKeys addObjectsFromArray:_mArr];
    }
    
    [userdefaults setObject:historyKeys forKey:SearchHistoryKey];
    [userdefaults synchronize];
    [self getHistoryNews];
    
    
    _searchField.text = arr[0];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetAPIClient POST:APIDoSearch parameters:[RequestParameters doSearchType:arr[1] key:arr[0] cpage:arr[2] pageSize:PAGESIZE] showLoading:NO success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel *model = [[DataModel alloc] initWithString:JSON error:nil];
        
        if ([model.result isKindOfClass:[NSDictionary class]])
        {
            ArticleList* pageMode = [ArticleList ArticleListWithDictionary:(NSDictionary *)model.result];
            
            if ([pageMode.firstPage boolValue]) {
                [self.searchNewsArr removeAllObjects];
                self.searchView.tableV.contentOffset = CGPointMake(0, 0);
            }
            [self.searchNewsArr addObjectsFromArray:pageMode.list];
            pageMode.list = self.searchNewsArr;
            [self.searchView showSearchNewsWithData:pageMode];
        }
        
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.searchView showSearchNewsWithData:nil];
        
        [self getHistoryNews];
        
    }];
}
//选择类型
- (void)selectType:(NSArray *)sender
{
    _searchType = sender[1];
    _searchView.searchType = _searchType;
    [_typeBtn setTitle:sender[0] forState:UIControlStateNormal];
    
    if (_searchField.text.length>0) {
        [self doSearch:@[_searchField.text,_searchType,@"1"]];
    }
    
}

#pragma mark-
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _searchView.isShowSearchNewsList = NO;

    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _searchView.isShowSearchNewsList = NO;

    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchView.isShowSearchNewsList = NO;
    _searchView.tableV.mj_header.hidden = YES;
    _searchView.tableV.mj_footer.hidden = YES;
    [textField resignFirstResponder];
    
    if (textField.text.length==0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请输入关键字"];
        return NO;
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
        
    }
    _searchView.searchKey = _searchField.text;
    
    [self doSearch:@[_searchField.text,_searchType,@"1"]];
    return YES;
}

#pragma mark-
- (void)gotoDetailViewController:(ArticleItem *)item
{
    if ([item.TYPE isEqualToString:@"6"])
    {
        RecruitDetailController* vc = [RecruitDetailController new];
        vc.eventId = item.PLATFORM_ARTICAL_ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        if ([item.ARTICLE_TYPE isEqualToString:@"0"]) {
            NewsDetailViewController* vc = [NewsDetailViewController new];
            vc.detailId = item.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ImagesNewsDetailController* vc = [ImagesNewsDetailController new];
            vc.detailId = item.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark-
- (void)createSubViews{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(44+10, 5, SCREENWIDTH - 64, 34)];
    [self.navigationController.navigationBar addSubview:_topView];
    
    WeakObj(self);
    _searchFiledView = [UIView new];
    [_topView addSubview:_searchFiledView];
    _searchFiledView.backgroundColor = [UIColor whiteColor];
    _searchFiledView.layer.cornerRadius = 17;
    _searchFiledView.layer.borderWidth = 0.5;
    _searchFiledView.clipsToBounds = YES;
    _searchFiledView.layer.borderColor = [[UIColor colorWithWhite:217/255.f alpha:1.f] CGColor];
    [_searchFiledView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(wself.topView);
    }];
    
    _typeBtn = [UIButton buttonWithType:UIButtonTypeCustom tag:-1 title:@"全部" frame:CGRectZero backImage:nil target:self action:@selector(typeSelect:)];
    [_typeBtn setImage:[UIImage imageNamed:@"search_list"] forState:UIControlStateNormal];
    _typeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_typeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_searchFiledView addSubview:_typeBtn];
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(wself.searchFiledView);
        make.width.equalTo(70);
    }];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithWhite:219/255.f alpha:1.f];
    [_searchFiledView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(5);
        make.bottom.equalTo(wself.searchFiledView.mas_bottom).offset(-5);
        make.left.equalTo(wself.typeBtn.mas_right);
        make.width.equalTo(1);
    }];
    
    _searchField = [[CustomTextField alloc] initWithFrame:CGRectMake(44, 0, SCREENWIDTH-44-10, 34)];
    _searchField.clearsOnBeginEditing = NO;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.font = [UIFont systemFontOfSize:14];
    _searchField.textColor = [UIColor colorWithHexString:@"666666"];
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    imageView.frame = CGRectMake(15, 10, 20, 20);
    _searchField.leftView.backgroundColor = [UIColor clearColor];
    _searchField.placeholder = @"请输入关键字";
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.delegate = self;
    [_topView addSubview:_searchField];
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(wself.searchFiledView);
        make.left.equalTo(wself.typeBtn.mas_right);
    }];
    
    _searchView = [SearchView new];
    _searchView.delegate = self;
    [self.view addSubview:_searchView];
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

- (void)dealloc{
    [_typeBtn removeFromSuperview];
    [_searchField removeFromSuperview];
    [_lineView removeFromSuperview];
    [_searchFiledView removeFromSuperview];
    [_topView removeFromSuperview];
}

@end
