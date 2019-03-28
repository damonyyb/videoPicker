//
//  JYVideoSlider.m
//  VideoCutDemo
//
//  Created by Joblee on 2019/2/20.
//  Copyright © 2019年 bh. All rights reserved.
//

#import "JYVideoSlider.h"
@interface JYVideoSlider ()<UIScrollViewDelegate>
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (nonatomic, strong) UIView * centerLineView;
@property (nonatomic, strong) NSURL * videoUrl;
@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic, assign) CGFloat self_w;
@property (nonatomic, assign) CGFloat self_h;
@property (nonatomic) Float64 durationSeconds;
@property (nonatomic, assign) CGFloat scale;
@end
@implementation JYVideoSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    self.self_h = self.bounds.size.height;
    self.self_w = self.bounds.size.width;
    [self addSubview:self.scrollView];
    [self addSubview:self.centerLineView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(JYVideoSlider:endTime:)]){
        
        [_delegate JYVideoSlider:self endTime: self.scrollView.contentOffset.x*self.scale] ;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];

}
#pragma mark - Video

- (void)getMovieFrame:(NSURL *)videoUrl {
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    self.imageGenerator = nil;
    AVAsset *myAsset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    //缩略图大小
    CGImageRef halfWayImage = [self.imageGenerator copyCGImageAtTime: CMTimeMakeWithSeconds(0, 600) actualTime:NULL error:NULL];
    UIImage *videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage scale:1.0 orientation:UIImageOrientationUp];
    self.imageGenerator.maximumSize = CGSizeMake(videoScreen.size.width*0.1, videoScreen.size.height * 0.1);
    int picWidth = 50;
    
    self.durationSeconds = CMTimeGetSeconds([myAsset duration]);
    
    int picsCnt = ceil( self.durationSeconds);//返回大于或者等于指定表达式的最小整数
    self.scale = self.durationSeconds/(picWidth*picsCnt);//每个点对应多少秒
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width+picsCnt*picWidth, self.bounds.size.height);
    NSMutableArray *allTimes = [[NSMutableArray alloc] init];
    
    for (int i=0; i<picsCnt; i++) {
        
        CMTime timeFrame;
        timeFrame = CMTimeMakeWithSeconds(0.5, 600);
        [allTimes addObject:[NSValue valueWithCMTime:timeFrame]];
        
        CGImageRef halfWayImage = [self.imageGenerator copyCGImageAtTime:timeFrame actualTime:NULL error:NULL];
        
        UIImage *videoScreen = [[UIImage alloc] initWithCGImage:halfWayImage scale:1.0 orientation:UIImageOrientationUp];
        UIImageView *tmp = [[UIImageView alloc] initWithImage:videoScreen];
        tmp.layer.masksToBounds = YES;
        tmp.contentMode = UIViewContentModeScaleAspectFill;
        tmp.frame = CGRectMake(self.bounds.size.width/2 + i*picWidth, 0, picWidth, self.bounds.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.scrollView addSubview:tmp];
        });
        
        CGImageRelease(halfWayImage);
    }
}
- (UIView *)centerLineView
{
    if (!_centerLineView) {
        //拖拽视图
        _centerLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, 1, self.frame.size.height+4)];
        _centerLineView.backgroundColor = [UIColor redColor];
        _centerLineView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    return _centerLineView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
-(void)dealloc
{
    NSLog(@"slider 释放");
}
@end
