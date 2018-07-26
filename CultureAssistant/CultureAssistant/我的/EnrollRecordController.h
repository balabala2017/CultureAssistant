//
//  EnrollRecordController.h
//  CultureAssistant
//


#import "CustomDetailViewController.h"

//个人中心里面的待审核、待参加、服务中、待评价、待确定、我的报名都是这个页面，我的报名包含前面的

//0-已提交, 1-待审核, 2-审核通过/待发布（待参加）, 3-审核不通过, 4-取消审核; 5:服务中; 6:待评价; 7:待确定; 8:已确认
@interface EnrollRecordController : CustomDetailViewController
@property(nonatomic,strong)NSString* recordStatus;
@end
