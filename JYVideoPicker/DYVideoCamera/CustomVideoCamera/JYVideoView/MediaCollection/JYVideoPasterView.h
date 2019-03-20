//
//  JYVideoPasterView.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/12.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYVideoPasterModel.h"
#import "FilterModel.h"
#import "StickersModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JYVideoPasterViewStyle) {
    JYVideoPasterViewStyle_Paster,
    JYVideoPasterViewStyle_filter,
    JYVideoPasterViewStyle_videoEdit
};

@interface JYVideoPasterView : UIView
@property (nonatomic, strong) NSArray <FilterModel *>*filterModelArray;
@property (nonatomic, strong) NSArray <StickersModel *>*stickersModelArray;
@property (nonatomic, assign) JYVideoPasterViewStyle style;
@property (nonatomic, copy) void(^videoPasterViewBlock)(NSIndexPath *indexPath);

- (void)setupWithStyle:(JYVideoPasterViewStyle)style dataSource:(id)dataSource;
- (void)reloadCollectionView;

/**
 改变背景颜色

 @param isWhite 是否白色，非白色即正常蒙层风格
 */
-(void)changeBackgroundColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
