//
//  JYVideoGridView.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/13.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoGridView.h"
#import "Masonry.h"
@implementation JYVideoGridView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i=0; i<4; i++) {
            UIView *lineView = [UIView new];
            [self addSubview:lineView];
            lineView.backgroundColor = [UIColor whiteColor];
            //竖线
            if (i<2) {
                float originY = [UIScreen mainScreen].bounds.size.height*(i+1)*1/3.0f;
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo(0.5);
                    make.top.mas_equalTo(originY);
                }];
            }else{
            //横线
                float originX = [UIScreen mainScreen].bounds.size.width*(i-1)*1/3.0f;
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(0.5);
                    make.left.mas_equalTo(originX);
                }];
            }
            
        }
    }
    return self;
}

@end
