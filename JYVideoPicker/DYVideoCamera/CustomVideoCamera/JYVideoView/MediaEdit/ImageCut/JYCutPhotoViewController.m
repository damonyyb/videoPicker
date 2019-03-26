//
//  JYCutPhotoViewController.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/20.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYCutPhotoViewController.h"
#import "Masonry.h"
#import "JYNavingationBar.h"
#import "JYPhotoCropBottomView.h"
#import "JYEditImageViewController.h"
#import "JYPhotoConfigModel.h"
#import "UIImage+JYRotate.h"
#import "UIImage+JYCropImage.h"

#define viewHeight (SCREEN_WIDTH - 64)

@interface JYCutPhotoViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *currentShowImageView;
@property (nonatomic, strong) NSMutableArray *showImageViewArray;

@property (nonatomic, strong) UIScrollView *currentScrollView;
@property (nonatomic, strong) NSMutableArray *scrollViewArray;

@property (nonatomic, strong) NSMutableArray *originalImageArray;

@property (nonatomic, strong) UIView *borderView;

@property (nonatomic, strong) JYNavingationBar *navigationView;
@property (nonatomic, strong) UIView *bottomBar;

//选取取消按钮
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
///底部原图选择
@property (nonatomic, strong) JYPhotoCropBottomView *photoCropBottomView;


@end

@implementation JYCutPhotoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupSubview];
    }
    
    return self;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
/**
 设置默认值
 */
- (void)setupSubview
{
    _cutBorderColor = [UIColor whiteColor];
    _maxScale = 3;
    _cutBorderWidth = 1;
    _cutCoverColor = [UIColor colorWithWhite:0 alpha:0.3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.cancelButton];
    self.navigationView.hidden = NO;
    [self.navigationView setTitle:[NSString stringWithFormat:@"1/%lu裁剪照片",(unsigned long)self.photoArray.count]];
    [self.view bringSubviewToFront:self.photoCropBottomView];
    //地图原图选择器
    [self.photoCropBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
    }];
    [self.view addSubview:self.borderView];
    [self setCoverView];
}
/**
 通过资源获取图片的数据
 
 @param mAsset 资源文件
 @param imageBlock 图片数据回传
 */
- (void)fetchImageWithAsset:(PHAsset*)mAsset imageBlock:(void(^)(NSData*))imageBlock {
    
    [[PHImageManager defaultManager] requestImageDataForAsset:mAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        if (orientation != UIImageOrientationUp) {
//            UIImage* image = [UIImage imageWithData:imageData];
            // 尽然弯了,那就板正一下
//            image = [image fixOrientation];
            // 新的 数据信息 （不准确的）
//            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        
        // 直接得到最终的 NSData 数据
        if (imageBlock) {
            imageBlock(imageData);
        }
        
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark -- 裁剪图片，跳转到下一页

- (void)cropPhoto
{
    NSMutableArray *modelArr = [NSMutableArray new];
    for (int i=0; i<self.showImageViewArray.count; i++) {
        UIImageView *imgView = self.showImageViewArray[i];
        CGRect rect = [self.view convertRect:_cutFrame toView:imgView];
        UIImage *img = [VideoManager getCropImageWithOriginalImage:imgView.image cropRect:rect imageViewSize:imgView.frame.size];
        JYPhotoConfigModel *model = [JYPhotoConfigModel new];
        model.beautyLevel = 0.5;
        model.brightLevel = 0.5;
        model.editImage = img;
        [modelArr addObject:model];
    }
    
    JYEditImageViewController *vc = [[JYEditImageViewController alloc]init];
    vc.photoConfigModelArray = modelArr;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)rotateImageWithIndex:(NSInteger)index{
    
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI / 2.0 ];
//    rotationAnimation.duration = 1;
////    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = 1;
//    [self.currentScrollView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    //旋转
    self.originalImage =  [self.originalImage rotate:UIImageOrientationLeft];
    [self.currentScrollView removeFromSuperview];
    
    self.currentScrollView = [self getScrollView];
    self.currentScrollView.tag = 100 + index;
    [self.view addSubview:self.currentScrollView];
    
    UIImageView *imgView = [self getImageView];
    self.currentShowImageView = imgView;
    [self.currentScrollView addSubview:imgView];
    
    [self.showImageViewArray replaceObjectAtIndex:index withObject:self.currentShowImageView];
    [self.scrollViewArray replaceObjectAtIndex:index withObject:self.currentScrollView];
    [self.view sendSubviewToBack:self.currentScrollView];
}

- (UIScrollView*)getScrollView
{
    _cutFrame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH);
    _currentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, viewHeight)];
    _currentScrollView.delegate = self;
    _currentScrollView.multipleTouchEnabled=YES; //是否支持多点触控
    _currentScrollView.minimumZoomScale = 1.0;  //表示与原图片最小的比例
    _currentScrollView.maximumZoomScale = _maxScale; //表示与原图片最大的比例
    _currentScrollView.backgroundColor = [UIColor blackColor];
    _currentScrollView.showsVerticalScrollIndicator = NO;
    _currentScrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        _currentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _currentScrollView.clipsToBounds = NO;
    _currentScrollView.contentInset = UIEdgeInsetsMake(0, _cutFrame.origin.x, viewHeight - _cutFrame.size.height, SCREEN_WIDTH -  _cutFrame.origin.x - _cutFrame.size.width);
    
    return _currentScrollView;
}

- (UIImageView*)getImageView
{
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    if (_originalImage) {
        imgView.image = _originalImage;
        imgView.frame = CGRectMake(0, 0, _cutFrame.size.width, _cutFrame.size.width * _originalImage.size.height / _originalImage.size.width);
        
        if (imgView.frame.size.height < _cutFrame.size.height) {
            imgView.frame = CGRectMake(0, 0,_cutFrame.size.height * _originalImage.size.width / _originalImage.size.height, _cutFrame.size.height);
        }
        
        _currentScrollView.contentSize = CGSizeMake(_cutFrame.size.width, _cutFrame.size.height);
        
        //调节图片位置
        if (imgView.frame.size.height > _currentScrollView.contentSize.height) {
            _currentScrollView.contentSize = CGSizeMake(_cutFrame.size.width, imgView.frame.size.height);
        }

        //调节图片位置
        if (imgView.frame.size.width > _currentScrollView.contentSize.width) {
            _currentScrollView.contentSize = CGSizeMake( imgView.frame.size.width, _cutFrame.size.height);
        }
    }
    return imgView;
}

- (UIView*)borderView
{
    if (!_borderView) {
        _borderView = [[UIView alloc]initWithFrame:_cutFrame];
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderWidth = _cutBorderWidth;
        _borderView.layer.borderColor = _cutBorderColor.CGColor;
        _borderView.userInteractionEnabled = NO;
    }
    
    return _borderView;
}

- (JYNavingationBar *)navigationView
{
    if (!_navigationView) {
        _navigationView = [JYNavingationBar new];
        [self.view addSubview:_navigationView];
        [_navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(64);
        }];
        kWeakSelf
        _navigationView.rightButtonBlock = ^{
//            [weakSelf cropPhoto];
            NSInteger index = [weakSelf.scrollViewArray indexOfObject:weakSelf.currentScrollView]+1;
            if (index < weakSelf.scrollViewArray.count) {//切换到下一张
                weakSelf.currentScrollView.hidden = YES;
                weakSelf.currentScrollView = weakSelf.scrollViewArray[index];
                weakSelf.currentScrollView.hidden = NO;
                
                weakSelf.currentShowImageView = weakSelf.showImageViewArray[index];
                weakSelf.originalImage =  weakSelf.currentShowImageView.image;
            }else{//裁剪，跳到下一页
                [weakSelf cropPhoto];
                
            }
           
        };
        _navigationView.backButtonBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _navigationView;
}
- (JYPhotoCropBottomView *)photoCropBottomView
{
    if (!_photoCropBottomView) {
        _photoCropBottomView = [JYPhotoCropBottomView new];
        [self.view addSubview:_photoCropBottomView];
        _photoCropBottomView.dataSource = self.photoArray;
    }
    kWeakSelf
    _photoCropBottomView.imageCollcetionView.selectBlock = ^(NSInteger index) {
        weakSelf.currentScrollView.hidden = YES;
        weakSelf.currentScrollView = weakSelf.scrollViewArray[index];
        weakSelf.currentScrollView.hidden = NO;
        
        weakSelf.currentShowImageView = weakSelf.showImageViewArray[index];
        weakSelf.originalImage =  weakSelf.currentShowImageView.image;
        [weakSelf.navigationView setTitle:[NSString stringWithFormat:@"%lu/%lu裁剪照片",index+1,(unsigned long)weakSelf.showImageViewArray.count]];
    };
    _photoCropBottomView.RotateBlock = ^{
        [weakSelf rotateImageWithIndex:[weakSelf.scrollViewArray indexOfObject:weakSelf.currentScrollView]];
    };
    return _photoCropBottomView;
}



/**
 覆盖层
 */
- (void)setCoverView
{
    
    CGMutablePathRef path = CGPathCreateMutableCopy([UIBezierPath bezierPathWithRect:self.currentScrollView.bounds].CGPath);
    
    UIBezierPath *cutBezierPath = [UIBezierPath bezierPathWithRect:self.currentScrollView.bounds];
    cutBezierPath.lineWidth = self.cutBorderWidth;
    
    CGMutablePathRef cutPath = CGPathCreateMutableCopy(cutBezierPath.CGPath);
    CGPathAddPath(path, nil, cutPath);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.path = path;
    shapeLayer.fillColor = self.cutCoverColor.CGColor;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    [self.view.layer addSublayer:shapeLayer];
    CGPathRelease(cutPath);
    CGPathRelease(path);
}




#pragma mark scrollView
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.currentShowImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //缩放处理
}
- (NSMutableArray *)showImageViewArray
{
    if (!_showImageViewArray) {
        _showImageViewArray = [NSMutableArray new];
    }
    return _showImageViewArray;
}
-(void)setPhotoArray:(NSArray<HXPhotoModel *> *)photoArray
{
    _photoArray = photoArray;
    kWeakSelf
    for (int i=0; i<self.photoArray.count; i++) {
        [self fetchImageWithAsset:self.photoArray[i].asset imageBlock:^(NSData * imageData) {
            UIImage *img = [UIImage imageWithData:imageData];
            [weakSelf.originalImageArray addObject:img];
            weakSelf.originalImage = img;
     
            UIScrollView *scrollView = [self getScrollView];
            scrollView.tag = 100 + i;
            [weakSelf.view addSubview:scrollView];
            [weakSelf.scrollViewArray addObject:scrollView];
            [weakSelf.view sendSubviewToBack:scrollView];
            weakSelf.currentScrollView = scrollView;
            
            
            UIImageView *imgView = [self getImageView];
            imgView.image = img;
            self.currentShowImageView = imgView;
            [self.showImageViewArray addObject:imgView];
            [scrollView addSubview:imgView];
            
            scrollView.hidden = YES;
            if (i == 0) {
                scrollView.hidden = NO;
            }else if (i == weakSelf.photoArray.count - 1){
                self.currentScrollView = weakSelf.scrollViewArray.firstObject;
                weakSelf.currentShowImageView = weakSelf.showImageViewArray.firstObject;
                weakSelf.originalImage = weakSelf.originalImageArray.firstObject;
            }
        }];
        
    }
    
}
-(NSMutableArray *)scrollViewArray
{
    if (!_scrollViewArray) {
        _scrollViewArray = [NSMutableArray new];
    }
    return _scrollViewArray;
}
- (NSMutableArray *)originalImageArray
{
    if (!_originalImageArray) {
        _originalImageArray = [NSMutableArray new];
    }
    return _originalImageArray;
}
@end
