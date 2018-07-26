//
//  TextFontSliderView.m
//  CultureAssistant
//


#import "TextFontSliderView.h"


@interface TextFontSliderView ()

@property(nonatomic,strong)UIView* whiteView;
@property(nonatomic,strong)UISlider* slider;
@end

@implementation TextFontSliderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView* bgView = [UIView new];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [self addSubview:bgView];
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTextFontView:)]];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        
        self.whiteView = [[UIView alloc] init];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whiteView];
        
        UIFont* textFont = [UIFont systemFontOfSize:16];
        
        UIButton* btn1 = [UIButton new];
        btn1.tag = 1;
        [btn1 setTitle:@"小" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn1.titleLabel.font = textFont;
        btn1.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.whiteView addSubview:btn1];
        [btn1 addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.top.equalTo(self.whiteView);
            make.width.equalTo(@(SCREENWIDTH/5));
            make.height.equalTo(@60);
        }];
        
        UIButton* btn2 = [UIButton new];
        btn2.tag = 2;
        [btn2 setTitle:@"中" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn2.titleLabel.font = textFont;
        btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.whiteView addSubview:btn2];
        [btn2 addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(btn1.mas_top);
            make.left.equalTo(btn1.mas_right);
            make.width.equalTo(btn1.mas_width);
            make.height.equalTo(btn1.mas_height);
        }];
        
        UIButton* btn3 = [UIButton new];
        btn3.tag = 3;
        [btn3 setTitle:@"大" forState:UIControlStateNormal];
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn3.titleLabel.font = textFont;
        btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.whiteView addSubview:btn3];
        [btn3 addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(btn1.mas_top);
            make.left.equalTo(btn2.mas_right);
            make.width.equalTo(btn1.mas_width);
            make.height.equalTo(btn1.mas_height);
        }];
        
        UIButton* btn4 = [UIButton new];
        btn4.tag = 4;
        [btn4 setTitle:@"超大" forState:UIControlStateNormal];
        [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn4.titleLabel.font = textFont;
        btn4.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.whiteView addSubview:btn4];
        [btn4 addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn4 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(btn1.mas_top);
            make.left.equalTo(btn3.mas_right);
            make.width.equalTo(btn1.mas_width);
            make.height.equalTo(btn1.mas_height);
        }];
        
        
        UIButton* btn5 = [UIButton new];
        btn5.tag = 5;
        [btn5 setTitle:@"极大" forState:UIControlStateNormal];
        [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn5.titleLabel.font = textFont;
        btn5.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.whiteView addSubview:btn5];
        [btn5 addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn5 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(btn1.mas_top);
            make.left.equalTo(btn4.mas_right);
            make.width.equalTo(btn1.mas_width);
            make.height.equalTo(btn1.mas_height);
        }];
        
        self.slider = [UISlider new];
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 1;
        self.slider.continuous = YES;
        self.slider.minimumTrackTintColor = BaseColor;
        self.slider.maximumTrackTintColor = [UIColor grayColor];
        [self.slider setThumbImage:[UIImage imageNamed:@"slider_font"] forState:UIControlStateNormal];
        [self.whiteView addSubview:self.slider];
        [self.slider addTarget:self action:@selector(changeSliderValue:) forControlEvents:UIControlEventValueChanged];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(btn1.mas_bottom).offset(5);
            make.left.equalTo(self.whiteView.mas_left).offset(20);
            make.right.equalTo(self.whiteView.mas_right).offset(-20);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (void)setSliderValue:(CGFloat)sliderValue{
    _sliderValue = sliderValue;
    self.slider.value = sliderValue;
}

- (void)changeSliderValue:(UISlider *)sender{
    if (self.slider.value < 0.13) {
        self.slider.value = 0;
    }
    else if (self.slider.value >= 0.13 && self.slider.value < 0.38) {
        self.slider.value = 0.25;
    }
    else if (self.slider.value >= 0.38 && self.slider.value < 0.63) {
        self.slider.value = 0.5;
    }
    else if (self.slider.value >= 0.63 && self.slider.value < 0.88) {
        self.slider.value = 0.75;
    }
    else {
        self.slider.value = 1;
    }
    if (self.changeTextFontHandler) {
        self.changeTextFontHandler(sender.value);
    }
}

- (void)onTapButton:(UIButton *)sender
{
    UIButton* btn = sender;
    switch (btn.tag) {
        case 1:
            self.slider.value = 0;
            break;
        case 2:
            self.slider.value = 0.25;
            break;
        case 3:
            self.slider.value = 0.5;
            break;
        case 4:
            self.slider.value = 0.75;
            break;
        case 5:
            self.slider.value = 1;
            break;
        default:
            break;
    }
    if (self.changeTextFontHandler) {
        self.changeTextFontHandler(self.slider.value);
    }
}

- (void)showSliderView{
    self.whiteView.frame = CGRectMake(0, -100, SCREENWIDTH, 100);
    [UIView animateWithDuration:.5 animations:^{
        self.whiteView.frame = CGRectMake(0, 0, SCREENWIDTH, 100);
    }];
}

- (void)hideSliderView{
    self.whiteView.frame = CGRectMake(0, -100, SCREENWIDTH, 100);
}

- (void)dismissTextFontView:(UITapGestureRecognizer *)gesture{
    if (self.dismissFontSliderHandler) {
        self.dismissFontSliderHandler();
    }
}

@end
