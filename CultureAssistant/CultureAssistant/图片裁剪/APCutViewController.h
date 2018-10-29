//
//  APCutViewController.h
//  CultureAssistant
//
//  Created by zhu yingmin on 2018/10/19.
//  Copyright © 2018年 天闻. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * horizontal = @"horizontal";
static NSString *  vertical = @"vertical";

@protocol CutPhotoDelegate <NSObject>

- (void)cutPhoto:(UIImage *)image withOrientation:(NSString *)orientation;

@end

@interface APCutViewController : UIViewController

@property (nonatomic, weak) id<CutPhotoDelegate> delegate;

- (id)initWithImage:(UIImage *)originalImage;
@end

NS_ASSUME_NONNULL_END
