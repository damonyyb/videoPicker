//
//  JYBottomBeautySliderView.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/19.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYBottomBeautySliderView.h"
#import "Masonry.h"
#import "UIColor+JYHex.h"

@interface JYBottomBeautySliderView ()
///标题
@property (nonatomic, strong) UILabel *titleLab;


@end
@implementation JYBottomBeautySliderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加标题栏
        [self addTitleLab];
    }
    return self;
}
- (void)addTitleLab{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLab = [UILabel new];
    [self addSubview:self.titleLab];
    self.titleLab.text = @"美化";
    self.titleLab.font = [UIFont systemFontOfSize:18];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = [UIColor blackColor];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    UIView *lineView = [UIView new];
    [self.titleLab addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.sliederView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-60);
        make.top.mas_equalTo(lineView.mas_bottom);
        make.bottom.mas_equalTo(-25);
    }];
}
- (JYVideoRecordSliderView *)sliederView
{
    if (!_sliederView) {
        _sliederView = [JYVideoRecordSliderView new];
        [self addSubview:_sliederView];
        [_sliederView setTextColor:[UIColor blackColor]];
    }
    return _sliederView;
}
@end
