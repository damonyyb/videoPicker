//
//  JYPointSideButton.m
//  D2
//
//  Created by Feng Liu on 2018/12/7.
//  Copyright © 2018 jiuyu. All rights reserved.
//

#import "JYPointSideButton.h"

@implementation JYPointSideButton


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //获取当前button的实际大小
    CGRect bounds = self.bounds;
    
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    
    //扩大bounds 左右方向和上下方向扩大或缩小的长度。正值为缩小，负值为扩大
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    
    //如果点击的点 在 新的bounds里，就返回YES
    return CGRectContainsPoint(bounds, point);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
