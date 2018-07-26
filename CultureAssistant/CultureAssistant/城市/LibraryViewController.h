//
//  LibraryViewController.h
//  CultureAssistant
//


#import <UIKit/UIKit.h>

@interface LibraryViewController : UIViewController

@property(nonatomic,strong)CityModel* cityModel;
@property(nonatomic,copy)void(^selectedLibraryFinished)(void);
@end
