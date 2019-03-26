//
//  JYPhotoBeautyBottomView.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/21.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYPhotoBeautyBottomView : UIView
@property (nonatomic, copy) void(^callBackBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
