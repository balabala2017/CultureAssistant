//
//  VolunteerInfoView.m
//  CultureAssistant
//


#import "VolunteerInfoView.h"

@interface VolunteerInfoView ()
@property(nonatomic,strong)UILabel* nameLabel;//姓名
@property(nonatomic,strong)UILabel* sexLabel;//性别
@property(nonatomic,strong)UILabel* areaLabel;//注册地点
@property(nonatomic,strong)UILabel* dateLabel;//注册日期
@property(nonatomic,strong)UILabel* numberLabel;//编号
@end

@implementation VolunteerInfoView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        VolunteerInfo* volunteer = [UserInfoManager sharedInstance].volunteer;
        
        UIButton* btn = [UIButton new];
        btn.backgroundColor = BaseColor;
        [btn setTitle:@"修改信息" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(40);
            make.bottom.left.right.equalTo(self);
        }];
        
        
        UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"volunteer_bg.jpg"]];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(20, 20, 50, 20));
        }];
        
        
        UILabel* label1 = [self profileLabel];
        label1.text = @"姓        名";
        [self addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(50);
            make.top.equalTo(220);
        }];
        
        _nameLabel = [self valueLabel];
        _nameLabel.text = volunteer.realName;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label1.right).offset(20);
            make.top.equalTo(label1);
        }];
        
        UILabel* label2 = [self profileLabel];
        label2.text = @"性        别";
        [self addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label1);
            make.top.equalTo(label1.bottom).offset(10);
        }];
        
        _sexLabel = [self valueLabel];
        _sexLabel.text = [volunteer.sex intValue] == 1?@"女":@"男";
        [self addSubview:_sexLabel];
        [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label2.right).offset(20);
            make.top.equalTo(label2);
        }];
        
        UILabel* label3 = [self profileLabel];
        label3.text = @"注册地点";
        [self addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label2);
            make.top.equalTo(label2.bottom).offset(10);
        }];
        
        _areaLabel = [self valueLabel];
        _areaLabel.text = volunteer.areaName;
        [self addSubview:_areaLabel];
        [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label3.right).offset(20);
            make.top.equalTo(label3);
        }];
        
        UILabel* label4 = [self profileLabel];
        label4.text = @"注册日期";
        [self addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label3);
            make.top.equalTo(label3.bottom).offset(10);
        }];
        
        NSArray* array ;
        if([volunteer.registerDate length] > 0){
            array = [volunteer.registerDate componentsSeparatedByString:@" "];
        }
        
        _dateLabel = [self valueLabel];
        _dateLabel.text = array.count>1?array[0]:@"";
        [self addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label4.right).offset(20);
            make.top.equalTo(label4);
        }];
        
        UILabel* label5 = [self profileLabel];
        label5.text = @"编        号";
        [self addSubview:label5];
        [label5 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label4);
            make.top.equalTo(label4.bottom).offset(10);
        }];
        
        _numberLabel = [self valueLabel];
        _numberLabel.text = volunteer.volunteNo;
        [self addSubview:_numberLabel];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label5.right).offset(20);
            make.top.equalTo(label5);
        }];
        
    }
    return self;
}

- (void)onTapButton:(id)sender{
    if (self.removeInfoViewToModify) {
        self.removeInfoViewToModify();
    }
}

- (UILabel *)profileLabel{
    UILabel* label = [UILabel new];
    label.textColor = [UIColor colorWithRed:0xec/255.f green:0x24/255.f blue:0x1d/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:18];
    return label;
}

- (UILabel *)valueLabel{
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:18];
    return label;
}
@end
