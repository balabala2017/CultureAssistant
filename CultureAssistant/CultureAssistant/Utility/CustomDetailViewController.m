//
//  CustomDetailViewController.m
//  CultureAssistant
//


#import "CustomDetailViewController.h"

@interface CustomDetailViewController ()

@property(nonatomic,strong)UIView* lineView;
@end

@implementation CustomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"\n\n>>>>>>>>>> %@\n\n",[self class]);
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    
//    UIColor * color = [UIColor blackColor];
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
//    self.navigationController.navigationBar.titleTextAttributes = dict;
//    
//    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
//    _lineView.backgroundColor = [UIColor colorWithHexString:@"dbdbdb"];
//    [self.navigationController.navigationBar addSubview:_lineView];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBarTintColor:BaseColor];
//    
//    UIColor * color = [UIColor whiteColor];
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
//    self.navigationController.navigationBar.titleTextAttributes = dict;
//    
//    [_lineView removeFromSuperview];
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)backButtonClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swipeBack:(UISwipeGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
