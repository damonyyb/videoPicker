//
//  VideoManager.h
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^videoImgBlock)(UIImage *videoImage);
typedef void(^urlAssetBlock)(AVURLAsset *urlAsset);
typedef void(^outputBlock)(NSURL *outputURL);
typedef void(^videoListBlock)(NSArray*avassetUrlArr);




@interface VideoManager : NSObject

+ (NSArray *)getMusicData;
+ (NSArray *)getStikersData;
+ (NSArray *)getFiltersData;
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
/**
 裁剪照片
 
 @return 图片
 */
+(UIImage *)getCropImageWithOriginalImage:(UIImage *)originalImage cropRect:(CGRect)cropRect imageViewSize:(CGSize)imageViewSize;





/**
 获取视频封面图
 
 @param asset PHAsset
 @param size 大小
 @param completion 回调image
 */
+ (void)getVideoPhotoWithAsset:(PHAsset *)asset size:(CGSize)size completion:(videoImgBlock)completion;

/**
 根据视频URL获取视频封面图
 
 @param videoURL 视频URL
 @param time 时间
 @return 图片
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
/**
 获取 AVURLAsset
 
 @param asset PHAsset
 @param completion 回调urlAsset
 */
+ (void)getURLAssetWithAsset:(PHAsset *)asset completion:(urlAssetBlock)completion;


/**
 根据时间裁剪
 
 @param avAsset avAsset
 @param startTime 起始时间
 @param endTime 结束时间
 @param completion 回调视频url
 */
+ (void)cutVideoWithAVAsset:(AVAsset *)avAsset startTime:(CGFloat)startTime endTime:(CGFloat)endTime completion:(outputBlock)completion;

@end
