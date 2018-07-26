//
//  RegisterDropTableView.m
//  CultureAssistant
//


#import "RegisterDropTableView.h"

@interface RegisterDropTableView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableView;
@end

@implementation RegisterDropTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView* bgView = [UIView new];
        bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.3];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self);
        }];
        [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesturer:)]];
        
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.layer.borderColor = Color999999.CGColor;
        _tableView.layer.borderWidth = 1;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(80);
            make.top.equalTo(60);
            make.width.equalTo(210);
            make.height.equalTo(210);
        }];
    }
    return self;
}


- (void)setCityArray:(NSArray *)cityArray{
    _cityArray = cityArray;
    [_tableView reloadData];
}


- (void)onTapGesturer:(UITapGestureRecognizer *)gesture{
    if (self.closeHandler) {
        self.closeHandler();
    }
}

#pragma mark- 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityCell"];
    }
    CityModel* city = _cityArray[indexPath.row];
    cell.textLabel.text = city.AREA_NAME;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     CityModel* city = _cityArray[indexPath.row];
    if (self.selectCityHandler) {
        self.selectCityHandler(city);
    }
}

@end
