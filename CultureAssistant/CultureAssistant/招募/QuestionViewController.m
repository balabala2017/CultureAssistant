//
//  QuestionViewController.m
//  CultureAssistant
//


#import "QuestionViewController.h"
#import "RequestHelper.h"

@interface QuestionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)QuestionList* list;
@property(nonatomic,strong)UILabel* scoreLabel;
@property(nonatomic,strong)UILabel* numberLabel;
@property(nonatomic,strong)UITextView* questionView;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)QuestionTopic* questionTopic;

@property(nonatomic,strong)UIButton* nextButton;
@property(nonatomic,strong)UIButton* commitButton;

@property(nonatomic,strong)NSMutableDictionary* resultDic;
@property(nonatomic,strong)NSMutableArray* optionArray;
@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"问卷调查";
    
    self.resultDic = [NSMutableDictionary dictionary];
    self.optionArray = [NSMutableArray array];
    
    [self createSubViews];
    
    if (self.questionId) {
        [self getQuestionList];
    }
    
}

- (void)getQuestionList{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    typeof(self) __weak wself = self;
    [AFNetAPIClient GET:APIGetQuestion parameters:[RequestParameters getQuestion:self.questionId] success:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]]) {
            self.list = [QuestionList QuestionListWithDictionary:(NSDictionary *)model.result];
            if (self.list.topics.count > 0)
            {
                [wself layoutQuestion:self.list.topics[0]];
                wself.index = 0;
            }
        }
        
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)layoutQuestion:(QuestionTopic *)question
{
    [self.optionArray removeAllObjects];
    
    self.questionTopic = question;
    
    if ([question.topicId isEqualToString:@"1"]) {
        _scoreLabel.text = [NSString stringWithFormat:@"单选题（%@分）",question.score];
    }else{
        _scoreLabel.text = [NSString stringWithFormat:@"多选题（%@分）",question.score];
    }
    
    _numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)(self.index+1),(long)self.list.topics.count];
    
    
    NSString* string = [NSString stringWithFormat:@"%ld、%@",(long)(self.index+1),question.topicName];
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:12];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, [attributedString length])];
    
    CGSize attSize = [attributedString boundingRectWithSize:CGSizeMake(SCREENWIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    _questionView.attributedText = attributedString;
    [_questionView mas_remakeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(12);
        make.top.equalTo(self.scoreLabel.bottom).offset(10);
        make.right.equalTo(self.view.right).offset(-12);
        make.height.equalTo(attSize.height+20);
    }];
    
    [_tableView reloadData];
    
    if (self.index+1 < self.list.topics.count) {
        _nextButton.hidden = NO;
        _commitButton.hidden = YES;
    }else{
        _nextButton.hidden = YES;
        _commitButton.hidden = NO;
    }
}

#pragma mark-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionTopic.results.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionOption* item = self.questionTopic.results[indexPath.row];
    if ([self.questionTopic.topicTypeId isEqualToString:@"1"]){
        QuestionSingleCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionSingleCell"];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@、%@",item.options,item.candidateAnswer];
        cell.choiceBtn.selected = NO;
        for (NSString* string in self.optionArray) {
            if ([string isEqualToString:item.resultId]) {
                cell.choiceBtn.selected = YES;
                break;
            }
        }
        return cell;
    }else{
        QuestionBoxCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionBoxCell"];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@、%@",item.options,item.candidateAnswer];
        cell.choiceBtn.selected = NO;
        for (NSString* string in self.optionArray) {
            if ([string isEqualToString:item.resultId]) {
                cell.choiceBtn.selected = YES;
                break;
            }
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionOption* item = self.questionTopic.results[indexPath.row];
    if ([self.questionTopic.topicTypeId isEqualToString:@"1"])
    {
        NSArray* array = [tableView visibleCells];
        
        QuestionSingleCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.choiceBtn.selected = !cell.choiceBtn.selected;

        if (cell.choiceBtn.selected ) {
            if (![self.optionArray containsObject:item.resultId]) {
                [self.optionArray addObject:item.resultId];
            }
        }else{
            if ([self.optionArray containsObject:item.resultId]) {
                [self.optionArray removeObject:item.resultId];
            }
        }
        
        for (QuestionSingleCell * cell1 in array) {
            if (cell1 != cell) {
                cell1.choiceBtn.selected = NO;
            }
        }
    }else{
        QuestionBoxCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.choiceBtn.selected = !cell.choiceBtn.selected;
        
        if (cell.choiceBtn.selected) {
            if (![self.optionArray containsObject:item.resultId]) {
                [self.optionArray addObject:item.resultId];
            }
        }else{
            if ([self.optionArray containsObject:item.resultId]) {
                [self.optionArray removeObject:item.resultId];
            }
        }
    }
}


#pragma mark-

- (void)nextQuestion:(id)sender
{
    if (self.optionArray.count <= 0) {
        [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请答题"]; return;
    }
    
    NSString* key = [NSString stringWithFormat:@"resultName%@",self.questionTopic.topicId];
    NSString* value = @"";
    for (NSInteger i = 0; i < self.optionArray.count; i++) {
        NSString* string = self.optionArray[i];
        if (i == 0) {
            value = [value stringByAppendingString:string];
        }else{
            value = [[value stringByAppendingString:@","] stringByAppendingString:string];
        }
    }

    [self.resultDic setObject:value forKey:key];
    
    
    if (self.index < self.list.topics.count-1) {
        self.index++;
        [self layoutQuestion:self.list.topics[self.index]];
    }
}

//说明：
//答案提交参数说明
//
//示例：resultName12=33,34,35,36,37&resultName13=40,41,42
//
//key:resultName+该问题ID
//
//value:选中的答案ID，多选以逗号分割
- (void)commitQuestion:(id)sender{
    
    if (self.list.topics.count == 1 || self.index == self.list.topics.count-1)
    {
        if (self.optionArray.count <= 0) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"请答题"]; return;
        }
        
        NSString* key = [NSString stringWithFormat:@"resultName%@",self.questionTopic.topicId];
        NSString* value = @"";
        for (NSInteger i = 0; i < self.optionArray.count; i++) {
            NSString* string = self.optionArray[i];
            if (i == 0) {
                value = [value stringByAppendingString:string];
            }else{
                value = [[value stringByAppendingString:@","] stringByAppendingString:string];
            }
        }
        [self.resultDic setObject:value forKey:key];
    }
    
    [AFNetAPIClient GET:APIQuestionDoCommit parameters:[[RequestHelper sharedInstance] prepareRequestparameter:self.resultDic] success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.code isEqualToString:@"200"]) {
            [MBProgressHUD MBProgressHUDWithView:self.view Str:@"谢谢你的回答，提交成功"];
        }
        [self performSelector:@selector(backForwardPage) withObject:nil afterDelay:1.f];
    }failure:^(id JSON, NSError *error){
        NSString* string = (NSString *)JSON;
        [MBProgressHUD MBProgressHUDWithView:self.view Str:string];
    }];
}

- (void)backForwardPage{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
- (void)createSubViews
{
    UIView* bottomBar = [UIView new];
    bottomBar.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(52);
    }];
    
    UIView* line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    [bottomBar addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.right.left.equalTo(bottomBar);
        make.height.equalTo(1);
    }];
    
    _scoreLabel = [UILabel new];
    _scoreLabel.backgroundColor = [UIColor colorWithHexString:@"ff9933"];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.font = [UIFont systemFontOfSize:13];
    _scoreLabel.text = @"多选题（5分）";
    [self.view addSubview:_scoreLabel];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.equalTo(12);
        make.width.equalTo(110);
        make.height.equalTo(30);
    }];
    WeakObj(self);
    _numberLabel = [UILabel new];
    _numberLabel.textColor = Color999999;
    _numberLabel.textAlignment = NSTextAlignmentRight;
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.text = @"20/20";
    [self.view addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(wself.scoreLabel);
        make.right.equalTo(wself.view.right).offset(-12);
    }];
    
    _questionView = [UITextView new];
    _questionView.layer.borderColor = Colordddddd.CGColor;
    _questionView.layer.borderWidth = 1;
    _questionView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_questionView];
    [_questionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(12);
        make.top.equalTo(wself.scoreLabel.bottom).offset(10);
        make.right.equalTo(wself.view.right).offset(-12);
        make.height.equalTo(100);
    }];
    
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[QuestionSingleCell class] forCellReuseIdentifier:@"QuestionSingleCell"];
    [_tableView registerClass:[QuestionBoxCell class] forCellReuseIdentifier:@"QuestionBoxCell"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(wself.questionView);
        make.top.equalTo(wself.questionView.bottom).offset(10);
        make.bottom.equalTo(bottomBar.top);
    }];
    
    
    _nextButton = [UIButton new];
    _nextButton.backgroundColor = [UIColor whiteColor];
    _nextButton.layer.cornerRadius = 4;
    [_nextButton setTitle:@"下一题" forState:UIControlStateNormal];
    _nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nextButton.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    _nextButton.layer.borderWidth = 1;
    [bottomBar addSubview:_nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(bottomBar.right).offset(-15);
        make.centerY.equalTo(bottomBar);
        make.width.equalTo(132);
        make.height.equalTo(34);
    }];
    [_nextButton addTarget:self action:@selector(nextQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
    _commitButton = [UIButton new];
    _commitButton.backgroundColor = [UIColor colorWithHexString:@"e83e0b"];
    _commitButton.layer.cornerRadius = 4;
    [_commitButton setTitle:@"交卷" forState:UIControlStateNormal];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomBar addSubview:_commitButton];
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(bottomBar.right).offset(-15);
        make.centerY.equalTo(bottomBar);
        make.width.equalTo(132);
        make.height.equalTo(34);
    }];
    [_commitButton addTarget:self action:@selector(commitQuestion:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _commitButton.hidden = YES;
}

@end
