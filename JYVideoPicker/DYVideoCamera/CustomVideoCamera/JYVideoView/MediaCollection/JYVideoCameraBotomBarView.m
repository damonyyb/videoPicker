//
//  JYVideoCameraBotomBarView.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/11.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoCameraBotomBarView.h"
#import "UIColor+JYHex.h"
#import "Masonry.h"
@interface JYVideoCameraBotomBarView()
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
///蒙层
@property (nonatomic, strong) UIVisualEffectView *visualView;
///滑块
@property (nonatomic, strong) UIView *sliederView;
///白色背景
@property (nonatomic, strong) UIView *whiteBgView;


@end
@implementation JYVideoCameraBotomBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
#pragma mark -- 初始化

- (void)setupSubviews
{
    self.currentActon = JYVideoCameraBotomBarViewAction_video;
    //添加蒙层
    [self addCoverView];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //录制
    _recordBtn = [self createButtonWithImage:@"" title:@""];
    [self addSubview:_recordBtn];
    _recordBtn.tag = JYVideoCameraBotomBarViewAction_record;
    _recordBtn.backgroundColor = [UIColor colorWithHexString:@"#F22B3C"];
    _recordBtn.layer.masksToBounds = YES;
    _recordBtn.layer.cornerRadius = 31;
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(62);
    }];
    //取消/美化
    _cancelBtn = [self createButtonWithImage:@"beauty" title:@""];
    [self addSubview:_cancelBtn];
    _cancelBtn.tag = JYVideoCameraBotomBarViewAction_beauty;
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(-2*screenWidth/6);
        make.centerY.mas_equalTo(_recordBtn.mas_centerY);
        
    }];
    //删除/分段/拍照美化
    _delBtn = [self createButtonWithImage:@"subsection" title:@""];
    [self addSubview:_delBtn];
    _delBtn.tag = JYVideoCameraBotomBarViewAction_subsection;
    [_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(screenWidth*2/7);
        make.centerY.mas_equalTo(_recordBtn.mas_centerY);
    }];
    //添加底部按钮
    [self addBottomButtons];
    
    
}
#pragma mark -- 添加底部按钮

- (void)addBottomButtons{
    UIButton *btnTemp = nil;
    float buttonWidth = 30;
    //功能按钮
    NSArray *titleArray = @[@"相册",@"摄像",@"拍照"];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *selectBtn = [UIButton new];
        [self addSubview:selectBtn];
        selectBtn.tag = JYVideoCameraBotomBarViewAction_album + i;
        [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [selectBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        float width = 35;
        float centerX = -85+i*85;
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(centerX);
            make.top.mas_equalTo(self.recordBtn.mas_bottom).mas_offset(27);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(buttonWidth);
        }];
        if (i==1) {
            btnTemp = selectBtn;
        }
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
        make.bottom.mas_equalTo(-20);
    }];
    self.sliederView = sliederView;
}
#pragma mark -- 点击 "相册","摄像","拍照"

- (void)buttonClicked:(UIButton *)button
{
    if (self.currentActon == button.tag) {
        return;
    }
    //移动滑块
    [UIView animateWithDuration:0.15 animations:^{
//        self.sliederView.frame = CGRectMake(274, self.sliederView.frame.origin.y, self.sliederView.frame.size.width, self.sliederView.frame.size.height);
    [self.sliederView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom);
        make.left.mas_equalTo(button.mas_left);
        make.width.mas_equalTo(button.mas_width);
        make.height.mas_equalTo(4);
        make.bottom.mas_equalTo(-20);
    }];
    } completion:^(BOOL finished) {

    }];
    //回调
    self.bottomBarAction(button);
    self.currentActon = button.tag;
    if (button.tag == JYVideoCameraBotomBarViewAction_album) {//相册
        [self exchangeToAlbum];
    }else if (button.tag == JYVideoCameraBotomBarViewAction_video){//视频
        [self exchangeToVideoState];
    }else if (button.tag == JYVideoCameraBotomBarViewAction_takePhoto){//拍照
        [self exchangToTakePhotoState];
        
    }
    
}
#pragma mark -- 切换到拍照模式
- (void)exchangToTakePhotoState
{
    self.delBtn.tag = JYVideoCameraBotomBarViewAction_photoBeauty;
    self.visualView.contentView.backgroundColor = [UIColor whiteColor];
    for (int i = JYVideoCameraBotomBarViewAction_album; i<JYVideoCameraBotomBarViewAction_album+3; i++) {
        UIButton *btn = [self viewWithTag:i];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
    }
    //展示白色背景
    [UIView animateWithDuration:0.35 animations:^{
        self.whiteBgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
    //切换按钮图片
    [_cancelBtn setTitle:@"" forState:UIControlStateNormal];
    [_delBtn setTitle:@"" forState:UIControlStateNormal];
    [_cancelBtn setImage:[UIImage imageNamed:@"photoFilter"] forState:UIControlStateNormal];
    [_delBtn setImage:[UIImage imageNamed:@"photoBeauty"] forState:UIControlStateNormal];
    //拍照按钮处理
    self.recordBtn.backgroundColor = [UIColor whiteColor];
    self.recordBtn.layer.borderColor = [UIColor colorWithHexString:@"#F22B3C"].CGColor;
    self.recordBtn.layer.borderWidth = 3;
    
    
}
#pragma mark -- 切换到视频模式

- (void)exchangeToVideoState
{
    self.delBtn.tag = JYVideoCameraBotomBarViewAction_subsection;
    self.visualView.contentView.backgroundColor = [UIColor clearColor];
    for (int i = JYVideoCameraBotomBarViewAction_album; i<JYVideoCameraBotomBarViewAction_album+3; i++) {
        UIButton *btn = [self viewWithTag:i];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    //隐藏白色背景
    [UIView animateWithDuration:0.35 animations:^{
        self.whiteBgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    //切换按钮图片
    [_cancelBtn setTitle:@"" forState:UIControlStateNormal];
    [_delBtn setTitle:@"" forState:UIControlStateNormal];
    [_cancelBtn setImage:[UIImage imageNamed:@"beauty"] forState:UIControlStateNormal];
    [_delBtn setImage:[UIImage imageNamed:@"subsection"] forState:UIControlStateNormal];
    
    //拍照按钮处理
    self.recordBtn.backgroundColor = [UIColor colorWithHexString:@"#F22B3C"];

}
#pragma mark -- 切换到相册模式

- (void)exchangeToAlbum
{
    [UIView animateWithDuration:0.35 animations:^{
        self.whiteBgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
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
#pragma mark -- 移除蒙层
- (void)removeCoverView
{
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.visualView removeFromSuperview];
}
- (void)btnAction:(UIButton *)sender
{
    self.bottomBarAction(sender);
    switch (sender.tag) {
        case JYVideoCameraBotomBarViewAction_cancel://取消
        {
            [self setNormalState];
        }
            break;
        case JYVideoCameraBotomBarViewAction_record://录制/拍照
        {
            [self removeCoverView];
            self.isRecording =  sender.selected;
            [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [_cancelBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [_delBtn setTitle:@"回删" forState:UIControlStateNormal];
            [_delBtn setImage:[UIImage imageNamed:@"deleteVideo"] forState:UIControlStateNormal];
            self.cancelBtn.tag = JYVideoCameraBotomBarViewAction_cancel;
            self.delBtn.tag = JYVideoCameraBotomBarViewAction_delete;
            if (self.isRecording) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.recordBtn.layer.cornerRadius = 5;
                }];
                
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                   self.recordBtn.layer.cornerRadius = self.recordBtn.frame.size.height/2;
                }];
            }
            
        }
            break;
        case JYVideoCameraBotomBarViewAction_delete://删除
            
            break;
        case JYVideoCameraBotomBarViewAction_album://相册
            break;
        case JYVideoCameraBotomBarViewAction_subsection://分段
        {
            if (self.currentActon == JYVideoCameraBotomBarViewAction_takePhoto) {
            }
        }
            break;
        case JYVideoCameraBotomBarViewAction_photoBeauty://拍照美颜
        {
            if (self.currentActon == JYVideoCameraBotomBarViewAction_takePhoto) {
            }
        }
            break;
    }
}
- (void)resetToVideo{
    self.currentActon = JYVideoCameraBotomBarViewAction_video;
    UIButton *button = [self viewWithTag:JYVideoCameraBotomBarViewAction_album + 1];
    [UIView animateWithDuration:0.15 animations:^{
        [self.sliederView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(button.mas_bottom);
            make.left.mas_equalTo(button.mas_left);
            make.width.mas_equalTo(button.mas_width);
            make.height.mas_equalTo(4);
            make.bottom.mas_equalTo(-20);
        }];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)setNormalState
{
    [self addCoverView];
    self.isRecording = NO;
    _cancelBtn.hidden = NO;
    [self.recordBtn setTitle:@"" forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"" forState:UIControlStateNormal];
    [_delBtn setTitle:@"" forState:UIControlStateNormal];
    [_cancelBtn setImage:[UIImage imageNamed:@"beauty"] forState:UIControlStateNormal];
    [_delBtn setImage:[UIImage imageNamed:@"subsection"] forState:UIControlStateNormal];
    self.cancelBtn.tag = JYVideoCameraBotomBarViewAction_beauty;
    self.delBtn.tag = JYVideoCameraBotomBarViewAction_subsection;
    self.recordBtn.layer.cornerRadius = self.recordBtn.frame.size.height/2;
}
- (void)hidecancelBtn:(BOOL)isHidden
{
    self.cancelBtn.hidden = isHidden;
}
#pragma mark -- 创建按钮

- (UIButton *)createButtonWithImage:(NSString *)imageName title:(NSString *)title
{
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)hideDeleteButton:(BOOL)isHidden
{
    self.delBtn.hidden = isHidden;
}
- (void)setRecordBtnEnable:(BOOL)enable
{
    self.recordBtn.enabled = enable;
    [self.recordBtn setTitle:@"" forState:UIControlStateNormal];
}
- (void)pauseRecord
{
    [self btnAction:self.recordBtn];
}
-(UIVisualEffectView *)visualView
{
    if (!_visualView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    }
    return _visualView;
}
-(UIView *)whiteBgView
{
    if (!_whiteBgView) {
        _whiteBgView = [UIView new];
        _whiteBgView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        _whiteBgView.backgroundColor = [UIColor whiteColor];
       [self addSubview:_whiteBgView];
       [self sendSubviewToBack:_whiteBgView];
       [self sendSubviewToBack:self.visualView];
    }
    return _whiteBgView;
}
- (void)updateRecordButtonTitle:(float)second
{
    [self.recordBtn setTitle:[NSString stringWithFormat:@"%.1fs",second] forState:UIControlStateNormal];
}
@end
