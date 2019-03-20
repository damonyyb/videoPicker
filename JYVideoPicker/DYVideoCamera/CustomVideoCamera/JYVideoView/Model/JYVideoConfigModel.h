//
//  JYVideoConfigModel.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/15.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYVideoConfigModel : NSObject
///视频总时长
@property (nonatomic, assign) float totlalSeconds;
///视频总分段数
@property (nonatomic, assign) float totlalSubsection;
///是否分段拍摄
@property (nonatomic, assign) BOOL isSubsection;
///当前段已录制秒数
@property (nonatomic, assign) float seconds;
///总已录秒数
@property (nonatomic, assign) float totalRecordSeconds;
@end

NS_ASSUME_NONNULL_END
