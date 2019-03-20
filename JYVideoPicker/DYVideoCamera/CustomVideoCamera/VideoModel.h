//
//  VideoModel.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/2/25.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HXPhotoModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JYModelType) {
    JYModelType_photo,
    JYModelType_video
};

@interface VideoModel : NSObject
@property (nonatomic, strong) HXPhotoModel *videoModel;
@property (nonatomic, assign) JYModelType modelType;
@end

NS_ASSUME_NONNULL_END
