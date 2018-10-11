//
//  RecruitViewController.m
//  CultureAssistant
//


#import "RecruitViewController.h"
#import "RecruitListViewController.h"
#import "WYScrollView.h"
#import "RecruitDetailController.h"

@interface RecruitViewController ()<UIScrollViewDelegate,WYScrollViewNetDelegate>

@property(nonatomic,strong)WYScrollView *WYNetScrollView;

@property(nonatomic,strong)UIScrollView* scrollView;

@property(nonatomic,strong)UIScrollView* menuScrollView;//标签
@property(nonatomic,strong)UIScrollView* bigScrollView;

@property(nonatomic,assign)CGFloat kButtonWidth;
@property(nonatomic,strong)UIButton *lastButton;
@property(nonatomic,strong)UIView * menuRedLineView;

@property(nonatomic,strong)NSArray * channelArray;

@property(nonatomic,strong)BannerList* banners;

@property(nonatomic,strong)NSString* areaCode;
@property(nonatomic,strong)NSString* orgId;

@property (nonatomic,strong) UIView * arrowView;
@end

@implementation RecruitViewController

- (void)viewDidLoad{
    [super viewDidLoad];

//    _scrollView = [UIScrollView new];
//    _scrollView.delegate = self;
//    [self.view addSubview:_scrollView];
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view.bottom).offset(-49);
//    }];
//
//    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT+SCREENWIDTH/2.f);
    
    
    self.channelArray = @[@"全部",@"预热中",@"报名中",@"进行中",@"已结束",@"已结项"];
    
    [self creatSubviews];
    [self addChildController];
    
    self.areaCode = @"";
    self.orgId = @"";
    
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:LocationSelectedArea];
    if (array.count>2) {
        NSString* string = array[2];
        if ([string isEqualToString:@"CityModel"]) {
            self.areaCode = array[0];
        }else{
            self.orgId = array[0];
        }
    }
    
    //用3进行测试
//    [self getBannerList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCityLibrary:) name:Change_City_Library object:nil];
    
}

- (void)creatSubviews
{
//    if (!self.WYNetScrollView) {
//        self.WYNetScrollView = [[WYScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2.0)];
//        self.WYNetScrollView.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
//        self.WYNetScrollView.netDelagate = self;
//        self.WYNetScrollView.iconView.image = [UIImage imageNamed:@"recruit_banner"];
//    }
//    [_scrollView addSubview:self.WYNetScrollView];
    
    
    
    _kButtonWidth = SCREENWIDTH/3;
    if (self.channelArray.count < 5) {
        _kButtonWidth = SCREENWIDTH/self.channelArray.count;
    }else{
        _kButtonWidth = 100;
    }
    
    _menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    _menuScrollView.contentSize = CGSizeMake(_kButtonWidth * self.channelArray.count, 40);
    _menuScrollView.showsHorizontalScrollIndicator = NO;
    _menuScrollView.delegate = self;
    _menuScrollView.pagingEnabled = YES;
    [self.view addSubview:_menuScrollView];
    
    for (UIImageView* subView in _menuScrollView.subviews) {
        [subView removeFromSuperview];
    }
    {
        
        _arrowView = [UIView new];
        [self.view addSubview:_arrowView];
        [_arrowView mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.top.bottom.equalTo(self.menuScrollView);
            make.width.equalTo(40);
        }];
        
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zixun_square"]];
        [_arrowView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.arrowView);
        }];
        
        imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zixun_arrow"]];
        [_arrowView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(self.arrowView);
        }];
        
    }
    typeof(self) __weak wself = self;
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithWhite:194/255.f alpha:1.f];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(wself.menuScrollView.left);
        make.bottom.equalTo(wself.menuScrollView.bottom);
        make.right.equalTo(wself.menuScrollView.right);
        make.height.equalTo(1);
    }];
    
    _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, SCREENHEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-40)];
    _bigScrollView.contentSize = CGSizeMake(SCREENWIDTH*self.channelArray.count, _bigScrollView.bounds.size.height);
    _bigScrollView.showsHorizontalScrollIndicator = NO;
    _bigScrollView.showsVerticalScrollIndicator = NO;
    _bigScrollView.pagingEnabled = YES;
    _bigScrollView.delegate = self;
    [self.view addSubview:_bigScrollView];
    
    
    for (NSInteger i = 0; i < self.channelArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*_kButtonWidth, 0, _kButtonWidth, 40);
        [button setTitle:self.channelArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [button setTitleColor:BaseColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        if (SCREENWIDTH <= 320) {
            button.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            button.selected = YES;
            _lastButton = button;
        }
        [self.menuScrollView addSubview:button];
    }
    
    _menuRedLineView = [UIView new];
    _menuRedLineView.tag = -1;
    _menuRedLineView.backgroundColor = BaseColor;
    [self.menuScrollView addSubview:_menuRedLineView];
    [_menuRedLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(0);
        make.top.equalTo(37);
        make.width.equalTo(self.kButtonWidth);
        make.height.equalTo(3);
    }];
}

- (void)addChildController
{
    self.channelArray = @[@"全部",@"预热中",@"报名中",@"进行中",@"已结束",@"已结项"];
    NSArray* stateArray = @[@"",@"0",@"1",@"2",@"3",@"4"];

    for (NSInteger i = 0; i < self.channelArray.count; i++) {
        RecruitListViewController *VC = [[RecruitListViewController alloc] init];
        VC.view.frame = CGRectMake(i*self.bigScrollView.bounds.size.width, 0, self.bigScrollView.bounds.size.width, self.bigScrollView.bounds.size.height);
        VC.activeState = stateArray[i];

        [self.bigScrollView addSubview:VC.view];
        [self addChildViewController:VC];
    }
}

- (void)clickButton:(UIButton *)button
{
    _lastButton.selected = NO;
    button.selected = YES;
    _lastButton = button;
    
    [_menuRedLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lastButton.frame.origin.x);
    }];
    
    //上方小的滑动视图的滚动
    float xx = SCREENWIDTH * (button.tag - 1) * (_kButtonWidth / SCREENWIDTH) - _kButtonWidth;
    [_menuScrollView scrollRectToVisible:CGRectMake(xx, 0, SCREENWIDTH, _menuScrollView.frame.size.height) animated:YES];

    
    //下方大的滑动视图的滚动
    CGFloat offsetX = button.tag * self.bigScrollView.frame.size.width;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
}



//- (void)getBannerList{
//    //@"430000"
//
//    typeof(self) __weak wself = self;
//    [AFNetAPIClient GET:APIGetBanners parameters:[RequestParameters getBannersByChannelId:@"8" type:@"" cpage:@"1" pageSize:@"4" areaCode:self.areaCode orgId:self.orgId objectType:@"6" visibled:@"1"] success:^(id JSON, NSError *error){
//        DataModel *model = [[DataModel alloc] initWithString:JSON error:nil];
//        if ([model.result isKindOfClass:[NSDictionary class]]){
//            self.banners = [BannerList BannerListWithDictionary:(NSDictionary *)model.result];
//            if (self.banners.list.count >0) {
//                [wself layoutTopBanner];
//            }else{
//                self.scrollView.contentOffset = CGPointMake(0, SCREENWIDTH/2.f);
//            }
//        }
//    }failure:^(id JSON, NSError *error){
//        self.scrollView.contentOffset = CGPointMake(0, SCREENWIDTH/2.f);
//    }];
//}

#pragma mark-
//- (void)layoutTopBanner
//{
//    NSMutableArray* tempArray = [NSMutableArray array];
//    for (NSInteger i = 0;i < self.banners.list.count;i++) {
//        BannerItem* model = self.banners.list[i];
//        if (model.IMG_URL.length > 0) {
//            [tempArray addObject:model.IMG_URL];
//        }
//    }
//
//    self.WYNetScrollView.imageArray = tempArray;
//    self.WYNetScrollView.AutoScrollDelay = 3;
//    self.WYNetScrollView.showImageInfo = YES;
//
//}
//
//-(void)showNetworkImageInfoAtIndex:(NSInteger)index{
//    if (self.banners.list.count > 0  && index < self.banners.list.count ) {
//        BannerItem* model = self.banners.list[index];
//        self.WYNetScrollView.titleLabel.text = model.SUMMARY;
//    }
//}
//
//-(void)didSelectedNetImageAtIndex:(NSInteger)index{
//    if (self.banners.list.count <= 0) return;
//
//    BannerItem* model = self.banners.list[index];
//
//    RecruitDetailController* vc = [RecruitDetailController new];
//    vc.eventId = model.ID;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark-
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.bigScrollView == scrollView)
    {
        NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
        [UIView animateWithDuration:.5f animations:^{
            self.arrowView.hidden = index == self.channelArray.count - 1?YES:NO;
        }];
        
        
        _lastButton.selected = NO;
        UIButton *button = _menuScrollView.subviews[index];
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = YES;
            _lastButton = button;
            [_menuRedLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.lastButton.frame.origin.x);
            }];
        }
    }
}


/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    if (self.bigScrollView == scrollView)
    {
        float xx = scrollView.contentOffset.x * (_kButtonWidth / SCREENWIDTH) - _kButtonWidth;
        [_menuScrollView scrollRectToVisible:CGRectMake(xx, 0, SCREENWIDTH, _menuScrollView.frame.size.height) animated:YES];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

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
    
//    [self getBannerList];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
