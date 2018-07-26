//
//  RecruitListViewController.h
//  CultureAssistant
//

#import <UIKit/UIKit.h>

@interface RecruitListViewController : UIViewController
@property(nonatomic,strong)NSString* activeState;
@property(nonatomic,copy)void(^scrollHandler)(NSString* direction);
@end
