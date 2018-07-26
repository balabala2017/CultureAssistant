//
//  WYScrollView.m
//  无忧学堂
//
//  Created by jacke－xu on 16/2/22.
//  Copyright © 2016年 jacke－xu. All rights reserved.
//

#import "WYScrollView.h"
#import "UIImageView+WebCache.h"

#define pageSize 16

//获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define pageColor RGB(0x03, 0xa9, 0xf4)

/** 滚动宽度*/
#define ScrollWidth self.frame.size.width

/** 滚动高度*/
#define ScrollHeight self.frame.size.height

@interface WYScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *PageControl;

@property (nonatomic, assign) NSInteger currentIndex;/** 当前显示的是第几个*/
@property (nonatomic, assign) NSInteger MaxImageCount;/** 图片个数*/
@property (nonatomic, assign) BOOL isNetworkImage;/** 是否是网络图片*/

@end

@implementation WYScrollView

#pragma mark - 网络图片

-(instancetype)initWithFrame:(CGRect)frame WithNetImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if ( self) {
        
        _isNetworkImage = YES;
        _showImageInfo = NO;
        
        if (imageArray.count < 2 ) {
            
            _imageArray = [imageArray copy];
            
            [self onlyInitImageView];
        }
        else
        {
            /** 创建滚动view*/
            [self createScrollView];
            
            /** 加入本地image*/
            [self setImageArray:imageArray];
            
            /** 设置数量*/
            [self setMaxImageCount:_imageArray.count];
        }
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if ( self) {
        
        _isNetworkImage = YES;
        _showImageInfo = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    
    return self;
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    
    for (UIView* subView in self.subviews) {
        [subView removeFromSuperview];
    }
    _scrollView = nil;
    _leftImageView = nil;
    _centerImageView = nil;
    _rightImageView = nil;
    _PageControl = nil;
    
    if (imageArray.count < 2 ) {
        
        _imageArray = [imageArray copy];
        
        [self onlyInitImageView];
    }
    else
    {
        /** 创建滚动view*/
        [self createScrollView];
        
        /** 加入本地image*/
//        [self setImageArray:imageArray];
        
        /** 设置数量*/
        [self setMaxImageCount:_imageArray.count];
    }
}

#pragma mark - 设置数量
- (void)onlyInitImageView {

    UIImageView *centerImageView = [[UIImageView_SD alloc] initWithFrame:CGRectMake(0, 0,ScrollWidth, ScrollHeight)];
    centerImageView.userInteractionEnabled = YES;
    [centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
    [self addSubview:centerImageView];
    
    _centerImageView = centerImageView;

    _currentIndex = 0;
    
    if (_imageArray.count > 0) {
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[_currentIndex]] placeholderImage:_placeholderImage];
    }
}


-(void)setMaxImageCount:(NSInteger)MaxImageCount
{
    _MaxImageCount = MaxImageCount;
    
     /** 复用imageView初始化*/
    [self initImageView];
    
    /** pageControl*/
    [self createPageControl];
    
    /** 定时器*/
    [self setUpTimer];
    
    /** 初始化图片位置*/
    [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
}

- (void)createScrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:scrollView];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        
        /** 复用，创建三个*/
        scrollView.contentSize = CGSizeMake(ScrollWidth * 3, 0);
        _scrollView = scrollView;
    }

    
    /** 设置滚动延时时间*/
    _AutoScrollDelay = 0;
    
    /** 开始显示的是第一个   前一个是最后一个   后一个是第二张*/
    _currentIndex = 0;
    
    
}


- (void)initImageView {
    if (!_leftImageView) {
        UIImageView *leftImageView = [[UIImageView_SD alloc] initWithFrame:CGRectMake(0, 0,ScrollWidth, ScrollHeight)];
        [_scrollView addSubview:leftImageView];
        _leftImageView = leftImageView;
    }
    
    if (!_centerImageView) {
        UIImageView *centerImageView = [[UIImageView_SD alloc] initWithFrame:CGRectMake(ScrollWidth, 0,ScrollWidth, ScrollHeight)];
        [_scrollView addSubview:centerImageView];
        centerImageView.userInteractionEnabled = YES;
        [centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
        _centerImageView = centerImageView;

    }
    
    if (!_rightImageView) {
        UIImageView *rightImageView = [[UIImageView_SD alloc] initWithFrame:CGRectMake(ScrollWidth * 2, 0,ScrollWidth, ScrollHeight)];
        [_scrollView addSubview:rightImageView];
        _rightImageView = rightImageView;
    }

}

//点击事件
- (void)imageViewDidTap
{
    [self.netDelagate didSelectedNetImageAtIndex:_currentIndex];
    [self.localDelagate didSelectedLocalImageAtIndex:_currentIndex];
}

-(void)createPageControl
{
    if (!_PageControl) {
//        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(ScrollWidth-95,ScrollHeight - pageSize,95, 8)];
        UIPageControl *pageControl = [UIPageControl new];
        [self addSubview:pageControl];
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(95);
            make.height.equalTo(8);
            make.bottom.equalTo(self.bottom).offset(-10);
            make.right.equalTo(self.right).offset(-10);
        }];
        _PageControl = pageControl;
    }
    //设置页面指示器的颜色
    _PageControl.pageIndicatorTintColor = [UIColor whiteColor];
    //设置当前页面指示器的颜色
    _PageControl.currentPageIndicatorTintColor = pageColor;
    _PageControl.numberOfPages = _MaxImageCount;
    _PageControl.currentPage = 0;
}

- (void)setShowImageInfo:(BOOL)showImageInfo
{
    _showImageInfo = showImageInfo;
    if (_showImageInfo)
    {
        _PageControl.frame = CGRectMake(ScrollWidth-95,ScrollHeight - pageSize,95, 8);
        if (!_bgView) {
            _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, ScrollHeight - 40, ScrollWidth, 40)];
            _bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.3];
        }
        [self insertSubview:_bgView belowSubview:_PageControl];
        
        if (!_iconView) {
            _iconView = [UIImageView new];
            _iconView.frame = CGRectMake(5, 15, 14, 12.5);
        }
        [_bgView addSubview:_iconView];
        
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, ScrollWidth-25-95, 40)];
            _titleLabel.textColor = [UIColor whiteColor];
            _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        [_bgView addSubview:_titleLabel];

        
        if (self.netDelagate && [self.netDelagate respondsToSelector:@selector(showNetworkImageInfoAtIndex:)]) {
            [self.netDelagate showNetworkImageInfoAtIndex:0];
        }
    }
}

#pragma mark - 定时器

- (void)setUpTimer
{
    if (_AutoScrollDelay < 0.5) return;//太快了

    if (!_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)scorll
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +ScrollWidth, 0) animated:YES];
}

#pragma mark - 给复用的imageView赋值

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{
    if (_isNetworkImage)
    {
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[LeftIndex]] placeholderImage:_placeholderImage];
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[centerIndex]] placeholderImage:_placeholderImage];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[rightIndex]] placeholderImage:_placeholderImage];
     
        if (self.netDelagate && [self.netDelagate respondsToSelector:@selector(showNetworkImageInfoAtIndex:)]) {
            [self.netDelagate showNetworkImageInfoAtIndex:_currentIndex];
        }
    }
    else
    {
        _leftImageView.image = _imageArray[LeftIndex];
        _centerImageView.image = _imageArray[centerIndex];
        _rightImageView.image = _imageArray[rightIndex];
    }
    
    [_scrollView setContentOffset:CGPointMake(ScrollWidth, 0)];
}

#pragma mark - 滚动代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setUpTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //开始滚动，判断位置，然后替换复用的三张图
    [self changeImageWithOffset:scrollView.contentOffset.x];
}

- (void)changeImageWithOffset:(CGFloat)offsetX
{
    if (offsetX >= ScrollWidth * 2)
    {
        _currentIndex++;
        
        if (_currentIndex == _MaxImageCount-1)
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
        }
        else if (_currentIndex == _MaxImageCount)
        {
            
            _currentIndex = 0;
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }
        else
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _PageControl.currentPage = _currentIndex;
    }
    
    if (offsetX <= 0)
    {
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else if (_currentIndex == -1) {
            
            _currentIndex = _MaxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        
        _PageControl.currentPage = _currentIndex;
    }
}

-(void)dealloc
{
    _imageArray = nil;
    [self removeTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - set方法，设置间隔时间

- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay
{
//    if ([DeviceHelper sharedInstance].isPad) return;
    
    if (_imageArray.count < 2) return;
    
    _AutoScrollDelay = AutoScrollDelay;
    
    [self removeTimer];
    [self setUpTimer];
}

#pragma mark-
- (void)appWillResignActive{
    [self removeTimer];
}

- (void)appDidBecomeActive{
    [self setUpTimer];
}

@end
