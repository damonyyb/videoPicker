//
//  JYVideoPasterView.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/12.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoPasterView.h"
#import "JYVideoCommonCell.h"
#import "Masonry.h"
#import "JYVideoImageCell.h"
#import "UIView+Tools.h"
#import "UIColor+JYHex.h"
#import "JYCustomCollectionView.h"

#define kFilterCellID @"filterCellID"
#define kStickerCellID @"stickerCellID"
@interface JYVideoPasterView ()
@property (nonatomic, assign) CGFloat selfHeight;
///蒙层
@property (nonatomic, strong) UIVisualEffectView *visualView;
///标题
@property (nonatomic, strong) UILabel *titleLab;

///横线
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) JYCustomCollectionView *collectionView;



@end
@implementation JYVideoPasterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
    }
    return self;
}




- (void)setupWithStyle:(JYVideoPasterViewStyle)style dataSource:(id)dataSource
{
    [self.collectionView setupWithStyle:style dataSource:dataSource];
    switch (style) {
            case JYVideoPasterViewStyle_filter:
        {
            self.selfHeight = 110;
        }
            break;
            case JYVideoPasterViewStyle_Paster:
        {
            self.selfHeight = 200;
        }
            break;
        default:
            break;
    }
    //添加标题栏
    [self addTitleLab];
    
    //添加collectionview
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(self.selfHeight);
    }];
    
    //添加蒙层
    [self addCoverView];
}
#pragma mark -- reloadCollectionView
-(void)reloadCollectionView
{
    [self.collectionView reloadData];
}
- (void)changeBackgroundColor:(UIColor *)color
{
    if (color == [UIColor whiteColor]) {
        self.titleLab.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        self.visualView.hidden = YES;
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    }else{
        self.backgroundColor = [UIColor clearColor];
        self.visualView.hidden = NO;
        self.titleLab.textColor = [UIColor whiteColor];
        self.lineView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.2f];
    }
}
#pragma mark -- 添加蒙层

- (void)addCoverView
{
    //蒙层
    [self addSubview:self.visualView];
    [self sendSubviewToBack:self.visualView];
    [self.visualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
- (void)addTitleLab{
    self.titleLab = [UILabel new];
    [self addSubview:self.titleLab];
    switch (self.style) {
        case JYVideoPasterViewStyle_filter:
            self.titleLab.text = @"滤镜";
            break;
        case JYVideoPasterViewStyle_Paster:
            self.titleLab.text = @"贴纸";
        default:
            break;
    }
    
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = [UIColor whiteColor];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    UIView *lineView = [UIView new];
    [self.titleLab addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.2f];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    self.lineView = lineView;
}
#pragma mark -- lazy load

-(UIVisualEffectView *)visualView
{
    if (!_visualView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    }
    return _visualView;
}
-(JYCustomCollectionView *)collectionView
{
    if (!_collectionView) {
        kWeakSelf
        _collectionView = [JYCustomCollectionView new];
        _collectionView.videoPasterViewBlock = ^(NSIndexPath * _Nonnull indexPath) {
            weakSelf.videoPasterViewBlock(indexPath);
        };
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
@end
