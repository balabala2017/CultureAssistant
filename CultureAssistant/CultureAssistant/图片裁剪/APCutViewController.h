//
//  APCutViewController.h
//  CultureAssistant
//
//  Created by zhu yingmin on 2018/10/19.
//  Copyright © 2018年 天闻. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPImageresizerView.h"

NS_ASSUME_NONNULL_BEGIN


@protocol CutPhotoDelegate <NSObject>

- (void)cutPhoto:(UIImage *)image;

@end

@interface APCutViewController : UIViewController

@property (nonatomic, weak) id<CutPhotoDelegate> delegate;

@property (nonatomic, strong) JPImageresizerConfigure *configure;
@end

NS_ASSUME_NONNULL_END
