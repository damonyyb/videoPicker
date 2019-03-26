//
//  JYCircleView.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/26.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
NS_ASSUME_NONNULL_BEGIN

@interface CircleProgressLayer : CALayer
@property (nonatomic, assign) CGFloat progress;
@end

@interface JYCircleView : UIView<CAAnimationDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UILabel * progressLabel;
@property (strong,nonatomic) CircleProgressLayer * circleProgressLayer;
@end



NS_ASSUME_NONNULL_END
