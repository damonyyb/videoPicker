//
//  JYEditImageFilterAndBeautyBottomView.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/25.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYEditImageFilterAndBeautyBottomView.h"
#import "Masonry.h"
#import "UIColor+JYHex.h"
#import "VideoManager.h"
@interface JYEditImageFilterAndBeautyBottomView ()
///滑块
@property (nonatomic, strong) UIView *sliederView;
///滤镜
@property (nonatomic, strong) NSArray <FilterModel *>*filterModelArray;
@end

@implementation JYEditImageFilterAndBeautyBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}
- (void)setupViews{
    self.backgroundColor = [UIColor whiteColor];
    _filterModelArray = [NSMutableArray arrayWithArray:[VideoManager getFiltersData]];
    
    
    
    UIButton *btnTemp = nil;
    
    NSArray *titleArr = @[@"",@"滤镜",@"美化",@""];
    NSArray *imageArr = @[@"video_close_black",@"",@"",@"video_select_black"];
    float inset = SCREEN_WIDTH*(16/375.f);
    float space = SCREEN_WIDTH*(72/375.f);
    float itemSize = 0;
    float top_bottom = SCREEN_WIDTH*(12/375.f);
    
    for (int i=0; i<titleArr.count; i++) {
        
        float originX = inset+i*(space+itemSize);
        if (i == 0 || i == titleArr.count - 1) {
             itemSize = SCREEN_WIDTH*(25/375.f);
        }else{
            itemSize = SCREEN_WIDTH*(36/375.f);
        }
        UIButton *btn = [JYPointSideButton new];
        btn.tag = 100 + i;
        [self addSubview:btn];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState: UIControlStateNormal];
        [btn setTitle:titleArr[i] forState: UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top_bottom);
            make.left.mas_equalTo(originX);
            make.width.mas_equalTo(itemSize);
            make.height.mas_equalTo(25);
        }];
        if (i==1) {
            btnTemp = btn;
        }
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    //滑块
    UIView *sliederView = [UIView new];
    [self addSubview:sliederView];
    sliederView.layer.backgroundColor = [UIColor colorWithRed:242/255.0 green:43/255.0 blue:60/255.0 alpha:1.0].CGColor;
    sliederView.layer.cornerRadius = 2.8;
    [sliederView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnTemp.mas_bottom);
        make.left.mas_equalTo(btnTemp.mas_left);
        make.width.mas_equalTo(btnTemp.mas_width);
        make.height.mas_equalTo(4);
    }];
    self.sliederView = sliederView;
    //分割线
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor blackColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(sliederView.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(0.5);
    }];
    //滤镜
    [self.filterCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    //美颜滑杆
    [self.beautySliederView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    self.beautySliederView.hidden = YES;
    
}
- (void)buttonClicked:(UIButton *)button
{
    if (button.tag == JYEditImageFilterAndBeautyBottomViewAction_filter) {
        self.beautySliederView.hidden = YES;
        self.filterCollectionView.hidden = NO;
        [self moveSlicerWithButton:button];
    }else if (button.tag == JYEditImageFilterAndBeautyBottomViewAction_beauty){
        self.beautySliederView.hidden = NO;
        self.filterCollectionView.hidden = YES;
        [self moveSlicerWithButton:button];
    }else{
        [self showBottomBar:NO super:self.superview];
    }
}
- (void)showBottomBar:(BOOL)show super:(UIView *)super
{
    self.hidden = NO;
    if (show) {
        CGRect frame = self.frame;
        frame.origin.y = SCREEN_HEIGHT-frame.size.height;
        [UIView animateWithDuration:0.15 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {}];
    }else{
        CGRect frame = self.frame;
        frame.origin.y = SCREEN_HEIGHT;
        [UIView animateWithDuration:0.15 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {}];
    }
    
}
- (void)moveSlicerWithButton:(UIButton *)button
{
    //移动滑块
    [UIView animateWithDuration:0.15 animations:^{
        [self.sliederView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(button.mas_bottom);
            make.left.mas_equalTo(button.mas_left);
            make.width.mas_equalTo(button.mas_width);
            make.height.mas_equalTo(4);
        }];
    } completion:^(BOOL finished) {
        
    }];
}
- (JYCustomCollectionView *)filterCollectionView
{
    if (!_filterCollectionView) {
        kWeakSelf
        _filterCollectionView = [JYCustomCollectionView new];
        _filterCollectionView.backgroundColor = [UIColor whiteColor];
        [weakSelf addSubview:_filterCollectionView];
        [_filterCollectionView setupWithStyle:JYVideoPasterViewStyle_filter dataSource:self.filterModelArray];
        _filterCollectionView.textColor = [UIColor blackColor];
    }
    return _filterCollectionView;
}
- (JYVideoRecordSliderView *)beautySliederView
{
    if (!_beautySliederView) {
        _beautySliederView = [JYVideoRecordSliderView new];
        [self addSubview:_beautySliederView];
        [_beautySliederView setTextColor:[UIColor blackColor]];
    }
    return _beautySliederView;
}
@end
