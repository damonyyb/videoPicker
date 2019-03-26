//
//  JYCustomCollectionView.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/21.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterModel.h"
#import "StickersModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface JYCustomCollectionView : UIView
@property (nonatomic, strong) NSArray <FilterModel *>*filterModelArray;
@property (nonatomic, strong) NSArray <StickersModel *>*stickersModelArray;
@property (nonatomic, assign) JYVideoPasterViewStyle style;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, copy) void(^videoPasterViewBlock)(NSIndexPath *indexPath);
- (void)reloadData;
- (void)setupWithStyle:(JYVideoPasterViewStyle)style dataSource:(id)dataSource;

@end

NS_ASSUME_NONNULL_END
