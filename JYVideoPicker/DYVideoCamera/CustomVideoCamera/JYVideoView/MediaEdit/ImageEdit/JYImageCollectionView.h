//
//  JYImageCollectionView.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/25.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYImageCollectionView : UIView
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) void(^selectBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
