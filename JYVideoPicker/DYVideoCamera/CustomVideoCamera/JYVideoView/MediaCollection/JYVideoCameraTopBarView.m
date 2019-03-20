//
//  JYVideoCameraTopBarView.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/11.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoCameraTopBarView.h"
#import "Masonry.h"
#define buttonTag 100
@interface JYVideoCameraTopBarView()
@property (nonatomic, strong) UIView *containView;

@end
@implementation JYVideoCameraTopBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews
{
    //顶部5按钮按钮
    UIButton *btn = nil;
    UIButton *temp = nil;
    int t = 0;
    for (int i=0; i<4; i++) {
        btn = [self createButtonWithImage:self.imageArray[i] title:@""];
        temp = btn;
        btn.tag = i+buttonTag;
        [self addSubview:btn];
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(17);
                make.left.mas_equalTo(17);
            }];
        }else if (i == 3){
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(17);
                make.right.mas_equalTo(-17);
            }];
        }else{
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(17);
                make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-22-33+(22+33)*(i-1));
            }];
        }
        t = i;
    }
    //闪光灯、倒计时、网格
    _containView = [UIView new];
    [self addSubview:_containView];
    _containView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.4f].CGColor;
    _containView.hidden = YES;
    _containView.layer.masksToBounds = YES;
    _containView.layer.cornerRadius = 8;
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(59);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
    }];

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //按钮
    for (int i=t+1; i<self.titleArray.count; i++) {
        btn = [self createButtonWithImage:self.imageArray[i] title:self.titleArray[i]];
        temp = btn;
        btn.tag = i+buttonTag;
        [_containView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(17);
            make.centerX.mas_equalTo(-2*screenWidth/6+(2*screenWidth/6)*(i-t-1));
            make.bottom.mas_equalTo(-17);
        }];
    }
}

- (void)updateUIWithVideoRcordState:(JYVideoRecordState)state
{
    if (state == JYVideoRecordState_recording) {
        
    }else if (state == JYVideoRecordState_pauseRecord){
        UIButton *btn = [self viewWithTag:buttonTag+1];
        btn.hidden = YES;
        btn = [self viewWithTag:buttonTag+3];
        btn.hidden = YES;
    }else if (state == JYVideoRecordState_finishRecord){
        UIButton *btn = [self viewWithTag:buttonTag+1];
        btn.hidden = NO;
        btn = [self viewWithTag:buttonTag+3];
        btn.hidden = NO;
    }
}
- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == JYVideoCameraTopBarViewAction_more) {
        self.containView.hidden = btn.isSelected;
        btn.selected = !btn.isSelected;
    }else{
        self.topbarActon(btn);
    }
}
- (UIButton *)createButtonWithImage:(NSString *)imageName title:(NSString *)title
{
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"返回",@"尺寸",@"分段",@"更多",@"闪光灯",@"倒计时",@"网格"];
    }
    return _titleArray;
}
-(NSArray *)imageArray
{
    return @[@"back",@"scale",@"exchange",@"more",@"light",@"timer",@"more"];
}
- (void)isChangeImageToWhiteColor:(BOOL)isWihteColor
{
    if (isWihteColor) {
        NSArray *blackImageArray = @[@"back_black",@"scale_black",@"exchange_black",@"more_black"];
        for (int i=0; i<blackImageArray.count; i++) {
            UIButton *btn = [self viewWithTag:buttonTag+i];
            [btn setImage:[UIImage imageNamed:blackImageArray[i]] forState:UIControlStateNormal];
            if (i == 1) {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }else{
        for (int i=0; i<4; i++) {
            UIButton *btn = [self viewWithTag:buttonTag+i];
            [btn setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
            if (i == 1) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
}
@end
