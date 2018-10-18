//
//  ScanningViewController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/14.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DCScanningViewController.h"

@interface ScanningViewController : DCScanningViewController

@property(nonatomic,copy)void(^feedbackScanningResult)(NSString *message);
@end
