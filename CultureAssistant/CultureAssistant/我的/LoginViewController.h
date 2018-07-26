//
//  LoginViewController.h
//  CultureAssistant
//

#import "CustomDetailViewController.h"

@interface LoginViewController : CustomDetailViewController

@property(nonatomic,copy)void(^loginSuccess)(void);

@property(nonatomic,assign)BOOL fromRegisterPage;

@end
