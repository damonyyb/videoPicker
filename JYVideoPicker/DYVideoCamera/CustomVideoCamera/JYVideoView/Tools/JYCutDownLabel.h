//
//  JYCutDownLabel.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/20.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYCutDownLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame;

///倒数s时间
@property (nonatomic, assign) int count;
///开始倒计时
- (void)startCount;

@end

NS_ASSUME_NONNULL_END
