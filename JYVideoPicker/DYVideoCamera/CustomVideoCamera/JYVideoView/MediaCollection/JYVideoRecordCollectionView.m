//
//  JYVideoRecordCollectionView.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/12.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoRecordCollectionView.h"
#import "VideoManager.h"
static NSString *cellID = @"cellID";
#define itemWidth [UIScreen mainScreen].bounds.size.width*45/375
#define space [UIScreen mainScreen].bounds.size.width*5/375.f

@interface JYVideoRecordCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLab;
///红点
@property (nonatomic, strong) UIView *redPointView;
@end

@implementation JYVideoRecordCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
    }
    return self;
}
- (void)setupSubviews
{
    //时间/分段
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(17);
        
    }];
    //红点
    _redPointView = [UIView new];
    [self addSubview:_redPointView];
    _redPointView.backgroundColor = [UIColor redColor];
    [_redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
        make.right.mas_equalTo(self.titleLab.mas_left).mas_offset(-10);
        make.width.height.mas_equalTo(12);
    }];
    _redPointView.layer.masksToBounds = YES;
    _redPointView.hidden = YES;
    _redPointView.layer.cornerRadius = 6;
    [self.redPointView.layer addAnimation:[self AlphaLight:0.5] forKey:@"aAlpha"];
    //collectionView
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(itemWidth);
        make.width.mas_equalTo(0.1);
        make.centerX.mas_equalTo(0);
    }];
}
-(CABasicAnimation *) AlphaLight:(float)time
{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;//动画循环的时间，也就是呼吸灯效果的速度
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}
//[weakSelf.redPointView.layer removeAnimationForKey:@"aAlpha"];
#pragma mark -- collection delegate&&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:100];
    if (!imgView) {
        imgView = [UIImageView new];
        imgView.tag = 100;
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 2;
        imgView.layer.borderWidth = 0.5;
        imgView.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell.contentView);
        }];
    }
    imgView.image = [VideoManager thumbnailImageForVideo:self.videoArray[indexPath.row] atTime:0.0];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.videoSelectedBlock(self.videoArray[indexPath.row]);
}
#pragma mark -- lazy load

- (UIView *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        [self addSubview:_titleLab];
        _titleLab.font = [UIFont systemFontOfSize:12];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.numberOfLines = 1;
        _titleLab.textColor = [UIColor whiteColor];
    }
    return _titleLab;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
//        layout.estimatedItemSize = CGSizeMake(itemWidth, itemWidth);
        // 设置水平滚动方向
        //水平滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置额外滚动区域
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // 设置cell间距
        //设置垂直间距
        layout.minimumLineSpacing = space;
        //初始化collectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
#pragma mark -- setter
-(void)setVideoArray:(NSMutableArray<NSURL *> *)videoArray
{
    self.redPointView.hidden = YES;
    self.collectionView.hidden = NO;
    //重新加载数据
    _videoArray = videoArray;
    [self.collectionView reloadData];
    //更新宽度
    CGFloat width = itemWidth*videoArray.count+space*(videoArray.count-1);
    if (width >= [UIScreen mainScreen].bounds.size.width) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    //更新标题
    if (self.config.isSubsection) {
        self.titleLab.text = [NSString stringWithFormat:@"分%.0f段 | 共%.0f秒",self.config.totlalSubsection,self.config.totlalSeconds];
//        self.hidden = NO;
    }else{
//        self.titleLab.hidden = NO;
        self.titleLab.text = [NSString stringWithFormat:@"%.1f | 共60.0秒",self.config.seconds];
//        self.hidden = NO;
    }
    self.config.totalRecordSeconds += self.config.seconds;
}
-(void)setConfig:(JYVideoConfigModel *)config
{
    _config = config;
    [self updateUI];
    self.redPointView.hidden = YES;
}
- (void)updateUI{
    if (self.config.isSubsection) {
        self.titleLab.text = [NSString stringWithFormat:@"分%.0f段 | 共%.0f秒",self.config.totlalSubsection,self.config.totlalSeconds];
    }else{
        self.titleLab.text = [NSString stringWithFormat:@"%.1f | 60.0",self.config.seconds];
    }
    
     self.redPointView.hidden = NO;
    self.collectionView.hidden = YES;
//    self.titleLab.hidden = !self.config.isSubsection;
//    self.hidden = !self.config.isSubsection;
}
- (void)updateConfigWithTime:(float)second
{
    self.config.seconds = second;
    [self updateUI];
}
@end
