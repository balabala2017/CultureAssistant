//
//  APCutViewController.m
//  CultureAssistant
//
//  Created by zhu yingmin on 2018/10/19.
//  Copyright © 2018年 天闻. All rights reserved.
//

#import "APCutViewController.h"


@interface APCutViewController ()

@property (nonatomic, weak) JPImageresizerView *imageresizerView;
@end

@implementation APCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    
    NSArray* array = @[@"旋转",@"裁剪"];
    CGFloat btnWidth = SCREENWIDTH/2.f;
    
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
    

    __weak typeof(self) wSelf = self;
    JPImageresizerView *imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:self.configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;

    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;

    }];
    [self.view insertSubview:imageresizerView atIndex:0];
    
    self.imageresizerView = imageresizerView;
    self.imageresizerView.resizeWHScale = 85.6 / 54.0;

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
            [self.imageresizerView rotation];
        }
            break;
            
        case 1:
        {
            __weak typeof(self) weakSelf = self;
            [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                
                if (!resizeImage) {
                    NSLog(@"没有裁剪图片");
                    return;
                }
                
                [strongSelf.delegate cutPhoto:resizeImage];
                
                [strongSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
        }
            break;
        default:
            break;
    }
}
@end
