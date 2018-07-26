//
//  Object+Extension.h
//  AgedCulture
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface Object_Extension : NSObject
+ (NSMutableAttributedString *)customNSMutableAttributedAllString:(NSString *)string contentStrs_Colors_Fonts:(NSArray <NSArray  *>*)list;//数组中存放的数组，数组元素中包含字符串、颜色、字体

@end

@interface UIColor (Extension)
+ (UIColor *)randomColor;
+ (UIColor *)colorWithHexString:(NSString *)string;
@end

@interface UIImage (Extension)
- (NSString *)UIImageToMD5;
- (UIImage *)imageWithColor:(UIColor *)color;
@end

@interface UIButton (constructor)
+(UIButton *)buttonWithType:(UIButtonType)buttonType tag:(NSInteger)tag title:(NSString *)title frame:(CGRect)frame backImage:(UIImage*) image target:(id)target action:(SEL)action;
+(UIButton *)buttonWithImageNormal:(UIImage*)image imageSelected:(UIImage*)imageSelected imageEdge:(UIEdgeInsets)imageEdge title:(NSString *)title target:(id)target action:(SEL)action;
+(UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end

@interface UILabel (constructor)

+(UILabel *)labelWithText:(NSString *)text textAlign:(NSTextAlignment)textAlign textFont:(UIFont *)font;
@end

@interface CustomTextField : UITextField

@property (nonatomic,strong) UILabel * placeHolderLab;
@end

@interface CustomTextField (constructor)

+(CustomTextField *)textFieldWithPlaceholder:(NSString *)placeholder textFont:(UIFont *)font;
@end

@interface UITableViewSub : UITableView
@property (nonatomic,assign) BOOL _showActivity;

@end


@interface MBProgressHUD (constructor)

+(void)MBProgressHUDWithView:(UIView *)view Str:(NSString *)str;
@end

@interface NSString (Extension)
//判断字符串是不是纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;
/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;
//校验邮编
+ (BOOL) isValidZipcode:(NSString*)value;
//校验email
+ (BOOL) validateEmail:(NSString *)candidate;
//判断身份证号码是否正确
+ (BOOL)validateIdentityCard:(NSString *)IDCardNumber;

+ (NSString *)ConvertStr:(NSString *)str;

- (NSString *)MD5Hash;

- (CGFloat)heightForLayoutWithFont:(UIFont *)font width:(CGFloat)width;

- (NSDate *)convertToDate;
@end

#pragma mark-
@interface DefaultImages : NSObject

@property (strong, nonatomic)NSMutableArray * defaultImages;
+(DefaultImages *)shareDefaultImages;
-(UIImage *)placeholderImage:(CGRect)frame;
@end

@interface UIImageView_SD : UIImageView

@end

@interface NSDictionary (Unicode)
- (NSString*)my_description;
@end
#pragma mark-
@interface Utility : NSObject

+ (UITextField *)textFieldForLoginWithplaceholder:(NSString *)placeholder;
//修正照片方向(手机转90度方向拍照)
+ (UIImage *)fixOrientation:(UIImage *)aImage;
//字符串转换为时间
+ (NSDate *)stringConvertToDate:(NSString *)dateString;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

#pragma mark- NSArray+JSON
@interface NSArray (JSON)

/**
 *  转换成JSON串字符串（没有可读性）
 *
 *  @return JSON字符串
 */
- (NSString *)toJSONString;

/**
 *  转换成JSON串字符串（有可读性）
 *
 *  @return JSON字符串
 */
- (NSString *)toReadableJSONString;

/**
 *  转换成JSON数据
 *
 *  @return JSON数据
 */
- (NSData *)toJSONData;

@end

