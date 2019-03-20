//
//  JYVideoImageCell.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/13.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoImageCell.h"
#import "Masonry.h"
#import "UIView+Tools.h"

@implementation JYVideoImageCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _iconImgView = [[UIImageView alloc] init];
        [self addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(@(0));
            make.width.height.equalTo(@(60));
        }];
        [_iconImgView makeCornerRadius:30 borderColor:nil borderWidth:0];
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return self;
}

@end
