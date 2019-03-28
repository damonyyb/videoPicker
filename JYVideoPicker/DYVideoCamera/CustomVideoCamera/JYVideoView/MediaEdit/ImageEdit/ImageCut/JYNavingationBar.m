//
//  JYNavingationBar.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/20.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYNavingationBar.h"
#import "Masonry.h"
#import "UIColor+JYHex.h"

@interface JYNavingationBar ()


@end

@implementation JYNavingationBar

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
    //左边按钮
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    //右变按钮
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
    }];
    //标题
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backButton.mas_right).mas_offset(20);
        make.right.mas_equalTo(self.rightButton.mas_left).mas_offset(-20);
        make.centerY.mas_equalTo(0);
    }];
    
}
- (void)setWithStyle
{
    [self.backButton setImage:[UIImage imageNamed:@"video_back_white"] forState:UIControlStateNormal];
    self.titleLab.textColor = [UIColor whiteColor];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
#pragma mark -- 设置title
- (void)setTitle:(NSString *)title
{
    self.titleLab.text = title;
}

- (void)backButtonClicked
{
    self.backButtonBlock();
}
- (void)rightButtonClicked
{
    self.rightButtonBlock();
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = @"裁剪照片";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (JYPointSideButton*)backButton
{
    if (!_backButton) {
        _backButton = [JYPointSideButton new];
        [self addSubview:_backButton];
        [_backButton setImage:[UIImage imageNamed:@"backPhoto"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}
- (JYPointSideButton*)rightButton
{
    if (!_rightButton) {
        _rightButton = [JYPointSideButton new];
        [self addSubview:_rightButton];
        [_rightButton setTitle:@"下一张" forState:UIControlStateNormal];
        [_rightButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_rightButton setBackgroundColor:[UIColor colorWithHexString:@"#F22B3C"]];
        [_rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton.layer setCornerRadius:15];
    }
    
    return _rightButton;
}
@end
