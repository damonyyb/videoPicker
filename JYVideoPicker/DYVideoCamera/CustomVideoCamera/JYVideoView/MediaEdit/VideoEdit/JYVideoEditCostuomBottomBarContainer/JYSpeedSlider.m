//
//  JYSpeedSlider.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/28.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYSpeedSlider.h"
#import "UIButton+JYCustomLayout.h"
@interface JYSpeedSlider ()<UIScrollViewDelegate>
@property (nonatomic, strong) JYPointSideButton *backRunButton;
@property (nonatomic, strong) UIScrollView *scrollView;

@end
@implementation JYSpeedSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews{
    
    //时间
    _timeLabel = [UILabel new];;
    [self addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.text = @"调整后 时长 00:06";
    _timeLabel.textColor = [UIColor blackColor];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(17);
    }];
    
    //倒放按钮
    [self.backRunButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.timeLabel);
    }];
    [self.backRunButton layoutButtonWithButtonLaoutStyle:JYButtonLaoutStyle_Right space:15];
    //刻度值
    NSArray *timeArray = @[@"1/4x",@"1/2x",@"1x",@"2x",@"3x"];
    float startPoint = 77*SCREEN_WIDTH/375;
    float endPoint = SCREEN_WIDTH-startPoint;
    float width = endPoint-startPoint;
    float space = width/4;
    UILabel *tempLabel;
    for (int i=0; i<timeArray.count; i++) {
        float originx = -2*space + i * space;
        
        UILabel *timeScaleLabel = [UILabel new];
        timeScaleLabel.font = [UIFont systemFontOfSize:10];
        timeScaleLabel.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
        timeScaleLabel.text = timeArray[i];
        [self addSubview:timeScaleLabel];
        [timeScaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(17);
            make.centerX.mas_equalTo(originx);
        }];
        tempLabel = timeScaleLabel;
    }
    //scrollView
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempLabel.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(startPoint);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(30);
    }];
    
    self.scrollView.contentSize = CGSizeMake(width*2, 30);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.scrollView.contentOffset = CGPointMake(-width/2.0, 0);
        [self.scrollView setContentOffset:CGPointMake(width/2.0, 0) animated:YES];
    });;
    float scaleSpace = width/20.f;
    float lowHeight = 10;
    float midHeight = 17;
    float height = 30;
    
    //添加刻度
    for (int i=0; i<21; i++) {
        float originx = i * scaleSpace;
        float heighTemp = lowHeight;
        float lineWidth = 1.0;
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self.scrollView addSubview:lineView];
        if (i == 0 || i == 5 || i == 15 || i == 20) {
            heighTemp = midHeight;
            lineView.backgroundColor = [UIColor colorWithHexString:@"#4A4A4A"];
        }else if (i == 10){
            lineWidth = 2.0;
            heighTemp = height;
            lineView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        }
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(heighTemp);
            make.centerY.mas_equalTo(0);
            make.centerX.mas_equalTo(originx);
        }];
    }
}
#pragma mark -- action

- (void)rightButtonClicked:(UIButton *)button
{
    button.selected = !button.isSelected;
    self.isRunback = button.isSelected;
}
#pragma mark -- scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self calculateRateWithScrollView:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self calculateRateWithScrollView:scrollView];
}
- (void)calculateRateWithScrollView:(UIScrollView *)scrollView
{
    NSLog(@"%lf",scrollView.contentOffset.x);
    
    CGFloat width = scrollView.frame.size.width;
    //每个大刻度的宽度
    CGFloat unitLength = width/4.f;
    //滚动距离
    CGFloat scrollLenth = scrollView.contentOffset.x - unitLength*2.0;
    
    if (scrollLenth < 0) {
        scrollLenth = -scrollLenth;
        if (scrollLenth > unitLength+unitLength/2.f) {
            self.rate = 1/4.f;
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (scrollLenth <= unitLength+unitLength/2.f && scrollLenth > unitLength/2.f){
            self.rate = 1/2.f;
            [self.scrollView setContentOffset:CGPointMake(unitLength, 0) animated:YES];
        }
        else{
            self.rate = 1.0;
            [self.scrollView setContentOffset:CGPointMake(unitLength*2, 0) animated:YES];
        }
    }else{
        if (scrollLenth <= unitLength/2.f) {
            self.rate = 1.0;
            [self.scrollView setContentOffset:CGPointMake(unitLength*2, 0) animated:YES];
        }if (scrollLenth > unitLength/2.f && scrollLenth <= unitLength + unitLength/2.f ) {
            self.rate = 2.0;
            [self.scrollView setContentOffset:CGPointMake(unitLength*3, 0) animated:YES];
        }else{
            self.rate = 4.0;
            [self.scrollView setContentOffset:CGPointMake(unitLength*4, 0) animated:YES];
        }
    }
}
- (JYPointSideButton*)backRunButton
{
    if (!_backRunButton) {
        _backRunButton = [JYPointSideButton new];
        [self addSubview:_backRunButton];
        [_backRunButton setTitle:@"倒放" forState:UIControlStateNormal];
        [_backRunButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backRunButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [_backRunButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [_backRunButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_backRunButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backRunButton;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self addSubview:_scrollView];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
@end
