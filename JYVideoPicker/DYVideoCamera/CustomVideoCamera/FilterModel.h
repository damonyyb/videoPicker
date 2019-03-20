//
//  FilterModel.h
//  DYVideoCamera
//
//  Created by Joblee on 2019/2/18.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterModel : NSObject
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* value;
@property (nonatomic,strong) NSString* fillterName;
@property (nonatomic,strong) NSString* iconPath;
@property (nonatomic,assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
