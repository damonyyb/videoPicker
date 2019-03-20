//
//  EditVideoViewController.h
//  iShow
//
//  Created by 胡阳阳 on 17/3/8.
//
//

#import <UIKit/UIKit.h>
#import "HXPhotoPicker.h"
#import "VideoModel.h"
@interface EditVideoViewController : UIViewController


@property(nonatomic,retain) NSMutableArray <VideoModel *>*videoModelArray;

@property (nonatomic , strong) NSNumber* width;
@property (nonatomic , strong) NSNumber* hight;
@property (nonatomic , strong) NSNumber* bit;
@property (nonatomic , strong) NSNumber* frameRate;
@property (nonatomic, strong) UIImage *image;

@end
