//
//  CityViewController.h
//  CultureAssistant
//


#import "CustomDetailViewController.h"

@interface CityViewController : CustomDetailViewController

@property(nonatomic,strong)NSString* locationCity;//将获取的定位城市名称传递过来

@property(nonatomic,copy)void(^citySelectedFinished)(CityModel *item);
@end
