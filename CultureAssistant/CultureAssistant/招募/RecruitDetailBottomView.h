//
//  RecruitDetailBottomView.h
//  CultureAssistant
//


#import <UIKit/UIKit.h>

@interface RecruitDetailBottomView : UIView

@property(nonatomic,strong)RecruitDetail* recruitDetail;

//获取活动报名人员列表
- (void)getEventApplys:(NSString *)eventId;
//获取招募活动动态信息
- (void)getEventDynamics:(NSString *)eventId;
@end
