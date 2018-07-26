//
//  ImagesNewsDetailController.m
//  CultureAssistant
//


#import "ImagesNewsDetailController.h"
#import "MRZoomScrollView.h"

@interface ImagesNewsDetailController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView* scrollView;

@property(nonatomic,strong)ArticleDetail* articleItem;

@property(nonatomic,strong)NSArray* contentArray;
@property(nonatomic,strong)UIView* contentView;//下半部分的文字描述
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UILabel* numberLabel;
@property(nonatomic,strong)UITextView* textView;

@property(nonatomic,assign)BOOL showDesc;
@end

@implementation ImagesNewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createSubViews];
    
    self.showDesc = YES;
    
    if (self.detailId) {
        [self getArticle:self.detailId];
    }
    
}

- (void)onTapGesture:(UITapGestureRecognizer *)gesture{
    
    self.showDesc = !self.showDesc;
    [UIView animateWithDuration:0.5 animations:^{
        if (!self.showDesc) {
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make){
                make.bottom.equalTo(self.view).offset(160);
            }];
        }else{
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make){
                make.bottom.equalTo(self.view);
            }];
        }
    }completion:^(BOOL finished){
        
    }];
}

- (void)getArticle:(NSString *)aid{
    typeof(self) __weak wself = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetAPIClient GET:APIGetArticleDetail parameters:[RequestParameters getArticleById:aid] success:^(id JSON, NSError *error){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        DataModel* model  = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.result isKindOfClass:[NSDictionary class]])
        {
            self.articleItem = [[ArticleDetail alloc] initWithDictionary:(NSDictionary *)model.result error:nil];
            
            [wself layoutImageView];
        }
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)layoutImageView
{
    self.titleLabel.text = self.articleItem.TITLE;
    
    if (self.articleItem.ATTACH_JSONSTR.length <= 0) return;
    
    self.contentArray = [NSJSONSerialization JSONObjectWithData:[ self.articleItem.ATTACH_JSONSTR dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingMutableContainers error:nil];
    for (NSInteger i = 0; i < self.contentArray.count; i++)
    {
        NSDictionary* dic = self.contentArray[i];
        
        MRZoomScrollView* imgView = [[MRZoomScrollView alloc] initWithFrame:CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)];
        imgView.needTapGesture = NO;
        [_scrollView addSubview:imgView];
        [imgView setBackgroundColor:[UIColor clearColor]];
        imgView.imageUrl = dic[@"picUrl"];
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"1/%ld",(long)self.contentArray.count];
    NSDictionary* dic = self.contentArray[0];
    self.textView.text = dic[@"picDesc"];
    
    _scrollView.contentSize = CGSizeMake(self.contentArray.count*SCREENWIDTH, 0);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)onTapBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark-
- (void)createSubViews{
    UIButton* backBtn = [UIButton new];
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onTapBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(20);
        make.left.equalTo(20);
        make.width.height.equalTo(44);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(backBtn);
        make.left.equalTo(backBtn.right);
        make.right.equalTo(self.view);
    }];
    

    _scrollView = [UIScrollView new];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)]];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleLabel.bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-45);
    }];
    
    //下半部分描述信息
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(155);
    }];
    
    self.numberLabel = [UILabel new];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(10);
        make.left.equalTo(0);
        make.width.equalTo(50);
    }];
    

    self.textView = [UITextView new];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.editable = NO;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.numberLabel.right);
        make.right.bottom.equalTo(self.contentView);
        make.top.equalTo(0);
    }];

}

#pragma mark-
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSUInteger index = scrollView.contentOffset.x / _scrollView.frame.size.width;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)(index+1),(long)self.contentArray.count];
    NSDictionary* dic = self.contentArray[index];
    self.textView.text = dic[@"picDesc"];
    
    if (_scrollView.contentOffset.x < -50) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
