//
//  JYVideoSlider.h
//  VideoCutDemo
//
//  Created by Joblee on 2019/2/20.
//  Copyright © 2019年 bh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JYVideSliderDelegate;
@interface JYVideoSlider : UIView

@property (nonatomic, weak) id <JYVideSliderDelegate> delegate;
//@property (nonatomic, strong) UILabel *bubleText;
//@property (nonatomic, strong) UIView *topBorder;
//@property (nonatomic, strong) UIView *bottomBorder;
//@property (nonatomic, assign) CGFloat maxGap;
//@property (nonatomic, assign) CGFloat minGap;
- (void)getMovieFrame:(NSURL *)videoUrl;
@end
@protocol JYVideSliderDelegate <NSObject>

@optional

- (void)JYVideoSlider:(JYVideoSlider *)slider endTime:(CGFloat)endTime;



@end
NS_ASSUME_NONNULL_END
