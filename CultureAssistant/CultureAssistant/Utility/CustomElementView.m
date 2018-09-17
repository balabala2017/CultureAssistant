//
//  CustomElementView.m
//  CultureAssistant
//


#import "CustomElementView.h"
#import "WYScrollView.h"

@implementation CustomElementView

@end
#pragma mark-
@interface CityHeaderView ()
@property(nonatomic,strong) UILabel * label;
@end

@implementation CityHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:.9 alpha:1.f];
        _label = [UILabel labelWithText:@"热门访问" textAlign:NSTextAlignmentLeft textFont:[UIFont systemFontOfSize:14]];
        _label.textColor = [UIColor colorWithWhite:.4 alpha:1.f];
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(10);
            make.right.bottom.equalTo(self).offset(-10);
        }];
        
    }
    return self;
}
-(void)title:(NSString *)title
{
    _label.text = title;
}
@end

@interface CitySquareCell ()

@property(nonatomic,strong)UILabel * label;
@end

@implementation CitySquareCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _label = [UILabel labelWithText:@"袁腾飞讲历史" textAlign:NSTextAlignmentCenter textFont:[UIFont systemFontOfSize:15]];
        _label.textColor = [UIColor blackColor];
        _label.backgroundColor = [UIColor whiteColor];
        _label.layer.borderWidth = .5;
        _label.layer.borderColor = [UIColor colorWithWhite:.8 alpha:1].CGColor;
        _label.layer.cornerRadius = 5;
        _label.clipsToBounds = YES;
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            
        }];
    }
    return self;
}

-(void)title:(NSString *)title
{
    _label.text = title;
}
@end

@interface CityItemCell ()

@property(nonatomic,strong)UILabel * label;
//@property(nonatomic,strong)UIImageView * selectImageV;
@property(nonatomic,strong)UIButton * arrowButton;
@property(nonatomic,strong)CityModel * cityModel;
@end

@implementation CityItemCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * lineV = [UIView new];
        lineV.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self addSubview:lineV];
        [lineV makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(.5);
        }];
        
        _label = [UILabel labelWithText:@"袁腾飞讲历史" textAlign:NSTextAlignmentLeft textFont:[UIFont systemFontOfSize:15]];
        _label.userInteractionEnabled = YES;
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-50);
        }];
        [_label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLabel:)]];

//        _selectImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"city_selected"]];
//        _selectImageV.backgroundColor = [UIColor clearColor];
//        [self addSubview:_selectImageV];
//        [_selectImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
//            make.right.equalTo(self).offset(-10);
//            make.width.height.equalTo(15);
//        }];
        
        
        _arrowButton = [UIButton new];
        [_arrowButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        [self addSubview:_arrowButton];
        [_arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self);
            make.width.equalTo(30);
            make.height.equalTo(40);
        }];
        [_arrowButton addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)cityItem:(CityModel *)item
{
    self.cityModel = item;
    
//    _selectImageV.hidden = ![item.isSelected boolValue];
    _label.text = item.AREA_NAME;
}

- (void)onTapLabel:(UITapGestureRecognizer *)gesture{
    NSLog(@"%s",__func__);
    if (self.seletctCityHandle) {
        self.seletctCityHandle(self.cityModel,self.indexPath);
    }
}

- (void)onTapButton:(id)sender{
    if (self.showLibraryHandle) {
        self.showLibraryHandle(self.cityModel);
    }
}
@end

#pragma mark- 场馆
@interface LibraryCell ()
@property(nonatomic,strong)UIImageView* imgView;
@end

@implementation LibraryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"space_selected"]];
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.right.equalTo(self.right).offset(-10);
            make.width.height.equalTo(15);
        }];

        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(15);
            make.right.equalTo(self.imgView.left).offset(-10);
        }];
        

    }
    return self;
}

- (void)setChoosed:(BOOL)choosed{
    self.imgView.hidden = !choosed;
}
@end

#pragma mark-
@interface InfoTableViewCell ()
@property(nonatomic,strong)UIView* baseView;
@end

@implementation InfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.baseView = [UIView new];
        [self.contentView addSubview:self.baseView];
        [self.baseView mas_makeConstraints:^(MASConstraintMaker* make){
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"c2c2c2"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(5);
            make.right.equalTo(-5);
            make.height.equalTo(1.0f/[UIScreen mainScreen].scale);
        }];
    }
    return self;
}

- (void)setContent:(ArticleItem *)item{
    
}

+ (CGFloat)heightForCell:(ArticleItem *)item{
    return 0;
}
@end

#pragma mark-
@interface InfoCommonCell ()
@property(nonatomic,strong)UIImageView_SD* iconView;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* dateLabel;
@property(nonatomic,strong)UILabel* readCountLabel;
@end

@implementation InfoCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconView = [UIImageView_SD new];
        self.iconView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [self.baseView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.equalTo(self.baseView);
            make.height.equalTo(89);
            make.width.equalTo(113);
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"212121"];
        self.titleLabel.numberOfLines = 2;
        if (SCREENWIDTH < 375) {
            self.titleLabel.font = [UIFont systemFontOfSize:15];
        }else{
            self.titleLabel.font = [UIFont systemFontOfSize:18];
        }
        [self.baseView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.baseView.top);
            make.left.equalTo(self.iconView.right).offset(15);
            make.right.equalTo(self.baseView.right);
            make.height.greaterThanOrEqualTo(20);
        }];
        
        self.dateLabel = [UILabel new];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        [self.baseView addSubview:self.dateLabel];
        self.dateLabel.textColor = Color666666;
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.titleLabel.left);
            make.bottom.equalTo(self.iconView);
        }];
        
        self.readCountLabel = [UILabel new];
        self.readCountLabel.backgroundColor = [UIColor clearColor];
        self.readCountLabel.textAlignment = NSTextAlignmentRight;
        self.readCountLabel.textColor = Color666666;
        self.readCountLabel.font = [UIFont systemFontOfSize:12];
        [self.baseView addSubview:self.readCountLabel];
        [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.titleLabel.right);
            make.bottom.equalTo(self.iconView.bottom);
        }];
        
        UIImageView* readIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye_icon"]];
        [self.baseView addSubview:readIcon];
        [readIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.readCountLabel.left).offset(-5);
            make.centerY.equalTo(self.readCountLabel);
        }];
    }
    return self;
}

- (void)setContent:(ArticleItem *)item{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:item.COVER_IMG_URL] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.titleLabel.text = item.TITLE;
    if (item.PUBLISH_TIME) {
        NSArray* tempArray = [item.PUBLISH_TIME componentsSeparatedByString:@" "];
        if (tempArray.count > 1) {
            self.dateLabel.text = [tempArray objectAtIndex:0];
        }
    }
    if (item.READ_COUNT) {
        self.readCountLabel.text = [NSString stringWithFormat:@"%@",item.READ_COUNT];
    }
    
}


+ (CGFloat)heightForCell{
    return 109;
}


@end

#pragma mark-
@interface InfoImagesCell ()
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIImageView_SD* leftImageView;
@property(nonatomic,strong)UIImageView_SD* midImageView;
@property(nonatomic,strong)UIImageView_SD* rightImageView;
@property(nonatomic,strong)UILabel* dateLabel;
@property(nonatomic,strong)UILabel* readCountLabel;
@end

@implementation InfoImagesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"212121"];
        if (SCREENWIDTH < 375) {
            self.titleLabel.font = [UIFont systemFontOfSize:15];
        }else{
            self.titleLabel.font = [UIFont systemFontOfSize:18];
        }
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.baseView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.top.right.equalTo(self.baseView);
            make.height.greaterThanOrEqualTo(20);
        }];
        
        self.leftImageView = [UIImageView_SD new];
        [self.baseView addSubview:self.leftImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.titleLabel.bottom).offset(5);
            make.left.equalTo(self.baseView);
            make.width.equalTo((SCREENWIDTH-22)/3.0);
            make.height.equalTo(self.leftImageView.width).multipliedBy(3/4.0);
        }];
        
        
        self.midImageView = [UIImageView_SD new];
        [self.baseView addSubview:self.midImageView];
        [self.midImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.leftImageView);
            make.left.equalTo(self.leftImageView.right).offset(1);
            make.width.height.equalTo(self.leftImageView);
        }];
        
        
        self.rightImageView = [UIImageView_SD new];
        [self.baseView addSubview:self.rightImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.leftImageView);
            make.left.equalTo(self.midImageView.right).offset(1);
            make.width.height.equalTo(self.leftImageView);
        }];
        
        self.dateLabel = [UILabel new];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textColor = [UIColor colorWithHexString:@"666666"];;
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        [self.baseView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.leftImageView.bottom).offset(5);
            make.left.equalTo(self.baseView);
        }];
        
        self.readCountLabel = [UILabel new];
        self.readCountLabel.textColor = [UIColor colorWithHexString:@"666666"];;
        self.readCountLabel.font = [UIFont systemFontOfSize:12];
        self.readCountLabel.backgroundColor = [UIColor clearColor];
        self.readCountLabel.textAlignment = NSTextAlignmentRight;
        [self.baseView addSubview:self.readCountLabel];
        [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.dateLabel);
            make.right.equalTo(self.baseView);
        }];
        
        UIImageView* readIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye_icon"]];
        [self.baseView addSubview:readIcon];
        [readIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.readCountLabel.left).offset(-5);
            make.centerY.equalTo(self.readCountLabel);
        }];
    }
    return self;
}

- (void)setContent:(ArticleItem *)item{
    
    if (item.ATTACH_JSONSTR.length <= 0) return;
    
    self.titleLabel.text = item.TITLE;
    
    NSArray* array = [NSJSONSerialization JSONObjectWithData:[item.ATTACH_JSONSTR dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingMutableContainers error:nil];
    
    for (NSInteger i = 0; i < array.count; i++) {
        if (i == 0) {
            NSDictionary* dic = array[0];
            [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"picUrl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
        if (i == 1) {
            NSDictionary* dic = array[1];
            [self.midImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"picUrl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
        if (i == 2) {
            NSDictionary* dic = array[2];
            [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"picUrl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        }
    }
    
    if (item.PUBLISH_TIME) {
        NSArray* tempArray = [item.PUBLISH_TIME componentsSeparatedByString:@" "];
        if (tempArray.count > 1) {
            self.dateLabel.text = [tempArray objectAtIndex:0];
        }
    }
    if (item.READ_COUNT) {
        self.readCountLabel.text = [NSString stringWithFormat:@"%@",item.READ_COUNT];
    }
}

+ (CGFloat)heightForCell:(ArticleItem *)item{
    return 66+(SCREENWIDTH-22)/4;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews) {
        if (![control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            continue;
        }
        
        for (UIView *subView in control.subviews) {
            if (![subView isKindOfClass: [UIImageView class]]) {
                continue;
            }
            
            UIImageView *imageView = (UIImageView *)subView;
            if (self.selected) {
                [imageView setValue:BaseColor forKey:@"tintColor"];   // 选中时的颜色
            }
        }
    }
}

@end

#pragma mark-
@interface InfoADImageCell ()
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIImageView* adImageView;
@property(nonatomic,strong)UILabel* descLabel;
@property(nonatomic,strong)UILabel* dateLabel;
@property(nonatomic,strong)UILabel* readCountLabel;
@property(nonatomic,strong)UILabel* tipLabel;
@end

@implementation InfoADImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"212121"];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.baseView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.top.right.equalTo(self.baseView);
            make.height.greaterThanOrEqualTo(20);
        }];
        
        self.tipLabel = [UILabel new];
        self.tipLabel.backgroundColor = [UIColor colorWithWhite:153/255.f alpha:1.f];
        self.tipLabel.layer.cornerRadius = 2;
        self.tipLabel.layer.masksToBounds = YES;
        self.tipLabel.text = @"推广";
        self.tipLabel.textColor = [UIColor whiteColor];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.font = [UIFont systemFontOfSize:9];
        [self.baseView addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.baseView);
            make.bottom.equalTo(self.baseView.bottom);
            make.width.equalTo(25);
            make.height.equalTo(13);
        }];
        
        self.descLabel = [UILabel new];
        self.descLabel.backgroundColor = [UIColor clearColor];
        self.descLabel.textColor =  [UIColor colorWithHexString:@"666666"];
        self.descLabel.text = @"专题";
        self.descLabel.font = [UIFont systemFontOfSize:12];
        [self.baseView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.tipLabel.right).offset(5);
            make.bottom.equalTo(self.baseView.bottom);
            make.height.equalTo(16);
        }];
        
        
        self.dateLabel = [UILabel new];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textColor = [UIColor colorWithHexString:@"666666"];;
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        [self.baseView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.descLabel.right).offset(5);
            make.bottom.equalTo(self.baseView.bottom);
        }];
        
        self.readCountLabel = [UILabel new];
        self.readCountLabel.textColor = [UIColor colorWithHexString:@"666666"];;
        self.readCountLabel.font = [UIFont systemFontOfSize:12];
        self.readCountLabel.backgroundColor = [UIColor clearColor];
        self.readCountLabel.textAlignment = NSTextAlignmentRight;
        [self.baseView addSubview:self.readCountLabel];
        [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.dateLabel);
            make.right.equalTo(self.baseView);
        }];
        
        UIImageView* readIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye_icon"]];
        [self.baseView addSubview:readIcon];
        [readIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.readCountLabel.left).offset(-5);
            make.centerY.equalTo(self.readCountLabel);
        }];
        
        self.adImageView = [UIImageView_SD new];
        [self.baseView addSubview:self.adImageView];
        [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.left.right.equalTo(self.baseView);
            make.bottom.equalTo(self.tipLabel.top).offset(-10);
        }];
        
        
    }
    return self;
}

- (void)setContent:(ArticleItem *)item{
    
    self.titleLabel.text = item.TITLE;
    
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:item.COVER_IMG_URL] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
    if ([item.LABEL length] > 0) {
        self.descLabel.text = item.LABEL;
    }else{
        self.readCountLabel.text = @"";
    }
    
    if (item.PUBLISH_TIME) {
        NSArray* tempArray = [item.PUBLISH_TIME componentsSeparatedByString:@" "];
        if (tempArray.count > 1) {
            self.dateLabel.text = [tempArray objectAtIndex:0];
        }
    }
    if ([item.READ_COUNT length] > 0) {
        self.readCountLabel.text = [NSString stringWithFormat:@"%@",item.READ_COUNT];
    }else{
        self.readCountLabel.text = @"0";
    }
}

+ (CGFloat)heightForCell:(ArticleItem *)item{
    return 148;
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    self.tipLabel.backgroundColor = [UIColor colorWithWhite:153/255.f alpha:1.f];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.tipLabel.backgroundColor = [UIColor colorWithWhite:153/255.f alpha:1.f];
}


@end

#pragma mark-
@interface InfoTextCell ()
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* dateLabel;
@property(nonatomic,strong)UILabel* readCountLabel;
@end

@implementation InfoTextCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"212121"];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 2;
        if (SCREENWIDTH < 375) {
            self.titleLabel.font = [UIFont systemFontOfSize:15];
        }else{
            self.titleLabel.font = [UIFont systemFontOfSize:18];
        }
        [self.baseView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.top.right.equalTo(self.baseView);
            make.height.greaterThanOrEqualTo(20);
        }];
        
        self.dateLabel = [UILabel new];
        self.dateLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        [self.baseView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(self).offset(-5);
            make.left.equalTo(self.baseView);
        }];
        
        self.readCountLabel = [UILabel new];
        self.readCountLabel.textColor =  [UIColor colorWithHexString:@"666666"];;
        self.readCountLabel.backgroundColor = [UIColor clearColor];
        self.readCountLabel.textAlignment = NSTextAlignmentRight;
        self.readCountLabel.font = [UIFont systemFontOfSize:12];
        [self.baseView addSubview:self.readCountLabel];
        [self.readCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.dateLabel);
            make.right.equalTo(self.baseView);
        }];
        
        UIImageView* readIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye_icon"]];
        [self.baseView addSubview:readIcon];
        [readIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.readCountLabel.left).offset(-5);
            make.centerY.equalTo(self.readCountLabel);
        }];
    }
    return self;
}

- (void)setContent:(ArticleItem *)item{
    self.titleLabel.text = item.TITLE;
    
    if (item.PUBLISH_TIME) {
        NSArray* tempArray = [item.PUBLISH_TIME componentsSeparatedByString:@" "];
        if (tempArray.count > 1) {
            self.dateLabel.text = [tempArray objectAtIndex:0];
        }
    }
    if (item.READ_COUNT) {
        self.readCountLabel.text = [NSString stringWithFormat:@"%@",item.READ_COUNT];
    }
}

+ (CGFloat)heightForCell:(ArticleItem *)item
{
    CGRect rect = [item.TITLE boundingRectWithSize:CGSizeMake(SCREENWIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil];
    if (rect.size.height < 25) {
        return 73;
    }
    return 95;
}

@end

@interface InfoTopImageCell ()<WYScrollViewNetDelegate>

@property(nonatomic,strong)WYScrollView *WYNetScrollView;

@end

@implementation InfoTopImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setImagesArray:(NSArray *)imagesArray{
    
    _imagesArray = imagesArray;
    NSMutableArray* tempArray = [NSMutableArray array];
    for (NSInteger i = 0;i < _imagesArray.count;i++) {
        BannerItem* model = _imagesArray[i];
        if (model.IMG_URL.length > 0) {
            [tempArray addObject:model.IMG_URL];
        }
    }
    
    if (!self.WYNetScrollView) {
        self.WYNetScrollView = [[WYScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*37/75.0)];
        self.WYNetScrollView.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
        self.WYNetScrollView.netDelagate = self;
    }
    
    if (_imagesArray.count > 0) {
        self.WYNetScrollView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*37/75.0);
    }else{
        self.WYNetScrollView.frame = CGRectMake(0, 0, SCREENWIDTH, 0);
    }
    [self.contentView addSubview:self.WYNetScrollView];
    self.WYNetScrollView.imageArray = tempArray;
    self.WYNetScrollView.AutoScrollDelay = 3;
    self.WYNetScrollView.showImageInfo = YES;
    
}

-(void)showNetworkImageInfoAtIndex:(NSInteger)index{
    if (_imagesArray.count > 0  && index < _imagesArray.count ) {
        BannerItem* model = _imagesArray[index];
        self.WYNetScrollView.titleLabel.text = model.SUMMARY;
    }
}

-(void)didSelectedNetImageAtIndex:(NSInteger)index{
    if (_imagesArray.count <= 0) return;
    
    if (self.gotoArticleDetail) {
        self.gotoArticleDetail(_imagesArray[index]);
    }
}
@end

#pragma mark- 注册

@interface RegisterTableHead ()

@end

@implementation RegisterTableHead

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        
        _titleLable = [UILabel new];
        _titleLable.text = @"———— 基本信息 ————";
        _titleLable.textColor = [UIColor colorWithHexString:@"999999"];
        _titleLable.font = [UIFont systemFontOfSize:12];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLable];
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
    }
    return self;
}
@end


@interface RegisterTableCell ()

@property(nonatomic,strong)UILabel* starIcon;
@property(nonatomic,strong)UIButton* selectBtn;
@end

@implementation RegisterTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _starIcon = [UILabel new];
        _starIcon.text = @"*";
        _starIcon.font = [UIFont systemFontOfSize:15];
        _starIcon.textColor = [UIColor colorWithHexString:@"666666"];
        [self.contentView addSubview:_starIcon];

        
        _titleLabel = [UILabel new];
        _titleLabel.text =  @"地区：";
        _titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];

        
        _textField = [UITextField new];
//        _textField.placeholder = @"请输入";
        _textField.textColor = [UIColor colorWithHexString:@"666666"];
        _textField.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_textField];
        
        _selectBtn = [UIButton new];
        [_selectBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
        [self.contentView addSubview:_selectBtn];
        [_selectBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"bdbdbd"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(1);
            make.left.equalTo(15);
            make.bottom.equalTo(self);
            make.right.equalTo(self.right).offset(-15);
        }];
        
        WeakObj(self);
        [_starIcon mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.width.equalTo(15);
            make.centerY.equalTo(self);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(wself.starIcon.right).offset(5);
            make.centerY.equalTo(self);
        }];
        
        [_textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(wself.titleLabel.right).offset(10);
            make.centerY.equalTo(wself.titleLabel);
            make.width.equalTo(220);
        }];

        
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.right).offset(-15);
            make.top.bottom.equalTo(self);
            make.width.equalTo(30);
        }];
    }
    return self;
}

- (void)setShowStar:(BOOL)showStar{
    self.starIcon.hidden = !showStar;
    if (showStar) {
        [_titleLabel remakeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.starIcon.right).offset(5);
            make.centerY.equalTo(self);
        }];
    }else{
        [_titleLabel remakeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.centerY.equalTo(self);
        }];
    }
}

- (void)setShowSelectBtn:(BOOL)showSelectBtn{
    self.selectBtn.hidden = !showSelectBtn;
    if (showSelectBtn) {
        _textField.placeholder = @"请选择";
    }else{
        _textField.placeholder = @"";
    }
}

- (void)onTapButton:(id)sender{
    [_textField becomeFirstResponder];
}
@end

@implementation RegisterSkillItem

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        _boxBtn = [UIButton new];
        [_boxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [_boxBtn setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:_boxBtn];
        [_boxBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.centerY.equalTo(self);
            make.height.width.equalTo(30);
        }];
        
        WeakObj(self);
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(wself.boxBtn.right);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}


@end

@implementation  RegisterButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end

@interface RegisterSkillCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)NSArray* dataArray;
@end

@implementation RegisterSkillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* label = [UILabel new];
        label.text =  @"特长：请选择（多选）";
        label.textColor = [UIColor colorWithHexString:@"666666"];
        label.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:label];
        [label remakeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.top.equalTo(10);
        }];
        
        self.dataArray = [DeviceHelper sharedInstance].specialitys;
        
        UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = (SCREENWIDTH-80*3-20-30)/3;
        layout.itemSize = CGSizeMake(80, 30);
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        _collectionView.layer.borderWidth = 1;
        _collectionView.layer.borderColor = [UIColor colorWithHexString:@"c7cacc"].CGColor;
        [_collectionView registerClass:[RegisterSkillItem class] forCellWithReuseIdentifier:@"RegisterSkillItem"];
        [self.contentView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(40);
            make.left.equalTo(15);
            make.right.equalTo(self.right).offset(-15);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)setSpecialitys:(NSArray *)specialitys{
    _specialitys = specialitys;
    
    [self.collectionView reloadData];
}

+ (CGFloat)heightForRegisterSkillCell{
    NSInteger count = [DeviceHelper sharedInstance].specialitys.count;
    CGFloat height = 40+5+(count/3+(count%3>0?1:0))*35;
    return height;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RegisterSkillItem* item = [collectionView dequeueReusableCellWithReuseIdentifier:@"RegisterSkillItem" forIndexPath:indexPath];
    [item.boxBtn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    item.boxBtn.tag = indexPath.item;
    
    InitDictData* data = self.dataArray[indexPath.item];
    item.boxBtn.selected = NO;
    for (NSString * key in self.specialitys) {
        if ([data.id intValue] == [key intValue]) {
            item.boxBtn.selected = YES;
        }
    }
    item.titleLabel.text = data.name;
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //审核状态不可修改
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 1) {
        return ;
    }
    
    RegisterSkillItem* item = (RegisterSkillItem *)[collectionView cellForItemAtIndexPath:indexPath];
    item.boxBtn.selected = !item.boxBtn.selected;
    InitDictData* data = self.dataArray[indexPath.item];
    if (self.selectedSkillHandler) {
        self.selectedSkillHandler(item.boxBtn.selected == YES?YES:NO, data.id);
    }
}

- (void)onTapButton:(UIButton *)button{
    //审核状态不可修改
    if ([[UserInfoManager sharedInstance].userModel.auditFlag intValue] == 1) {
        return ;
    }
    
    button.selected = !button.selected;
    InitDictData* data = self.dataArray[button.tag];
    if (self.selectedSkillHandler) {
        self.selectedSkillHandler(button.selected == YES?YES:NO, data.id);
    }
    
}
@end

@implementation RegisterBoxCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _boxBtn = [UIButton new];
        [_boxBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [_boxBtn setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:_boxBtn];
        
        
        _titleLabel = [UILabel new];
        _titleLabel.text =  @"盲人阅览室服务";
        _titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_boxBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(30);
        }];
        WeakObj(self);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(wself.boxBtn.right).offset(10);
            make.centerY.equalTo(self);
        }];
        
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"bdbdbd"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(1);
            make.left.equalTo(15);
            make.bottom.equalTo(self);
            make.right.equalTo(self.right).offset(-15);
        }];
        
    }
    return self;
}


@end

#pragma mark- 招募

@implementation RecruitTextView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        _topLabel = [UILabel new];
        _topLabel.text = @"报名人数";
        _topLabel.textColor = Color999999;
        _topLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_topLabel];
        [_topLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.centerX.equalTo(self);
        }];
        WeakObj(self);
        _bottomLabel = [UILabel new];
        _bottomLabel.text = @"24人";
        _bottomLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_bottomLabel];
        [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(wself.topLabel.bottom).offset(10);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}
@end

@interface RecruitSmallView ()
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* textLabel;
@end

@implementation RecruitSmallView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _iconView = [UIImageView new];
        _iconView.image = [UIImage imageNamed:@"small_clock"];
        [self addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.equalTo(self);
        }];
        WeakObj(self);
        _textLabel = [UILabel new];
        _textLabel.text = @"剩余63天";
        _textLabel.textColor = Color999999;
        _textLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(wself.iconView);
            make.left.equalTo(wself.iconView.right).offset(5);
        }];
        
        if (SCREENWIDTH <= 320) {
            _textLabel.font = [UIFont systemFontOfSize:10];
        }
        
    }
    return self;
}

- (void)setImage:(NSString *)imgName text:(NSString *)text{
    _iconView.image = [UIImage imageNamed:imgName];
    _textLabel.text = text;
}

@end


@interface RecruitViewCell ()
@property(nonatomic,strong)UIImageView_SD* coverView;
@property(nonatomic,strong)UILabel* tagLabel;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* areaLabel;
@property(nonatomic,strong)UILabel* typeLabel;
@property(nonatomic,strong)UIView* progressView;
@property(nonatomic,strong)UILabel* progressLabel;

@property(nonatomic,strong)RecruitSmallView* timeView;
@property(nonatomic,strong)RecruitSmallView* personView;

@property(nonatomic,strong)CAGradientLayer *gradient;
@end


@implementation RecruitViewCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _coverView = [UIImageView_SD new];
        [self addSubview:_coverView];
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.top.equalTo(self);
            make.height.equalTo(self.width).multipliedBy(275/370.f);
        }];
        
        _tagLabel = [UILabel new];
        _tagLabel.font = [UIFont systemFontOfSize:12];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.text = @"进行中";
        _tagLabel.backgroundColor = [UIColor colorWithHexString:@"48971c"];
        [self addSubview:_tagLabel];
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.top.equalTo(self);
            make.height.equalTo(22);
            make.width.equalTo(44);
        }];
        if (SCREENWIDTH <= 320) {
            _tagLabel.font = [UIFont systemFontOfSize:10];
        }
        
        WeakObj(self);
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = Color333333;
        _titleLabel.text = @"中国盲人图书馆图书录入";
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(10);
            make.right.equalTo(self.right).offset(-10);
            make.top.equalTo(wself.coverView.bottom).offset(10);
        }];
        if (SCREENWIDTH <= 320){
            _titleLabel.font = [UIFont systemFontOfSize:12];
        }
        
        UIImageView* areaImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"small_location"]];
        [self addSubview:areaImage];
        [areaImage mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(16);
            make.top.equalTo(wself.titleLabel.bottom).offset(15);
        }];
        
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
            make.right.equalTo(self.right).offset(-15);
            make.centerY.equalTo(areaImage);
            make.width.equalTo(58);
            make.height.equalTo(16);
        }];
        if (SCREENWIDTH <= 320) {
            _typeLabel.font = [UIFont systemFontOfSize:10];
        }
        
        
        _areaLabel = [UILabel new];
        _areaLabel.font = [UIFont systemFontOfSize:12];
        _areaLabel.textColor = Color999999;
        _areaLabel.text = @"湖南";
        [self addSubview:_areaLabel];
        [_areaLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(areaImage);
            make.left.equalTo(areaImage.right).offset(5);
            make.width.equalTo((SCREENWIDTH-7)/2.0-16-7.5-5-15-5-58);
        }];
        
        if (SCREENWIDTH <= 320) {
            _areaLabel.font = [UIFont systemFontOfSize:10];
        }

        _progressView = [UIView new];
        _progressView.backgroundColor = [UIColor colorWithHexString:@"c2c2c2"];
        _progressView.layer.cornerRadius = 1.5;
        [self addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(wself.typeLabel.bottom).offset(10);
            make.left.equalTo(15);
            make.right.equalTo(self.right).offset(-15);
            make.height.equalTo(3);
        }];

        _gradient = [CAGradientLayer layer];
        _gradient.frame = CGRectMake(0, 0, (SCREENWIDTH-7)/2-15-15, 3);
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
        _progressLabel.text = @"100%";
        _progressLabel.clipsToBounds = YES;
        [self addSubview:_progressLabel];
        [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(wself.progressView);
            make.left.equalTo(15);
            make.width.equalTo(40);
            make.height.equalTo(16);
        }];
        if (SCREENWIDTH <= 320) {
            _progressLabel.font = [UIFont systemFontOfSize:10];
        }
        
        
        
        _timeView = [RecruitSmallView new];
        [self addSubview:_timeView];
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(15);
            make.top.equalTo(wself.progressLabel.bottom).offset(10);
            if (SCREENWIDTH <= 320) {
                make.width.equalTo(55);
            }else{
                make.width.equalTo(70);
            }
        }];
        
        _personView = [RecruitSmallView new];
        [self addSubview:_personView];
        [_personView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(wself.timeView.right).offset(15);
            make.centerY.equalTo(wself.timeView);
        }];
        
        [_timeView setImage:@"small_clock" text:@"剩余63天"];
        [_personView setImage:@"person_icon" text:@"招募30人"];
    }
    return self;
}


- (void)setRecruitItem:(ArticleItem *)recruitItem{
    [_coverView sd_setImageWithURL:[NSURL URLWithString:recruitItem.COVER_IMG_URL]];
    _titleLabel.text = recruitItem.TITLE;
    _areaLabel.text = recruitItem.ADDRESS;
    
    //活动状态(0:预热中; 1:报名中; 2:进行中; 3:已结束; 4:已结项; 5:已取消)
    /*
     <!--活动状态背景-->
     <color name="bg_recruit_green">#48971c</color>//进行中
     <color name="bg_recruit_orange">#ff6100</color>//预热中
     <color name="bg_recruit_red">#e01f16</color>//报名中
     <color name="bg_recruit_finished">#666666</color>//已结束
     <color name="bg_recruit_finish">#cccccc</color>//已结项  招募活动列表左上角状态背景色
     */
    _timeView.hidden = NO;
    _progressView.hidden = NO;
    _progressLabel.hidden = NO;
    _personView.hidden = NO;
    
    
    switch ([recruitItem.ACTIVE_STATE intValue]) {
        case 0://预热中   剩余天数是离报名开始天数，不显示进度条、不显示招募人数
        {
            _tagLabel.text = @"预热中";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"ff6100"];
            
            if (recruitItem.RECRUIT_START_TIME.length > 0)
            {
                NSDate* date = [Utility stringConvertToDate:recruitItem.RECRUIT_START_TIME];
                long timeInterval = [date timeIntervalSince1970]-[[NSDate date] timeIntervalSince1970];
                int hour = (int)timeInterval/3600;
                
                if (hour < 0) {
                    [_timeView setImage:@"small_clock" text:@"30天后开始"];
                }
                else if (hour > 24) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%d天后开始",(int)hour/24]];
                }else{
                    if (hour>0) {
                        [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%d小时后开始",hour]];
                    }else{
                        int m = (int)timeInterval/60;
                        if (m>0) {
                            [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%d分后开始",m]];
                        }else{
                            [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%d秒后开始",(int)timeInterval]];
                        }
                    }
                }
            }
            
            _progressView.hidden = YES;
            _progressLabel.hidden = YES;
            _personView.hidden = YES;
            
        }
            break;
        case 1://报名中   剩余天数是离报名结束天数，显示目标招募人数、显示进度条
        {
            _tagLabel.text = @"报名中";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"e01f16"];
            
            if (recruitItem.RECRUIT_END_TIME.length > 0)
            {
                NSDate* date = [Utility stringConvertToDate:recruitItem.RECRUIT_END_TIME];
                long timeInterval = [date timeIntervalSince1970]-[[NSDate date] timeIntervalSince1970];
                int hour = (int)timeInterval/3600;
                if (hour < 0) {
                    [_timeView setImage:@"small_clock" text:@"剩余30天"];
                }
                else if (hour > 24) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d天",(int)hour/24]];
                }else{
                    if (hour>0) {
                        [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d小时",hour]];
                    }else{
                        int m = (int)timeInterval/60;
                        if (m>0) {
                            [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d分",m]];
                        }else{
                            [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d秒",(int)timeInterval]];
                        }
                    }
                }
            }

            _progressLabel.text = [NSString stringWithFormat:@"%.f%@",[recruitItem.RECRUIT_PERCENT floatValue]*100,@"%"];
            
            _gradient.frame = CGRectMake(0, 0, ((SCREENWIDTH-7)/2-15-15)*[recruitItem.RECRUIT_PERCENT floatValue], 3);
            
            if ([recruitItem.RECRUIT_PERCENT intValue] == 1) {
                [_progressLabel mas_updateConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo((SCREENWIDTH-7)/2-15-40);
                }];
            }else{
                [_progressLabel mas_updateConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(15+((SCREENWIDTH-7)/2-15-15)*[recruitItem.RECRUIT_PERCENT floatValue]);
                }];
            }

            [_personView setImage:@"person_icon" text:[NSString stringWithFormat:@"招募%@人",recruitItem.RECRUIT_NUM]];
            
        }
            break;
        case 2://进行中   剩余天数是离活动结束天数，显示已招募人数，不显示进度条
        {
            _tagLabel.text = @"进行中";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"48971c"];
            
            if (recruitItem.END_TIME.length > 0)
            {
                NSDate* date = [Utility stringConvertToDate:recruitItem.END_TIME];
                long timeInterval = [date timeIntervalSince1970]-[[NSDate date] timeIntervalSince1970];
                int hour = (int)timeInterval/3600;
                
                if (hour < 0) {
                    [_timeView setImage:@"small_clock" text:@"剩余30天"];
                }
                else if (hour > 24) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d天",(int)hour/24]];
                }else{
                    if (hour>0) {
                        [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d小时",hour]];
                    }else{
                        int m = (int)timeInterval/60;
                        if (m>0) {
                            [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d分",m]];
                        }else{
                            [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d秒",(int)timeInterval]];
                        }
                    }
                }
            }
            [_personView setImage:@"person_icon" text:[NSString stringWithFormat:@"已招募%@人",recruitItem.CURR_RECRUIT_NUM]];
            
            _progressView.hidden = YES;
            _progressLabel.hidden = YES;
            
        }
            break;
        case 3://已结束   显示结束时间，不显示招募人数、不显示进度条
        {
            _tagLabel.text = @"已结束";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"666666"];
            
            if (recruitItem.END_TIME.length > 0) {
                NSArray* array = [recruitItem.END_TIME componentsSeparatedByString:@" "];
                if (array.count > 0) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%@结束",array[0]]];
                }
            }
        
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
            _personView.hidden = YES;
        }
            break;
        case 4://已结项  显示结束时间，不显示招募人数和进度条
        {
            _tagLabel.text = @"已结项";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
            
            if (recruitItem.END_TIME.length > 0) {
                NSArray* array = [recruitItem.END_TIME componentsSeparatedByString:@" "];
                if (array.count > 0) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%@结束",array[0]]];
                }
            }
            
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
            _personView.hidden = YES;
        }

            break;
        case 5://已取消  忽略
        {
            _tagLabel.text = @"已取消";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
            
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
            _timeView.hidden = YES;
            _personView.hidden = YES;
        }

            break;
        default:
            break;
    }
    
    NSArray* array = [recruitItem.SERVICE_TYPE_NAMES componentsSeparatedByString:@","];
    if (array.count > 0) {
        _typeLabel.text = array[0];
    }
}


- (void)setMyEnroll:(MyEnrollModel *)myEnroll{
    _myEnroll = myEnroll;
    
    [_coverView sd_setImageWithURL:[NSURL URLWithString:_myEnroll.volEventObj.eventPhoto]];
    _titleLabel.text = _myEnroll.volEventObj.eventName;
    _areaLabel.text = _myEnroll.volEventObj.eventAddr;
    
    NSArray* array = [_myEnroll.volEventObj.eventDesireObj.serviceTypeNames componentsSeparatedByString:@","];
    if (array.count > 0) {
        _typeLabel.text = array[0];
    }
    
    //活动状态(0:预热中; 1:报名中; 2:进行中; 3:已结束; 4:已结项; 5:已取消)
    /*
     <!--活动状态背景-->
     <color name="bg_recruit_green">#48971c</color>//进行中
     <color name="bg_recruit_orange">#ff6100</color>//预热中
     <color name="bg_recruit_red">#e01f16</color>//报名中
     <color name="bg_recruit_finished">#666666</color>//已结束
     <color name="bg_recruit_finish">#cccccc</color>//已结项  招募活动列表左上角状态背景色
     */
    switch ([_myEnroll.volEventObj.activeState intValue]) {
        case 0://预热中  剩余天数是离报名开始天数，不显示进度条、不显示招募人数
        {
            _tagLabel.text = @"预热中";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"ff6100"];
            
            NSDate* date = [Utility stringConvertToDate:_myEnroll.volEventObj.recruitStartDate];
            long timeInterval = [date timeIntervalSince1970]-[[NSDate date] timeIntervalSince1970];
            int hour = (int)timeInterval/3600;
            if (hour > 24) {
                [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%d天后开始",(int)hour/24]];
            }else{
                if (hour>0) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%d小时后开始",hour]];
                }else{
                    int m = (int)timeInterval/60;
                    if (m>0) {
                        [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%d分后开始",m]];
                    }else{
                        [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%d秒后开始",(int)timeInterval]];
                    }
                }
            }
            
            _progressView.hidden = YES;
            _progressLabel.hidden = YES;
            _personView.hidden = YES;
        }

            break;
        case 1://报名中  剩余天数是离报名结束天数，显示目标招募人数、显示进度条
        {
            _tagLabel.text = @"报名中";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"e01f16"];
            
            NSDate* date = [Utility stringConvertToDate:_myEnroll.volEventObj.recruitEndDate];
            long timeInterval = [date timeIntervalSince1970]-[[NSDate date] timeIntervalSince1970];
            int hour = (int)timeInterval/3600;
            if (hour > 24) {
                [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d天",(int)hour/24]];
            }else{
                if (hour>0) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d小时",hour]];
                }else{
                    int m = (int)timeInterval/60;
                    if (m>0) {
                        [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d分",m]];
                    }else{
                        [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d秒",(int)timeInterval]];
                    }
                }
            }
            
            _progressLabel.text = [NSString stringWithFormat:@"%.f%@",[_myEnroll.volEventObj.recruitRate floatValue]*100,@"%"];
            
            _gradient.frame = CGRectMake(0, 0, ((SCREENWIDTH-7)/2-15-15)*[_myEnroll.volEventObj.recruitRate floatValue], 3);
            WeakObj(self);
            if ([_myEnroll.volEventObj.recruitRate intValue] == 1) {
                [_progressLabel mas_updateConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo((SCREENWIDTH-7)/2-15-40);
                }];
            }else{
                [_progressLabel mas_updateConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(15+((SCREENWIDTH-7)/2-15-15)*[wself.myEnroll.volEventObj.recruitRate floatValue]);
                }];
            }
            
            [_personView setImage:@"person_icon" text:[NSString stringWithFormat:@"招募%@人",_myEnroll.volEventObj.planRecruitNum]];
        }

            break;
        case 2://进行中 剩余天数是离活动结束天数，显示已招募人数，不显示进度条
        {
            _tagLabel.text = @"进行中";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"48971c"];
            
            NSDate* date = [Utility stringConvertToDate:_myEnroll.volEventObj.eventEndDate];
            long timeInterval = [date timeIntervalSince1970]-[[NSDate date] timeIntervalSince1970];
            int hour = (int)timeInterval/3600;
            if (hour > 24) {
                [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d天",(int)hour/24]];
            }else{
                if (hour>0) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d小时",hour]];
                }else{
                    int m = (int)timeInterval/60;
                    if (m>0) {
                        [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d分",m]];
                    }else{
                        [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"剩余%d秒",(int)timeInterval]];
                    }
                }
            }
            [_personView setImage:@"person_icon" text:[NSString stringWithFormat:@"已招募%@人",_myEnroll.volEventObj.hasRecruitNum]];
            
            _progressView.hidden = YES;
            _progressLabel.hidden = YES;
        }
            break;
        case 3://已结束  显示结束时间，不显示招募人数、不显示进度条
        {
            _tagLabel.text = @"已结束";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"666666"];
            
            if (_myEnroll.volEventObj.eventEndDate.length > 0) {
                NSArray* array = [_myEnroll.volEventObj.eventEndDate componentsSeparatedByString:@" "];
                if (array.count > 0) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%@结束",array[0]]];
                }
            }
            
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
            _personView.hidden = YES;
        }

            break;
        case 4://已结项 显示结束时间，不显示招募人数、不显示进度条
        {
            _tagLabel.text = @"已结项";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
            
            if (_myEnroll.volEventObj.eventEndDate.length > 0) {
                NSArray* array = [_myEnroll.volEventObj.eventEndDate componentsSeparatedByString:@" "];
                if (array.count > 0) {
                    [_timeView setImage:@"small_clock" text:[NSString stringWithFormat:@"%@结束",array[0]]];
                }
            }
            
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
            _personView.hidden = YES;
        }

            break;
        case 5://已取消  忽略
        {
            _tagLabel.text = @"已取消";
            _tagLabel.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
            
            _progressLabel.hidden = YES;
            _progressView.hidden = YES;
            _timeView.hidden = YES;
            _personView.hidden = YES;
        }

            break;
        default:
            break;
    }

    [_personView setImage:@"person_icon" text:[NSString stringWithFormat:@"招募%@人",_myEnroll.volEventObj.planRecruitNum]];
}
@end

//岗位描述
@interface RecruitPostDescCell ()<UIWebViewDelegate>
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* descLabel;
@property(nonatomic,strong)UILabel* conditionLabel;
@property(nonatomic,strong)UILabel* numberLabel;

@property(nonatomic,strong)UILabel* textLabel;
@property(nonatomic,strong)NSMutableAttributedString* attributedString;
@end

@implementation RecruitPostDescCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"e5e5e7"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(20);
            make.right.equalTo(self.right).offset(-20);
            make.height.equalTo(1);
            make.top.equalTo(40);
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = Color212121;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.text = @"导盲陪同视障朋友品茶等";
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(line.top).offset(-8);
            make.left.right.equalTo(line);
        }];

        self.enrollBtn = [UIButton new];
        self.enrollBtn.backgroundColor = BaseColor;
        [self.enrollBtn setTitle:@"立即报名" forState:UIControlStateNormal];
        self.enrollBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.enrollBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.enrollBtn.layer.cornerRadius = 15;
        [self addSubview:self.enrollBtn];
        [self.enrollBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(self.bottom).offset(-12);
            make.right.equalTo(line);
            make.height.equalTo(30);
            make.width.equalTo(95);
        }];
        
        
        self.numberLabel = [UILabel new];
        self.numberLabel.textColor = Color212121;
        self.numberLabel.font = [UIFont systemFontOfSize:12];
        self.numberLabel.text = @"计划招募:   16     已招募:     8";
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(self.enrollBtn);
            make.left.equalTo(line);
        }];
        
        
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(line.bottom).offset(8);
            make.left.right.equalTo(line);
            make.bottom.equalTo(self.enrollBtn.top).offset(-8);
        }];

    }
    return self;
}


+(CGSize)SizeForRecruitPostDescCell:(RecruitPost *)recruitPost
{
    NSString* mixedString = [NSString stringWithFormat:@"岗位描述:\n%@\n\n招募条件:\n%@\n\n",[RecruitPostDescCell StripHT:recruitPost.postDesc],[RecruitPostDescCell StripHT:recruitPost.postCondion]];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:mixedString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,
                                      NSFontAttributeName:[UIFont systemFontOfSize:13],
                                      NSForegroundColorAttributeName:[UIColor colorWithHexString:@"949494"]
                                      } range:NSMakeRange(0, [attributedString length])];
    
    
    CGSize attSize = [attributedString boundingRectWithSize:CGSizeMake(SCREENWIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return CGSizeMake(SCREENWIDTH, attSize.height+40+30);
    
}
- (void)setRecruitPost:(RecruitPost *)recruitPost{
    _recruitPost = recruitPost;
    
    self.titleLabel.text = recruitPost.postName;

    self.numberLabel.text = [NSString stringWithFormat:@"计划招募:   %@     已招募:     %@",recruitPost.planRecruitNum,recruitPost.hasRecruitNum];

    
    NSString* mixedString = [NSString stringWithFormat:@"岗位描述:\n%@\n\n招募条件:\n%@\n\n",[RecruitPostDescCell StripHT:recruitPost.postDesc],[RecruitPostDescCell StripHT:recruitPost.postCondion]];
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:mixedString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,
                                      NSFontAttributeName:[UIFont systemFontOfSize:13],
                                      NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]
                                      } range:NSMakeRange(0, [attributedString length])];
    
    _textLabel.attributedText = attributedString;
    
}



//content是根据网址获得的网页源码字符串
+ (NSString *)StripHT:(NSString *)content{
    
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    
    content=[regularExpretion
             
             stringByReplacingMatchesInString:content
             
             options:NSMatchingReportProgress
             
             range:NSMakeRange(0, content.length)
             
             withTemplate:@"-"];//替换所有html和换行匹配元素为"-"
    
    regularExpretion=[NSRegularExpression
                      
                      regularExpressionWithPattern:@"-{1,}"
                      
                      options:0
                      
                      error:nil];
    
    
    content=[regularExpretion
             
             stringByReplacingMatchesInString:content
             
             options:NSMatchingReportProgress
             
             range:NSMakeRange(0, content.length)
             
             withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    //根据"-"分割到数组
    
    NSArray *arr = [NSArray array];
    
    
    content = [NSString stringWithString:content];
    
    
    arr = [content componentsSeparatedByString:@"-"];
    
    
    NSMutableArray  *marr=[NSMutableArray  arrayWithArray:arr];
    
    [marr removeObject:@""];
    
    NSString* mixedString = @"";
    for (NSString* string in marr) {
        mixedString = [mixedString stringByAppendingString:string];
    }
    
    
    return  mixedString;
}


@end

//招募查询

@implementation RecruitConditonHead
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"服务类别:";
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"686868"];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(9);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end

@implementation RecruitConditonItem

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = .5;
        self.layer.borderColor = [UIColor colorWithHexString:@"bdbdbd"].CGColor;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"服务类别:";
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.titleLabel.backgroundColor = BaseColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    }else{
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

- (void)setChoosed:(BOOL)choosed{
    _choosed = choosed;
    if (_choosed) {
        self.titleLabel.backgroundColor = BaseColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    }else{
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
    }
}
@end

@interface RecruitConditonCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView* collectionView;

@property(nonatomic,strong)NSString* serviceTypeID;
@property(nonatomic,strong)NSString* serviceObjectID;
@property(nonatomic,strong)NSString* recruitNumID;
@end

@implementation RecruitConditonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"c8c7cc"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.top.right.equalTo(self);
            make.height.equalTo(1);
        }];
        
        self.serviceTypeID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceType];
        if (self.serviceTypeID.length <= 0) {
            self.serviceTypeID = @"0";
        }
        self.serviceObjectID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryServiceObject];
        if (self.serviceObjectID.length <= 0) {
            self.serviceObjectID = @"0";
        }
        self.recruitNumID = [[NSUserDefaults standardUserDefaults] objectForKey:RecruitQueryRecruitNum];
        if (self.recruitNumID.length <= 0) {
            self.recruitNumID = @"0";
        }
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 9, 5, 9);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[RecruitConditonItem class] forCellWithReuseIdentifier:@"RecruitConditonItem"];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        
        line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"c8c7cc"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(1);
        }];


    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [_collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    InitDictData * dictData = self.dataArray[indexPath.item];
    
    CGRect rect = CGRectFromString(dictData.frameSize);
    return  CGSizeMake(rect.size.width, rect.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"RecruitConditonItem";
    RecruitConditonItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    InitDictData * dictData = self.dataArray[indexPath.item];
    cell.titleLabel.text = dictData.name;
    cell.frame = CGRectFromString(dictData.frameSize);
    cell.choosed = NO;
    NSString* string ;
    switch (self.indexPath.section) {
        case 0:
            string = self.serviceTypeID;
            break;
        case 1:
            string = self.serviceObjectID;
            break;
        case 2:
            string = self.recruitNumID;
            break;
        default:
            break;
    }
    if (string.length > 0 && [string isEqualToString:dictData.id]) {
        cell.choosed = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    InitDictData * dictData = self.dataArray[indexPath.item];
    
    RecruitConditonItem * cell = (RecruitConditonItem *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.choosed = !cell.choosed;
    
    switch (self.indexPath.section) {
        case 0:
            if (self.selecteInitData) {
                if ([dictData.id intValue] == 0) {
                    self.selecteInitData(@"", RecruitQueryServiceType);
                    self.serviceTypeID = @"";
                }else{
                    self.selecteInitData(dictData.id, RecruitQueryServiceType);
                    self.serviceTypeID = dictData.id;
                }
            }
            break;
        case 1:
            if (self.selecteInitData) {
                if ([dictData.id intValue] == 0) {
                    self.selecteInitData(@"", RecruitQueryServiceObject);
                    self.serviceObjectID = @"";
                }else{
                    self.selecteInitData(dictData.id, RecruitQueryServiceObject);
                    self.serviceObjectID = dictData.id;
                }
            }
            break;
        case 2:
            if (self.selecteInitData) {
                if ([dictData.id intValue] == 0) {
                    self.selecteInitData(@"", RecruitQueryRecruitNum);
                    self.recruitNumID = @"";
                }else{
                    self.selecteInitData(dictData.id, RecruitQueryRecruitNum);
                    self.recruitNumID = dictData.id;
                }
            }
            break;
            
        default:
            break;
    }
    
    NSArray* array = [collectionView visibleCells];
    for (RecruitConditonItem * item in array) {
        if (item != cell) {
            item.choosed = NO;
        }
    }
}

@end


@implementation RecruitApplyIcon

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = (SCREENWIDTH-70)/12.f;
        self.layer.masksToBounds = YES;
        
        _iconView = [UIImageView new];
        _iconView.backgroundColor = [UIColor colorWithHexString:@"efeff4"];
        [self addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        
        
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"查看\n更多";
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        _label.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}
@end

@implementation QuestionSingleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _choiceBtn = [UIButton new];
        [_choiceBtn setImage:[UIImage imageNamed:@"single_normal"] forState:UIControlStateNormal];
        [_choiceBtn setImage:[UIImage imageNamed:@"single_selected"] forState:UIControlStateSelected];
        [self addSubview:_choiceBtn];
        [_choiceBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.height.equalTo(44);
            make.left.centerY.equalTo(self);
        }];
        WeakObj(self);
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.text = @"A、毛泽东";
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(wself.choiceBtn.right).offset(5);
            make.right.equalTo(self.right).offset(-10);
        }];
    }
    return self;
}

@end

@interface QuestionBoxCell ()

@end


@implementation QuestionBoxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _choiceBtn = [UIButton new];
        [_choiceBtn setImage:[UIImage imageNamed:@"multiple_normal"] forState:UIControlStateNormal];
        [_choiceBtn setImage:[UIImage imageNamed:@"multiple_selected"] forState:UIControlStateSelected];
        [self addSubview:_choiceBtn];
        [_choiceBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.height.equalTo(44);
            make.left.centerY.equalTo(self);
        }];
        WeakObj(self);
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.text = @"A、毛泽东";
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(wself.choiceBtn.right).offset(5);
            make.right.equalTo(self.right).offset(-10);
        }];
    }
    return self;
}

@end

#pragma mark- 设置

@implementation SettingCellView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(23);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(20);
            make.width.equalTo(100);
        }];
        
        self.arrowView = [UIImageView new];
        self.arrowView.backgroundColor = [UIColor clearColor];
        self.arrowView.image = [UIImage imageNamed:@"arrow_icon"];
        [self addSubview:self.arrowView];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self).offset(-25);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(6.5);
            make.height.equalTo(12);
        }];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(15);
            make.right.equalTo(-15);
//            make.height.equalTo(1.0f/[UIScreen mainScreen].scale);
            make.height.equalTo(1);
        }];
    }
    return self;
}

@end

//服务记录

@implementation ServiceRecordHead

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView* bottomLine = [UIView new];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(1);
            make.left.right.bottom.equalTo(self);
        }];
        
        UIView* leftLine = [UIView new];
        leftLine.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(1);
            make.left.equalTo(90);
            make.top.bottom.equalTo(self);
        }];
        
        UIView* rightLine = [UIView new];
        rightLine.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(1);
            make.right.equalTo(self.right).offset(-90);
            make.top.bottom.equalTo(self);
        }];
        
        UILabel* label = [UILabel new];
        label.text = @"日期";
        label.textColor = BaseColor;
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(0);
            make.width.equalTo(90);
        }];
        
        
        label = [UILabel new];
        label.text = @"内容";
        label.textColor = BaseColor;
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(self);
        }];
        
        label = [UILabel new];
        label.text = @"时长";
        label.textColor = BaseColor;
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.right.equalTo(0);
            make.width.equalTo(90);
        }];
        
    }
    return self;
}

@end


@interface ServiceRecordCell ()
@property(nonatomic,strong)UILabel* leftLabel;
@property(nonatomic,strong)UILabel* midLabel;
@property(nonatomic,strong)UILabel* rightLabel;
@end


@implementation ServiceRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        UIView* bottomLine = [UIView new];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(1);
            make.left.right.bottom.equalTo(self);
        }];
        
        UIView* leftLine = [UIView new];
        leftLine.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(1);
            make.left.equalTo(90);
            make.top.bottom.equalTo(self);
        }];
        
        UIView* rightLine = [UIView new];
        rightLine.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
        [self addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(1);
            make.right.equalTo(self.right).offset(-90);
            make.top.bottom.equalTo(self);
        }];
        
        _leftLabel = [UILabel new];
        _leftLabel.text = @"2017-03-03";
        _leftLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _leftLabel.font = [UIFont boldSystemFontOfSize:12];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.left.equalTo(0);
            make.width.equalTo(90);
        }];
        
        
        _midLabel = [UILabel new];
        _midLabel.text = @"维持盲人馆次序需要30人";
        _midLabel.numberOfLines = 2;
        _midLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _midLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:_midLabel];
        [_midLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.center.equalTo(self);
            make.width.equalTo(SCREENWIDTH - 20 -180);
        }];
        
        _rightLabel = [UILabel new];
        _rightLabel.text = @"3小时";
        _rightLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _rightLabel.font = [UIFont boldSystemFontOfSize:12];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self);
            make.right.equalTo(0);
            make.width.equalTo(90);
        }];
        
        
    }
    return self;
}

- (void)setServiceRecord:(ServiceRecord *)serviceRecord{
    _serviceRecord = serviceRecord;
    
    if (serviceRecord.serviceStartTime.length > 0) {
        NSArray* array = [serviceRecord.serviceStartTime componentsSeparatedByString:@" "];
        if (array.count > 0) {
            _leftLabel.text = array[0];
        }
    }
    _midLabel.text = serviceRecord.eventName;
    _rightLabel.text = [NSString stringWithFormat:@"%@小时",serviceRecord.totalServiceTime];
    
}
@end

@interface StarLevelCell ()

@property(nonatomic,strong)UIImageView * iconView;
@property(nonatomic,strong)UILabel* contentLabel;

@end

@implementation StarLevelCell

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _iconView = [UIImageView new];
        _iconView.image = [UIImage imageNamed:@"top_level"];
        _iconView.contentMode = UIViewContentModeCenter;
        [self addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(50);
        }];
        WeakObj(self);
        _contentLabel = [UILabel new];
        _contentLabel.textColor = Color666666;
        _contentLabel.numberOfLines = 2;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.text = @"2017-04-04我注册成为志愿者，我的等级是志愿者";
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(wself.iconView.right).offset(15);
            make.centerY.equalTo(self);
            make.right.equalTo(self.right).offset(-10);
        }];
    }
    return self;
}

- (void)setStarRecord:(StarRecord *)starRecord{
    _starRecord = starRecord;
    
    _contentLabel.text = _starRecord.starDesc;
    
    UIImage* image ;
    switch ([starRecord.starLevel integerValue]) {
        case 0:
        {
            if (_starRecord.id.length > 0)
            {
                image = [UIImage imageNamed:@"base_level"];
                _contentLabel.text = _starRecord.starDesc;
            }else{
                image = [UIImage imageNamed:@"base_level0"];
                _contentLabel.text = @"志愿者审核中";
            }
        }
            break;
        case 1:
        {
            if (_starRecord.id.length > 0) {
                image = [UIImage imageNamed:@"one_level"];
            }else{
                image = [UIImage imageNamed:@"one_level0"];
            }
        }
            break;
        case 2:
        {
            if (_starRecord.id.length > 0) {
                image = [UIImage imageNamed:@"two_level"];
            }else{
                image = [UIImage imageNamed:@"two_level0"];
            }
        }
            break;
        case 3:
        {
            if (_starRecord.id.length > 0) {
                image = [UIImage imageNamed:@"three_level"];
            }else{
                image = [UIImage imageNamed:@"three_level0"];
            }
        }
            break;
        case 4:
        {
            if (_starRecord.id.length > 0){
                image = [UIImage imageNamed:@"four_level"];
            }else{
                image = [UIImage imageNamed:@"four_level0"];
            }
        }
            break;
        case 5:
        {
            if (_starRecord.id.length > 0){
                image = [UIImage imageNamed:@"five_level"];
            }else{
                image = [UIImage imageNamed:@"five_level0"];
            }
        }
            break;
            
        default:
            break;
    }
    _iconView.image = image;
    if (image) {
        [_iconView mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.equalTo(50);
        }];
    }
}
@end


@implementation BlankContentView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        [self addSubview:imageView];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self);
            make.width.height.equalTo(300);
        }];
    }
    return self;
}

@end



