//
//  RecruitPostDescController.h
//  CultureAssistant
//


#import "CustomDetailViewController.h"

@interface RecruitPostDescController : CustomDetailViewController

@property(nonatomic,strong)NSString* eventId;

@property(nonatomic,copy)void(^enrollSucessHandler)(void);
@end
