//
//  JYEditImageViewController.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/21.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYEditImageViewController.h"
#import "JYNavingationBar.h"
#import "Masonry.h"
#import "JYPhotoBeautyBottomView.h"
#import "JYVideoRecordSliderView.h"

#import "JYCustomCollectionView.h"

#import "JYEditImageFilterAndBeautyBottomView.h"
@interface JYEditImageViewController ()

@property (nonatomic, strong) JYNavingationBar *navigationView;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) NSMutableArray *showImageViewArray;
@property (nonatomic, strong) JYPhotoBeautyBottomView *bottomBar;
@property (nonatomic, strong) NSMutableArray* filterAry;

@property (nonatomic, strong) GPUImageFilter *filter;
//美白、磨皮滑竿
@property (nonatomic, strong) JYVideoRecordSliderView *sliederView;
///美颜
@property (nonatomic, strong) FSKGPUImageBeautyFilter*beautyFilter;
///滤镜
@property (nonatomic, strong) NSArray <FilterModel *>*filterModelArray;
///滤镜名称
@property (nonatomic, strong) NSString *filtClassName;
@property (nonatomic, strong) JYPhotoConfigModel *photoConfigModel;

///美颜、滤镜
@property (nonatomic, strong) JYEditImageFilterAndBeautyBottomView *filterAndBeautyBottomView;

@end

@implementation JYEditImageViewController
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoConfigModel = self.photoConfigModelArray.firstObject;
    _filterModelArray = [NSMutableArray arrayWithArray:[VideoManager getFiltersData]];
    self.navigationView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    //底部
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
    }];
    [self.bottomBar layoutIfNeeded];

    float top = (SCREEN_HEIGHT - 64 - self.bottomBar.frame.size.height - SCREEN_WIDTH)/2;
    for (int i = 0; i<self.photoConfigModelArray.count; i++) {
        UIImageView *imgView = [UIImageView new];
        imgView.userInteractionEnabled = YES;
        JYPhotoConfigModel *model = self.photoConfigModelArray[i];
        [self setFilterWithIndex:model.filterIndex];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imgView];
        imgView.hidden = YES;
        imgView.image = model.editImage;
        [self.showImageViewArray addObject:imgView];
        //图片
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.navigationView.mas_bottom).mas_offset(top);
            make.width.height.mas_equalTo(SCREEN_WIDTH);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnImageViewAction:)];
        [imgView  addGestureRecognizer:tap];
        if (i == 0) {
            self.showImageView = imgView;
            imgView.hidden = NO;
        }
        
    }
    //滤镜、美颜
    [self.filterAndBeautyBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
        make.bottom.mas_equalTo(200);
    }];
    
    
}
- (void)tapOnImageViewAction:(UITapGestureRecognizer *)gesture
{
//    self.filterAndBeautyBottomView.hidden = YES;
    [self.filterAndBeautyBottomView showBottomBar:NO super:self.view];
}
- (JYNavingationBar *)navigationView
{
    if (!_navigationView) {
        _navigationView = [JYNavingationBar new];
        [self.view addSubview:_navigationView];
        [_navigationView setWithStyle];
        kWeakSelf
        _navigationView.rightButtonBlock = ^{
            NSInteger index = [weakSelf.photoConfigModelArray indexOfObject:weakSelf.photoConfigModel];
            if (index < weakSelf.photoConfigModelArray.count-1) {
                weakSelf.showImageView.hidden = YES;
                weakSelf.showImageView = weakSelf.showImageViewArray[index+1];//越界问题
                weakSelf.showImageView.hidden = NO;
                weakSelf.photoConfigModel = weakSelf.photoConfigModelArray[index+1];
                [weakSelf setFilterWithIndex:weakSelf.photoConfigModel.filterIndex];
            }else{
                
            }
            
        };
        _navigationView.backButtonBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [_navigationView setTitle:@"1/1"];
    }
    return _navigationView;
}

- (JYPhotoBeautyBottomView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [JYPhotoBeautyBottomView new];
        [self.view addSubview:_bottomBar];
        kWeakSelf
        _bottomBar.callBackBlock = ^(NSInteger index) {
            if (index == 0) {
//                weakSelf.beautysliderView.hidden = NO;
//                weakSelf.filterAndBeautyBottomView.hidden = NO;
                [weakSelf.filterAndBeautyBottomView showBottomBar:YES super:weakSelf.view];
            }else if (index == 1){
//                weakSelf.stic
            }else if (index == 2){
//                weakSelf.filterCollectionView.hidden = NO;
            }
        };
    }
    return _bottomBar;
}
- (JYVideoRecordSliderView *)sliederView
{
    if (!_sliederView) {
        kWeakSelf
        _sliederView = [JYVideoRecordSliderView new];
        _sliederView.hidden = YES;
        [self.view addSubview:_sliederView];
        [_sliederView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(-80);
            make.bottom.mas_equalTo(self.bottomBar.mas_top).mas_offset(-15);
        }];
        _sliederView.updateSbuffingValueBlock = ^(CGFloat value) {
            weakSelf.beautyFilter.beautyLevel = value;
        };
        _sliederView.updateSkinWhiteningValueBlock = ^(CGFloat value) {
            weakSelf.beautyFilter.brightLevel = value;
        };
    }
    return _sliederView;
}
- (FSKGPUImageBeautyFilter *)beautyFilter
{
    if (!_beautyFilter) {
        _beautyFilter = [[FSKGPUImageBeautyFilter alloc]init];
        _beautyFilter.beautyLevel = self.photoConfigModel.beautyLevel;
        _beautyFilter.brightLevel = self.photoConfigModel.brightLevel;
    }
    return _beautyFilter;
}
//


- (JYEditImageFilterAndBeautyBottomView *)filterAndBeautyBottomView
{
    kWeakSelf
    if (!_filterAndBeautyBottomView) {
        _filterAndBeautyBottomView = [JYEditImageFilterAndBeautyBottomView new];
        [self.view addSubview:_filterAndBeautyBottomView];
    }
    _filterAndBeautyBottomView.beautySliederView.updateSbuffingValueBlock = ^(CGFloat value) {
        weakSelf.beautyFilter.beautyLevel = value;
        [weakSelf addBeautyAndFilter];
    };
    _filterAndBeautyBottomView.beautySliederView.updateSkinWhiteningValueBlock = ^(CGFloat value) {
        weakSelf.beautyFilter.brightLevel = value;
        [weakSelf addBeautyAndFilter];
    };
    _filterAndBeautyBottomView.filterCollectionView.videoPasterViewBlock = ^(NSIndexPath * _Nonnull indexPath) {
                    [weakSelf setFilterWithIndex:indexPath.row];
    };
    

    return _filterAndBeautyBottomView;
}
- (void)setFilterWithIndex:(NSInteger)index
{
    if (index == 0) {//无滤镜
        FilterModel* data = [self.filterModelArray objectAtIndex:index];
        self.filtClassName = data.fillterName;
        self.filter = [[NSClassFromString(self.filtClassName) alloc] init];
    
    }else{//有滤镜
        
        FilterModel* data = [self.filterModelArray objectAtIndex:index];
        self.filtClassName = data.fillterName;

        if ([data.fillterName isEqualToString:@"GPUImageSaturationFilter"]) {
            GPUImageSaturationFilter* xxxxfilter = [[NSClassFromString(self.filtClassName) alloc] init];
            xxxxfilter.saturation = [data.value floatValue];
            self.filter = xxxxfilter;

        }else{
            self.filter = [[NSClassFromString(self.filtClassName) alloc] init];
        }
    }
    [self addBeautyAndFilter];
}


//美白
- (void)addBeautyAndFilter{
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:self.photoConfigModel.editImage];
    //设置美白参数
    [self.beautyFilter forceProcessingAtSize:self.showImageView.image.size];
    [pic addTarget:self.beautyFilter];
    [self.beautyFilter addTarget:self.filter];
    [pic processImage];
    //处理最后add进去的filter就可以了
    [self.filter useNextFrameForImageCapture];
    UIImage *newImage = [self.filter imageFromCurrentFramebuffer];
    self.showImageView.image = newImage;
}
- (NSMutableArray *)showImageViewArray
{
    if (!_showImageViewArray) {
        _showImageViewArray = [NSMutableArray new];
    }
    return _showImageViewArray;
}
@end

