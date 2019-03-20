//
//  JYVideoSubsectionView.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/14.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoSubsectionView.h"
#import "Masonry.h"

#define plus 1000
#define subtract 10001
#define totalSecond 2000
#define isSelectedBtnTag 3000

@interface JYVideoSubsectionView()
///蒙层
@property (nonatomic, strong) UIVisualEffectView *visualView;
///标题
@property (nonatomic, strong) UILabel *titleLab;
///分段选择
@property (nonatomic, strong) UIView *containView;
///分段标题
@property (nonatomic, strong) UILabel *subsectionLab;
///数量
@property (nonatomic, strong) UILabel *numberLab;
///是否第一次选择分段按钮
@property (nonatomic, assign) BOOL isFirstTimeSelected;
///分段按钮
@property (nonatomic, strong) UIButton *subsectonBtn;
///不分段按钮
@property (nonatomic, strong) UIButton *unSubsectonBtn;


@end

@implementation JYVideoSubsectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFirstTimeSelected = YES;
        [self addCoverView];
        [self addTitleLab];
        [self addTakephotoView];
        [self addSubtionView];
        [self addTimeSelectView];
    }
    return self;
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
#pragma mark -- 添加标题

- (void)addTitleLab{
    //标题
    self.titleLab = [UILabel new];
    [self addSubview:self.titleLab];
    self.titleLab.text = @"分段";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = [UIColor whiteColor];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    //分割线
    UIView *lineView = [UIView new];
    [self.titleLab addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.2f];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}
#pragma mark -- 添加正常/分段拍摄视图
- (void)addTakephotoView
{
    NSArray *titleArray = @[@"正常拍摄",@"分段拍摄"];
    NSArray *detailArray = @[@"不分段最多拍摄60秒",@"设置每段的时长"];
    NSArray *imgArray = @[@"unselected",@"selected"];
    for (int i=0; i<2; i++) {
        float height = 41;
        float originY = 45 + height * i;
        UIView *containView = [UIView new];
        self.containView = containView;
        [self addSubview:containView];
        [containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(originY);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(41);
        }];
        //标题
        UILabel *titleLab = [UILabel new];
        [containView addSubview:titleLab];
        titleLab.text = titleArray[i];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = [UIColor whiteColor];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(-10);
        }];
        //描述
        UILabel *detailLab = [UILabel new];
        [containView addSubview:detailLab];
        detailLab.text = detailArray[i];
        detailLab.font = [UIFont systemFontOfSize:12];
        detailLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLab.mas_centerY);
            make.left.mas_equalTo(titleLab.mas_right).mas_offset(20);
        }];
        //按钮
        UIButton *selectBtn = [UIButton new];
        [containView addSubview:selectBtn];
        selectBtn.tag = isSelectedBtnTag + i;
        [selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLab.mas_centerY);
            make.right.mas_equalTo(-20);
            make.width.height.mas_equalTo(15);
        }];
        [selectBtn setImage:[UIImage imageNamed:imgArray[0]] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:imgArray[1]] forState:UIControlStateSelected];
        if (i == 0) {
            selectBtn.selected = YES;
            self.unSubsectonBtn = selectBtn;
        }else{
            self.subsectonBtn = selectBtn;
        }
    }
}
#pragma mark -- 添加分段栏

- (void)addSubtionView
{
    //标题
    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    titleLab.text = @"分段";
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = [UIColor whiteColor];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(20);
    }];
    self.subsectionLab = titleLab;
    //+按钮
    UIButton *plustBtn = [UIButton new];
    [self addSubview:plustBtn];
    plustBtn.layer.backgroundColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0].CGColor;
    plustBtn.layer.cornerRadius = 2;
    [plustBtn setTitle:@"+" forState:UIControlStateNormal];
    plustBtn.tag = plus;
    [plustBtn addTarget:self action:@selector(subsectionNumberBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [plustBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLab.mas_centerY);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(24);
    }];
    //数量
    UILabel *numberLab = [UILabel new];
    [self addSubview:numberLab];
    numberLab.text = @"1";
    numberLab.textAlignment = NSTextAlignmentCenter;
    numberLab.font = [UIFont systemFontOfSize:15];
    numberLab.textColor = [UIColor whiteColor];
    [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLab.mas_centerY);
        make.right.mas_equalTo(plustBtn.mas_left);
        make.width.mas_equalTo(100);
    }];
    self.numberLab = numberLab;
    //-按钮
    UIButton *subtractBtn = [UIButton new];
    [self addSubview:subtractBtn];
    [subtractBtn setTitle:@"-" forState:UIControlStateNormal];
    subtractBtn.layer.backgroundColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1.0].CGColor;
    subtractBtn.layer.cornerRadius = 2;
    subtractBtn.tag = subtract;
    [subtractBtn addTarget:self action:@selector(subsectionNumberBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [subtractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLab.mas_centerY);
        make.right.mas_equalTo(numberLab.mas_left);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(24);
    }];
}
#pragma mark -- 添加时长选择栏

- (void)addTimeSelectView
{
    //标题
    UILabel *titleLab = [UILabel new];
    [self addSubview:titleLab];
    titleLab.text = @"总时长";
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = [UIColor whiteColor];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subsectionLab.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
    }];
    //时长按钮
    NSArray *titleArray = @[@"60秒",@"35秒",@"15秒",@"10秒"];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *selectBtn = [UIButton new];
        [self addSubview:selectBtn];
        selectBtn.tag = totalSecond + i;
        NSLog(@"%ld",selectBtn.tag);
        [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [selectBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [selectBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(totalTimeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        float width = 60;
        float rightSpace = - width*i;
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLab.mas_centerY);
            make.right.mas_equalTo(rightSpace);
            make.width.mas_equalTo(width);
        }];
    }
}
- (void)resetConfig
{
    
}
//是否分段
- (void)selectBtnClicked:(UIButton *)button
{
    button.selected = YES;
    self.config.isSubsection = button.tag-isSelectedBtnTag;
    //设置另一个按钮为非选中状态
    if (self.config.isSubsection) {
        self.unSubsectonBtn.selected = NO;
    }else{
        self.subsectonBtn.selected = NO;
    }
    //第一次设置为默认
    if (self.isFirstTimeSelected) {
        UIButton *buttonTemp = (UIButton *)[self viewWithTag:totalSecond+3];
        buttonTemp.selected = YES;
        self.numberLab.text = @"2";
        self.isFirstTimeSelected = NO;
    }
    //回调
    self.configChangeBlock(self.config);
    
}
//分段数量
- (void)subsectionNumberBtnClicked:(UIButton *)button
{
    //如果不选择分段，不能进行操作
    if (!self.config.isSubsection) {
        return;
    }
    NSInteger numbner = [self.numberLab.text integerValue];
    if (button.tag == subtract) {
        numbner--;
    }else{
        numbner++;
    }
    //最多6段，最少1段
    if (numbner<1 || numbner >6) {
        return;
    }
    self.numberLab.text = [NSString stringWithFormat:@"%ld",(long)numbner];
    self.config.totlalSubsection = [self.numberLab.text integerValue];
    self.configChangeBlock(self.config);
}
//总时长
- (void)totalTimeBtnClicked:(UIButton *)button
{
    //如果不选择分段，不能进行操作
    if (!self.config.isSubsection) {
        return;
    }
    self.config.totlalSeconds = [[button.titleLabel.text stringByReplacingOccurrencesOfString:@"秒" withString:@""] integerValue];
    self.configChangeBlock(self.config);
    for (int i=0; i<4; i++) {
        UIButton *buttonTemp = (UIButton *)[self viewWithTag:i+totalSecond];
        if (buttonTemp.tag == button.tag) {
            NSLog(@"%ld,%ld",buttonTemp.tag,button.tag);
            buttonTemp.selected = YES;
        }else{
            buttonTemp.selected = NO;
        }
    }
    
}
-(JYVideoConfigModel *)config
{
    if (!_config) {
        _config = [JYVideoConfigModel new];
        _config.totlalSeconds = 10;
        _config.totlalSubsection = 2;
        _config.isSubsection = NO;
    }
    return _config;
}
-(UIVisualEffectView *)visualView
{
    if (!_visualView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    }
    return _visualView;
}
@end
