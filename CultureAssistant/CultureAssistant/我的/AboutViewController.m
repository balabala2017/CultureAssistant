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
    
    NSString* content = @"       文化助盲以弘扬中华传统文化为己任，坚持做传递正能量的高品质文化传播交流平台。依托大数据等先进技术，汇集全网热点文化资讯，提供丰富的传统文化资源；创新文化互动活动，扶持各地文化特色产品发展。为全民文化交流提供个性展示舞台，为文化机构等提供互联网宣传运营平台。\n       专业的运营团队，具有丰富的线上线下运营经验，热忱期待与各地文化机构等进行广泛合作，共同弘扬中华民族传统！";
    
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
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
