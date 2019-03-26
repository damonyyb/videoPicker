//
//  VideoManager.m
//  VideoCutDemo
//
//  Created by bh on 2017/11/17.
//  Copyright © 2017年 bh. All rights reserved.
//

#import "VideoManager.h"
#import "VideoModel.h"
#import "MusicModel.h"
#import "FilterModel.h"
#import "StickersModel.h"

@implementation VideoManager

+ (instancetype)shareManager
{
    static VideoManager *videoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoManager = [[self alloc] init];
    });
    
    return videoManager;
}
+ (NSArray *)getMusicData
{
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"music2" ofType:@"json"];
    NSData *configData = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
    NSArray *items = dic[@"music"];
    int i = 529 ;
    NSMutableArray *array = [NSMutableArray array];
    
    MusicModel *effect = [[MusicModel alloc] init];
    effect.name = @"原始";
    effect.iconPath = [[NSBundle mainBundle] pathForResource:@"nilMusic" ofType:@"png"];
    effect.isSelected = YES;
    [array addObject:effect];
    
    
    for (NSDictionary *item in items) {
        //        NSString *path = [baseDir stringByAppendingPathComponent:item[@"resourceUrl"]];
        MusicModel *effect = [[MusicModel alloc] init];
        effect.name = item[@"name"];
        effect.eid = item[@"id"];
        effect.musicPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"audio%d",i] ofType:@"mp3"];
        effect.iconPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon%d",i] ofType:@"png"];
        [array addObject:effect];
        i++;
    }
    
    return array;
}
+ (NSArray *)getFiltersData
{
    FilterModel* filter1 = [[VideoManager shareManager] createWithName:@"Empty" andFlieName:@"LFGPUImageEmptyFilter" andValue:nil];
    filter1.isSelected = YES;
    FilterModel* filter2 = [[VideoManager shareManager] createWithName:@"Amatorka" andFlieName:@"GPUImageAmatorkaFilter" andValue:nil];
    FilterModel* filter3 = [[VideoManager shareManager] createWithName:@"MissEtikate" andFlieName:@"GPUImageMissEtikateFilter" andValue:nil];
    FilterModel* filter4 = [[VideoManager shareManager] createWithName:@"Sepia" andFlieName:@"GPUImageSepiaFilter" andValue:nil];
    FilterModel* filter5 = [[VideoManager shareManager] createWithName:@"Sketch" andFlieName:@"GPUImageSketchFilter" andValue:nil];
    FilterModel* filter6 = [[VideoManager shareManager] createWithName:@"SoftElegance" andFlieName:@"GPUImageSoftEleganceFilter" andValue:nil];
    FilterModel* filter7 = [[VideoManager shareManager] createWithName:@"Toon" andFlieName:@"GPUImageToonFilter" andValue:nil];
    
    FilterModel* filter8 = [[FilterModel alloc] init];
    filter8.name = @"Saturation0";
    filter8.iconPath = [[NSBundle mainBundle] pathForResource:@"GPUImageSaturationFilter0" ofType:@"png"];
    filter8.fillterName = @"GPUImageSaturationFilter";
    filter8.value = @"0";
    
    FilterModel* filter9 = [[FilterModel alloc] init];
    filter9.name = @"Saturation2";
    filter9.iconPath = [[NSBundle mainBundle] pathForResource:@"GPUImageSaturationFilter2" ofType:@"png"];
    filter9.fillterName = @"GPUImageSaturationFilter";
    filter9.value = @"2";
    
    return [NSArray arrayWithObjects:filter1,filter2,filter3,filter4,filter5,filter6,filter7,filter8,filter9, nil];
}
+ (NSArray *)getStikersData
{
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"stickers" ofType:@"json"];
    NSData *configData = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
    NSArray *items = dic[@"stickers"];
    int i = 529 ;
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *item in items) {
        //        NSString *path = [baseDir stringByAppendingPathComponent:item[@"resourceUrl"]];
        StickersModel* stickersItem = [[StickersModel alloc] init];
        stickersItem.name = item[@"name"];
        stickersItem.stickersImgPaht = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"stickers%d",i] ofType:@"jpg"];
        [array addObject:stickersItem];
        i++;
    }
    
    return array;
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
            case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
            case UIImageOrientationRight:
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;

            break;
            case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
    
}
/**
 裁剪照片
 
 @return 图片
 */
+(UIImage *)getCropImageWithOriginalImage:(UIImage *)originalImage cropRect:(CGRect)cropRect imageViewSize:(CGSize)imageViewSize{
    //    CGRect rect = [self.view convertRect:_cutFrame toView:_showImageView];
    //算出截图位置相对图片的坐标
    CGFloat scale = originalImage.size.width / imageViewSize.width;
    CGRect myImageRect= CGRectMake(cropRect.origin.x * scale, cropRect.origin.y * scale, cropRect.size.width * scale, cropRect.size.height * scale);
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(originalImage.CGImage, myImageRect);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    //释放资源
    CGImageRelease(subImageRef);
    
    return smallImage;
}
-(FilterModel*)createWithName:(NSString* )name andFlieName:(NSString*)fileName andValue:(NSString*)value
{
    FilterModel* filter1 = [[FilterModel alloc] init];
    filter1.name = name;
    filter1.iconPath =  [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    filter1.fillterName = fileName;
    if (value) {
        filter1.value = value;
    }
    return filter1;
}
+ (void)getVideoPhotoWithAsset:(PHAsset *)asset size:(CGSize)size completion:(videoImgBlock)completion 
{
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
       
        BOOL downloadFinished = ![info objectForKey:PHImageCancelledKey] && ![info objectForKey:PHImageErrorKey];
        
        // 加上这个key 会不返回缩略图 
        // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        
        if (downloadFinished) {
//            NSLog(@"%@",result);
            if (completion) {
                completion(result);
            }
        }
        
        
    }];
}
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    assetImageGenerator.maximumSize = CGSizeMake(80, 80);
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


+ (void)getURLAssetWithAsset:(PHAsset *)asset completion:(urlAssetBlock)completion
{
    // 保证其他格式（比如慢动作）视频为正常视频
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    
    [[PHCachingImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
       
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        
        
        if (completion) {
            completion(urlAsset);
        }
        
    }];
}

+ (void)cutVideoWithAVAsset:(AVAsset *)avAsset startTime:(CGFloat)startTime endTime:(CGFloat)endTime completion:(outputBlock)completion
{
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        NSString *fileName = [nowTimeStr stringByAppendingString:@"cutVideo.mp4"];
        NSURL *videoPath = [self filePathWithFileName:fileName];

        [self cutVideoWithAVAsset:avAsset startTime:startTime endTime:endTime filePath:videoPath completion:^(NSURL *outputURL) {
           
            if (completion) {
                completion(outputURL);
            }
        }];
        
    }
}

+ (void)cutVideoWithAVAsset:(AVAsset *)asset startTime:(CGFloat)startTime endTime:(CGFloat)endTime filePath:(NSURL *)filePath completion:(outputBlock)completion
{
    // 1.将素材拖入素材库
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject]; // 视频轨迹
    
    AVAssetTrack *audioAssetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject]; // 音轨
    
    // 2.将素材的视频插入视频轨道 ，音频插入音轨
    
    AVMutableComposition *composition = [[AVMutableComposition alloc] init]; // AVAsset的子类
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid]; // 视频轨道
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil]; // 在视频轨道插入一个时间段的视频
    
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid]; // 音轨
    
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil]; // 插入音频数据，否则没有声音
    
    // 3. 裁剪视频，就是要将所有的视频轨道进行裁剪，就需要得到所有的视频轨道，而得到一个视频轨道就需要得到它上面的所有素材
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    CMTime totalDuration = CMTimeAdd(kCMTimeZero, asset.duration);
    
    CGFloat videoAssetTrackNaturalWidth = videoAssetTrack.naturalSize.width;
    CGFloat videoAssetTrackNatutalHeight = videoAssetTrack.naturalSize.height;
    
    CGSize renderSize = CGSizeMake(videoAssetTrackNaturalWidth*2, videoAssetTrackNatutalHeight*2);
    
    CGFloat renderW = MAX(videoAssetTrackNaturalWidth*2, videoAssetTrackNatutalHeight);
    
    CGFloat rate;
    
    rate = renderW / MIN(videoAssetTrackNaturalWidth, videoAssetTrackNatutalHeight);
    
    CGAffineTransform layerTransform = CGAffineTransformMake(videoAssetTrack.preferredTransform.a, videoAssetTrack.preferredTransform.b, videoAssetTrack.preferredTransform.c, videoAssetTrack.preferredTransform.d, videoAssetTrack.preferredTransform.tx * rate, videoAssetTrack.preferredTransform.ty * rate);

    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);
    
    [layerInstruction setTransform:layerTransform atTime:kCMTimeZero]; // 得到视频素材
    [layerInstruction setOpacity:0.0 atTime:totalDuration];
    
    AVMutableVideoCompositionInstruction *instrucation = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instrucation.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    instrucation.layerInstructions = @[layerInstruction];
    
    AVMutableVideoComposition *mainComposition = [AVMutableVideoComposition videoComposition];
    mainComposition.instructions = @[instrucation];
    mainComposition.frameDuration = CMTimeMake(1, 30);
    mainComposition.renderSize = renderSize; // 裁剪出对应大小
    
    //  区间
    CMTime start = CMTimeMakeWithSeconds(startTime, totalDuration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(endTime - startTime, totalDuration.timescale);
    
    CMTimeRange range = CMTimeRangeMake(start, duration);
    
    // 导出视频
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    session.videoComposition = mainComposition;
    session.outputURL = filePath;
    session.shouldOptimizeForNetworkUse = YES;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    session.timeRange = range;
    
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        if ([session status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"%@",[NSThread currentThread]);
            NSLog(@"%@",session.outputURL);
            NSLog(@"导出成功");
            if (completion) {
                completion(session.outputURL);
            }
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"导出失败");
            });
        }
    }];
    
}


+ (NSURL *)filePathWithFileName:(NSString *)fileName
{
    // 获取沙盒 temp 路径
    NSString *tempPath = NSTemporaryDirectory();
    tempPath = [tempPath stringByAppendingPathComponent:@"Video"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 判断文件夹是否存在 不存在创建
    BOOL exits = [manager fileExistsAtPath:tempPath isDirectory:nil];
    if (!exits) {
        
        // 创建文件夹
        [manager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 创建视频存放路径
    tempPath = [tempPath stringByAppendingPathComponent:fileName];
    
    // 判断文件是否存在
    if ([manager fileExistsAtPath:tempPath isDirectory:nil]) {
        // 存在 删除之前的视频
        [manager removeItemAtPath:tempPath error:nil];
    }
    
    return [NSURL fileURLWithPath:tempPath];
}

@end
