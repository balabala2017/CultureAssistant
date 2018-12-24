//
//  NewsDetailViewController.m
//  CultureAssistant
//


#import "NewsDetailViewController.h"

#import <WebKit/WebKit.h>
#import "TextFontSliderView.h"
#import "MRZoomScrollView.h"


@interface NewsDetailViewController ()<MRZoomScrollViewDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *sourceLabel;
@property(nonatomic,strong)UILabel *readCountLabel;

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,assign)NSInteger textFont;//改变页面字体大小
@property(nonatomic,strong)TextFontSliderView* sliderView;
@property(nonatomic,assign)CGFloat sliderValue;

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSMutableArray* mUrlArray;

//请求详情返回结果
@property(nonatomic,strong)ArticleDetail* articleItem;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createSubViews];
    
    if (self.detailId) {
        [self getArticle:self.detailId];
    }
    
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
            
            [wself updateWebVWithContent:self.articleItem.CONTENT];
        }
    }failure:^(id JSON, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



-(void)updateWebVWithContent:(NSString*)_content
{
    if (self.articleItem.TITLE.length>0) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 5;
        NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSParagraphStyleAttributeName:paraStyle};
        
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self.articleItem.TITLE attributes:dic];
        _titleLabel.attributedText = attributeStr;
    }
    
    NSString* dateStr = self.articleItem.PUBLISH_TIME;
    if (self.articleItem.PUBLISH_TIME.length>0) {
        NSArray* array = [self.articleItem.PUBLISH_TIME componentsSeparatedByString:@" "];
        if (array.count > 0) {
            dateStr = [array firstObject];
        }
        _timeLabel.text = [NSString stringWithFormat:@"时间：%@",dateStr];
    }
    _sourceLabel.text = [NSString stringWithFormat:@"来源：%@",self.articleItem.SOURCE];
    _readCountLabel.text = [NSString stringWithFormat:@"点击：%@",self.articleItem.READ_COUNT];
    
    
    NSString *html = [self changeToHTML:_content];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"templateMeeting" ofType:@"html"];
    [self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:htmlPath]];
}

- (NSString *)changeToHTML:(NSString *)string
{
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"templateMeeting" ofType:@"html"];
    NSMutableString *htmlString = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    NSRange titleRange = [htmlString rangeOfString:@"{title}"];
//    if (titleRange.location != NSNotFound) {
//        [htmlString replaceCharactersInRange:titleRange withString:self.articleItem.TITLE.length>0?self.articleItem.TITLE:@""];
//    }
//    NSRange dateRange = [htmlString rangeOfString:@"{date}"];
//    if (dateRange.location != NSNotFound)
//    {
//        NSString* dateStr = @"";
//        if (self.articleItem.PUBLISH_TIME.length>0) {
//            NSArray* array = [self.articleItem.PUBLISH_TIME componentsSeparatedByString:@" "];
//            if (array.count > 0) {
//                dateStr = [array firstObject];
//            }
//        }
//        NSString *dateString = [NSString stringWithFormat:@"时间：%@            来源：%@           点击：%@", dateStr,self.articleItem.SOURCE.length>0?self.articleItem.SOURCE:@"", self.articleItem.READ_COUNT.length>0?self.articleItem.READ_COUNT:@""];
//        [htmlString replaceCharactersInRange:dateRange withString:dateString];
//    }
    NSRange contentRange = [htmlString rangeOfString:@"{content}"];
    if (contentRange.location != NSNotFound) {
        [htmlString replaceCharactersInRange:contentRange withString:(self.articleItem.CONTENT?self.articleItem.CONTENT:@"")];
    }
    return htmlString;
}

- (void)swipeBack:(UISwipeGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *requestString = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        [self showBigImage:imageUrl];//创建视图并显示图片
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (self.articleItem) {
        
    }
    
    [webView evaluateJavaScript:@"adjustImagePosition()" completionHandler:nil];
    
    
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){"
    @" var objs = document.getElementsByTagName(\"img\");"
    @" var imgScr = '';"
    @" for(var i=0;i<objs.length;i++){"
    @"     imgScr = imgScr + objs[i].src + '+';"
    @" };"
    @" return imgScr;"
    @"};";
    
    [webView evaluateJavaScript:jsGetImages completionHandler:nil];//注入js方法
    
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(NSString *urlResurlt, NSError * error){
        self.mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
        if (self.mUrlArray.count >= 2) {
            [self.mUrlArray removeLastObject];
        }
    }];
    
    //urlResurlt 就是获取到得所有图片的url的拼接；mUrlArray就是所有Url的数组
    //添加图片可点击js
    NSString* jsString =
    @"function registerImageClickAction(){"
    @" var objs = document.getElementsByTagName(\"img\");"
    @" for(var i=0;i<objs.length;i++){"
    @"      objs[i].onclick=function(){"
    @"                                 document.location=\"myweb:imageClick:\"+this.src;"
    @"                                };"
    @"  };"
    @"  return objs;"
    @"};";
    
    [webView evaluateJavaScript:jsString completionHandler:nil];
    [webView evaluateJavaScript:@"registerImageClickAction();" completionHandler:nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NewsDetail_Font"]) {
        NSString *textSizeJS = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%li%%'", (long)_textFont];
        [_webView evaluateJavaScript:textSizeJS completionHandler:nil];
    }
    
    [webView evaluateJavaScript: @"document.body.scrollHeight" completionHandler:^(NSString *string, NSError * error){
        CGFloat scrollHeight = [string floatValue];
        
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make){
            make.height.equalTo(scrollHeight);
        }];
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(self.webView.bottom);
        }];
        
    }];
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark-
-(void)showBigImage:(NSString *)imageUrl{
    //创建灰色透明背景，使其背后内容不可操作
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.bgView setBackgroundColor:[UIColor blackColor]];
    [window addSubview:self.bgView];
    
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.bgView.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self.bgView addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(self.mUrlArray.count*SCREENWIDTH, 0);
    
    for (NSInteger i = 0; i < self.mUrlArray.count; i++)
    {
        NSString* urlString = self.mUrlArray[i];
        
        MRZoomScrollView* imgView = [[MRZoomScrollView alloc] initWithFrame:CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)];
        imgView.delegate = self;
        [scrollView addSubview:imgView];
        [imgView setBackgroundColor:[UIColor clearColor]];
        imgView.imageUrl = urlString;
    }
    
    NSInteger index = [self.mUrlArray indexOfObject:imageUrl];
    scrollView.contentOffset = CGPointMake(index*SCREENWIDTH, 0);
}

-(void)imageViewHaveHidden
{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
}

#pragma mark-
- (void)createSubViews{
    
    UIButton *fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fontBtn.frame = CGRectMake(0, 0, 44, 44);
    [fontBtn setImage:[UIImage imageNamed:@"change_textFont"] forState:UIControlStateNormal];
    [fontBtn addTarget:self action:@selector(changeTextFontClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fontItem = [[UIBarButtonItem alloc]initWithCustomView:fontBtn];
    
    
    self.navigationItem.rightBarButtonItem = fontItem;
    
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NewsDetail_Font"]) {
        NSNumber *num = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"NewsDetail_Font"];
        self.sliderValue = [num floatValue];
    }else{
        self.sliderValue = 0.25;
    }

    [self setWebViewFont];
    
    
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"标题标题标题标题";
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor colorWithHexString:@"212121"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_scrollView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(10);
        make.left.equalTo(10);
        make.width.equalTo(SCREENWIDTH-20);
    }];
    
    WeakObj(self);
    _timeLabel = [UILabel new];
    _timeLabel.text = @"时间：2017.12.08";
    _timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
    _timeLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(wself.titleLabel.bottom).offset(10);
        make.left.equalTo(wself.titleLabel);
    }];
    
    _sourceLabel = [UILabel new];
    _sourceLabel.text = @"来源：原创";
    _sourceLabel.textColor = [UIColor colorWithHexString:@"666666"];
    _sourceLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:_sourceLabel];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(wself.timeLabel);
        make.centerX.equalTo(wself.view);
    }];
    
    _readCountLabel = [UILabel new];
    _readCountLabel.text = @"点击：100";
    _readCountLabel.textColor = [UIColor colorWithHexString:@"666666"];
    _readCountLabel.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:_readCountLabel];
    [_readCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(wself.timeLabel);
        make.right.equalTo(wself.view.right).offset(-10);
    }];

    
    self.webView = [WKWebView new];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.webView.navigationDelegate = self;
    [self.webView setMultipleTouchEnabled:YES];
    [self.webView setAutoresizesSubviews:YES];
    [self.webView.scrollView setAlwaysBounceVertical:YES];
    self.webView.scrollView.bounces = NO;
    [_scrollView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(wself.timeLabel.bottom);
        make.left.equalTo(0);
        make.width.height.equalTo(SCREENWIDTH);
    }];
    
    [_scrollView updateConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.webView);
    }];
    
}

- (void)changeTextFontClicked:(id)sender{
    typeof(self) __weak wself = self;
    if (!self.sliderView) {
        self.sliderView = [TextFontSliderView new];
        [self.view addSubview:self.sliderView];
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
        [self.sliderView showSliderView];
        self.sliderView.sliderValue = self.sliderValue;
        self.sliderView.dismissFontSliderHandler = ^{
            [UIView animateWithDuration:.3 animations:^{
                [wself.sliderView hideSliderView];
            }completion:^(BOOL finished){
                [wself.sliderView removeFromSuperview];
                wself.sliderView = nil;
            }];
        };
        self.sliderView.changeTextFontHandler = ^(CGFloat value){
            [wself updateWebViewTextSize:value];
        };
    }else{
        [UIView animateWithDuration:.3 animations:^{
            [wself.sliderView hideSliderView];
        }completion:^(BOOL finished){
            [wself.sliderView removeFromSuperview];
            wself.sliderView = nil;
        }];
    }
}

//改变页面字体大小
- (void)updateWebViewTextSize:(CGFloat)size
{
    if (self.sliderValue == size) return;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:size] forKey:@"NewsDetail_Font"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.sliderValue = size;
    [self setWebViewFont];

    NSString *textSizeJS = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%li%%'", (long)_textFont];
    [_webView evaluateJavaScript:textSizeJS completionHandler:nil];
}


- (void)setWebViewFont
{
    if (self.sliderValue == 0) {
        _textFont = 50;
    }
    else if (self.sliderValue == 0.25) {
        _textFont = 100;
    }
    else if (self.sliderValue == 0.5) {
        _textFont = 150;
    }
    else if (self.sliderValue == 0.75) {
        _textFont = 200;
    }
    else {
        _textFont = 250;
    }
}


@end
