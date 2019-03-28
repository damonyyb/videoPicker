//
//  JYVideoEditCostuomBottomBarContainer.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/27.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYVideoSlider.h"
#import "JYSpeedSlider.h"
NS_ASSUME_NONNULL_BEGIN

@interface JYVideoEditCostuomBottomBarContainer : UIView
///左边按钮
@property (nonatomic, strong) JYPointSideButton *leftButton;
///标题
@property (nonatomic, strong) UILabel *titleLab;
///右边按钮
@property (nonatomic, strong) JYPointSideButton *rightButton;
///视频拖动
@property (nonatomic, strong) JYVideoSlider *slider;
///视频速度
@property (nonatomic, strong) JYSpeedSlider *speedSlider;
///动作类型
@property (nonatomic, assign) JYVideoMakeDetailAction action;

//返回
@property (nonatomic, copy) void (^leftButtonBlock)(void);
//右边button
@property (nonatomic, copy) void (^rightButtonBlock)(JYVideoMakeDetailAction action);
///展示/隐藏
- (void)showBottomBar:(BOOL)show super:(UIView *)super;

@end

NS_ASSUME_NONNULL_END
