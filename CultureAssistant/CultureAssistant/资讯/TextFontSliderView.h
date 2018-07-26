//
//  TextFontSliderView.h
//  CultureAssistant
//


#import <UIKit/UIKit.h>

@interface TextFontSliderView : UIView

@property(nonatomic,assign)CGFloat sliderValue;
@property(nonatomic,copy)void(^dismissFontSliderHandler)(void);
@property(nonatomic,copy)void(^changeTextFontHandler)(CGFloat value);
- (void)showSliderView;
- (void)hideSliderView;
@end
