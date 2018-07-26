//
//  RegisterDropTableView.h
//  CultureAssistant
//

#import <UIKit/UIKit.h>

@interface RegisterDropTableView : UIView

@property(nonatomic,strong)NSArray* cityArray;
@property(nonatomic,strong)void(^closeHandler)(void);
@property(nonatomic,strong)void(^selectCityHandler)(CityModel* city);
@end
