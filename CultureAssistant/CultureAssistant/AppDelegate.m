//
//  AppDelegate.m
//  CultureAssistant
//


#import "AppDelegate.h"
#import "MainViewController.h"
#import "IQKeyboardManager.h"
#import "CustomNavigationController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initThirdKeyboard];
    
    MainViewController* mainVC = [[MainViewController alloc] init];
    CustomNavigationController* navi = [[CustomNavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navi;
    [self.window makeKeyWindow];
    return YES;
}

- (void)initThirdKeyboard{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //登录一次 获取新的token
    if ([UserInfoManager sharedInstance].isAlreadyLogin) {
        [self userLogin];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark-
- (void)userLogin
{
    UserInfo* userInfo = [UserInfoManager sharedInstance].userModel.userinfo;
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];

    NSString* accountStr = userInfo.userName;
    NSString* password = [userDefaults objectForKey:LocalUserPassword];
    if (!accountStr || !password) return;
    
    [AFNetAPIClient POST:APIUserLogin parameters:[RequestParameters toLogin:accountStr userPwd:password type:@"6"] showLoading:NO success:^(id JSON, NSError *error){
        
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if (200 == [model.code integerValue])
        {
            if ([model.result isKindOfClass:[NSString class]]) {
                
                NSString* jsonString = (NSString *)model.result;
                if (jsonString.length > 0) {
                    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                    [DeviceHelper sharedInstance].tokenCode = [dic objectForKey:@"tokenCode"];
                }
            }
            [UserInfoManager sharedInstance].isAlreadyLogin = YES;
            

            [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_volunteer_info" object:nil];
            [[UserInfoManager sharedInstance] getUserCenterInfo:^(BOOL finished){
                
            }];
        }else{
            [[UserInfoManager sharedInstance] deleteUserInfo];
        }
    }failure:^(id JSON, NSError *error){
        [[UserInfoManager sharedInstance] deleteUserInfo];
    }];
}

@end
