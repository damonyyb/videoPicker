//
//  UIColor+JYHex.h
//  D2
//
//  Created by Joblee on 2018/12/6.
//  Copyright © 2018年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JYHex)
/**
 16进制颜色转换为UIColor
 
 @param hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制）
 @param opacity 透明度
 @return 16进制字符串对应的颜色
 */

+ (UIColor *)colorWithHexString:(NSString *)hexColor alpha:(float)opacity;

/**
 16进制颜色转换为UIColor
 
 @param hexColor hexColor 16进制字符串（可以以0x开头，可以以#开头，也可以就是6位的16进制)
 @return 16进制字符串对应的颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColor;
///绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;


/**
 指定起始点 绘制渐变色

 @param colors 渐变颜色
 @param view 需要添加的view
 @param startPoint 起始点
 @param endPoint 终点
 @return layer
 */
+ (CAGradientLayer *)gradientColors:(NSArray *)colors gradientView:(UIView *)view startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
