//
//  ScanningViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/14.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "ScanningViewController.h"
#import "CameraTopView.h"


@interface ScanningViewController ()<DCScanBackDelegate>
/* 顶部工具View */
@property (nonatomic, strong) CameraTopView *cameraTopView;
@end

@implementation ScanningViewController

#pragma mark - LifeCyle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
    
    [self setUpTopView];
    
//    [self setUpBottomView];
}

#pragma mark - initialize
- (void)setUpBase
{
    self.scanDelegate = self;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - 导航栏处理
- (void)setUpTopView
{
    _cameraTopView = [[CameraTopView alloc] init];
    typeof(self) __weak wself = self;
    _cameraTopView.leftItemClickBlock = ^{
        [wself.navigationController popViewControllerAnimated:YES];
    };
    
    _cameraTopView.rightItemClickBlock = ^{
        [wself flashButtonClick:wself.flashButton];
    };
    
    _cameraTopView.rightRItemClickBlock = ^{
        [wself jumpPhotoAlbum];
    };
    
    [self.view addSubview:_cameraTopView];
    [_cameraTopView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(NAVIGATION_BAR_HEIGHT);
    }];
}
//- (void)setUpBottomView
//{
//    UIView *bottomView = [UIView new];
//    bottomView.frame = CGRectMake(0, SCREENHEIGHT - 65, SCREENWIDTH, 50);
//    
//    UILabel *supLabel = [UILabel new];
//    supLabel.text = @"支持扫描";
//    supLabel.font = self.tipLabel.font;
//    supLabel.textAlignment = NSTextAlignmentCenter;
//    supLabel.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
//    supLabel.frame = CGRectMake(0, 0, SCREENWIDTH, 20);
//    [bottomView addSubview:supLabel];
//    
//    NSArray *titles = @[@"快递单",@"物价码",@"二维码"];
//    NSArray *images = @[@"",@"",@""];
//    CGFloat btnW = (ScreenW - 80) / titles.count;
//    CGFloat btnH = bottomView.dc_height - supLabel.dc_bottom - 5;
//    CGFloat btnX;
//    CGFloat btnY = supLabel.frame.size.height + supLabel.frame.origin.y + 5;
//    for (NSInteger i = 0; i < titles.count; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.titleLabel.font = [UIFont systemFontOfSize:12];
//        [button setTitle:titles[i] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
//        [button setTitleColor:RGBA(245, 245, 245, 1) forState:UIControlStateNormal];
//        
//        btnX = 40 + (i * btnW);
//        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
//        [bottomView addSubview:button];
//    }
//    
//    [self.view addSubview:bottomView];
//}

#pragma mark - <DCScanBackDelegate>
- (void)DCScanningSucessBackWithInfor:(NSString *)message
{
    NSLog(@"代理回调扫描识别结果%@",message);
    if (message.length > 0) {
        ScanResult* result = [[ScanResult alloc] initWithString:message error:nil];
        
        [self signEvent:result.id];
    }

//    !_feedbackScanningResult?:_feedbackScanningResult(message);
//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)signEvent:(NSString *)eventId
{
    NSDictionary* dic = @{@"eventId":eventId};
    dic = [[RequestHelper sharedInstance] prepareRequestparameter:dic];
    
    typeof(self) __weak wself = self;
    [AFNetAPIClient POST:APISignEvent parameters:dic success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        
        [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        
        [wself performSelector:@selector(onBack) withObject:nil afterDelay:1.f];
        
    } failure:^(id JSON, NSError *error){
        if ([JSON isKindOfClass:[DataModel class]]) {
            DataModel* model = (DataModel *)JSON;
            [MBProgressHUD MBProgressHUDWithView:self.view Str:model.msg];
        }
        [wself performSelector:@selector(onBack) withObject:nil afterDelay:1.f];
    }];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
