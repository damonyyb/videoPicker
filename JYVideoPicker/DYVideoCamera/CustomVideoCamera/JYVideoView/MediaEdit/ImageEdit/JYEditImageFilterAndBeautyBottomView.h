//
//  JYEditImageFilterAndBeautyBottomView.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/25.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYVideoRecordSliderView.h"
#import "JYCustomCollectionView.h"
typedef NS_ENUM (NSInteger,JYEditImageFilterAndBeautyBottomViewAction) {
    JYEditImageFilterAndBeautyBottomViewAction_filter = 101,
    JYEditImageFilterAndBeautyBottomViewAction_beauty
};
NS_ASSUME_NONNULL_BEGIN

@interface JYEditImageFilterAndBeautyBottomView : UIView
///滑竿
@property (nonatomic, strong) JYVideoRecordSliderView *beautySliederView;

///滤镜
@property (nonatomic, strong) JYCustomCollectionView *filterCollectionView;
///展示/隐藏
- (void)showBottomBar:(BOOL)show super:(UIView *)super;

@end

NS_ASSUME_NONNULL_END
