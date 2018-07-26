//
//  MRZoomScrollView.m
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import "MRZoomScrollView.h"

#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@interface MRZoomScrollView ()

@property (nonatomic, strong) UIScrollView * scrollV;
@property (nonatomic, assign) BOOL isHeight;
@property (nonatomic, strong) UIImageView * selfImageV;

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation MRZoomScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.needTapGesture = YES;
        
        _scrollV = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollV.backgroundColor = [UIColor clearColor];
        _scrollV.delegate = self;
        [self addSubview:_scrollV];
        
        // Need setting the app only support portrait orientation?
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    }
    return self;
}


-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    if (!_selfImageV) {
        _selfImageV = [[UIImageView alloc] initWithFrame:self.bounds];
        
    }
    
    typeof(self) __weak wself = self;
    [_selfImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl]  placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            wself.selfImageV.image = image;
        }
        wself.selfImageV.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [wself imageVAutoSizeWith:wself.selfImageV];
    }];
    _selfImageV.userInteractionEnabled = YES;
    [_scrollV addSubview:_selfImageV];

    // Add gesture,double tap zoom imageView.
    if (self.needTapGesture)
    {
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [_selfImageV addGestureRecognizer:doubleTapGesture];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleSingleTap:)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [_scrollV addGestureRecognizer:singleTapGesture];
        
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }

//    [_scrollV setMinimumZoomScale:1];
//    [_scrollV setMaximumZoomScale:4];
//    [_scrollV setZoomScale:1];

}

- (void)setImage:(UIImage *)image
{
    _image = image;
    if (!_selfImageV) {
        _selfImageV = [[UIImageView_SD alloc] initWithFrame:self.bounds];
    }
    
    _selfImageV.image = image;
    [self imageVAutoSizeWith:_selfImageV];
    
    _selfImageV.userInteractionEnabled = YES;
    [_scrollV addSubview:_selfImageV];
    
    // Add gesture,double tap zoom imageView.
    if (self.needTapGesture)
    {
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [_selfImageV addGestureRecognizer:doubleTapGesture];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handleSingleTap:)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [_scrollV addGestureRecognizer:singleTapGesture];
        
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    }

}
#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale = _scrollV.zoomScale * 1.5;
    WeakObj(self);
    [UIView animateWithDuration:.3 animations:^{
        [wself.scrollV setZoomScale:newScale];
    }];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gesture
{
    [UIView animateWithDuration:.5 animations:^{
        self.hidden = YES;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewHaveHidden)]) {
            [self.delegate performSelector:@selector(imageViewHaveHidden)];
        }
    }];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _selfImageV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat width= scrollView.frame.size.width;
    CGFloat height= scrollView.frame.size.height;
    if(width>scrollView.contentSize.width)
    {
        width =(width-scrollView.contentSize.width)/2;
    }
    else
    {
        width = 0;
    }
    if(height>scrollView.contentSize.height)
    {
        height =(height-scrollView.contentSize.height)/2;
    }
    else
    {
        height = 0;
    }
    _selfImageV.center = CGPointMake(scrollView.contentSize.width/2+width, scrollView.contentSize.height/2+height);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale// scale between minimum and maximum. called after any 'bounce' animations
{

}

-(void)imageVAutoSizeWith:(UIImageView *)sender
{
    UIImage * image = sender.image;
    
    CGSize imageSize = image.size;
    sender.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*((imageSize.height/(imageSize.width+0.001))));
    sender.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
}

- (void)orientationDidChange:(NSNotification *)notification {
    
    UIImage * image = _selfImageV.image;
    CGSize imageSize = image.size;
    if (imageSize.height > imageSize.width) return;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:{
            _selfImageV.userInteractionEnabled = YES;
            _selfImageV.transform = CGAffineTransformIdentity;
            [self imageVAutoSizeWith:_selfImageV];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:{
            _selfImageV.userInteractionEnabled = NO;
            CGAffineTransform at =CGAffineTransformMakeRotation(M_PI/2);
            at = CGAffineTransformTranslate(at,0,0);
            [_selfImageV setTransform:at];
            
            UIImage * image = _selfImageV.image;
            CGSize imageSize = image.size;
            _selfImageV.frame = CGRectMake(0, 0,  self.frame.size.width, self.frame.size.width*(imageSize.width+0.001)/imageSize.height);
            _selfImageV.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);

        }
            break;
        case UIDeviceOrientationLandscapeRight:

            break;
        case UIDeviceOrientationPortraitUpsideDown:

            break;
        default:
            break;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
