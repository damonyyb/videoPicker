//
//  JYVideoSubsectionView.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/14.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYVideoConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JYVideoSubsectionView : UIView
///配置改变时回调
@property (nonatomic, copy) void(^configChangeBlock)(JYVideoConfigModel *config);
///配置
@property (nonatomic, strong) JYVideoConfigModel *config;
///设置默认配置
- (void)resetConfig;

@end

NS_ASSUME_NONNULL_END
