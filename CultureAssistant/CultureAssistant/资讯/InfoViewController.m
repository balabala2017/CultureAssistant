//
//  InfoViewController.m
//  CultureAssistant
//


#import "InfoViewController.h"
#import "InfoListViewController.h"

#define ChannelHeight  51.f

@interface InfoViewController ()<UIScrollViewDelegate>

@property (nonatomic,assign) CGFloat kButtonWidth;
@property (nonatomic,strong) UIScrollView *menuScrollView;
@property (nonatomic,strong) UIScrollView *bigScrollView;
@property (nonatomic,strong) UIButton *lastButton;
@property (nonatomic,strong) UIView * menuRedLineView;
@property (nonatomic,strong) UIView * arrowView;
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)setSubChannelsArr:(NSArray *)subChannelsArr{
    _subChannelsArr = subChannelsArr;

    if (_subChannelsArr.count > 1)
    {
        [self creatSubviews];
        [self addChildController];
    }
    else if (_subChannelsArr.count == 1)
    {
        InfoListViewController *infoVC = [[InfoListViewController alloc] init];
        [self addChildViewController:infoVC];
        infoVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64-44);
        ChannelModel* channel = _subChannelsArr[0];
        infoVC.channelid = channel.ID;
        InfoListViewController *vc = [self.childViewControllers firstObject];
        [self.view addSubview:vc.view];
    }
    
}

- (void)creatSubviews
{
    _kButtonWidth = SCREENWIDTH/3;
    if (_subChannelsArr.count < 5) {
        _kButtonWidth = SCREENWIDTH/_subChannelsArr.count;
    }else{
        _kButtonWidth = 100;
    }
    
    _menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, ChannelHeight)];
    _menuScrollView.contentSize = CGSizeMake(_kButtonWidth * _subChannelsArr.count, 40);
    _menuScrollView.showsHorizontalScrollIndicator = NO;
    _menuScrollView.backgroundColor = [UIColor whiteColor];
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
   
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"dedede"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.menuScrollView.left);
        make.bottom.equalTo(self.menuScrollView.bottom);
        make.right.equalTo(self.menuScrollView.right);
        make.height.equalTo(1);
    }];
    
    _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ChannelHeight, SCREENWIDTH, SCREENHEIGHT-64-TabBarHeight-ChannelHeight)];
    _bigScrollView.backgroundColor = [UIColor whiteColor];
    _bigScrollView.contentSize = CGSizeMake(SCREENWIDTH*_subChannelsArr.count, _bigScrollView.bounds.size.height);
    _bigScrollView.showsHorizontalScrollIndicator = NO;
    _bigScrollView.showsVerticalScrollIndicator = NO;
    _bigScrollView.pagingEnabled = YES;
    _bigScrollView.delegate = self;
    [self.view addSubview:_bigScrollView];
    
    
    for (NSInteger i = 0; i < _subChannelsArr.count; i++)
    {
        ChannelModel* channel = _subChannelsArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*_kButtonWidth, 0, _kButtonWidth, ChannelHeight);
        [button setTitle:channel.NAME forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"0288d1"] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        if (SCREENWIDTH <= 320) {
            button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
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
    _menuRedLineView.backgroundColor = [UIColor colorWithHexString:@"0288d1"];
    [self.menuScrollView addSubview:_menuRedLineView];
    [_menuRedLineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(0);
        make.top.equalTo(TabBarHeight-3);
        make.width.equalTo(self.kButtonWidth);
        make.height.equalTo(3);
    }];
    
}

- (void)addChildController
{
    for (NSInteger i = 0; i < _subChannelsArr.count; i++) {
        InfoListViewController *infoVC = [[InfoListViewController alloc] init];
        [self addChildViewController:infoVC];
        
        ChannelModel* channel = _subChannelsArr[i];
        infoVC.channelid = channel.ID;

    }
    
    // 添加默认控制器
    InfoListViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
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
    
    NSLog(@"=========xxx  %f",xx);
    
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
    
    [UIView animateWithDuration:.5f animations:^{
        self.arrowView.hidden = index == self.subChannelsArr.count - 1?YES:NO;
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
    
    InfoListViewController *infoVC = self.childViewControllers[index];
    if (infoVC.view.superview) return;
    infoVC.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:infoVC.view];
}


/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [self scrollViewDidEndScrollingAnimation:scrollView];
    float xx = scrollView.contentOffset.x * (_kButtonWidth / SCREENWIDTH) - _kButtonWidth;
    [_menuScrollView scrollRectToVisible:CGRectMake(xx, 0, SCREENWIDTH, _menuScrollView.frame.size.height) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_bigScrollView.contentOffset.x < -50) {

    }
}



@end
