//
//  RecruitDetailTopView.m
//  CultureAssistant
//


#import "RecruitDetailTopView.h"

@interface RecruitDetailTopView ()
@property(nonatomic,strong)UIImageView_SD* coverView;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* areaLabel;
@property(nonatomic,strong)UILabel* typeLabel;
@property(nonatomic,strong)UILabel* dateLabel;
@property(nonatomic,strong)UIView* progressView;
@property(nonatomic,strong)UILabel* progressLabel;

@property(nonatomic,strong)RecruitTextView* textView1;
@property(nonatomic,strong)RecruitTextView* textView2;
@property(nonatomic,strong)RecruitTextView* textView3;
@property(nonatomic,strong)RecruitTextView* textView4;

@property(nonatomic,strong)CAGradientLayer *gradient;
@end


@implementation RecruitDetailTopView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _coverView = [UIImageView_SD new];
        [self addSubview:_coverView];
        [_coverView mas_makeConstraints:^(MASConstraintMaker* make){
            make.top.left.right.equalTo(self);
            make.height.equalTo(SCREENWIDTH*564/750.f);
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = Color333333;
        _titleLabel.text = @"中国盲人图书馆图书录入";
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.right.equalTo(self.right).offset(-15);
            make.top.equalTo(self.coverView.bottom).offset(15);
        }];
        if (SCREENWIDTH <= 320) {
            _titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        UIImageView* areaImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small_location"]];
        [self addSubview:areaImage];
        [areaImage mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.top.equalTo(self.titleLabel.bottom).offset(15);
        }];
        
        _areaLabel = [UILabel new];
        _areaLabel.font = [UIFont systemFontOfSize:12];
        _areaLabel.textColor = Color999999;
        _areaLabel.text = @"湖南";
        [self addSubview:_areaLabel];
        [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(areaImage);
            make.left.equalTo(areaImage.right).offset(5);
            make.right.equalTo(self.right).offset(-5);
        }];
        if (SCREENWIDTH <= 320) {
            _areaLabel.font = [UIFont systemFontOfSize:10];
        }
        
        UILabel* label = [UILabel new];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = Color999999;
        label.text = @"服务类别:";
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(areaImage);
            make.top.equalTo(self.areaLabel.bottom).offset(7);
        }];
        if (SCREENWIDTH <= 320) {
            label.font = [UIFont systemFontOfSize:10];
        }
        
        _typeLabel = [UILabel new];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.textColor = [UIColor colorWithHexString:@"00a0e9"];
        _typeLabel.layer.borderWidth = 1;
        _typeLabel.layer.borderColor = [UIColor colorWithHexString:@"00a0e9"].CGColor;
        _typeLabel.layer.cornerRadius = 4;
        _typeLabel.text = @"服务类别";
        [self addSubview:_typeLabel];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label.right).offset(5);
            make.centerY.equalTo(label);
            make.width.equalTo(58);
            make.height.equalTo(16);
        }];
        if (SCREENWIDTH <= 320) {
            _typeLabel.font = [UIFont systemFontOfSize:10];
        }
        
        UILabel* label1 = [UILabel new];
        label1.font = [UIFont systemFontOfSize:12];
        label1.textColor = Color999999;
        label1.text = @"服务时间:";
        [self addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(areaImage);
            make.top.equalTo(self.typeLabel.bottom).offset(7);
        }];
        if (SCREENWIDTH <= 320) {
            label1.font = [UIFont systemFontOfSize:10];
        }
        
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [UIColor colorWithHexString:@"00a0e9"];
        _dateLabel.text = @"2017.04.05至2017.04.05";
        [self addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(label1.right).offset(5);
            make.centerY.equalTo(label1);
        }];
        if (SCREENWIDTH <= 320) {
            _dateLabel.font = [UIFont systemFontOfSize:10];
        }
        
        _progressView = [UIView new];
        _progressView.backgroundColor = [UIColor colorWithHexString:@"c2c2c2"];
        _progressView.layer.cornerRadius = 1.5;
        [self addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.dateLabel.bottom).offset(13);
            make.left.equalTo(15);
            make.right.equalTo(self.right).offset(-15);
            make.height.equalTo(3);
        }];
        
        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, 0, 0, 3);
        _gradient.locations = @[@0.0, @0.5, @1.0];
        _gradient.startPoint = CGPointMake(0, 0);
        _gradient.endPoint = CGPointMake(1.0, 0);
        _gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor colorWithHexString:@"5ac5ff"].CGColor,
                           (id)[UIColor colorWithHexString:@"54aaf7"].CGColor,
                           (id)[UIColor colorWithHexString:@"5194f0"].CGColor, nil];
        [_progressView.layer addSublayer:_gradient];
        
        
        _progressLabel = [UILabel new];
        _progressLabel.backgroundColor = [UIColor whiteColor];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:12];
        _progressLabel.textColor = [UIColor colorWithHexString:@"00a0e9"];
        _progressLabel.layer.borderWidth = 1;
        _progressLabel.layer.borderColor = [UIColor colorWithHexString:@"00a0e9"].CGColor;
        _progressLabel.layer.cornerRadius = 8;
        _progressLabel.text = @"0%";
        _progressLabel.clipsToBounds = YES;
        [self addSubview:_progressLabel];
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.progressView);
            make.left.equalTo(15);
            make.width.equalTo(40);
            make.height.equalTo(16);
        }];
        
        CGFloat width = (SCREENWIDTH-30)/4;
        CGFloat height = 40;
        
        _textView1 = [RecruitTextView new];
        _textView1.topLabel.text = @"支持人数";
        [self addSubview:_textView1];
        [_textView1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.progressView.bottom).offset(20);
            make.left.equalTo(15);
            make.width.equalTo(width);
            make.height.equalTo(height);
        }];
        
        
        _textView2 = [RecruitTextView new];
        _textView2.topLabel.text = @"报名人数";
        [self addSubview:_textView2];
        [_textView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.width.height.equalTo(self.textView1);
            make.left.equalTo(self.textView1.right);
        }];
        
        _textView3 = [RecruitTextView new];
        _textView3.topLabel.text = @"服务对象";
        [self addSubview:_textView3];
        [_textView3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.width.height.equalTo(self.textView1);
            make.left.equalTo(self.textView2.right);
        }];
        
        _textView4 = [RecruitTextView new];
        _textView4.topLabel.text = @"报名结束时间";
        [self addSubview:_textView4];
        [_textView4 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.width.height.equalTo(self.textView1);
            make.left.equalTo(self.textView3.right);
        }];
        
    }
    return self;
}

- (void)setRecruitDetail:(RecruitDetail *)recruitDetail{
    _recruitDetail = recruitDetail;
    
    [_coverView sd_setImageWithURL:[NSURL URLWithString:recruitDetail.eventPhoto] placeholderImage:nil];
    _titleLabel.text = recruitDetail.eventName;
    _areaLabel.text = recruitDetail.eventAddr;
    _dateLabel.text = [NSString stringWithFormat:@"%@至%@",recruitDetail.eventStartDate,recruitDetail.eventEndDate];
    
    _progressLabel.text = [NSString stringWithFormat:@"%.f%@",[recruitDetail.recruitRate floatValue]*100,@"%"];
    
    
    _gradient.frame = CGRectMake(0, 0, (SCREENWIDTH-30)*[recruitDetail.recruitRate floatValue], 3);

    if ([recruitDetail.recruitRate intValue] == 1) {
        [_progressLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(SCREENWIDTH-15-40);
        }];
    }else{
        [_progressLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15+(SCREENWIDTH-30)*[recruitDetail.recruitRate floatValue]);
        }];
    }


    NSArray* array = [recruitDetail.desire.serviceTypeNames componentsSeparatedByString:@","];
    if (array.count > 0) {
        _typeLabel.text = array[0];

        CGSize size = [_typeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}context:nil].size;
        
        [_typeLabel mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(size.width+10);
        }];
    }
    
    _textView1.bottomLabel.text = [NSString stringWithFormat:@"%@人",recruitDetail.planRecruitNum];
    _textView2.bottomLabel.text = [NSString stringWithFormat:@"%@人",recruitDetail.hasRecruitNum];
    
    if (recruitDetail.desire.serviceObjectNames.length > 0) {
        NSArray* array = [recruitDetail.desire.serviceObjectNames componentsSeparatedByString:@","];
        if (array.count > 0) {
            _textView3.bottomLabel.text = array[0];
        }
    }
    
    if (recruitDetail.recruitEndDate.length > 0) {
        NSArray* array = [recruitDetail.recruitEndDate componentsSeparatedByString:@" "];
        if (array.count > 0) {
            _textView4.bottomLabel.text = array[0];
        }
    }
    
}

@end
