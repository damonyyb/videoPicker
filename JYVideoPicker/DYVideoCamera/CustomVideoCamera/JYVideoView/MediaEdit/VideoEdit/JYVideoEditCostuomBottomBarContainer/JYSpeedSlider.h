//
//  JYSpeedSlider.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/28.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYSpeedSlider : UIView
@property (nonatomic, strong) UILabel *timeLabel;
///速度
@property (nonatomic, assign) CGFloat rate;
///是否倒放
@property (nonatomic, assign) BOOL isRunback;
@end

NS_ASSUME_NONNULL_END
