//
//  JYVideoRecordSliderView.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/12.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoRecordSliderView.h"
#import "Masonry.h"
@interface JYVideoRecordSliderView()
@property (nonatomic, strong) UISlider *sbuffingSlider;
@property (nonatomic, strong) UISlider *skinWhiteningSlider;
@property (nonatomic, strong) UILabel *sbuffingLab;
@property (nonatomic, strong) UILabel *skinWhiteningLab;

@end

@implementation JYVideoRecordSliderView

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
    
    //磨皮label
    UILabel *sbuffingLab = [UILabel new];
    [self addSubview:sbuffingLab];
    sbuffingLab.text = @"磨皮";
    sbuffingLab.textColor = [UIColor whiteColor];
    sbuffingLab.font = [UIFont systemFontOfSize:16];
    [sbuffingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
    }];
    self.sbuffingLab = sbuffingLab;
    //磨皮slider
    _sbuffingSlider = [UISlider new];
    [self addSubview:_sbuffingSlider];
    [_sbuffingSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sbuffingLab.mas_centerY);
        make.left.mas_equalTo(sbuffingLab.mas_right).mas_offset(20);
        make.right.mas_equalTo(-20);
    }];
    [_sbuffingSlider addTarget:self action:@selector(updateSbuffingValue) forControlEvents:UIControlEventValueChanged];
    //美白label
    UILabel *skinWhiteningLab = [UILabel new];
    [self addSubview:skinWhiteningLab];
    skinWhiteningLab.text = @"美白";
    skinWhiteningLab.textColor = [UIColor whiteColor];
    skinWhiteningLab.font = [UIFont systemFontOfSize:16];
    [skinWhiteningLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sbuffingLab.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(sbuffingLab.mas_left);
        make.bottom.mas_equalTo(-10);
    }];
    self.skinWhiteningLab = skinWhiteningLab;
    //美白slider
    UISlider *skinWhiteningSlider = [UISlider new];
    [self addSubview:skinWhiteningSlider];
    [skinWhiteningSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(skinWhiteningLab.mas_centerY);
        make.left.mas_equalTo(skinWhiteningLab.mas_right).mas_offset(20);
        make.right.mas_equalTo(self.sbuffingSlider.mas_right);
    }];
    [skinWhiteningSlider addTarget:self action:@selector(updateSkinWhiteningValue) forControlEvents:UIControlEventValueChanged];
    self.skinWhiteningSlider = skinWhiteningSlider;
    _sbuffingSlider.value = skinWhiteningSlider.value = 0.5;
    
    _sbuffingSlider.tintColor = skinWhiteningSlider.tintColor = [UIColor redColor];
}
- (void)setTextColor:(UIColor*)color
{
    self.sbuffingLab.textColor = self.skinWhiteningLab.textColor = color;
}
#pragma mark -- 更新磨皮效果

- (void)updateSbuffingValue
{
    self.updateSbuffingValueBlock(self.sbuffingSlider.value-0.3);
    self.beautySliderValue = self.sbuffingSlider.value;
}
- (void)updateSbuffingValueWithValue:(float)value
{
    self.sbuffingSlider.value = value;
    [self updateSbuffingValue];
}
#pragma mark -- 更新美白效果
- (void)updateSkinWhiteningValue
{
    self.updateSkinWhiteningValueBlock(self.skinWhiteningSlider.value-0.3);
}
- (void)updateSkinWhiteningValueWithValue:(float)value
{
    self.skinWhiteningSlider.value = value;
    [self updateSkinWhiteningValue];
}
@end
