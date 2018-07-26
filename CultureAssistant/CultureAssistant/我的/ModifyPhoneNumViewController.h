//
//  ModifyPhoneNumViewController.h
//  CultureAssistant
//

#import "CustomDetailViewController.h"

//同时用于第三方登录时绑定手机号
@interface ModifyPhoneNumViewController : CustomDetailViewController

//第三方登录时用到
@property(nonatomic,strong)NSString* openid;
@property(nonatomic,strong)NSString* type;
@property(nonatomic,strong)NSString* nickName;
@property(nonatomic,strong)NSString* headerIconUrl;
@property(nonatomic,strong)NSString* sex;
@end
