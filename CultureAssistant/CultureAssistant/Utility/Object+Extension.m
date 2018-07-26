//
//  Object+Extension.m
//  AgedCulture
//


#import "Object+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Object_Extension
+ (NSMutableAttributedString *)customNSMutableAttributedAllString:(NSString *)string contentStrs_Colors_Fonts:(NSArray <NSArray  *>*)list
{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5; //设置行间距
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@.0f
                          };
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:dic];
    
    
    
    for (NSArray * arr in list) {
        NSString * str = arr[0];
        UIColor * color = arr[1];
        UIFont * font = arr[2];
        [attributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      font,NSFontAttributeName,
                                      color,NSForegroundColorAttributeName,
                                      nil] range:[string rangeOfString:str]];
    }
    
    

    return attributedStr;
}

@end

@implementation UIColor (Extension)

+(UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

// 十六进制string加载颜色（[UIColor colorWithHexString:@"f5f5f5"]）
+ (UIColor *)colorWithHexString:(NSString *)string
{
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([pureHexString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *gString = [pureHexString substringWithRange:range];
    
    range.location += range.length ;
    NSString *bString = [pureHexString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end

@implementation UIImage (Extension)
- (NSString *)UIImageToMD5
{
    unsigned char result[16];
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self)];
    
    if (!imageData) return @"";
    
    CC_MD5([imageData bytes], (unsigned int)[imageData length], result);
    
    NSString *imageHash = [NSString stringWithFormat:
                           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return imageHash;
}
- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

@implementation UIButton (constructor)
+(instancetype )buttonWithType:(UIButtonType)buttonType tag:(NSInteger)tag title:(NSString *)title frame:(CGRect)frame backImage:(UIImage*) image target:(id)target action:(SEL)action
{
    
    UIButton * button = [[self class] buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}

+(instancetype)buttonWithImageNormal:(UIImage*)image imageSelected:(UIImage*)imageSelected imageEdge:(UIEdgeInsets)imageEdge title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton * button = [[self class] buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:imageSelected forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.imageEdgeInsets = imageEdge;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(instancetype )buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton * button = [[self class] buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end

@implementation UILabel (constructor)

+(UILabel *)labelWithText:(NSString *)text textAlign:(NSTextAlignment)textAlign textFont:(UIFont *)font{
    UILabel* label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.font = font;
    label.textAlignment = textAlign;
    return label;
}
@end

@implementation CustomTextField

-(UILabel *)placeHolderLab
{
    if (self.placeHolderLab == nil) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.placeHolderLab = [UILabel new];
        self.placeHolderLab.text = self.placeholder;
        self.placeHolderLab.font = self.font;
        self.placeHolderLab.textColor = [UIColor colorWithWhite:.7 alpha:1];
        self.placeHolderLab.textAlignment = NSTextAlignmentLeft;
        CGRect diffRect = [self editingRectForBounds:self.bounds];
        [self.superview addSubview:self.placeHolderLab];
        [self.placeHolderLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self);
            make.left.equalTo(self).offset(diffRect.origin.x);
        }];
    }
    return self.placeHolderLab;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    [super leftViewRectForBounds:bounds];
    return CGRectMake(10, (bounds.size.height-20)/2, 20, 20);
}
- (CGRect)textRectForBounds:(CGRect)bounds
{
    [super leftViewRectForBounds:bounds];
    if (self.leftView) {
        return CGRectMake(30, 0, (bounds.size.width-40), (bounds.size.height));
    }
    return CGRectMake(10, 0, (bounds.size.width-20), (bounds.size.height));
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    [super editingRectForBounds:bounds];
    if (self.leftView)
    {
        return  CGRectMake(30, 0, (bounds.size.width-40), (bounds.size.height));
    }
    return CGRectMake(10, 0, (bounds.size.width-20), (bounds.size.height));
}
@end

@implementation CustomTextField (constructor)

+(CustomTextField *)textFieldWithPlaceholder:(NSString *)placeholder textFont:(UIFont *)font{
    CustomTextField* textField = [CustomTextField new];
    textField.placeholder = placeholder;
    textField.font = font;
    textField.layer.borderColor = [UIColor colorWithWhite:0xD7/255.0 alpha:1.0].CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 4;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

@end

@interface UITableViewSub ()
{
    UIActivityIndicatorView *activityIV;
}
@end

@implementation UITableViewSub
@synthesize _showActivity;
-(instancetype)init
{
    if (self = [super init]) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)set_showActivity:(BOOL)showActivity
{
    _showActivity = showActivity;
    
    if (activityIV.superview == nil) {
        activityIV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:activityIV];
        activityIV.center = self.center;
//        [activityIV makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.superview);
//            make.width.height.equalTo(30);
//        }];
    }
    activityIV.hidden = !_showActivity;
    if (_showActivity) {
        [activityIV startAnimating];
    }
}

@end



@implementation MBProgressHUD (Extension)

+(void)MBProgressHUDWithView:(UIView *)view Str:(NSString *)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.yOffset = view.center.y/2.0; // CGPointMake(view.center.x, view.center.y *1.5);
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
    hud.labelText = str;
}
@end

#pragma mark-
@implementation NSString (Extension)
//判断字符串是不是纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    //多添加一个判断，超过11位不是电话号码
    if (string.length!=11) {
        return NO;
    }
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
//校验邮编
+ (BOOL) isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    unsigned long len = strlen(cvalue);
    if (len != 6) {
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}

//校验email
+ (BOOL) validateEmail:(NSString *)candidate
{
    NSArray *array = [candidate componentsSeparatedByString:@"."];
    if ([array count] >= 4) {
        return FALSE;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

//判断身份证号码是否正确
+ (BOOL)validateIdentityCard:(NSString *)IDCardNumber{
    if (IDCardNumber.length == 15)
    {
        //|  地址  |   年    |   月    |   日    |
        NSString *regex = @"^(\\d{6})([3-9][0-9][01][0-9][0-3])(\\d{4})$";
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [identityCardPredicate evaluateWithObject:IDCardNumber];
    }
    else if (IDCardNumber.length == 18)
    {
        NSMutableArray *IDArray = [NSMutableArray array];
        // 遍历身份证字符串,存入数组中
        for (int i = 0; i <18; i++) {
            NSRange range = NSMakeRange(i, 1);
            NSString *subString = [IDCardNumber substringWithRange:range];
            [IDArray addObject:subString];
        }
        // 系数数组
        NSArray *coefficientArray = @[@7, @9, @10, @5, @8, @4, @2, @1, @6, @3, @7, @9, @10, @5, @8, @4, @"2"];
        // 余数数组
        NSArray *remainderArray = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        // 每一位身份证号码和对应系数相乘之后相加所得的和
        int sum = 0;
        for (int i = 0; i <17; i++) {
            int coefficient = [coefficientArray[i] intValue];
            int ID = [IDArray[i] intValue];
            sum += coefficient * ID;
        }
        // 这个和除以11的余数对应的数
        NSString *str = remainderArray[(sum % 11)];
        // 身份证号码最后一位
        NSString *string = [IDCardNumber substringFromIndex:17];
        // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
        return [str isEqualToString:string];
    }
    return NO;
}

+ (NSString *)ConvertStr:(NSString *)str
{
    NSMutableString * phoneStr = [NSMutableString stringWithString:str];
    [phoneStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return phoneStr;
}

+(NSString *)normalizateNSString:(NSString *)aString{
    NSString *string = [[NSString alloc] initWithString:aString];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&#183;" withString:@"."];
    string = [string stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
    return string;
}

- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}


- (CGFloat)heightForLayoutWithFont:(UIFont *)font width:(CGFloat)width{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

- (NSDate *)convertToDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self];
    return date;
}
@end
#pragma mark-
@implementation DefaultImages

+(DefaultImages *)shareDefaultImages
{
    static DefaultImages * s_instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        s_instance = [[DefaultImages alloc] init];
        s_instance.defaultImages = [NSMutableArray array];
    });
    return s_instance;
}


-(UIImage *)drawDefaultImage:(CGRect)frame
{
    if ((frame.size.width<.5) && (frame.size.height<.5)) {
        return nil;
    }
    CGSize size= CGSizeMake (frame. size . width , frame. size . height ); // 画布大小
    
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    
    
    CGContextRef context= UIGraphicsGetCurrentContext ();
    
    
    CGContextDrawPath (context, kCGPathStroke );
    
    
    CGContextAddRect(context, frame);
    
    [[UIColor colorWithWhite:205.0/255.0 alpha:1] setFill];
    CGContextFillPath(context);
    
    
    // 画 打败了多少用户
    float fontSize = 25;
    float place = 10;
    NSDictionary * attrs = @{ NSFontAttributeName :[ UIFont fontWithName : @"Arial-BoldMT" size : fontSize ], NSForegroundColorAttributeName :[ UIColor whiteColor ] };
    
    CGSize strSize = [@"文化助盲" sizeWithAttributes:attrs];
    do {
        attrs = @{ NSFontAttributeName :[ UIFont fontWithName : @"Arial-BoldMT" size : fontSize ], NSForegroundColorAttributeName :[ UIColor whiteColor ] };
        strSize =[@"文化助盲" sizeWithAttributes:attrs];
        fontSize = fontSize - 1;
        place = place/2;
    } while (strSize.width>size.width/2);
    
    place = 5+place;
    
    [@"文化助盲" drawInRect:CGRectMake((size.width-strSize.width)/2, size.height/2-strSize.height-place, size.width, size.height)  withAttributes:attrs];
    
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextMoveToPoint(context, 10, size.height/2);
    CGContextAddLineToPoint(context, size.width-10, size.height/2);
    CGContextStrokePath(context);
    
    attrs = @{ NSFontAttributeName :[ UIFont fontWithName : @"Arial-BoldMT" size : fontSize/1.5 ], NSForegroundColorAttributeName :[ UIColor whiteColor ] };
    
    strSize =[@"加载中..." sizeWithAttributes:attrs];
    [@"加载中..." drawInRect:CGRectMake((size.width-strSize.width)/2, size.height/2+place, size.width, size.height)  withAttributes:attrs];
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    //NSLog(@"newImage:=====%@",newImage);
    UIGraphicsEndImageContext ();
    
    return newImage;
    return nil;
}

-(UIImage *)placeholderImage:(CGRect)frame
{
    UIImage * placeholder = nil;
    BOOL isDrawed = NO;
    for (UIImage * image in [DefaultImages shareDefaultImages].defaultImages) {
        if (((int)image.size.width == (int)frame.size.width) && ((int)image.size.height == (int)frame.size.height)) {
            placeholder = image;
            isDrawed = YES;
            break;
        }
    }
    if (isDrawed == NO) {
        placeholder = [self drawDefaultImage:frame];
        if (placeholder) {
            [[DefaultImages shareDefaultImages].defaultImages addObject:placeholder];
        }
    }
    return placeholder;
}

@end


@implementation UIImageView_SD

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    
    if (self.image == nil) {
        if (![[[UIDevice currentDevice] model] isEqualToString:@"iPad"]){
            self.image = [[DefaultImages shareDefaultImages] placeholderImage:self.bounds];
        }
    }
}


@end

@implementation NSDictionary (Unicode)
- (NSString*)my_description {
    NSString *desc = [self description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}
@end


#pragma mark-
@implementation Utility

+ (UITextField *)textFieldForLoginWithplaceholder:(NSString *)placeholder{
    UITextField* textField = [UITextField new];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    textField.attributedPlaceholder = attrString;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textColor = [UIColor whiteColor];
    textField.font = [UIFont boldSystemFontOfSize:24];
    return textField;
}

//修正照片方向(手机转90度方向拍照)
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (NSDate *)stringConvertToDate:(NSString *)dateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [format setTimeZone:timeZone];
    [format setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [format dateFromString:dateString];
    NSLog(@"%s  date  %@",__func__,date);
    return date;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end

#pragma mark- NSArray+JSON
@implementation NSArray (JSON)

- (NSString *)toJSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

- (NSString *)toReadableJSONString {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

- (NSData *)toJSONData {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    
    return data;
}

@end
