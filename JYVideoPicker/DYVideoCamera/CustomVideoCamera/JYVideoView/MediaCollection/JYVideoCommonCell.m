//
//  JYVideoCommonCell.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/13.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoCommonCell.h"
#import "Masonry.h"
#import "UIView+Tools.h"
@interface JYVideoCommonCell ()

@end

@implementation JYVideoCommonCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _iconImgView = [[UIImageView alloc] init];
        [self addSubview:_iconImgView];
        [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.width.height.equalTo(@(60));
            make.centerX.equalTo(self);
        }];
        [_iconImgView makeCornerRadius:30 borderColor:nil borderWidth:0];
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(_iconImgView.mas_bottom).offset(10);
            make.left.right.equalTo(_iconImgView);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

@end
