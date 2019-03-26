//
//  JYPhotoCropBottomView.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/25.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYPhotoCropBottomView.h"

#import "UIButton+JYCustomLayout.h"

@interface JYPhotoCropBottomView ()

///提示
@property (nonatomic, strong) UILabel *tipsLab;
///旋转按钮
@property (nonatomic, strong) UIButton *rotateBtn;

@end

@implementation JYPhotoCropBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //提示
        [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        //地图原图选择器
        [self.imageCollcetionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipsLab.mas_bottom).mas_offset(26);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-30);
            make.right.mas_equalTo(-40);
        }];
        
        //右边蒙层
        float width = SCREEN_WIDTH*85/375.f;
        UIView *coverView = [UIView new];
        [self addSubview:coverView];
        [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tipsLab.mas_bottom);
            make.bottom.right.mas_equalTo(0);
            make.width.mas_equalTo(width);
        }];
        [coverView layoutIfNeeded];
        
        // gradient
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = coverView.bounds;
        gl.startPoint = CGPointMake(0.03, 0.5);
        gl.endPoint = CGPointMake(0.16, 0.5);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0), @(1.0f)];
        [coverView.layer addSublayer:gl];
        //旋转按钮
        [self.rotateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.imageCollcetionView);
            make.right.mas_equalTo(-17);
            make.height.mas_equalTo(self.imageCollcetionView);
        }];
        [self.rotateBtn layoutButtonWithButtonLaoutStyle:JYButtonLaoutStyle_Top space:8];
    }
    return self;
}
#pragma mark -- action
- (void)rotateButtonClicked:(UIButton *)button
{
    self.RotateBlock();
}

#pragma mark -- setter

- (void)setDataSource:(NSArray <HXPhotoModel*>*)dataSource
{
    _dataSource = dataSource;
    NSMutableArray *array = [NSMutableArray new];
    for (HXPhotoModel *model in dataSource) {
        [array addObject:model.thumbPhoto];
    }
    self.imageCollcetionView.dataSource = array;
}
#pragma mark -- lazy load

-(UILabel *)tipsLab
{
    if (!_tipsLab) {
        _tipsLab = [UILabel new];
        [self addSubview:_tipsLab];
        _tipsLab.backgroundColor = [UIColor colorWithHexString:@"#FFE5E5"];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"超出宽高限制 请裁剪图片"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        _tipsLab.attributedText = string;
        _tipsLab.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLab;
}
- (JYImageCollectionView *)imageCollcetionView
{
    if (!_imageCollcetionView) {
        _imageCollcetionView = [JYImageCollectionView new];
        [self addSubview:_imageCollcetionView];
    }
    return _imageCollcetionView;
}

- (UIButton *)rotateBtn
{
    if (!_rotateBtn) {
        _rotateBtn = [UIButton new];
        [_rotateBtn setImage:[UIImage imageNamed:@"video_rotate"] forState:UIControlStateNormal];
        [_rotateBtn setTitle:@"旋转" forState:UIControlStateNormal];
        [_rotateBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_rotateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rotateBtn setBackgroundColor:[UIColor whiteColor]];
        [_rotateBtn addTarget:self action:@selector(rotateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rotateBtn];
        
    }
    return _rotateBtn;
}
@end

