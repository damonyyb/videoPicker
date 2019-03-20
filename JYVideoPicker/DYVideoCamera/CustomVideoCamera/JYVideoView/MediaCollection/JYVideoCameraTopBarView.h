//
//  JYVideoCameraTopBarView.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/11.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM (NSInteger,JYVideoCameraTopBarViewAction){
    ///返回
    JYVideoCameraTopBarViewAction_goback = 100,
    ///比例
    JYVideoCameraTopBarViewAction_scale,
    ///切换前后摄像头
    JYVideoCameraTopBarViewAction_exchangeCamera,
    ///更多
    JYVideoCameraTopBarViewAction_more,
    ///闪光灯
    JYVideoCameraTopBarViewAction_light,
    ///倒计时
    JYVideoCameraTopBarViewAction_countDown,
    ///网格
    JYVideoCameraTopBarViewAction_gridding
};
typedef NS_ENUM(NSInteger, JYVideoRecordState) {
    ///录像中
    JYVideoRecordState_recording,
    ///暂停录像
    JYVideoRecordState_pauseRecord,
    ///结束录像
    JYVideoRecordState_finishRecord
};
@interface JYVideoCameraTopBarView : UIView
@property (nonatomic, copy) void (^topbarActon)(UIButton *button);
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;


/**
 是否改成白色图片

 @param isWihteColor 非白即黑
 */
- (void)isChangeImageToWhiteColor:(BOOL)isWihteColor;

/**
 根据录像状态更新UI

 @param state 录像状态
 */
- (void)updateUIWithVideoRcordState:(JYVideoRecordState)state;

@end

NS_ASSUME_NONNULL_END
