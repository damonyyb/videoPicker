//
//  StickersModel.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/2/18.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StickersModel : NSObject
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* stickersImgPaht;
@property (nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
