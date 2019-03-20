//
//  JYVideoRecordCollectionView.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/12.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYVideoConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JYVideoRecordCollectionView : UIView
@property (nonatomic, strong) NSMutableArray <NSURL *>*videoArray;
@property (nonatomic, copy) void (^videoSelectedBlock)(NSURL *url);
///配置
@property (nonatomic, strong) JYVideoConfigModel *config;
///更新UI
- (void)updateUI;
///更新时间
- (void)updateConfigWithTime:(float)second;
@end

NS_ASSUME_NONNULL_END
