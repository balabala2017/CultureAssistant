//
//  RecruitDetailBottomView.m
//  CultureAssistant
//


#import "RecruitDetailBottomView.h"

@interface RecruitDetailBottomView ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIWebViewDelegate>

@property (nonatomic,strong) NSArray* tagArray;
@property (nonatomic,assign) CGFloat kButtonWidth;
@property (nonatomic,strong) UIScrollView *menuScrollView;
@property (nonatomic,strong) UIScrollView *bigScrollView;
@property (nonatomic,strong) UIButton *lastButton;
@property (nonatomic,strong) UIView * menuRedLineView;

@property (nonatomic,strong) UIWebView * descView;//详情
@property (nonatomic,strong) UITableView * sponsorView;//发起人
@property (nonatomic,strong) UIScrollView * trendView;//动态

@property (nonatomic,strong) NSMutableArray* linkInfo;//项目发起人

@property (nonatomic,strong)NSArray* applysArray;//申请人数组
@property (nonatomic,assign)NSUInteger applyPage;
@property (nonatomic,strong)NSArray* dynamicsArray;//动态数组

@property (nonatomic,strong)UICollectionView* collectionView;//报名人
@property (nonatomic,strong)UIWebView * webView;//动态

@property (nonatomic,strong)NSArray* tempApplys;//截取一部分

@property (nonatomic,strong)UILabel * noApplysLabel;//没有报名人员时的提醒
@end


@implementation RecruitDetailBottomView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.linkInfo = [NSMutableArray array];
        
        [self createSubViews];
    }
    return self;
}

- (void)setRecruitDetail:(RecruitDetail *)recruitDetail{
    _recruitDetail = recruitDetail;
    
    NSArray* array = _recruitDetail.eventDescs;
    
    NSString* string = @"";
    for (NSDictionary* dic in array)
    {
//        string = [string stringByAppendingString:[NSString stringWithFormat:@"<div class=\"title\"><h2>%@</h2></div> %@<p></p>",dic[@"title"],dic[@"desc"]]];
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@<p></p>",dic[@"desc"]]];
    }
    [self updateWebVInsideWithContent:string fileName:@"templateMeeting"];
    
    if (_recruitDetail.linker.name.length>0) {
        [self.linkInfo addObject:[NSString stringWithFormat:@"发起人：%@",_recruitDetail.linker.name]];
    }
    if (_recruitDetail.linker.mobile.length>0) {
        [self.linkInfo addObject:[NSString stringWithFormat:@"手机号码：%@",_recruitDetail.linker.mobile]];
    }
    if (_recruitDetail.linker.email.length>0) {
        [self.linkInfo addObject:[NSString stringWithFormat:@"邮箱：%@",_recruitDetail.linker.email]];
    }
    if (_recruitDetail.linker.address.length>0) {
        [self.linkInfo addObject:[NSString stringWithFormat:@"地址：%@",_recruitDetail.linker.address]];
    }
    if (_recruitDetail.linker.phone.length>0) {
        [self.linkInfo addObject:[NSString stringWithFormat:@"电话号码：%@",_recruitDetail.linker.phone]];
    }
    if (_recruitDetail.linker.wechat.length>0) {
        [self.linkInfo addObject:[NSString stringWithFormat:@"微信：%@",_recruitDetail.linker.wechat]];
    }
    if (_recruitDetail.linker.wechat.length>0) {
        [self.linkInfo addObject:[NSString stringWithFormat:@"QQ：%@",_recruitDetail.linker.qq]];
    }
    [_sponsorView reloadData];
}


//获取活动报名人员列表
- (void)getEventApplys:(NSString *)eventId{
    if (eventId.length <= 0) return;
    WeakObj(self);
    [AFNetAPIClient GET:APIGetEventApplys parameters:[RequestParameters getEventApplys:eventId cpage:@"1" pageSize:@"1000"] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray *)model.result;
            self.applysArray = [VolunteerModel arrayOfModelsFromDictionaries:array];
            if (self.applysArray.count > 6) {
                self.tempApplys = [self.applysArray subarrayWithRange:NSMakeRange(0, 5)];
            }
            if (self.applysArray.count > 0) {
                wself.noApplysLabel.hidden = YES;
                [wself.collectionView reloadData];
            }else{
                wself.noApplysLabel.hidden = NO;
            }
        }
    }failure:^(id JSON, NSError *error){
        
    }];
}

//获取招募活动动态信息
- (void)getEventDynamics:(NSString *)eventId{
    if (eventId.length <= 0) return;
    
    [AFNetAPIClient GET:APIGetEventDynamics parameters:[RequestParameters getEventsById:eventId] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray *)model.result;
            self.dynamicsArray = [RecruitDynamic arrayOfModelsFromDictionaries:array];
            
            NSString* contentStr = @"";
            for (RecruitDynamic* dynamic in self.dynamicsArray) {
                
                NSString* string = [NSString stringWithFormat:@"<div class=\"title\"><h4>%@</h4></div> %@<p></p>",dynamic.title,dynamic.content];
                contentStr = [contentStr stringByAppendingString:string];
                
                [self updateWebVInsideWithContent:contentStr fileName:@"template1"];
            }
        }
    }failure:^(id JSON, NSError *error){
        
    }];
}

#pragma mark-
-(void)updateWebVInsideWithContent:(NSString*)_content fileName:(NSString * )name
{
    NSString *html = [self changeToHTML:_content fileName:name];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    if ([name isEqualToString:@"template1"]) {
        [_webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:htmlPath]];
    }else{
        [_descView loadHTMLString:html baseURL:[NSURL fileURLWithPath:htmlPath]];
    }
}


- (NSString *)changeToHTML:(NSString *)string  fileName:(NSString * )name
{
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:name ofType:@"html"];
    NSMutableString *htmlString = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSRange contentRange = [htmlString rangeOfString:@"{content}"];
    if (contentRange.location != NSNotFound) {
        [htmlString replaceCharactersInRange:contentRange withString:string.length>0?string:@""];
    }
    return htmlString;
}

#pragma mark-
- (void)webViewDidFinishLoad:(UIWebView *)webView{
   float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    WeakObj(self);
    [_webView mas_updateConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(height+50);
    }];
    
    [_trendView mas_updateConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(wself.webView);
    }];
}

#pragma mark-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.linkInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellWithIdentifier"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.linkInfo[indexPath.row];
    return cell;
}

#pragma mark-
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        UILabel* label = [UILabel new];
        if (self.applysArray.count > 0){
            label.text = @"已报名";
        }else{
            label.text = @"";
        }

        label.textColor = [UIColor colorWithHexString:@"666666"];
        label.font = [UIFont systemFontOfSize:14];
        [reusableview addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(10);
            make.centerY.equalTo(reusableview);
        }];
    }
    return reusableview;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.applysArray.count > 6) {
        return 6;
    }
    return self.applysArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecruitApplyIcon * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecruitApplyIcon" forIndexPath:indexPath];
    if (self.applysArray.count > 6) {
        if (indexPath.item < 5) {
            VolunteerModel* model = self.applysArray[indexPath.item];
            [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.createUserImg]];
            cell.label.hidden = YES;
        }else{
            cell.iconView.image = nil;
            cell.label.hidden = NO;
        }
    }else{
        VolunteerModel* model = self.applysArray[indexPath.item];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.createUserImg]];
        cell.label.hidden = YES;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark-
- (void)createSubViews{
    self.tagArray = @[@"项目详情",@"项目发起人",@"项目动态"];
    _kButtonWidth = SCREENWIDTH/3;
    
    
    _menuScrollView = [UIScrollView new];
    [self addSubview:_menuScrollView];
    [_menuScrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self);
        make.height.equalTo(53);
    }];
    
    for (UIImageView* subView in _menuScrollView.subviews) {
        [subView removeFromSuperview];
    }
    WeakObj(self);
    UIView* line = [UIView new];
    line.backgroundColor = Colordddddd;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(wself.menuScrollView);
        make.height.equalTo(1);
    }];
    
    
    _bigScrollView = [UIScrollView new];
    _bigScrollView.showsHorizontalScrollIndicator = NO;
    _bigScrollView.showsVerticalScrollIndicator = NO;
    _bigScrollView.pagingEnabled = YES;
    _bigScrollView.delegate = self;
    [self addSubview:_bigScrollView];
    [_bigScrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(wself.menuScrollView.bottom);
    }];
    
    UIButton* tempBtn = nil;
    for (NSInteger i = 0; i < self.tagArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.tagArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:Colore83e0b forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        if (SCREENWIDTH <= 320) {
            button.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuScrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.height.equalTo(wself.menuScrollView);
            make.width.equalTo(wself.kButtonWidth);
            if (tempBtn) {
                make.left.equalTo(tempBtn.right);
            }else{
                make.left.equalTo(0);
            }
        }];
        tempBtn = button;
        
        if (i==0) {
            button.selected = YES;
            _lastButton = button;
        }
    }
    
    _menuRedLineView = [UIView new];
    _menuRedLineView.tag = -1;
    _menuRedLineView.backgroundColor = Colore83e0b;
    [_menuScrollView addSubview:_menuRedLineView];
    [_menuRedLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(0);
        make.top.equalTo(50);
        make.width.equalTo(wself.kButtonWidth);
        make.height.equalTo(3);
    }];
    
    
    _descView = [UIWebView new];
    [_bigScrollView addSubview:_descView];
    [_descView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(self);
        make.width.equalTo(SCREENWIDTH);
    }];
    
    _sponsorView = [UITableView new];
    _sponsorView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _sponsorView.delegate = self;
    _sponsorView.dataSource = self;
    [_bigScrollView addSubview:_sponsorView];
    [_sponsorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(wself.descView.right);
        make.top.equalTo(0);
        make.bottom.equalTo(self);
        make.width.equalTo(SCREENWIDTH);
    }];

    
    _trendView = [UIScrollView new];
    [_bigScrollView addSubview:_trendView];
    [_trendView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(wself.sponsorView.right);
        make.top.equalTo(0);
        make.bottom.equalTo(self);
        make.width.equalTo(SCREENWIDTH);
    }];

    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置横向还是竖向
        flowLayout.itemSize = CGSizeMake((SCREENWIDTH-70)/6.f, (SCREENWIDTH-70)/6.f);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 9;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.headerReferenceSize = CGSizeMake(SCREENWIDTH, 40);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[RecruitApplyIcon class] forCellWithReuseIdentifier:@"RecruitApplyIcon"];
        [_trendView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(wself.trendView);
            make.height.equalTo(100);
            make.width.equalTo(SCREENWIDTH);
        }];
        
        _webView = [UIWebView new];
        _webView.delegate = self;
        [_trendView addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(wself.trendView);
            make.top.equalTo(wself.collectionView.bottom).offset(5);
            make.height.equalTo(100);
            make.width.equalTo(SCREENWIDTH);
        }];
        
        _noApplysLabel = [UILabel new];
        _noApplysLabel.numberOfLines = 0;
        _noApplysLabel.text = @"还没有人报名，赶快行动起来吧。";
        _noApplysLabel.textAlignment = NSTextAlignmentCenter;
        _noApplysLabel.font = [UIFont boldSystemFontOfSize:20];
        [_trendView addSubview:_noApplysLabel];
        [_noApplysLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.top.equalTo(40);
            make.width.equalTo(SCREENWIDTH-30);
        }];
        _noApplysLabel.hidden = YES;
    }
    
    [_bigScrollView mas_updateConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(wself.trendView.right);
    }];
}

- (void)clickButton:(UIButton *)button
{
    _lastButton.selected = NO;
    button.selected = YES;
    _lastButton = button;
    [_menuRedLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lastButton.frame.origin.x);
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

#pragma mark-
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    _lastButton.selected = NO;
    UIButton *button = _menuScrollView.subviews[index];
    if ([button isKindOfClass:[UIButton class]]) {
        button.selected = YES;
        _lastButton = button;
        [_menuRedLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(_lastButton.frame.origin.x));
        }];
    }
}


/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    float xx = scrollView.contentOffset.x * (_kButtonWidth / SCREENWIDTH) - _kButtonWidth;
    [_menuScrollView scrollRectToVisible:CGRectMake(xx, 0, SCREENWIDTH, _menuScrollView.frame.size.height) animated:YES];
}
@end
