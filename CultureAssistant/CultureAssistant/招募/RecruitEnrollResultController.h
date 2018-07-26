//
//  RecruitEnrollResultController.h
//  CultureAssistant
//

#import <UIKit/UIKit.h>

@interface RecruitEnrollResultController : UIViewController

@property(nonatomic,copy)void(^enrollFinishedHandler)(void);
@end
