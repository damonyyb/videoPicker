//
//  UIButton+JYCustomLayout.h
//  D2
//
//  Created by Joblee on 2018/12/6.
//  Copyright © 2018年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JYButtonLaoutStyle) {
    ///image在上 label在下
    JYButtonLaoutStyle_Top = 0,
    ///image在左，label在右
    JYButtonLaoutStyle_Left,
    ///image 在下 label 在上
    JYButtonLaoutStyle_Bottom,
    ///image 在右 label 在左
    JYButtonLaoutStyle_Right,
};
@interface UIButton (JYCustomLayout)
///图片标题布局
- (void)layoutButtonWithButtonLaoutStyle:(JYButtonLaoutStyle)style
                                             space:(float)space;

@end

NS_ASSUME_NONNULL_END
