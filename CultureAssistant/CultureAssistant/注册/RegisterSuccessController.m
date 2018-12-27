//
//  RegisterSuccessController.m
//  CultureAssistant
//
//  Created by zhu yingmin on 2018/12/26.
//  Copyright © 2018年 天闻. All rights reserved.
//

#import "RegisterSuccessController.h"

@interface RegisterSuccessController ()

@end

@implementation RegisterSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* maskView = [UIView new];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.3];
    [self.view addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMaskView:)]];
    
    
    UIView* whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 6;
    whiteView.layer.masksToBounds = YES;
    [self.view addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self.view);
        make.height.equalTo(230);
        make.left.equalTo(20);
        make.right.equalTo(self.view.right).offset(-20);
    }];
    
    UILabel* label = [UILabel new];
    label.text = @"志愿者注册结果";
    label.textColor = BaseColor;
    label.font = [UIFont systemFontOfSize:18];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(10);
        make.left.equalTo(15);
    }];
    
    UIView* line1 = [UIView new];
    line1.backgroundColor = BaseColor;
    [whiteView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label.bottom).offset(10);
        make.height.equalTo(1);
        make.left.right.equalTo(whiteView);
    }];
    
    
    UIButton* btn = [UIButton new];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:btn];
    [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(whiteView);
        make.height.equalTo(40);
    }];
    
    UIView* line2 = [UIView new];
    line2.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [whiteView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(btn.top);
        make.height.equalTo(1);
        make.left.right.equalTo(whiteView);
    }];
    
    label = [UILabel new];
    label.numberOfLines = 2;
    label.textColor = [UIColor colorWithHexString:@"333333"];
    label.text = @"志愿者注册成功，审核已通过";
    label.font = [UIFont systemFontOfSize:22];
    [whiteView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(whiteView);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    
}

- (void)onTapMaskView:(UITapGestureRecognizer *)gesture{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)onTapButton:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
