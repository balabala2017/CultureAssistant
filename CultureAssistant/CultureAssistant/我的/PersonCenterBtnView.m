//
//  PersonCenterBtnView.m
//  CultureCloudApp
//
//  Created by deng qiulin on 17/1/16.
//  Copyright © 2017年 twsm. All rights reserved.
//

#import "PersonCenterBtnView.h"


@implementation PersonCenterButton

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorWithHexString:@"434343"];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.height.equalTo(14);
        }];
        
        WeakObj(self);
        _iconView = [UIImageView new];
        _iconView.backgroundColor = [UIColor clearColor];
        [self addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make){
//            make.width.equalTo(43/2.f);
//            make.height.equalTo(51/2.f);
            make.centerX.equalTo(wself.mas_centerX);
            make.bottom.equalTo(wself.nameLabel.mas_top).offset(-10);
        }];
        
    }
    return self;
}

@end

@interface PersonCenterBtnView ()

@property(nonatomic,strong)NSMutableArray* btnArray;
@end

@implementation PersonCenterBtnView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.btnArray = [NSMutableArray array];
        
        //上面暂时先加一根线
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor colorWithWhite:232/255.f alpha:1.f];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.top.equalTo(self);
            make.height.equalTo(1);
        }];
        
        //横线
        line = [UIView new];
        line.backgroundColor = [UIColor colorWithWhite:235/255.f alpha:1.f];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.equalTo(self);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(1);
        }];
        
        //竖线
        line = [UIView new];
        line.backgroundColor = [UIColor colorWithWhite:235/255.f alpha:1.f];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.bottom.equalTo(self);
            make.left.equalTo(SCREENWIDTH/3);
            make.width.equalTo(1);
        }];
        //竖线
        line = [UIView new];
        line.backgroundColor = [UIColor colorWithWhite:235/255.f alpha:1.f];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.bottom.equalTo(self);
            make.left.equalTo(SCREENWIDTH*2/3);
            make.width.equalTo(1);
        }];
        
        NSArray* imageArray = @[@"person_icon1",@"person_icon2",@"person_icon3",@"person_icon4",@"person_icon5",@"person_icon6"];
        NSArray* nameArray = @[@"待审核(0)",@"待参加(0)",@"服务中(0)",@"待评价(0)",@"待确定(0)",@"我的报名"];
        CGFloat btnWidth = SCREENWIDTH/3;
        CGFloat bthHeight = 188/2;
        for (NSInteger i = 0; i < nameArray.count; i++)
        {
            PersonCenterButton* button = [[PersonCenterButton alloc] initWithFrame:CGRectMake((i%3)*btnWidth, (i/3)*bthHeight, btnWidth, bthHeight)];
            button.iconView.image = [UIImage imageNamed:imageArray[i]];
            button.nameLabel.text = nameArray[i];
            [self addSubview:button];
            button.tag = i;
            [button addTarget:self action:@selector(tapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnArray addObject:button];
        }
        

        line = [UIView new];
        line.backgroundColor = [UIColor colorWithWhite:232/255.f alpha:1.f];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-7);
            make.height.equalTo(1);
        }];
        
        
        UIView* view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:244/255.f alpha:1.f];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(7);
        }];
        
        line = [UIView new];
        line.backgroundColor = [UIColor colorWithWhite:232/255.f alpha:1.f];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@1);
        }];
        
    }
    return self;
}

- (void)refreshContent
{
    NSArray* nameArray;
    if ([UserInfoManager sharedInstance].isAlreadyLogin){
        UserModel* user = [UserInfoManager sharedInstance].userModel;
        nameArray = @[[NSString stringWithFormat:@"待审核(%@)",user.pendingNum.length>0?user.pendingNum:@"0"],
                      [NSString stringWithFormat:@"待参加(%@)",user.toStayInNum.length>0?user.toStayInNum:@"0"],
                      [NSString stringWithFormat:@"服务中(%@)",user.inServiceNum.length>0?user.inServiceNum:@"0"],
                      [NSString stringWithFormat:@"待评价(%@)",user.evaluateNum.length>0?user.evaluateNum:@"0"],
                      [NSString stringWithFormat:@"待确定(%@)",user.identifiedNum.length>0?user.identifiedNum:@"0"],
                               @"我的报名"];
    }else{
        nameArray = @[@"待审核(0)",@"待参加(0)",@"服务中(0)",@"待评价(0)",@"待确定(0)",@"我的报名"];
    }

    for (NSInteger i = 0; i < self.btnArray.count; i++) {
        PersonCenterButton* button = self.btnArray[i];
        button.nameLabel.text = nameArray[i];
    }
}

- (void)tapButtonAction:(UIButton *)sender
{
    PersonCenterButton* button = (PersonCenterButton *)sender;

    if (self.gotoPersonBehaviourVC) {
        self.gotoPersonBehaviourVC(button.tag);
    }
    
}

@end
