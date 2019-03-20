//
//  VideoCameraView.m
//  addproject
//
//  Created by 胡阳阳 on 17/3/3.
//  Copyright © 2017年 mac. All rights reserved.
//
#import "VideoCameraView.h"
#import "GPUImageBeautifyFilter.h"
#import "LFGPUImageEmptyFilter.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "EditVideoViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Tools.h"
#import "SDAVAssetExportSession.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "EditingPublishingDynamicViewController.h"
#import <Photos/Photos.h>
#import <Photos/PHImageManager.h>
#import "Masonry.h"
#import "MusicItemCollectionViewCell.h"
#import "MusicModel.h"
#import "FilterModel.h"
#import "StickersModel.h"
#import "HXPhotoPicker.h"
#import "UIViewController+HXExtension.h"
#import "VideoModel.h"
#import "JYVideoCameraTopBarView.h"
#import "JYVideoCameraBotomBarView.h"
#import "JYVideoRecordCollectionView.h"
#import "FSKGPUImageBeautyFilter.h"
#import "JYVideoRecordSliderView.h"
#import "JYVideoPasterView.h"
#import "JYVideoGridView.h"
#import "JYVideoSubsectionView.h"
#import "UIColor+JYHex.h"
#import "JYBottomBeautySliderView.h"
#import "JYCutDownLabel.h"

#define VIDEO_FOLDER @"videoFolder"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define TIMER_INTERVAL 0.05
//默认60秒
#define TIMER_VIDEO 60

typedef NS_ENUM(NSInteger, CameraManagerDevicePosition) {
    CameraManagerDevicePositionBack,
    CameraManagerDevicePositionFront,
};
typedef NS_ENUM(NSInteger, JYSourceType) {
    JYSourceType_Video = 0,
    JYSourceType_Album,
    JYSourceType_Photo
};
@interface VideoCameraView ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,AVCaptureMetadataOutputObjectsDelegate,HXAlbumListViewControllerDelegate, HXPhotoViewControllerDelegate,UIGestureRecognizerDelegate>
{
    float preLayerWidth;//镜头宽
    float preLayerHeight;//镜头高
    float preLayerHWRate; //高，宽比
    NSMutableArray* urlArray;
    float currentTime; //当前视频长度
    float lastTime; //记录上次时间
    UIView* progressPreView; //进度条
    float progressStep; //进度条每次变长的最小单位
    MBProgressHUD* HUD;
    //播放音乐
    AVPlayer *mainPlayer;
    AVPlayerItem *audioPlayerItem;
    AVPlayerLayer *playerLayer;
}
@property (nonatomic, assign) CameraManagerDevicePosition position;
///完成录制
@property (nonatomic, strong) UIButton *finishRecordButton;
///视频分段时间记录
@property (nonatomic, strong) NSMutableArray *lastAry;

@property (nonatomic, strong) UIView* btView;

@property (nonatomic, assign) BOOL isRecoding;
//************************* 滤镜 ********************//
@property (nonatomic, strong) NSMutableArray* musicAry;
@property (nonatomic, strong) NSMutableArray* filterAry;
@property (nonatomic, strong) NSMutableArray* stickersAry;

@property (nonatomic ,strong) NSString* filtClassName;
@property (nonatomic ,strong) NSIndexPath* lastFilterIndex;

@property (nonatomic ,strong) NSIndexPath* lastStickersIndex;
@property (nonatomic ,strong) NSIndexPath* nowStickersIndex;
@property (nonatomic ,assign) float saturationValue;
///相机
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
///视频imageView
@property (nonatomic, strong) GPUImageView *filteredVideoView;
///拍照imageView
@property (nonatomic, strong) GPUImageView *filteredPhotoView;

///贴纸
@property (nonatomic ,strong) UIImageView* stickersImgView;
///音频路径
@property (nonatomic,strong) NSString* audioPath;
///挂饰
@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
///顶部按钮
@property (nonatomic, strong) JYVideoCameraTopBarView *topbar;
///底部按钮
@property (nonatomic, strong) JYVideoCameraBotomBarView *bottomBar;
///是否从相册选择
@property (nonatomic, assign) BOOL isFromAlbum;
///已录视频
@property (nonatomic, strong) JYVideoRecordCollectionView *videoCollectionView;
//美白、磨皮滑竿
@property (nonatomic, strong) JYVideoRecordSliderView *sliederView;
//滤镜
@property (nonatomic, strong) GPUImageFilter *filter;
///底部美化栏
@property (nonatomic, strong) JYVideoPasterView *bottomBeautyView;
///底部贴纸栏
@property (nonatomic, strong) JYVideoPasterView *bottomPasteView;
///网格
@property (nonatomic, strong) JYVideoGridView *gridView;
///美颜
@property (nonatomic, strong) FSKGPUImageBeautyFilter *beautyFilter;
///分段
@property (nonatomic, strong) JYVideoSubsectionView *bottomSubsectionView;
///新建相机cameraManager
@property (nonatomic,strong) GPUImageStillCamera *stillCamera;
///用于保存原图
@property AVCaptureStillImageOutput *photoOutput;
///当前是否拍照模式
@property (nonatomic, assign) JYSourceType sourceType;
///查看无美颜按钮
@property (nonatomic, strong) UIImageView *checkView;
///拍照模式美颜slider
@property (nonatomic, strong) JYBottomBeautySliderView *beautysliderView;


@end

@implementation VideoCameraView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return nil;
    }
    self.backgroundColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notCloseCor) name:@"closeVideoCamerOne" object:nil];
    
    lastTime = 0;
    progressStep = SCREEN_WIDTH*TIMER_INTERVAL/TIMER_VIDEO;
    
    preLayerWidth = [self.width floatValue];
    preLayerHeight = [self.hight floatValue];;
    preLayerHWRate =preLayerHeight/preLayerWidth;
    _lastAry = [[NSMutableArray alloc] init];
    urlArray = [[NSMutableArray alloc]init];
    [self createVideoFolderIfNotExist];
    mainScreenFrame = frame;
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    if ([self.videoCamera.inputCamera lockForConfiguration:nil]) {
        //自动对焦
        if ([self.videoCamera.inputCamera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [self.videoCamera.inputCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        //自动曝光
        if ([self.videoCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [self.videoCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }
        //自动白平衡
        if ([self.videoCamera.inputCamera isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [self.videoCamera.inputCamera setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        
        [self.videoCamera.inputCamera unlockForConfiguration];
    }
    
    
    _position = CameraManagerDevicePositionBack;
    //    videoCamera.frameRate = 10;
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [self.videoCamera addAudioInputsAndOutputs];
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    //视频播放器
    mainPlayer = [[AVPlayer alloc] init];
    
    [self addSomeView];
    
    
//    /////////********人脸识别********///
//    //.创建原数据的输出对象
//    AVCaptureMetadataOutput *metaout = [[AVCaptureMetadataOutput alloc] init];
//    //.设置代理监听输出对象输出的数据，在主线程中刷新
//    [metaout setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    if ([self.videoCamera.captureSession canAddOutput:metaout]) {
//        [self.videoCamera.captureSession addOutput:metaout];
//    }
//    //告诉输出对象要输出什么样的数据,识别人脸, 最多可识别10张人脸
//    [metaout setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
    
    //创建预览图层(用于人脸识别)
    //    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.videoCamera.captureSession];
    //    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    _previewLayer.frame = self.bounds;
    //    [self.layer insertSublayer:_previewLayer atIndex:0];
    
//    _musicAry = [NSMutableArray arrayWithArray:[VideoManager getMusicData]];
    _filterAry = [NSMutableArray arrayWithArray:[VideoManager getFiltersData]];
//    _stickersAry = [NSMutableArray arrayWithArray:[VideoManager getStikersData]];
    
    _lastFilterIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    _lastStickersIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    //    [self playMusic];
    
//    //贴纸
//    _stickersImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
//    _stickersImgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//    _stickersImgView.hidden = YES;
//    [self addSubview:_stickersImgView];
//    [_stickersImgView setUserInteractionEnabled:YES];
//    [_stickersImgView setMultipleTouchEnabled:YES];
//    //手势
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//    [_stickersImgView addGestureRecognizer:panGestureRecognizer];
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topOnVideoView:)];
//    tapGestureRecognizer.delegate = self;
//    [self.filteredVideoView addGestureRecognizer:tapGestureRecognizer];
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    self.filteredVideoView.tag = 1001;
//
//
//    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topOnVideoViewt:)];
//    tapGestureRecognizer2.delegate = self;
//    [self.filteredPhotoView addGestureRecognizer:tapGestureRecognizer2];
//    tapGestureRecognizer2.cancelsTouchesInView = NO;
//    self.filteredPhotoView.tag = 1002;
    
    //添加滤镜视图
    [self addFilteredVideoViewWithFrame:self.bounds];
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches.anyObject.view isKindOfClass:[self.filteredPhotoView class]]) {
        [self topOnVideoView];
    }
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 如果控件不允许与用户交互那么返回 nil
    if (self.userInteractionEnabled == NO || self.alpha <= 0.01 || self.hidden == YES) {
        return nil;
    }
    // 如果这个点不在当前控件中那么返回 nil
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    // 从后向前遍历每一个子控件
    for (int i = (int)self.subviews.count - 1; i >= 0; i--) {
        // 获取一个子控件
        UIView *lastVw = self.subviews[i];
        // 把当前触摸点坐标转换为相对于子控件的触摸点坐标
        CGPoint subPoint = [self convertPoint:point toView:lastVw];
        // 判断是否在子控件中找到了更合适的子控件
        UIView *nextVw = [lastVw hitTest:subPoint withEvent:event];
        // 如果找到了返回
        if (nextVw) {
            return nextVw;
            
           
        }
    }
    // 如果以上都没有执行 return, 那么返回自己(表示子控件中没有"更合适"的了)
    return  self;
}
#pragma mark -- 点击视频

- (void)topOnVideoView
{
    self.bottomBar.hidden = NO;
    self.bottomBeautyView.hidden = self.bottomSubsectionView.hidden = self.bottomPasteView.hidden = self.beautysliderView.hidden = self.sliederView.hidden = self.checkView.hidden = YES;
}
#pragma mark -- 点击视频

- (void)topOnVideoViewt:(UITapGestureRecognizer *)gesture
{
    self.bottomBar.hidden = NO;
    self.bottomBeautyView.hidden = self.bottomSubsectionView.hidden = self.bottomPasteView.hidden = self.beautysliderView.hidden = self.sliederView.hidden = self.checkView.hidden = YES;
}
#pragma mark -- 添加滤镜视图

- (void)addFilteredVideoViewWithFrame:(CGRect)frame
{
    [self.stillCamera removeAllTargets];
    [self.videoCamera removeAllTargets];
    [self.filteredVideoView removeFromSuperview];
    self.filteredVideoView.frame = frame;
    [self.videoCamera addTarget:self.filter];
    [self.filter addTarget:self.beautyFilter];
    [self.beautyFilter addTarget:self.filteredVideoView];
    
    
    [self addSubview:self.filteredVideoView];
    [self.videoCamera startCameraCapture];
    [self sendSubviewToBack:self.filteredVideoView];
    
}
- (void)addFilteredPhotoViewWithFrame:(CGRect)frame
{
    
    [self.stillCamera removeAllTargets];
    self.filteredPhotoView.frame = frame;
    
    [self.stillCamera addTarget:self.filter];
    [self.filter addTarget:self.beautyFilter];
    [self.beautyFilter addTarget:self.filteredPhotoView];
    
    [self.stillCamera startCameraCapture];
    [self sendSubviewToBack:self.filteredPhotoView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.tag != 1001)
    {
        return NO;
    }
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    AVMetadataFaceObject *faceobject = metadataObjects.firstObject;
    AVMetadataObject *face = [self.previewLayer transformedMetadataObjectForMetadataObject:faceobject];
    CGRect r = face.bounds;
    float w = r.size.width*1.5;
    float h = 120;
    self.faceView.frame = CGRectMake(r.origin.x-(w-r.size.width)/2, r.origin.y-r.size.height*0.6, w, h);
}
- (void) addSomeView{
    
    self.faceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoHuanggua"]];
    self.faceView.frame = CGRectZero;
    self.faceView.hidden = YES;
    [self addSubview:self.faceView];

    
    //进度条
    progressPreView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , 0, 4)];
    progressPreView.backgroundColor = [UIColor colorWithHexString:@"#F22B3C"];
    [progressPreView makeCornerRadius:2 borderColor:nil borderWidth:0];
    [self addSubview:progressPreView];
    
    //顶部按钮
    [self addSubview:self.topbar];
    [self.topbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    //底部录制按钮
    [self addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
    }];
    //视频分段
    [self addSubview:self.videoCollectionView];
    [self.videoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomBar.mas_top).mas_offset(-30);
        make.left.right.mas_equalTo(0);
    }];
}
#pragma mark -- 播放视频

- (void)playVideoWithURL:(NSURL *)URL
{
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:URL];
    [mainPlayer replaceCurrentItemWithPlayerItem:playerItem];
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:mainPlayer];
    playerLayer.frame = CGRectMake(0, 0, self.layer.bounds.size.width, self.layer.bounds.size.height);
    //通过KVO来观察status属性的变化，来获得播放之前的错误信息
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    [self.layer addSublayer:playerLayer];
    [mainPlayer play];
    
}
- (void)moviePlayDidEnd
{
    [playerLayer removeFromSuperlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //        //取出status的新值
        //        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]integerValue];
        //        switch (status) {
        //            case AVPlayerItemStatusFailed:
        //                NSLog(@"item 有误");
        //                self.isReadToPlay = NO;
        //                break;
        //            case AVPlayerItemStatusReadyToPlay:
        //                NSLog(@"准好播放了");
        //                self.isReadToPlay = YES;
        //                self.avSlider.maximumValue = self.item.duration.value / self.item.duration.timescale;
        //                break;
        //            case AVPlayerItemStatusUnknown:
        //                NSLog(@"视频资源出现未知错误");
        //                self.isReadToPlay = NO;
        //                break;
        //            default:
        //                break;
        //        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
}

#pragma mark -- 开始 / 停止录制

- (void)startRecording{
    if (!_isRecoding) {//开始录制
        self.topbar.hidden = YES;
        //记录时间
        lastTime = currentTime;
        [_lastAry addObject:[NSString stringWithFormat:@"%f",lastTime]];
        _isRecoding = YES;
        [self.bottomBar hideDeleteButton:YES];
        [self.bottomBar hidecancelBtn:YES];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/Movie%@.mov",nowTimeStr]];
        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        //视频写入器
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720.0, 1280.0)];
        movieWriter.isNeedBreakAudioWhiter = movieWriter.shouldPassthroughAudio = movieWriter.encodingLiveVideo = YES;
        [self.filter addTarget:movieWriter];
        self.videoCamera.audioEncodingTarget = movieWriter;
        [movieWriter startRecording];
        
        _btView.backgroundColor = [UIColor colorWithRed:(float)0xfd/256.0 green:(float)0xd8/256.0 blue:(float)0x54/256.0 alpha:1];
        fromdate = [NSDate date];
        //定时器
        myTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                   target:self
                                                 selector:@selector(updateTimer:)
                                                 userInfo:nil
                                                  repeats:YES];
        [self.bottomBar hidecancelBtn:NO];
    }
    else
    {//暂停录制
        [self.topbar updateUIWithVideoRcordState:JYVideoRecordState_pauseRecord];
        self.topbar.hidden = NO;
        self.videoCamera.audioEncodingTarget = nil;
        NSLog(@"Path %@",pathToMovie);
        if (pathToMovie == nil) {
            return;
        }
        _btView.backgroundColor = [UIColor colorWithRed:(float)0xfe/256.0 green:(float)0x65/256.0 blue:(float)0x53/256.0 alpha:1];
        //停止录入
        if (_isRecoding) {
            [movieWriter finishRecording];
            [self.filter removeTarget:movieWriter];
            [urlArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",pathToMovie]]];
            _isRecoding = NO;
        }
        [myTimer invalidate];
        myTimer = nil;
        if (urlArray.count) {
            [self.bottomBar hideDeleteButton:NO];
        }
        [self.videoCollectionView updateConfigWithTime:currentTime];
        self.videoCollectionView.videoArray = urlArray;
        [self.bottomBar hidecancelBtn:YES];
        
    }
    
    
}
#pragma mark -- 停止录入

- (void)stopRecording:(id)sender {
    [self.topbar updateUIWithVideoRcordState:JYVideoRecordState_finishRecord];
    self.videoCamera.audioEncodingTarget = nil;
    if (pathToMovie == nil) {
        return;
    }
    if (_isRecoding) {
        [movieWriter finishRecording];
        [self.filter removeTarget:movieWriter];
        _isRecoding = NO;
    }
    
    [myTimer invalidate];
    myTimer = nil;
    HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    HUD.label.text = @"视频生成中...";
//    if (self.isFromAlbum) {
        [urlArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",pathToMovie]]];
//    }
    NSString *path = [self getVideoMergeFilePathString];
    [self mergeAndExportVideos:urlArray withOutPath:path];
    
    [self preConfig];
    
}
#pragma mark -- 取消录制

-(void)cancelRecord
{
    self.videoCamera.audioEncodingTarget = nil;
    if (pathToMovie == nil) {
        return;
    }
    if (_isRecoding) {
        [movieWriter finishRecording];
        [self.filter removeTarget:movieWriter];
        _isRecoding = NO;
    }
    
    [myTimer invalidate];
    myTimer = nil;
    
    [self preConfig];
}
/**
 配置
 */
- (void)preConfig{
    [urlArray removeAllObjects];
    [_lastAry removeAllObjects];
    self.videoCollectionView.videoArray = urlArray;
//    self.videoCollectionView.hidden = YES;
    [self.bottomBar hideDeleteButton:NO];
    currentTime = 0;
    lastTime = 0;
    self.isFromAlbum = NO;
    self.finishRecordButton.hidden = YES;
    [progressPreView setFrame:CGRectMake(0, 0, 0, 4)];
    _btView.backgroundColor = [UIColor colorWithRed:250/256.0 green:211/256.0 blue:75/256.0 alpha:1];
    
}
- (void)resetToVideo
{
    self.sourceType = JYSourceType_Video;
    [self.bottomBar resetToVideo];
}
#pragma mark -- 删除视频

-(void)clickDleBtn:(UIButton*)sender {
    //处理进度条
    float progressWidth = [_lastAry.lastObject floatValue]/10*SCREEN_WIDTH;
    [progressPreView setFrame:CGRectMake(0, 0, progressWidth, 4)];
    //处理x时间显示
    currentTime = [_lastAry.lastObject floatValue];
//    _timeLabel.text = [NSString stringWithFormat:@"00:0%.0f",currentTime];
    [self.videoCollectionView updateConfigWithTime:currentTime];
    //如果视频数为0，则显示取消按钮
    if (urlArray.count) {
        [urlArray removeLastObject];
        [_lastAry removeLastObject];
        if (urlArray.count == 0) {
            [self.bottomBar hideDeleteButton:YES];
            self.topbar.hidden = NO;
            [self cancelRecord];
            [self.topbar updateUIWithVideoRcordState:JYVideoRecordState_finishRecord];
            [self.bottomBar setNormalState];
        }
        if (currentTime < 3) {
            self.finishRecordButton.hidden = YES;
        }
    }
    [self.videoCollectionView updateConfigWithTime:currentTime];
    self.videoCollectionView.videoArray = urlArray;
}
#pragma mark -- 拍照

- (void)takePhoto{
    [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        [self.stillCamera stopCameraCapture];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        //设置一个图片的存储路径
        pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/pic%@.png",nowTimeStr]];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(processedImage) writeToFile:pathToMovie atomically:YES];
        
        VideoModel *pModel = [[VideoModel alloc]init];
        pModel.videoModel = [HXPhotoModel photoModelWithImageURL:[NSURL URLWithString:pathToMovie]];
        pModel.modelType = JYModelType_photo;
        EditVideoViewController* view = [[EditVideoViewController alloc]init];
        view.width = _width;
        view.hight = _hight;
        view.bit = _bit;
        view.frameRate = _frameRate;
        view.image = processedImage;
        [view.videoModelArray addObject: pModel];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(pushCor:)]) {
            [self.delegate pushCor:view];
        }
        [self removeFromSuperview];
        
        
//        UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil);
    }];
}
#pragma mark -- 本地选取视频/图片
-(void)clickInputBtn:(UIButton*)sender {
    
    self.manager.configuration.saveSystemAblum = YES;
    HXWeakSelf
    [(UIViewController *)self.delegate hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        HXPhotoModel *model = allList.firstObject;
        if (model.subType == HXPhotoModelMediaSubTypePhoto) {
            [model requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:nil progressHandler:nil success:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
                [HUD hideAnimated:YES];
                EditVideoViewController* view = [[EditVideoViewController alloc]init];
                view.width = _width;
                view.hight = _hight;
                view.bit = _bit;
                view.frameRate = _frameRate;
                view.image = image;
                VideoModel *vModel = [[VideoModel alloc]init];
                vModel.videoModel = model;
                [view.videoModelArray addObject: vModel];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                if (self.delegate&&[self.delegate respondsToSelector:@selector(pushCor:)]) {
                    [self.delegate pushCor:view];
                }
                [self removeFromSuperview];
                [weakSelf hx_handleLoading];
            } failed:^(NSDictionary *info, HXPhotoModel *model) {
                [weakSelf hx_handleLoading];
                [weakSelf hx_showImageHUDText:@"获取失败"];
            }];
        }else  if (model.subType == HXPhotoModelMediaSubTypeVideo) {
            [weakSelf hx_showLoadingHUDText:@"获取视频中"];
            [model exportVideoWithPresetName:AVAssetExportPresetHighestQuality startRequestICloud:nil iCloudProgressHandler:nil exportProgressHandler:^(float progress, HXPhotoModel *model) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD hx_showLoadingHUDText:[NSString stringWithFormat:@"视频导出进度 - %f",progress]];
                });
                
            } success:^(NSURL *videoURL, HXPhotoModel *model) {
                NSSLog(@"%@",videoURL);
                VideoModel *vModel = [[VideoModel alloc]init];
                vModel.videoModel = model;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSData* videoData = [NSData dataWithContentsOfFile:[[vModel.videoModel.fileURL absoluteString ] stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
                    if (videoData.length>1024*1024*99) {
                        HUD.label.text = @"所选视频大于10M,请重新选择";
                        [HUD hideAnimated:YES afterDelay:1.5];
                    }else
                    {
                        [HUD hideAnimated:YES];
                        EditVideoViewController* view = [[EditVideoViewController alloc]init];
                        view.width = _width;
                        view.hight = _hight;
                        view.bit = _bit;
                        view.frameRate = _frameRate;
                        [view.videoModelArray addObject: vModel];
                        [[NSNotificationCenter defaultCenter] removeObserver:self];
                        if (self.delegate&&[self.delegate respondsToSelector:@selector(pushCor:)]) {
                            [self.delegate pushCor:view];
                        }
                        [self removeFromSuperview];
                        
                        
                    }
                });
                
                [weakSelf hx_handleLoading];
            } failed:^(NSDictionary *info, HXPhotoModel *model) {
                [weakSelf hx_handleLoading];
                [weakSelf hx_showImageHUDText:@"视频导出失败"];
            }];
            NSSLog(@"%lu个视频",(unsigned long)videoList.count);
        }
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSSLog(@"取消了");
    }];
    
}

#pragma mark -- 保存视频

- (void)mergeAndExportVideos:(NSArray*)videosPathArray withOutPath:(NSString*)outpath{
    if (videosPathArray.count == 0) {
        return;
    }
    [self.videoCamera stopCameraCapture];
    EditVideoViewController* view = [[EditVideoViewController alloc]init];
    view.width = _width;
    view.hight = _hight;
    view.bit = _bit;
    view.frameRate = _frameRate;
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0; i<videosPathArray.count; i++) {
        HXPhotoModel *model = [HXPhotoModel photoModelWithVideoURL:videosPathArray[i]];
        VideoModel *vModel = [[VideoModel alloc]init];
        vModel.modelType = JYModelType_video;
        vModel.videoModel = model;
        [array addObject:vModel];
    }
    [view.videoModelArray addObjectsFromArray:array];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(pushCor:)]) {
        [self.delegate pushCor:view];
    }
    [self removeFromSuperview];
    
    
    
    
}
#pragma mark -- 获取文件路径

- (NSString *)getVideoMergeFilePathString
{
    
    //沙盒中Temp路径
    NSString *tempPath = NSTemporaryDirectory();
    
    NSString* path = [tempPath stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@"merge.mov"];
    
    return fileName;
}
#pragma mark -- 创建文件夹

- (void)createVideoFolderIfNotExist
{
    
    //沙盒中Temp路径
    NSString *tempPath = NSTemporaryDirectory();
    NSString *folderPath = [tempPath stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建保存视频文件夹失败");
        }
    }
}

#pragma mark -- 返回上一级
-(void)clickBackToHome
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.videoCamera stopCameraCapture];
    if (_isRecoding) {
        [movieWriter cancelRecording];
        [self.filter removeTarget:movieWriter];
        _isRecoding = NO;
    }
    [myTimer invalidate];
    myTimer = nil;
    if (self.backToHomeBlock) {
        NSLog(@"clickBacktoHome");
        self.backToHomeBlock();
        [self removeFromSuperview];
    }
    
}

#pragma mark -- 切换前后摄像头
-(void)changeCameraPositionBtn:(UIButton*)sender{
    
    if (self.bottomBar.currentActon == JYVideoCameraBotomBarViewAction_takePhoto) {
        [self.stillCamera pauseCameraCapture];
        _position = CameraManagerDevicePositionFront;
        
        [self.stillCamera rotateCamera];
        [self.stillCamera resumeCameraCapture];
        
        sender.selected = YES;
        [self.stillCamera removeAllTargets];
        
        [self.filter removeAllTargets];
        [self.stillCamera addTarget:self.filter];
        [self.filter addTarget:self.beautyFilter];
        [self.beautyFilter addTarget:self.filteredPhotoView];
    }else{
        [self.videoCamera pauseCameraCapture];
        _position = CameraManagerDevicePositionFront;
        
        [self.videoCamera rotateCamera];
        [self.videoCamera resumeCameraCapture];
        
        sender.selected = YES;
        [self.videoCamera removeAllTargets];
        
        [self.filter removeAllTargets];
        [self.videoCamera addTarget:self.filter];
        [self.filter addTarget:self.beautyFilter];
        [self.beautyFilter addTarget:self.filteredVideoView];
    }

    if (self.bottomBar.currentActon == JYVideoCameraBotomBarViewAction_takePhoto) {
        if ([self.stillCamera.inputCamera lockForConfiguration:nil] && [self.stillCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [self.stillCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            [self.stillCamera.inputCamera unlockForConfiguration];
        }
    }else{
        if ([self.videoCamera.inputCamera lockForConfiguration:nil] && [self.videoCamera.inputCamera isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [self.videoCamera.inputCamera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            [self.videoCamera.inputCamera unlockForConfiguration];
        }
    }
    
    
    
    
    
}
#pragma mark -- 美颜按钮

- (void)beautifullyBtn
{
    self.faceView.hidden = !self.faceView.hidden;
}

#pragma mark -- 更新定时器时间

- (void)updateTimer:(NSTimer *)sender{
    //如果是分段录制，录制过程中禁止点击
    if (self.bottomSubsectionView.config.isSubsection) {
        [self.bottomBar setRecordBtnEnable:NO];
    }
    currentTime += TIMER_INTERVAL;
    if (!self.videoCollectionView.config) {
        self.videoCollectionView.config = [JYVideoConfigModel new];
    }
    [self.videoCollectionView updateConfigWithTime:currentTime];
   
    float progressWidth = progressPreView.frame.size.width+progressStep;
    [progressPreView setFrame:CGRectMake(0, 0, progressWidth, 4)];
    if (currentTime>3) {
        self.finishRecordButton.hidden = NO;
    }
    
    //时间到了停止录制视频
    if (currentTime>=self.bottomSubsectionView.config.totlalSeconds) {
        [self.bottomBar setRecordBtnEnable:YES];
        [self stopRecording:nil];
    }
    if (self.bottomSubsectionView.config.isSubsection) {
        //更新录制按钮上的文字
        [self.bottomBar updateRecordButtonTitle:currentTime];
        float subsectionTime = self.bottomSubsectionView.config.totlalSeconds/self.bottomSubsectionView.config.totlalSubsection;
        if (currentTime >= subsectionTime*(urlArray.count+1)) {
            [self.bottomBar pauseRecord];
            [self.bottomBar setRecordBtnEnable:YES];
        }
    }
    
}
#pragma mark -- 对焦图片

- (void)setfocusImage{
    UIImage *focusImage = [UIImage imageNamed:@"96"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, focusImage.size.width, focusImage.size.height)];
    imageView.image = focusImage;
    CALayer *layer = imageView.layer;
    layer.hidden = YES;
    [self.filteredVideoView.layer addSublayer:layer];
    _focusLayer = layer;
    
}
#pragma mark -- 触摸对焦

- (void)layerAnimationWithPoint:(CGPoint)point {
    if (_focusLayer) {
        CALayer *focusLayer = _focusLayer;
        focusLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [focusLayer setPosition:point];
        focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
        [CATransaction commit];
        
        
        CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
        animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
        //        animation.delegate = self;
        animation.duration = 0.3f;
        animation.repeatCount = 1;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [focusLayer addAnimation: animation forKey:@"animation"];
        
        // 0.5秒钟延时
        [self performSelector:@selector(focusLayerNormal) withObject:self afterDelay:0.5f];
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
}


- (void)focusLayerNormal {
    self.filteredVideoView.userInteractionEnabled = YES;
    self.filteredPhotoView.userInteractionEnabled = YES;
    _focusLayer.hidden = YES;
}

/**
 @abstract 将UI的坐标转换成相机坐标
 */
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = self.filteredVideoView.frame.size;
    CGSize apertureSize = CGSizeMake(1280, 720);//设备采集分辨率
    CGPoint point = viewCoordinates;
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    CGFloat xc = .5f;
    CGFloat yc = .5f;
    
    if (viewRatio > apertureRatio) {
        CGFloat y2 = frameSize.height;
        CGFloat x2 = frameSize.height * apertureRatio;
        CGFloat x1 = frameSize.width;
        CGFloat blackBar = (x1 - x2) / 2;
        if (point.x >= blackBar && point.x <= blackBar + x2) {
            xc = point.y / y2;
            yc = 1.f - ((point.x - blackBar) / x2);
        }
    }else {
        CGFloat y2 = frameSize.width / apertureRatio;
        CGFloat y1 = frameSize.height;
        CGFloat x2 = frameSize.width;
        CGFloat blackBar = (y1 - y2) / 2;
        if (point.y >= blackBar && point.y <= blackBar + y2) {
            xc = ((point.y - blackBar) / y2);
            yc = 1.f - (point.x / x2);
        }
    }
    pointOfInterest = CGPointMake(xc, yc);
    return pointOfInterest;
}

#pragma mark -- 触摸手势响应

-(void)cameraViewTapAction:(UITapGestureRecognizer *)tgr
{
    if (tgr.state == UIGestureRecognizerStateRecognized && (_focusLayer == nil || _focusLayer.hidden)) {
        CGPoint location = [tgr locationInView:self.filteredVideoView];
        [self setfocusImage];
        [self layerAnimationWithPoint:location];
        AVCaptureDevice *device = self.videoCamera.inputCamera;
        CGPoint pointOfInterest = [self convertToPointOfInterestFromViewCoordinates:location];
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [device setFocusPointOfInterest:pointOfInterest];
                [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                
            }
            
            if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [device setExposurePointOfInterest:pointOfInterest];
                [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            
            [device unlockForConfiguration];
            
            NSLog(@"FOCUS OK");
        } else {
            NSLog(@"ERROR = %@", error);
        }
    }
}



-(void)notCloseCor
{
    [self clickBackToHome];
}
#pragma mark -- 打开闪光灯

- (void)openLight:(UIButton *)sender{
    //修改前必须先锁定
    [self.videoCamera.inputCamera lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if (self.videoCamera.inputCamera.hasFlash && self.videoCamera.inputCamera.hasTorch) {
        if (self.videoCamera.inputCamera.flashMode == AVCaptureFlashModeOff) {
            self.videoCamera.inputCamera.flashMode = AVCaptureFlashModeOn;
            self.videoCamera.inputCamera.torchMode = AVCaptureTorchModeOn;
        } else if (self.videoCamera.inputCamera.flashMode == AVCaptureFlashModeOn) {
            self.videoCamera.inputCamera.flashMode = AVCaptureFlashModeOff;
            self.videoCamera.inputCamera.torchMode = AVCaptureTorchModeOff;
        }
    }
    [self.videoCamera.inputCamera unlockForConfiguration];
}

-(void)dealloc
{
    NSLog(@"%@释放了",self.class);
}

#pragma mark -- 贴纸拖动手势

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.topbar.hidden = self.bottomBar.hidden = self.bottomBeautyView.hidden = self.beautysliderView.hidden = self.sliederView.hidden = self.checkView.hidden = self.bottomPasteView.hidden = YES;
    }
    //贴纸移动
    if ( panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        CGPoint center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
        //限制贴纸的移动范围,不能超出视频的上下边界
        if (center.y+view.frame.size.height/2 < CGRectGetMaxY(self.filteredVideoView.frame) && center.y-view.frame.size.height/2 > CGRectGetMinY(self.filteredVideoView.frame)) {
            [view setCenter:center];
            [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        }
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.topbar.hidden = self.bottomPasteView.hidden = NO;
    }
}
#pragma mark -- 长按查看无美颜和美颜

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.beautyFilter.beautyLevel = 0;
    }else if (gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled ||  gesture.state == UIGestureRecognizerStateEnded){
        if (self.bottomBar.currentActon == JYVideoCameraBotomBarViewAction_takePhoto) {
            self.beautyFilter.beautyLevel = self.beautysliderView.sliederView.beautySliderValue;
        }else{
            self.beautyFilter.beautyLevel = self.sliederView.beautySliderValue;
        }
        
    }
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.singleSelected = YES;
        _manager.configuration.albumListTableView = ^(UITableView *tableView) {
            //            NSSLog(@"%@",tableView);
        };
        _manager.configuration.singleJumpEdit = NO;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
        _manager.configuration.openCamera = YES;
        _manager.type = HXPhotoManagerSelectedTypePhotoAndVideo;
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
        //        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
    }
    return _manager;
}
- (JYVideoCameraTopBarView *)topbar
{
    if (!_topbar) {
        _topbar = [JYVideoCameraTopBarView new];
        HXWeakSelf
        _topbar.topbarActon = ^(UIButton *button) {
            switch (button.tag) {
                    case JYVideoCameraTopBarViewAction_goback://返回
                    [weakSelf clickBackToHome];

                    break;
                    case JYVideoCameraTopBarViewAction_scale://比例
                {
                    if (self.bottomBar.currentActon == JYVideoCameraBotomBarViewAction_takePhoto) {//拍照
                        
                        if (weakSelf.filteredPhotoView.frame.size.height > weakSelf.filteredPhotoView.frame.size.width) {
                            [weakSelf addFilteredPhotoViewWithFrame:CGRectMake(0, 64, weakSelf.frame.size.width, weakSelf.frame.size.width)];
                            [weakSelf.topbar isChangeImageToWhiteColor:YES];
                        }else{
                            [weakSelf addFilteredPhotoViewWithFrame:CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.width*4/3)];
                            [weakSelf.topbar isChangeImageToWhiteColor:NO];
                        }
                    }else{//拍视频
                        if (weakSelf.filteredVideoView.frame.size.height > weakSelf.filteredVideoView.frame.size.width) {
                            [weakSelf addFilteredVideoViewWithFrame:CGRectMake(0, 64, weakSelf.frame.size.width, weakSelf.frame.size.width)];
                        }else{
                            [weakSelf addFilteredVideoViewWithFrame:weakSelf.bounds];
                        }
                    }
                    
                }
                    break;
                    case JYVideoCameraTopBarViewAction_exchangeCamera://切换前后摄像头
                {
                    [weakSelf changeCameraPositionBtn:button];
                    
                }
                    break;
                case JYVideoCameraTopBarViewAction_more://更多
                    
                    break;
                case JYVideoCameraTopBarViewAction_light://闪光灯
                    [weakSelf openLight:button];
                    break;
                case JYVideoCameraTopBarViewAction_countDown://倒计时
                {
                    [weakSelf showAlertView];
                }
                    break;
                    case JYVideoCameraTopBarViewAction_gridding://网格
                    weakSelf.gridView.hidden = !weakSelf.gridView.hidden;
                    break;
            }
        };
    }
    return _topbar;
}
- (void)showAlertView
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择时间" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"3秒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self showCutDownLabelWithTime:3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self recordBtnClicked];
        });
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"7秒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self showCutDownLabelWithTime:7];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self recordBtnClicked];
        });
    }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    UIViewController *vc = (UIViewController *)self.delegate;
    [vc presentViewController:alertController animated:YES completion:nil];
}

/**
 展示倒计时

 @param time 倒计时秒数
 */
-(void)showCutDownLabelWithTime:(int)time
{
    JYCutDownLabel *countLabel = [[JYCutDownLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    countLabel.center = self.center;
    countLabel.font = [UIFont boldSystemFontOfSize:35];
    countLabel.textColor = [UIColor colorWithHexString:@"#F22B3C"];
    countLabel.count = time; //不设置的话，默认是3
    [self addSubview:countLabel];
    
    [countLabel startCount];
}
- (void)recordBtnClicked
{
    if (self.sourceType == JYSourceType_Photo) {
        [self takePhoto];
    }else if (self.sourceType == JYSourceType_Video){
        [self startRecording];
    }
}
- (JYVideoCameraBotomBarView *)bottomBar
{
    if (!_bottomBar) {
        HXWeakSelf
        _bottomBar = [JYVideoCameraBotomBarView new];
        _bottomBar.bottomBarAction = ^(UIButton *button) {
            switch (button.tag) {
                case JYVideoCameraBotomBarViewAction_beauty://美颜/滤镜
                {
                    
                    if (weakSelf.bottomBar.currentActon == JYVideoCameraBotomBarViewAction_video) {//录像模式
                        weakSelf.bottomBeautyView.hidden = NO;
                        weakSelf.sliederView.hidden = weakSelf.checkView.hidden = button.isSelected;
                        [weakSelf.bottomBeautyView changeBackgroundColor:[UIColor blackColor]];
                        
                    }else if (weakSelf.bottomBar.currentActon == JYVideoCameraBotomBarViewAction_takePhoto){//拍照模式
                        weakSelf.bottomBeautyView.hidden = NO;
                        [weakSelf.bottomBeautyView changeBackgroundColor:[UIColor whiteColor]];
                    }
                    
                }
                break;
                case JYVideoCameraBotomBarViewAction_cancel://取消录制
                {
                    weakSelf.topbar.hidden = NO;
//                    weakSelf.videoCollectionView.hidden = YES;
                    
                    [weakSelf cancelRecord];
                }
                break;
                case JYVideoCameraBotomBarViewAction_record://开始/暂停录制视频 / 拍照
                {
                    [weakSelf recordBtnClicked];
                   
                }
                    break;
                case JYVideoCameraBotomBarViewAction_delete://删除视频
                {
                    [weakSelf clickDleBtn:button];

                }
                    break;
                case JYVideoCameraBotomBarViewAction_subsection://分段
                {
                    weakSelf.bottomSubsectionView.hidden = NO;
                }
                    break;
                case JYVideoCameraBotomBarViewAction_album://从相册选择视频/照片
                {
                     weakSelf.sourceType = JYSourceType_Album;
                    [weakSelf clickInputBtn:button];
                }
                    break;
                case JYVideoCameraBotomBarViewAction_video://摄像
                {
                    weakSelf.sourceType = JYSourceType_Video;
                    weakSelf.filteredPhotoView.hidden = YES;
                    weakSelf.filteredVideoView.hidden = NO;
                    [weakSelf addFilteredVideoViewWithFrame:CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height)];
                    weakSelf.backgroundColor = [UIColor blackColor];
                }
                    break;
                case JYVideoCameraBotomBarViewAction_takePhoto://拍照
                {
                    weakSelf.sourceType = JYSourceType_Photo;
                    weakSelf.filteredPhotoView.hidden = NO;
                    weakSelf.filteredVideoView.hidden = YES;
                    [weakSelf addFilteredPhotoViewWithFrame:CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.width*4/3)];
                    weakSelf.backgroundColor = [UIColor whiteColor];
                }
                    break;
                case JYVideoCameraBotomBarViewAction_photoBeauty://拍照美颜
                {
                    weakSelf.beautysliderView.hidden = weakSelf.checkView.hidden = button.isSelected;
//                    [weakSelf bringSubviewToFront:weakSelf.beautysliderView];
                }
                    break;
            }
        };
    }
    return _bottomBar;
}

-(JYVideoRecordCollectionView *)videoCollectionView
{
    if (!_videoCollectionView) {
        HXWeakSelf
        _videoCollectionView = [JYVideoRecordCollectionView new];
        _videoCollectionView.videoSelectedBlock = ^(NSURL * _Nonnull url) {
            [weakSelf playVideoWithURL:url];
        };
        _videoCollectionView.config.isSubsection  = NO;
    }
    return _videoCollectionView;
}
- (JYVideoRecordSliderView *)sliederView
{
    if (!_sliederView) {
        HXWeakSelf
        _sliederView = [JYVideoRecordSliderView new];
        _sliederView.hidden = YES;
        [self addSubview:_sliederView];
        [_sliederView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(-80);
            make.bottom.mas_equalTo(self.bottomBar.mas_top).mas_offset(-15);
        }];
        _sliederView.updateSbuffingValue = ^(CGFloat value) {
            weakSelf.beautyFilter.beautyLevel = value;
        };
        _sliederView.updateSkinWhiteningValue = ^(CGFloat value) {
            weakSelf.beautyFilter.brightLevel = value;
        };
    }
    return _sliederView;
}
- (JYVideoPasterView *)bottomBeautyView
{
    if (!_bottomBeautyView) {
        _bottomBeautyView = [JYVideoPasterView new];
        [self addSubview:_bottomBeautyView];
        [_bottomBeautyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
        }];
        //滤镜选择
        [_bottomBeautyView setupWithStyle:JYVideoPasterViewStyle_filter dataSource:[VideoManager getFiltersData]];
        HXWeakSelf
        _bottomBeautyView.videoPasterViewBlock = ^(NSIndexPath *indexPath) {
            
            if (self.lastFilterIndex.row != indexPath.row) {
                
                //1.修改数据源
                FilterModel* selectedModel = [weakSelf.filterAry objectAtIndex:indexPath.row];
                selectedModel.isSelected = YES;
                FilterModel* lastModel = [weakSelf.filterAry objectAtIndex:weakSelf.lastFilterIndex.row];
                lastModel.isSelected = NO;
                //2.刷新collectionView
                weakSelf.lastFilterIndex = indexPath;
                weakSelf.bottomBeautyView.filterModelArray = weakSelf.filterAry;
                [weakSelf.bottomBeautyView reloadCollectionView];
                
                if (indexPath.row == 0) {//无滤镜
                    [weakSelf.videoCamera removeAllTargets];
                    
                    FilterModel* data = [weakSelf.filterAry objectAtIndex:indexPath.row];
                    _filtClassName = data.fillterName;
                    
                    weakSelf.filter = [[NSClassFromString(weakSelf.filtClassName) alloc] init];
                    if (weakSelf.bottomBar.currentActon == JYVideoCameraBotomBarViewAction_video) {
                        [weakSelf.videoCamera removeAllTargets];
                        [weakSelf.videoCamera addTarget:weakSelf.filter];
                        
                        [weakSelf.filter addTarget:weakSelf.beautyFilter];
                        [weakSelf.beautyFilter addTarget:weakSelf.filteredVideoView];
                    }else{
                        [weakSelf.stillCamera removeAllTargets];
                        [weakSelf.stillCamera addTarget:weakSelf.filter];
                        
                        [weakSelf.filter addTarget:weakSelf.beautyFilter];
                        [weakSelf.beautyFilter addTarget:weakSelf.filteredPhotoView];
                    }
                    
                }else{//有滤镜
                    [weakSelf.videoCamera removeAllTargets];
                    
                    
                    FilterModel* data = [weakSelf.filterAry objectAtIndex:indexPath.row];
                    _filtClassName = data.fillterName;
                    
                    if ([data.fillterName isEqualToString:@"GPUImageSaturationFilter"]) {
                        GPUImageSaturationFilter* xxxxfilter = [[NSClassFromString(weakSelf.filtClassName) alloc] init];
                        xxxxfilter.saturation = [data.value floatValue];
                        _saturationValue = [data.value floatValue];
                        weakSelf.filter = xxxxfilter;
                        
                    }else{
                        weakSelf.filter = [[NSClassFromString(weakSelf.filtClassName) alloc] init];
                    }
                    if (weakSelf.bottomBar.currentActon == JYVideoCameraBotomBarViewAction_video) {
                        [weakSelf.videoCamera addTarget:weakSelf.filter];
                        
                        [weakSelf.filter addTarget:weakSelf.beautyFilter];
                        [weakSelf.beautyFilter addTarget:weakSelf.filteredVideoView];
                    }else{
                        [weakSelf.stillCamera removeAllTargets];
                        [weakSelf.stillCamera addTarget:weakSelf.filter];
                        
                        [weakSelf.filter addTarget:weakSelf.beautyFilter];
                        [weakSelf.beautyFilter addTarget:weakSelf.filteredPhotoView];
                    }
                    
                }
            }
        };
    }
    return _bottomBeautyView;
}
-(JYVideoPasterView *)bottomPasteView
{
    if (!_bottomPasteView) {
        _bottomPasteView = [JYVideoPasterView new];
        [self addSubview:_bottomPasteView];
        [_bottomPasteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
        }];
        [_bottomPasteView setupWithStyle:JYVideoPasterViewStyle_Paster dataSource:[VideoManager getStikersData]];
        HXWeakSelf
        _bottomPasteView.videoPasterViewBlock = ^(NSIndexPath *indexPath) {
            
            if (self.lastStickersIndex.row != indexPath.row) {
                
                //1.修改数据源
                StickersModel* selectedModel = [weakSelf.stickersAry objectAtIndex:indexPath.row];
                selectedModel.isSelected = YES;
                StickersModel* lastModel = [weakSelf.stickersAry objectAtIndex:weakSelf.lastStickersIndex.row];
                lastModel.isSelected = NO;
                //2.刷新collectionView
                weakSelf.lastStickersIndex = indexPath;
                weakSelf.bottomPasteView.stickersModelArray = weakSelf.stickersAry;
                [weakSelf.bottomPasteView reloadCollectionView];
                _nowStickersIndex = indexPath;
            }
            else
            {
                weakSelf.stickersImgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            }
            StickersModel* data = [weakSelf.stickersAry objectAtIndex:indexPath.row];
            weakSelf.stickersImgView.image = [UIImage imageWithContentsOfFile:data.stickersImgPaht];
            weakSelf.stickersImgView.hidden = NO;
        };
    }
    return _bottomPasteView;
}
- (JYVideoSubsectionView *)bottomSubsectionView
{
    if (!_bottomSubsectionView) {
        HXWeakSelf
        _bottomSubsectionView = [JYVideoSubsectionView new];
        _bottomSubsectionView.hidden = YES;
        [self addSubview:_bottomSubsectionView];
        [_bottomSubsectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
        }];
        _bottomSubsectionView.configChangeBlock = ^(JYVideoConfigModel * _Nonnull config) {
            weakSelf.videoCollectionView.config = config;
            progressStep = SCREEN_WIDTH*TIMER_INTERVAL/config.totlalSeconds;
        };
    }
    return _bottomSubsectionView;
}
- (JYVideoGridView *)gridView
{
    if (!_gridView) {
        _gridView = [JYVideoGridView new];
        [self insertSubview:_gridView atIndex:1];
        [_gridView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        _gridView.hidden = YES;
    }
    return _gridView;
}
- (FSKGPUImageBeautyFilter *)beautyFilter
{
    if (!_beautyFilter) {
        _beautyFilter = [[FSKGPUImageBeautyFilter alloc]init];
        _beautyFilter.beautyLevel = 0.5;
        _beautyFilter.brightLevel = 0.5;
    }
    return _beautyFilter;
}
- (GPUImageFilter *)filter
{
    if (!_filter) {
        _filter = [[LFGPUImageEmptyFilter alloc] init];
    }
    return _filter;
}
- (GPUImageStillCamera *)stillCamera
{
    if (!_stillCamera) {
        //初始化相机，默认为前置相机
        _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    return _stillCamera;
}
- (GPUImageView *)filteredVideoView
{
    if (!_filteredVideoView) {
        _filteredVideoView = [[GPUImageView alloc] initWithFrame:self.bounds];
        _filteredVideoView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    }
    return _filteredVideoView;
}
-(GPUImageView *)filteredPhotoView
{
    if (!_filteredPhotoView) {
        _filteredPhotoView = [[GPUImageView alloc] initWithFrame:self.bounds];
        _filteredPhotoView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        [self addSubview:_filteredPhotoView];
        [self sendSubviewToBack:_filteredPhotoView];
    }
    return _filteredPhotoView;
}
- (UIImageView *)checkView
{
    if (!_checkView) {
        //查看无磨皮
        _checkView = [UIImageView new];
        _checkView.userInteractionEnabled = YES;
        _checkView.image = [UIImage imageNamed:@"checkNormal"];
        [self addSubview:_checkView];
        [_checkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.width.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.bottomBar.mas_top).mas_offset(-35);
        }];
        //手势
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        longpress.minimumPressDuration = 0.1;
        [_checkView addGestureRecognizer:longpress];
    }
    return _checkView;
}
- (JYBottomBeautySliderView *)beautysliderView
{
    if (!_beautysliderView) {
        HXWeakSelf
        _beautysliderView = [JYBottomBeautySliderView new];
        [self addSubview:_beautysliderView];
        [_beautysliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
        }];
        _beautysliderView.sliederView.updateSbuffingValue = ^(CGFloat value) {
            weakSelf.beautyFilter.beautyLevel = value;
        };
        _beautysliderView.sliederView.updateSkinWhiteningValue = ^(CGFloat value) {
            weakSelf.beautyFilter.brightLevel = value;
        };
    }
    return _beautysliderView;
}
- (UIButton *)finishRecordButton
{
    if (!_finishRecordButton) {
        //完成录制
        _finishRecordButton  = [[UIButton alloc] init];
        _finishRecordButton.hidden = YES;
        [_finishRecordButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_finishRecordButton addTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_finishRecordButton];
        [_finishRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
    }
    return _finishRecordButton;
}
@end


