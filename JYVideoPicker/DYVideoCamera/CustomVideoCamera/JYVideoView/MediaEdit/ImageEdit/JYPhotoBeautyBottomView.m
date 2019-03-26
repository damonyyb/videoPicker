//
//  JYPhotoBeautyBottomView.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/21.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYPhotoBeautyBottomView.h"
#import "Masonry.h"
#import "UIColor+JYHex.h"
#import "UIButton+JYCustomLayout.h"

@implementation JYPhotoBeautyBottomView

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
    NSArray *titleArr = @[@"美化",@"贴纸",@"标签"];
     NSArray *imageArr = @[@"video_beauty_bottom",@"video_sticker_bottom",@"video_tag_bottom"];
    float inset = SCREEN_WIDTH*(38/375.f);
    float space = SCREEN_WIDTH*(30/375.f);
    float itemSize = SCREEN_WIDTH*(80/375.f);
    float bottom = SCREEN_WIDTH*(44/375.f);
    for (int i=0; i<3; i++) {
        UIView *itemView = [UIView new];
        [self addSubview:itemView];
        float originX = inset+i*(space+itemSize);
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(originX);
            make.width.height.mas_equalTo(itemSize);
            make.bottom.mas_equalTo(-bottom);
        }];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        itemView.layer.shadowOffset = CGSizeMake(0,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3)
        itemView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
        itemView.layer.shadowRadius = 3;//阴影半径，默认3
        itemView.layer.cornerRadius = 4;
        itemView.tag = 100+i;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [itemView addGestureRecognizer:tapGesture];
        
        UIButton *btn = [UIButton new];
        btn.enabled = NO;
        [itemView addSubview:btn];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState: UIControlStateNormal];
        [btn setTitle:titleArr[i] forState: UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        [btn layoutButtonWithButtonLaoutStyle:JYButtonLaoutStyle_Top space:10];
    }
    
}
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    self.callBackBlock(gesture.view.tag - 100);
}
//- (void)

@end
