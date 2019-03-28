//
//  JYNavingationBar.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/20.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYPointSideButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface JYNavingationBar : UIView

@property (nonatomic, strong) JYPointSideButton *backButton;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) JYPointSideButton *rightButton;

//返回
@property (nonatomic, copy) void (^backButtonBlock)(void);
//右边button
@property (nonatomic, copy) void (^rightButtonBlock)(void);

/**
 设置白色风格
 */
- (void)setWithStyle;

/**
 设置title
 */
- (void)setTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
