//
//  JYVideoRecordSliderView.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/12.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYVideoRecordSliderView : UIView
@property (nonatomic, copy) void(^updateSbuffingValueBlock)(CGFloat value);
@property (nonatomic, copy) void(^updateSkinWhiteningValueBlock)(CGFloat value);
///美颜值
@property (nonatomic, assign) CGFloat beautySliderValue;
///更新字体颜色
- (void)setTextColor:(UIColor*)color;
///更新磨皮
- (void)updateSbuffingValueWithValue:(float)value;
///更新美白
- (void)updateSkinWhiteningValueWithValue:(float)value;
@end

NS_ASSUME_NONNULL_END
