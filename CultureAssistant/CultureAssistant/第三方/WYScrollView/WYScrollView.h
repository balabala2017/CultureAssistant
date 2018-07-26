//
//  WYScrollView.h
//  无忧学堂
//
//  Created by jacke－xu on 16/2/22.
//  Copyright © 2016年 jacke－xu. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 遵循该代理就可以监控到网络滚动视图的index*/

@protocol WYScrollViewNetDelegate <NSObject>

@optional

/** 点中网络滚动视图后触发*/
-(void)didSelectedNetImageAtIndex:(NSInteger)index;

-(void)showNetworkImageInfoAtIndex:(NSInteger)index;
@end

/** 遵循该代理就可以监控到本地滚动视图的index*/

@protocol WYScrollViewLocalDelegate <NSObject>

@optional

/** 点中本地滚动视图后触发*/
-(void)didSelectedLocalImageAtIndex:(NSInteger)index;



@end

@interface WYScrollView : UIView

@property (nonatomic, strong) NSArray *imageArray;

/** 选中网络图片的索引*/
@property (nonatomic, weak) id <WYScrollViewNetDelegate> netDelagate;

/** 选中本地图片的索引*/
@property (nonatomic, weak) id <WYScrollViewLocalDelegate> localDelagate;

/** 占位图*/
@property (nonatomic, strong) UIImage *placeholderImage;

/** 滚动延时*/
@property (nonatomic, assign) NSTimeInterval AutoScrollDelay;

//展示图片信息 pageControl往右移
@property (nonatomic, assign) BOOL showImageInfo;
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* titleLabel;

/**
 *  本地图片
 *
 *  @param frame      位置
 *  @param imageArray 加载本地图片
 *
 *  @return self
 */
//- (instancetype) initWithFrame:(CGRect)frame WithLocalImages:(NSArray *)imageArray;

/**
 *  加载网络图片
 *
 *  @param frame      位置大小
 *  @param imageArray 名字
 *
 *  @return self
 */
- (instancetype) initWithFrame:(CGRect)frame WithNetImages:(NSArray *)imageArray;

@end
