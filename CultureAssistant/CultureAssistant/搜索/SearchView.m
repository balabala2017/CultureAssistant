//
//  SearchView.m
//  CultureAssistant
//


#import "SearchView.h"

#pragma mark-  搜索历史  热门搜索  方块
@interface SearchItemCell :UICollectionViewCell
@property(nonatomic,strong)UIButton * button;
@property(nonatomic,weak)id delegate;

@end;

@implementation SearchItemCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_button setTitleColor:[UIColor colorWithHexString:@"222222"] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        _button.backgroundColor = [UIColor clearColor];
        _button.clipsToBounds  = YES;
        [self addSubview:_button];
        _button.enabled = NO;
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end

#pragma mark- 搜索历史  热门搜索  区域
@interface SearchViewTableCell :UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UIView * view;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray * hotNewsArr;
@property (nonatomic,strong)NSArray * historyArr;
@property (nonatomic,weak)id  delegate;
@property (nonatomic,assign)BOOL isHistoryCell;

-(void)showHotNewsWithData:(NSArray *) newsList;
@end

@implementation SearchViewTableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _view = [UIView new];
        _view.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_view];
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-10);
            
        }];
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置横向还是竖向
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0 ,0) collectionViewLayout:flowLayout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[SearchItemCell class] forCellWithReuseIdentifier:@"SearchItemCell"];
        [_view addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        
    }
    return self;
}

-(void)showHotNewsWithData:(NSArray *) newsList
{
    self.hotNewsArr = newsList;
    self.isHistoryCell = NO;
    [_collectionView reloadData];
}

-(void)showHistoryWithData:(NSArray *) historyList
{
    self.historyArr = historyList;
    self.isHistoryCell = YES;
    [_collectionView reloadData];
}

#pragma mark -- UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isHistoryCell) {
        return self.historyArr.count;
    }
    return self.hotNewsArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"SearchItemCell";
    SearchItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor =[UIColor clearColor];
    cell.button.tag = indexPath.row;
    cell.delegate = self;
    
    HotKeyItem * item;
    if (self.isHistoryCell) {
        item = [self.historyArr objectAtIndex:indexPath.item];
    }else{
        item = [self.hotNewsArr objectAtIndex:indexPath.item];
    }
    [cell.button setTitle:item.KEY forState:UIControlStateNormal];
    if (item.ID) {
        UIImage * image = [UIImage imageNamed:@"hotKey_back"];
        image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        [cell.button setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        [cell.button setBackgroundImage:nil forState:UIControlStateNormal];
    }
    cell.frame = CGRectFromString(item.newsFrame);
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotKeyItem * item;
    if (self.isHistoryCell) {
        item = [self.historyArr objectAtIndex:indexPath.row];
    }else{
        item = [self.hotNewsArr objectAtIndex:indexPath.row];
    }
    
    
    CGRect rect = CGRectFromString(item.newsFrame);
    return  CGSizeMake(rect.size.width, rect.size.height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 18;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isHistoryCell) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickHistoryKey:)]) {
            [self.delegate performSelector:@selector(clickHistoryKey:) withObject:[NSNumber numberWithInteger:indexPath.item]];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickHotKey:)]) {
            [self.delegate performSelector:@selector(clickHotKey:) withObject:[NSNumber numberWithInteger:indexPath.item]];
        }
    }
    
}

@end

#pragma mark- 搜索类型面板
@interface TypeView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIButton * preButton;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UIView* contentView;

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSArray* dataArray;
@end

@implementation TypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.3;
        [self addSubview:_backgroundView];
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
        _backgroundView.userInteractionEnabled = YES;
        [_backgroundView addGestureRecognizer:tap];
        
        
        _contentView = [UIView new];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(0);
            make.left.equalTo(25);
            make.width.equalTo(112);
            make.height.equalTo(125.5);
        }];
        
        WeakObj(self);
        UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_typeArrow"]];
        [_contentView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(wself.contentView.mas_top);
            make.centerX.equalTo(wself.contentView);
            make.width.equalTo(9);
            make.height.equalTo(5.5);
        }];

        self.dataArray = @[@"全部",@"资讯",@"招募"];
        
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TypeCell"];
        _tableView.layer.cornerRadius = 6;
        [_contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(arrow.mas_bottom);
            make.left.right.bottom.equalTo(wself.contentView);
        }];
        
        UIView* lastLine = nil;
        for (NSInteger i = 0; i < 2; i++) {
            UIView* lineView = [UIView new];
            lineView.backgroundColor = [UIColor colorWithWhite:204/255.f alpha:1.f];
            [_tableView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make){
                if (lastLine) {
                    make.top.equalTo(lastLine.mas_bottom).offset(40);
                }else{
                    make.top.equalTo(40);
                }
                make.left.right.equalTo(wself.tableView);
                make.height.equalTo(1);
            }];
            lastLine = lineView;
        }
        
        self.isShow = YES;
    }
    return self;
}

#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* type = @"";
    switch (indexPath.row) {
        case 0:
            type = @"";
            break;
        case 1:
            type = @"0";
            break;
        case 2:
            type = @"6";
            break;
        default:
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectType:)]) {
        [self.delegate performSelector:@selector(selectType:) withObject:@[self.dataArray[indexPath.row],type]];
    }
    
    [self hidden];
}

#pragma mark-
- (void)hidden
{
    [UIView animateWithDuration:0.3 animations:^{

    } completion:^(BOOL finished) {
        self.isShow = NO;
        self.hidden = YES;
    }];
}

-(void)show
{
    self.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        self.isShow = YES;
        
    }];
    
}
@end

#pragma mark-
@interface SearchView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *searchTitleLabel;

@property (nonatomic, assign)  BOOL isFirst;//标识是否点击搜索按钮
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSArray *searchHistoryList;//搜索历史
@property (nonatomic, strong) NSArray *recentHotList;//近期热点
@property (nonatomic, strong) NSArray *searchNewsList;//搜索记录

@property (nonatomic, strong) NSDictionary * hotNewsAllDic;
@property (nonatomic, strong) NSArray * hotSortArr;

@property (nonatomic, assign) NSInteger cpage;
@property (nonatomic, strong) BlankContentView* blankView;
@end

@implementation SearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _isFirst = YES;
        
        _isShowSearchNewsList = NO;
        self.dataList = [NSMutableArray array];
        
        
        _tableV = [UITableViewSub new];
        [self addSubview:_tableV];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.backgroundColor = [UIColor clearColor];
        [_tableV registerClass:[InfoCommonCell class] forCellReuseIdentifier:@"InfoCommonCell"];
        [_tableV registerClass:[InfoTextCell class] forCellReuseIdentifier:@"InfoTextCell"];
        [_tableV registerClass:[InfoImagesCell class] forCellReuseIdentifier:@"InfoImagesCell"];
        [_tableV registerClass:[SearchViewTableCell class] forCellReuseIdentifier:@"SearchViewTableCell"];
        [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(@10);
        }];
        
        _cpage = 1;
        
        typeof(self) __weak wself = self;
        _tableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.cpage = 1;
            [wself searchWithKey:self.searchKey withPageIndex:@"1"];
        }];
        _tableV.mj_footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{
            self.cpage++;
            [wself searchWithKey:self.searchKey withPageIndex:[NSString stringWithFormat:@"%ld",(long)self.cpage]];
        }];
        
        _tableV.mj_header.hidden = YES;
        _tableV.mj_footer.hidden = YES;
        
        self.blankView = [BlankContentView new];
        [_tableV addSubview:self.blankView];
        [self.blankView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.tableV);
            make.width.height.equalTo(300);
        }];
        self.blankView.hidden = YES;

    }
    return self;
}

-(void)showTypeAndHotKeyWithData:(NSDictionary *)typeAndKeys withSortArray:(NSArray *)sortArr
{
    self.hotNewsAllDic = typeAndKeys;
    self.hotSortArr = sortArr;
}

-(void)showHotNewsWithData:(NSArray *)array
{
    _tableV.mj_header.hidden = YES;
    _tableV.mj_footer.hidden = YES;
    
    self.recentHotList = array;
    [_tableV reloadData];
}


-(void)showHistoryNewsWithData:(NSArray *) newsList
{
    _tableV.mj_header.hidden = YES;
    _tableV.mj_footer.hidden = YES;
    self.searchHistoryList = newsList;
    [_tableV reloadData];
}

-(void)showSearchNewsWithData:(ArticleList *) listModel
{
    _tableV.mj_header.hidden = NO;
    _tableV.mj_footer.hidden = NO;
    if (listModel == nil) {
        return;
    }
    
    _isShowSearchNewsList = YES;
    
    if ([listModel.pageNumber intValue]>=[listModel.totalPage intValue]) {
        [_tableV.mj_footer endRefreshingWithNoMoreData];
    }else{
        [_tableV.mj_footer endRefreshing];
    }
    [_tableV.mj_header endRefreshing];
    
    self.searchNewsList = listModel.list;
    [_tableV reloadData];
}

#pragma mark-
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isShowSearchNewsList) {
        return 1;
    }
    NSInteger count = 1;
    if (self.searchHistoryList.count>0) {
        count = 2;
    }
    return count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_isShowSearchNewsList) {
        return nil;
    }
    
    UIView * _headView = [UIView new];
    _headView.backgroundColor = [UIColor whiteColor];
    
    UILabel * label =[UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = [UIColor colorWithWhite:153/255.f alpha:1.f];
    NSString * text = @"    近期热点";
    if (section == 1)
    {
        text = @"    搜索历史";
        label.textColor = Color666666;
        UIButton * delBtn = [UIButton buttonWithImageNormal:[UIImage imageNamed:@"trash"] imageSelected:[UIImage imageNamed:@"trash"] imageEdge:UIEdgeInsetsMake(10, 0, 10, 70) title:@"清空记录" target:self action:@selector(deleteHistory:)];
        [delBtn setTitleColor:Color999999 forState:UIControlStateNormal];
        delBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [_headView addSubview:delBtn];
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_headView);
            make.width.equalTo(100);
        }];
    }
    label.text = text;
    [_headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_headView);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithWhite:215/255.f alpha:1.f];
    [_headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(1);
        make.left.equalTo(12);
        make.right.equalTo(_headView.mas_right).offset(-12);
        make.bottom.equalTo(_headView);
    }];
    return _headView ;
}

-(void)deleteHistory:(UIButton *)sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:nil forKey:SearchHistoryKey];
    [userdefaults synchronize];
    
    [self showHistoryNewsWithData:nil];
}


#pragma mark-
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isShowSearchNewsList) {
        return 0;
    }
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isShowSearchNewsList) {
        if (self.searchNewsList.count == 0) {
            self.blankView.hidden = NO;
        }else{
            self.blankView.hidden = YES;
        }
        return self.searchNewsList.count;
    }else{
        self.blankView.hidden = YES;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isShowSearchNewsList)
    {
        ArticleItem* item = self.searchNewsList[indexPath.row];
        if ([item.TYPE isEqualToString:@"0"] && [item.ARTICLE_TYPE isEqualToString:@"1"]) {
            return 66+(SCREENWIDTH-22)/4;
        }
        if (item.COVER_IMG_URL.length <= 0) {
            return [InfoTextCell heightForCell:item];
        }
        return [InfoCommonCell heightForCell];
    }
    
    CGFloat height = 50;
    if (indexPath.section == 0)
    {
        HotKeyItem * item = self.recentHotList.lastObject;
        CGRect rect = CGRectFromString(item.newsFrame);
        
        height = rect.origin.y + rect.size.height + 30;
    }
    else
    {
        HotKeyItem * item = self.searchHistoryList.lastObject;
        CGRect rect = CGRectFromString(item.newsFrame);
        
        height = rect.origin.y + rect.size.height + 30;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isShowSearchNewsList)
    {
        ArticleItem* item = self.searchNewsList[indexPath.row];
        
        //objType  分类ID（0:资讯；1：活动；2：资源；3：众筹）
        if ([item.TYPE isEqualToString:@"0"] && [item.ARTICLE_TYPE isEqualToString:@"1"]) {
            InfoImagesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InfoImagesCell"];
            [cell setContent:item];
            return cell;
        }
        
        if (item.COVER_IMG_URL.length > 0) {
            InfoCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCommonCell"];
            [cell setContent:item];
            return cell;
        }else{
            InfoTextCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTextCell"];
            [cell setContent:item];
            return cell;
        }
    }
    else
    {
        if (indexPath.section == 0) {
            static NSString * tableViewHotCellStatic = @"SearchViewTableCell";
            SearchViewTableCell * cell = [tableView dequeueReusableCellWithIdentifier:tableViewHotCellStatic];;
            cell.delegate = self;
            [cell showHotNewsWithData:self.recentHotList];
            return cell;
        }
        else
        {
            
            static NSString * reuseIdentifier = @"SearchViewTableCell";
            SearchViewTableCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];;
            cell.delegate = self;
            [cell showHistoryWithData:self.searchHistoryList];
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isShowSearchNewsList && self.searchNewsList.count > 0)
    {
        ArticleItem* item = self.searchNewsList[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(gotoDetailViewController:)]) {
            [self.delegate performSelector:@selector(gotoDetailViewController:) withObject:item];
        }
    }
}
#pragma mark-

-(void)searchWithKey:(NSString *)string withPageIndex:(NSString *)pageIndex
{
    _searchKey = string;
    if (_searchType.length <= 0) {
        _searchType = @"";
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(doSearch:)]) {
        [self.delegate performSelector:@selector(doSearch:) withObject:@[string, _searchType,pageIndex]];
    }
}

-(void)clickHotKey:(NSNumber *)hotKeyIndex
{
    HotKeyItem * item = [self.recentHotList objectAtIndex: [hotKeyIndex integerValue]];
    [self searchWithKey:item.KEY withPageIndex:@"1"];
}

-(void)clickHistoryKey:(NSNumber *)historyIndex
{
    HotKeyItem *item = [self.searchHistoryList objectAtIndex: [historyIndex integerValue]];
    [self searchWithKey:item.KEY withPageIndex:@"1"];
}


@end
