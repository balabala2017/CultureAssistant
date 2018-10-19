//
//  APCutViewController.m
//  CultureAssistant
//
//  Created by zhu yingmin on 2018/10/19.
//  Copyright © 2018年 天闻. All rights reserved.
//

#import "APCutViewController.h"
#import "APCutSelView.h"
#import "XMTool.h"

@interface APCutViewController ()
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) APCutSelView *showView;
@property (nonatomic, assign) CGFloat imgRotation;
@end

@implementation APCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%s",__func__);
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton * cancelBtn = [UIButton new];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(onTapCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.equalTo(CGSizeMake(44, 44));
        make.top.equalTo(STATUS_BAR_HEIGHT);
        make.left.equalTo(20);
    }];
    
    
    NSArray* array = @[@"旋转+",@"旋转-",@"切图"];
    CGFloat btnWidth = SCREENWIDTH/3.f;
    
    for (NSInteger i = 0; i < array.count; i ++)
    {
        UIButton * button = [UIButton new];
        button.tag = i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(onTapButtonFun:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.size.equalTo(CGSizeMake(btnWidth, 44));
            make.bottom.equalTo(-HOME_INDICATOR_HEIGHT);
            make.left.equalTo(i*btnWidth);
        }];
    }
    
    
    self.showView = [APCutSelView new];
    [self.view addSubview:self.showView];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cancelBtn.bottom).offset(50);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(-50-HOME_INDICATOR_HEIGHT);
    }];
    
    self.showView.orgImg = self.originalImage;
}

- (id)initWithImage:(UIImage *)originalImage{
    self = [super init];
    if (self) {

        NSLog(@"%s  %@",__func__,originalImage);
        self.originalImage = originalImage;
        
        
        
        
    }
    return self;
}

#pragma mark- 按钮点击事件
- (void)onTapCancelBtn:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)onTapButtonFun:(UIButton *)button
{
    switch (button.tag) {
        case 0:
        {
            self.imgRotation += M_PI/18/5;
            self.showView.rotationAngle = self.imgRotation;
        }
            break;
            
        case 1:
        {
            self.imgRotation -= M_PI/18/5;
            self.showView.rotationAngle = self.imgRotation;
        }
            break;
            
        case 2:
        {
            typeof(self) __weak wself = self ;
            [self.showView imageFromCurrent:^(UIImage *img) {
                [wself.delegate cutPhoto:img];
                
                [wself dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
        }
            break;
        default:
            break;
    }
}
@end
