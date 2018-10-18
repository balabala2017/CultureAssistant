//
//  CameraTopView.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/14.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "CameraTopView.h"

@interface CameraTopView ()
/* 左边Item */
@property (strong , nonatomic)UIButton *leftItemButton;
/* 右边Item */
@property (strong , nonatomic)UIButton *rightItemButton;
/* 右边第二个Item */
@property (strong , nonatomic)UIButton *rightRItemButton;
@end

@implementation CameraTopView
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _leftItemButton = ({
        UIButton * button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(leftButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
//    _rightItemButton = ({
//        UIButton * button = [UIButton new];
//        [button setImage:[UIImage imageNamed:@"starsq_sandbox-btn_camera_light"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(rightButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
//        button;
//    });
//
    _rightRItemButton = ({
        UIButton * button = [UIButton new];
//        [button setImage:[UIImage imageNamed:@"scan_photo_album"] forState:UIControlStateNormal];
        [button setTitle:@"相册" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightRButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
//    [self addSubview:_rightItemButton];
    [self addSubview:_rightRItemButton];
    [self addSubview:_leftItemButton];
}


#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
//    [_leftItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(20);
//        make.left.equalTo(self.mas_left).offset(10);
//        make.height.equalTo(35);
//        make.width.equalTo(35);
//    }];
    _leftItemButton.frame = CGRectMake(0, STATUS_BAR_HEIGHT, 44, 44);
    
//    [_rightItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.leftItemButton.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.height.equalTo(35);
//        make.width.equalTo(35);
//    }];
//
    [_rightRItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftItemButton.centerY);
        make.right.equalTo(-10);
        make.height.equalTo(44);
        make.width.equalTo(44);
    }];
    
}


#pragma 自定义右边导航Item点击
- (void)rightButtonItemClick {
    !_rightItemClickBlock ? : _rightItemClickBlock();
}

#pragma 自定义左边导航Item点击
- (void)leftButtonItemClick {
    
    !_leftItemClickBlock ? : _leftItemClickBlock();
}

#pragma mark - 自定义右边第二个导航Item点击
- (void)rightRButtonItemClick
{
    !_rightRItemClickBlock ? : _rightRItemClickBlock();
}
@end
