//
//  MRZoomScrollView.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRZoomScrollViewDelegate <NSObject>

@optional
- (void)imageViewHaveHidden;

@end


@interface MRZoomScrollView : UIView <UIScrollViewDelegate>


@property (nonatomic, strong)NSString * imageUrl;//通过url加载图片
@property (nonatomic, strong)UIImage * image;//通过image加载图片
@property (nonatomic, assign)BOOL needTapGesture;

@property (nonatomic, weak) id<MRZoomScrollViewDelegate> delegate;
@end
