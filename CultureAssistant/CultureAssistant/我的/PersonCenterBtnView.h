//
//  PersonCenterBtnView.h
//  CultureCloudApp
//
//  Created by deng qiulin on 17/1/16.
//  Copyright © 2017年 twsm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCenterButton : UIButton

@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* nameLabel;
@end

@interface PersonCenterBtnView : UIView

@property(nonatomic,copy)void(^gotoPersonBehaviourVC)(NSInteger index);
- (void)refreshContent;
@end
