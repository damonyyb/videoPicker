//
//  VideoCameraView.h
//  addproject
//
//  Created by 胡阳阳 on 17/3/3.
//  Copyright © 2017年 mac. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "VideoManager.h"

/**
 点击返回
  */
typedef void(^clickBackToHomeBtnBlock)();

@protocol VideoCameraDelegate <NSObject>//协议

- (void)presentCor:(UIViewController*)cor;//协议方法
- (void)pushCor:(UIViewController*)cor;//协议方法

@end

@interface VideoCameraView : UIView
{
    
    GPUImageMovieWriter *movieWriter;
    NSString *pathToMovie;
    CALayer *_focusLayer;
    NSTimer *myTimer;
    NSDate *fromdate;
    CGRect mainScreenFrame;
}

@property (nonatomic , copy) clickBackToHomeBtnBlock backToHomeBlock;

@property (nonatomic , strong) NSNumber* width;
@property (nonatomic , strong) NSNumber* hight;
@property (nonatomic , strong) NSNumber* bit;
@property (nonatomic , strong) NSNumber* frameRate;
@property (nonatomic, assign) id<VideoCameraDelegate>delegate;//代理属性

/**
 重新设置为录视频模式
 */
- (void)resetToVideo;
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER; 
@end

