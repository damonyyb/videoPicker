//
//  JYPhotoConfigModel.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/22.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYPhotoConfigModel : NSObject
@property (nonatomic, assign) CGFloat beautyLevel;
@property (nonatomic, assign) CGFloat brightLevel;
///滤镜
@property (nonatomic, assign) NSInteger filterIndex;
@property (nonatomic, strong) UIImage *editImage;


@end

NS_ASSUME_NONNULL_END
