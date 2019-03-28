//
//  JYCutPhotoViewController.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/20.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoModel.h"
// 屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
// 屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
NS_ASSUME_NONNULL_BEGIN

@interface JYCutPhotoViewController : UIViewController
@property (nonatomic, strong) UIColor *cutBorderColor;//边框颜色
@property (nonatomic, assign) CGRect cutFrame;//边框位置
@property (nonatomic, assign) CGFloat maxScale;//最大缩放比例
@property (nonatomic, strong) UIImage *originalImage;//原图像
@property (nonatomic, assign) CGFloat cutBorderWidth;//边框宽度
@property (nonatomic, strong) UIColor *cutCoverColor;//周围覆盖层颜色

@property (nonatomic, strong) NSArray <HXPhotoModel *>*photoArray;

@end

NS_ASSUME_NONNULL_END
