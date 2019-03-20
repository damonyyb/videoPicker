//
//  JYVideoCameraBotomBarView.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/11.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, JYVideoCameraBotomBarViewAction) {
    ///美颜
    JYVideoCameraBotomBarViewAction_beauty = 200,
    ///取消
    JYVideoCameraBotomBarViewAction_cancel,
    ///录制
    JYVideoCameraBotomBarViewAction_record,
    ///分段
    JYVideoCameraBotomBarViewAction_subsection,
    ///删除
    JYVideoCameraBotomBarViewAction_delete,
    ///相册
    JYVideoCameraBotomBarViewAction_album,
    ///摄像
    JYVideoCameraBotomBarViewAction_video,
    ///拍照
    JYVideoCameraBotomBarViewAction_takePhoto,
    ///图片美颜
    JYVideoCameraBotomBarViewAction_photoBeauty
    
};
@interface JYVideoCameraBotomBarView : UIView
@property (nonatomic, copy) void (^bottomBarAction)(UIButton *button);
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) JYVideoCameraBotomBarViewAction currentActon;

/**
 是否隐藏删除按钮

 @param isHidden isHidden
 */
- (void)hideDeleteButton:(BOOL)isHidden;

/**
 是否隐藏取消/美颜按钮

 @param isHidden isHidden description
 */
- (void)hidecancelBtn:(BOOL)isHidden;
/**
 暂停录制
 */
- (void)pauseRecord;

/**
 设置录制按钮是否可点击

 @param enable enable description
 */
- (void)setRecordBtnEnable:(BOOL)enable;

/**
 设置成正常状态
 */
- (void)setNormalState;

/**
 更新录制按钮标题，显示
 */
- (void)updateRecordButtonTitle:(float)second;

/**
 重设为摄像状态
 */
- (void)resetToVideo;
@end

NS_ASSUME_NONNULL_END
