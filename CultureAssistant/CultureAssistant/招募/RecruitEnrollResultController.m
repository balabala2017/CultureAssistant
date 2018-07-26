//
//  RecruitEnrollResultController.m
//  CultureAssistant
//

#import "RecruitEnrollResultController.h"

@interface RecruitEnrollResultController ()

@end

@implementation RecruitEnrollResultController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView* bgView = [UIView new];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = .5;
    [self.view addSubview:bgView];
    [bgView makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController:)]];
    
    
    UIView *whiteBg = [UIView new];
    whiteBg.layer.cornerRadius = 6;
    whiteBg.layer.masksToBounds = YES;
    whiteBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBg];
    [whiteBg makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(250);
        make.height.equalTo(280);
        make.center.equalTo(self.view);
    }];
    
    UIImageView* colorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_colorBar"]];
    [whiteBg addSubview:colorView];
    [colorView makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.equalTo(whiteBg);
        make.height.equalTo(90);
    }];
    
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = @"您的报名已经提交";
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor whiteColor];
    [colorView addSubview:titleLabel];
    [titleLabel makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(colorView);
        make.bottom.equalTo(colorView.bottom).offset(-20);
    }];
    
    UILabel* label = [UILabel new];
    label.text = @"感谢您的报名，管理人员会尽快审核。";
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:15];
    [whiteBg addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(colorView.bottom).offset(25);
        make.left.equalTo(20);
        make.right.equalTo(whiteBg.right).offset(-20);
    }];
    
    UIButton* button = [UIButton new];
    [button setTitleColor:BaseColor forState:UIControlStateNormal];
    [button setTitle:@"知道了" forState:UIControlStateNormal];
    button.layer.cornerRadius = 20;
    button.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    [whiteBg addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(20);
        make.right.equalTo(whiteBg.right).offset(-20);
        make.height.equalTo(40);
        make.bottom.equalTo(whiteBg.bottom).offset(-20);
    }];
    [button addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton* closeBtn = [UIButton new];
    [closeBtn setImage:[UIImage imageNamed:@"circle_close"] forState:UIControlStateNormal];
    [whiteBg addSubview:closeBtn];
    [closeBtn makeConstraints:^(MASConstraintMaker *make){
        make.width.height.equalTo(44);
        make.right.top.equalTo(0);
    }];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeAction:(UIButton *)button{
    typeof(self) __weak wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (wself.enrollFinishedHandler) {
            wself.enrollFinishedHandler();
        }
    }];
}

- (void)dismissController:(UITapGestureRecognizer *)recognizer{
    typeof(self) __weak wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (wself.enrollFinishedHandler) {
            wself.enrollFinishedHandler();
        }
    }];
}

@end
