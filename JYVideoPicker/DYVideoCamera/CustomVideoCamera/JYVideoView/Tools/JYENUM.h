//
//  JYENUM.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/21.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#ifndef JYENUM_h
#define JYENUM_h

typedef NS_ENUM(NSInteger,JYVideoPasterViewStyle) {
    JYVideoPasterViewStyle_Paster,
    JYVideoPasterViewStyle_filter,
    JYVideoPasterViewStyle_videoEdit
};
///制作中的详细动作
typedef NS_ENUM(NSInteger, JYVideoMakeDetailAction) {
    JYVideoMakeDetailAction_crop = 0,
    JYVideoMakeDetailAction_rotate,
    JYVideoMakeDetailAction_speed,
    JYVideoMakeDetailAction_sticker,
    JYVideoMakeDetailAction_tag,
    JYVideoMakeDetailAction_text
};
#endif /* JYENUM_h */
