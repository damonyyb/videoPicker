//
//  JYVideoEditCostuomBottomBarContainer.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/27.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYVideoEditCostuomBottomBarContainer.h"

@interface JYVideoEditCostuomBottomBarContainer ()<JYVideSliderDelegate>
@property (nonatomic, strong) UIView *line;

@end
@implementation JYVideoEditCostuomBottomBarContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    //左边按钮
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(12);
    }];
    //右变按钮
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.leftButton);
    }];
    //标题
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftButton.mas_right).mas_offset(20);
        make.right.mas_equalTo(self.rightButton.mas_left).mas_offset(-20);
        make.centerY.mas_equalTo(self.leftButton);
    }];
    
    //横线
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftButton.mas_bottom).mas_offset(12);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}
#pragma mark -- action

- (void)leftButtonClicked
{
    [self showBottomBar:NO super:self];
}
- (void)rightButtonClicked
{
    self.rightButtonBlock();
}
#pragma mark -- slider delegate



#pragma mark -- lazy load
- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self addSubview:_line];
        
    }
    return _line;
}
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.text = @"分割片段";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (JYPointSideButton*)leftButton
{
    if (!_leftButton) {
        _leftButton = [JYPointSideButton new];
        [self addSubview:_leftButton];
        [_leftButton setImage:[UIImage imageNamed:@"video_close_black"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftButton;
}
- (JYPointSideButton*)rightButton
{
    if (!_rightButton) {
        _rightButton = [JYPointSideButton new];
        [self addSubview:_rightButton];
        [_rightButton setImage:[UIImage imageNamed:@"video_select_black"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton.layer setCornerRadius:15];
    }
    
    return _rightButton;
}

- (JYVideoSlider *)slider
{
    if (!_slider) {
        _slider = [[JYVideoSlider alloc] initWithFrame:CGRectMake(0, 52 * 0.63, SCREEN_WIDTH, 52)];
        _slider.delegate = self;
        //视频拖动裁剪
        [self addSubview:_slider];
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.line.mas_bottom).mas_offset(32);
            make.bottom.mas_equalTo(-37);
            make.width.left.right.mas_equalTo(0);
            make.height.mas_equalTo(52);
        }];
    }
    return _slider;
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
@end
