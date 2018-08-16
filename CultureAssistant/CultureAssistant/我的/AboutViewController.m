//
//  AboutViewController.m
//  CultureAssistant
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于";
    
    UIScrollView* scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    UIImageView* logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_logo"]];
    [scrollView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view);
        make.top.equalTo(30);
    }];
    
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_app"]];
    [scrollView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view);
        make.top.equalTo(logoView.bottom).offset(25);
    }];
    
    
    UILabel* textLabel = [UILabel new];
    textLabel.numberOfLines = 0;
    [scrollView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(20);
        make.width.equalTo(SCREENWIDTH-40);
        make.top.equalTo(imgView.mas_bottom).offset(20);
        make.height.equalTo(10);
    }];
    
    NSString* content = @"中国盲文图书馆文化助盲APP旨在为中国盲文图书馆及各分支馆建立统一的志愿者管理平台，依托互联网、尤其是移动互联网技术，利用数字化信息化手段，方便志愿者招募、志愿服务，志愿者培训、管理交流，志愿服务宣传、志愿服务评估等志愿者管理工作的开展。";
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 24.0f;
    [paragraphStyle setLineSpacing:12];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, [attributedString length])];
    
    CGSize attSize = [attributedString boundingRectWithSize:CGSizeMake(SCREENWIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    
    textLabel.attributedText = attributedString;
    [textLabel mas_updateConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(attSize.height+20);
    }];
    
    
    UILabel* labe4 = [UILabel new];
    labe4.text = [NSString stringWithFormat:@"版本: %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    labe4.textAlignment = NSTextAlignmentCenter;
    labe4.font = [UIFont systemFontOfSize:14];
    labe4.textColor = [UIColor colorWithWhite:51/255.f alpha:1.f];
    [scrollView addSubview:labe4];

    
    UILabel* label3 = [UILabel new];
    label3.text = @"Copyright©2017,天闻数媒科技(北京)有限公司";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:11];
    label3.textColor = [UIColor colorWithWhite:153/255.f alpha:1.f];
    [scrollView addSubview:label3];
    
    if (SCREENHEIGHT > 568) {
        [label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
            make.height.equalTo(15);
        }];
        
        [labe4 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(label3.mas_bottom).offset(-20);
            make.height.equalTo(15);
        }];
    }else{
        [labe4 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(0);
            make.right.equalTo(SCREENWIDTH);
            make.bottom.equalTo(textLabel.mas_bottom).offset(40);
            make.height.equalTo(15);
        }];
        
        [label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(0);
            make.right.equalTo(SCREENWIDTH);
            make.bottom.equalTo(labe4.mas_bottom).offset(20);
            make.height.equalTo(15);
        }];
    }
    
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(label3.mas_bottom).offset(10);
    }];
}



@end
