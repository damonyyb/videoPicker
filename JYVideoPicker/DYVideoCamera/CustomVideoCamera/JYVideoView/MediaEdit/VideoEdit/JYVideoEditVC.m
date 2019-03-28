//
//  JYVideoEditVC.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/26.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYVideoEditVC.h"
#import "GPUImage.h"
#import "LFGPUImageEmptyFilter.h"
#import "JYNavingationBar.h"
#import "JYVideoEditCustomCollectionView.h"
#import "JYVideoEditVideoDeleteOrImportView.h"
#import "HXPhotoManager.h"
#import "UIViewController+HXExtension.h"
#import "UIView+HXExtension.h"
#import "HXPhotoPicker.h"
#import "MBProgressHUD.h"
#import "JYVideoEditCostuomBottomBarContainer.h"

@interface JYVideoEditVC ()<JYVideSliderDelegate>

@property (nonatomic, strong) AVPlayer *mainPlayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageMovie *movieFile;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic ,strong) NSString* filtClassName;
@property (nonatomic, strong) JYNavingationBar *topbar;
///底部主要工具
@property (nonatomic, strong) JYVideoEditCustomCollectionView *bottomBar;
///制作中的详细工具
@property (nonatomic, strong) JYVideoEditCustomCollectionView *bottomBarMakeDetailView;
///视频列表
@property (nonatomic, strong) JYVideoEditVideoDeleteOrImportView *videoListView;
///
@property (nonatomic, strong) HXPhotoManager *manager;
///hud
@property (nonatomic, strong) MBProgressHUD *HUD;
///当前选中的视频
@property (nonatomic, strong) VideoModel *seletedVideoModel;
///播放时间
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat endTime;

///展示图片/视频视图
@property (nonatomic ,strong) GPUImageView *filterView;
///裁剪等工具
@property (nonatomic, strong) JYVideoEditCostuomBottomBarContainer *bottomBarContainer;

@end

@implementation JYVideoEditVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playVideo];
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notCloseCor) name:@"closeVideoCamerTwo" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mainPlayer pause];
    [self.movieFile endProcessing];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    
    [self prefersStatusBarHidden];
    self.view.backgroundColor = [UIColor whiteColor];
    //视频view
    _filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 424*SCREEN_HEIGHT/667.f)];
    _filterView.backgroundColor = [UIColor whiteColor];
    _mainPlayer = [[AVPlayer alloc] init];

}
- (void)videoConfigWithIndex:(NSInteger)index
{
    VideoModel *model = self.videoModelArray[index];
    self.seletedVideoModel = model;
    _playerItem = [[AVPlayerItem alloc] initWithURL:model.videoModel.fileURL];
    [self enableAudioTracks:YES inPlayerItem:_playerItem];
    self.seletedVideoModel = self.videoModelArray.firstObject;
    [self.mainPlayer replaceCurrentItemWithPlayerItem:self.playerItem];

    self.movieFile = [[GPUImageMovie alloc] initWithPlayerItem:self.playerItem];
    self.movieFile.runBenchmark = YES;
    self.movieFile.playAtActualSpeed = YES;
    
    _filter = [[LFGPUImageEmptyFilter alloc] init];
    _filtClassName = @"LFGPUImageEmptyFilter";
    [self.movieFile addTarget:self.filter];
    [self.filter addTarget:self.filterView];
    [self.view addSubview:self.filterView];

//    float scale = model.videoModel.asset.pixelWidth*1.f/model.videoModel.asset.pixelHeight;
//    if (scale>1) {
//        _filterView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH/scale);
//    }else{
//        _filterView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 424*SCREEN_HEIGHT/667.f);
//    }
}
- (void)playVideo{
    if (self.seletedVideoModel.rate <= 0) {
        self.mainPlayer.rate = 1.0;
    }else{
        self.mainPlayer.rate = self.seletedVideoModel.rate;
    }
    [self.mainPlayer play];
    [self.movieFile startProcessing];
}
#pragma mark -- 初始化视图

- (void)setupSubviews{
    
    [self.topbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    [self.bottomBarMakeDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.bottom.mas_equalTo(self.bottomBar.mas_top).mas_offset(-10);
    }];
    [self.videoListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.right.mas_equalTo(-7);
        make.bottom.mas_equalTo(self.bottomBarMakeDetailView.mas_top).mas_offset(-10);
    }];
    self.videoListView.videoModelArray = self.videoModelArray;
}
#pragma mark -- action

- (void)playButtonClicked
{
    if (self.seletedVideoModel.rate <= 0) {
        self.mainPlayer.rate = 1.0;
    }else{
        self.mainPlayer.rate = self.seletedVideoModel.rate;
    }
    [self.playerItem seekToTime:kCMTimeZero];
    [self.mainPlayer play];
//    if (_audioPath) {
//        [audioPlayerItem seekToTime:kCMTimeZero];
//        [_audioPlayer play];
//    }
    
}
- (void)playingEnd:(NSNotification *)notification
{
    
    [self playButtonClicked];
    //    if (playImg.isHidden) {
    //        [self pressPlayButton];
    //    }
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 裁剪视频

- (void)cutvideoBtnClicked
{
    kWeakSelf;
    __block NSURL *selectedURL = self.seletedVideoModel.videoModel.fileURL;
    AVAsset *avasset = [AVURLAsset URLAssetWithURL:selectedURL options:nil];
    CMTime totalDuration = CMTimeAdd(kCMTimeZero, avasset.duration);
    [self.HUD hx_showLoadingHUDText:@"视频裁剪中"];
    CMTimeRange range = CMTimeRangeMake(CMTimeMakeWithSeconds(0.0, totalDuration.timescale), CMTimeMakeWithSeconds(self.endTime, totalDuration.timescale));
    [HXPhotoTools exportEditVideoForAVAsset:avasset timeRange:range presetName:AVAssetExportPresetHighestQuality success:^(NSURL *videoURL) {
       
        HXPhotoModel *model = [HXPhotoModel photoModelWithVideoURL:videoURL];
        VideoModel *vModel = [[VideoModel alloc]init];
        vModel.videoModel = model;
        [self.videoModelArray enumerateObjectsUsingBlock:^(VideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.videoModel.fileURL isEqual:selectedURL]) {
                weakSelf.seletedVideoModel = vModel;
                [weakSelf.videoModelArray removeObject:obj];
                [weakSelf.videoModelArray insertObject:vModel atIndex:idx];
                selectedURL = videoURL;
                *stop = YES;
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.videoListView.videoModelArray = weakSelf.videoModelArray;
            [weakSelf.bottomBarContainer showBottomBar:NO super:self.view];
        });
        CMTimeRange range2 = CMTimeRangeMake(CMTimeMakeWithSeconds(self.endTime, totalDuration.timescale), CMTimeMakeWithSeconds(CMTimeGetSeconds(avasset.duration), totalDuration.timescale));
        [HXPhotoTools exportEditVideoForAVAsset:avasset timeRange:range2 presetName:AVAssetExportPresetHighestQuality success:^(NSURL *videoURL) {
            [self.HUD hx_showLoadingHUDText:@"视频裁剪成功" delay:1.0];
            HXPhotoModel *model1 = [HXPhotoModel photoModelWithVideoURL:videoURL];
            VideoModel *vModel1 = [[VideoModel alloc]init];
            vModel1.videoModel = model1;
            [weakSelf.videoModelArray enumerateObjectsUsingBlock:^(VideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.videoModel.fileURL isEqual:selectedURL]) {
                    [weakSelf.videoModelArray insertObject:vModel1 atIndex:idx+1];
                    *stop = YES;
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.videoListView.videoModelArray = weakSelf.videoModelArray;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.videoListView.currentIndexPath = [NSIndexPath indexPathForRow:weakSelf.videoModelArray.count-1 inSection:0];
                });
            });
        } failed:^(NSError *error) {
            
        }];
    } failed:^(NSError *error) {
        
    }];
    
}
#pragma mark -- 本地选取视频/图片
- (void)importVideo
{
    kWeakSelf
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        HXPhotoModel *model = allList.firstObject;
        if (model.subType == HXPhotoModelMediaSubTypeVideo) {
            [weakSelf.HUD hx_showLoadingHUDText:@"获取视频中"];
            [model exportVideoWithPresetName:AVAssetExportPresetHighestQuality startRequestICloud:nil iCloudProgressHandler:nil exportProgressHandler:^(float progress, HXPhotoModel *model) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.HUD hx_showLoadingHUDText:[NSString stringWithFormat:@"视频导出进度 - %f",progress]];
                });
                
            } success:^(NSURL *videoURL, HXPhotoModel *model) {
                NSSLog(@"%@",videoURL);
                VideoModel *vModel = [[VideoModel alloc]init];
                vModel.videoModel = model;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSData* videoData = [NSData dataWithContentsOfFile:[[vModel.videoModel.fileURL absoluteString ] stringByReplacingOccurrencesOfString:@"file://" withString:@""]];
                    if (videoData.length>1024*1024*99) {
                        weakSelf.HUD.label.text = @"所选视频大于10M,请重新选择";
                        [weakSelf.HUD hideAnimated:YES afterDelay:1.5];
                    }else
                    {
                        [weakSelf.HUD hideAnimated:YES];
                        [weakSelf.videoModelArray addObject:vModel];
                        weakSelf.videoListView.videoModelArray = weakSelf.videoModelArray;
                    }
                });
                
                [weakSelf.HUD hx_handleLoading];
            } failed:^(NSDictionary *info, HXPhotoModel *model) {
                [weakSelf.HUD hx_handleLoading];
                [weakSelf.HUD hx_showImageHUDText:@"视频导出失败"];
            }];
            NSSLog(@"%lu个视频",(unsigned long)videoList.count);
        }
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSSLog(@"取消了");
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -- lazyloader

-(JYNavingationBar *)topbar
{
    if (!_topbar) {
        _topbar = [JYNavingationBar new];
        [_topbar.rightButton setTitle:@"合成" forState:UIControlStateNormal];
        [_topbar.rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_topbar.rightButton setBackgroundColor:[UIColor redColor]];
        
        [_topbar.backButton setImage:[UIImage imageNamed:@"backPhoto"] forState:UIControlStateNormal];
        [_topbar.titleLab setText:[NSString stringWithFormat:@"%.1fs",self.videoModelArray.firstObject.videoModel.asset.duration]];
        [_topbar.titleLab setTextColor:[UIColor blackColor]];
        [self.view addSubview:_topbar];
        kWeakSelf
        _topbar.backButtonBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _topbar.rightButtonBlock = ^{
            
        };
        
    }
    return _topbar;
}

- (NSMutableArray<VideoModel *> *)videoModelArray
{
    if (!_videoModelArray) {
        _videoModelArray = [NSMutableArray new];
    }
    return _videoModelArray;
}
- (JYVideoEditCustomCollectionView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [JYVideoEditCustomCollectionView new];
        [self.view addSubview:_bottomBar];
        _bottomBar.titleArray = @[@"制作",@"美化",@"声音",@"封面"];
        _bottomBar.imageArray = @[@"video_edit_make",@"video_edit_beauty",@"video_eidt_audio",@"video_edit_cover"];
        [_bottomBar setupSubviews];
        [_bottomBar setButtonLayoutStyle:JYButtonLaoutStyle_Left space:3];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [_bottomBar addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.8);
        }];
    }
    return _bottomBar;
}
- (void)JYVideoSlider:(JYVideoSlider *)slider endTime:(CGFloat)endTime
{
    self.startTime = 0;
    self.endTime = endTime;
    [self.mainPlayer pause];
    // 快进 / 快退
    CMTime time = CMTimeMakeWithSeconds(endTime, self.mainPlayer.currentTime.timescale);
    [self.mainPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
}
- (JYVideoEditCustomCollectionView *)bottomBarMakeDetailView
{
    if (!_bottomBarMakeDetailView) {
        _bottomBarMakeDetailView = [JYVideoEditCustomCollectionView new];
        [self.view addSubview:_bottomBarMakeDetailView];
        
        _bottomBarMakeDetailView.layout = [[UICollectionViewFlowLayout alloc] init];
        
        _bottomBarMakeDetailView.layout.estimatedItemSize = CGSizeMake(30*SCREEN_WIDTH/375, 100);
        //设置水平间距
        _bottomBarMakeDetailView.layout.minimumInteritemSpacing = 17*SCREEN_WIDTH/375;
        //水平滚动
        _bottomBarMakeDetailView.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // 设置额外滚动区域
        _bottomBarMakeDetailView.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _bottomBarMakeDetailView.titleArray = @[@"分割",@"旋转",@"速度",@"贴纸",@"标签",@"文字"];
        _bottomBarMakeDetailView.imageArray = @[@"video_edit_crop",@"video_edit_rotate",@"video_edit_speed",@"video_edit_sticker",@"video_edit_tag",@"video_edit_text"];
        [_bottomBarMakeDetailView setButtonLayoutStyle:JYButtonLaoutStyle_Top space:7];
        [_bottomBarMakeDetailView setupSubviews];
        kWeakSelf
        _bottomBarMakeDetailView.videoMakeDetailActionBlock = ^(JYVideoMakeDetailAction action) {
            
            
            
            if (action == JYVideoMakeDetailAction_crop) {//裁剪
                weakSelf.bottomBarContainer.action = action;
                [weakSelf.bottomBarContainer showBottomBar:YES super:weakSelf.view];
                [weakSelf.view bringSubviewToFront:weakSelf.bottomBarContainer];
                [weakSelf.bottomBarContainer.slider getMovieFrame:weakSelf.seletedVideoModel.videoModel.fileURL];
                
            }else if (action == JYVideoMakeDetailAction_rotate){//旋转
                weakSelf.seletedVideoModel.transform = CGAffineTransformRotate(weakSelf.filterView.transform, -M_PI/2);
                [UIView animateWithDuration:0.35 animations:^{
                    weakSelf.filterView.transform = weakSelf.seletedVideoModel.transform;
                }];
                
            }else if (action == JYVideoMakeDetailAction_speed){//速度
                weakSelf.bottomBarContainer.action = action;
                [weakSelf.bottomBarContainer showBottomBar:YES super:weakSelf.view];
                [weakSelf.view bringSubviewToFront:weakSelf.bottomBarContainer];
            }
        };
        
    }
    return _bottomBarMakeDetailView;
}
- (JYVideoEditVideoDeleteOrImportView *)videoListView
{
    if (!_videoListView) {
        _videoListView = [JYVideoEditVideoDeleteOrImportView new];
        [self.view addSubview:_videoListView];
        kWeakSelf
        _videoListView.leftRightBtnBlock = ^(JYVideoEditVideoDeleteOrImportViewBtn btn) {
            if (btn == JYVideoEditVideoDeleteOrImportView_leftBtn) {
                
            }else{
                [weakSelf importVideo];
            }
        };
        _videoListView.collectionViewBlock = ^(NSInteger index) {
            [weakSelf videoConfigWithIndex:index];
            [weakSelf playVideo];
            
        };
    }
    return _videoListView;
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.singleSelected = NO;
        _manager.configuration.albumListTableView = ^(UITableView *tableView) {
            //            NSSLog(@"%@",tableView);
        };
        _manager.configuration.singleJumpEdit = NO;
        _manager.configuration.movableCropBox = YES;
        _manager.configuration.movableCropBoxEditSize = YES;
        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
        _manager.configuration.openCamera = NO;
        _manager.configuration.lookGifPhoto = NO;
        _manager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
        _manager.type = HXPhotoManagerSelectedTypeVideo;
        //        _manager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
    }
    return _manager;
}
- (JYVideoEditCostuomBottomBarContainer *)bottomBarContainer
{
    if (!_bottomBarContainer) {
        _bottomBarContainer = [JYVideoEditCostuomBottomBarContainer new];
        [self.view addSubview:_bottomBarContainer];
        _bottomBarContainer.slider.delegate = self;
        [_bottomBarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(180);
        }];
        kWeakSelf
        _bottomBarContainer.rightButtonBlock = ^(JYVideoMakeDetailAction action) {
            if (action == JYVideoMakeDetailAction_crop) {//裁剪确认
                [weakSelf cutvideoBtnClicked];
            }else if (action == JYVideoMakeDetailAction_speed){//速度确认
                weakSelf.seletedVideoModel.rate = weakSelf.bottomBarContainer.speedSlider.rate;
                weakSelf.mainPlayer.rate = weakSelf.seletedVideoModel.rate;
            }
        };
    }
    return _bottomBarContainer;
}
- (void)enableAudioTracks:(BOOL)enable inPlayerItem:(AVPlayerItem*)playerItem
{
    for (AVPlayerItemTrack *track in playerItem.tracks)
    {
        if ([track.assetTrack.mediaType isEqual:AVMediaTypeAudio])
        {
            track.enabled = enable;
        }
    }
}
@end
