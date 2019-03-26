//
//  JYEditImageViewController.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/21.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSKGPUImageBeautyFilter.h"
#import "GPUImage.h"
#import "JYPhotoConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JYEditImageViewController : UIViewController


@property (nonatomic, strong) NSArray <JYPhotoConfigModel *>*photoConfigModelArray;

@end

NS_ASSUME_NONNULL_END
