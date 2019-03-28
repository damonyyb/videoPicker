//
//  JYVideoEditVC.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/26.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JYVideoEditVC : UIViewController
@property(nonatomic,retain) NSMutableArray <VideoModel *>*videoModelArray;
@end

NS_ASSUME_NONNULL_END
