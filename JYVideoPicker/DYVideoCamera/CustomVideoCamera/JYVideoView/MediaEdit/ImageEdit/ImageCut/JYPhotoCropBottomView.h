//
//  JYPhotoCropBottomView.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/25.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoModel.h"
#import "JYImageCollectionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JYPhotoCropBottomView : UIView
@property (nonatomic, strong) NSArray <HXPhotoModel *>*dataSource;
///底部原图选择
@property (nonatomic, strong) JYImageCollectionView *imageCollcetionView;
///旋转按钮回调
@property (nonatomic, copy) void(^RotateBlock)(void);
@end

NS_ASSUME_NONNULL_END
