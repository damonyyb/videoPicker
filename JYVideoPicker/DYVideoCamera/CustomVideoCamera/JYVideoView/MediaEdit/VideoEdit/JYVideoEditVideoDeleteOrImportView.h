//
//  JYVideoEditVideoDeleteOrImportView.h
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/27.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,JYVideoEditVideoDeleteOrImportViewBtn) {
    JYVideoEditVideoDeleteOrImportView_leftBtn = 100,
    JYVideoEditVideoDeleteOrImportView_rightBtn,
};

@interface JYVideoEditVideoDeleteOrImportViewCell : UICollectionViewCell
@property(nonatomic,retain) VideoModel *model;
@end

@interface JYVideoEditVideoDeleteOrImportView : UIView
@property(nonatomic,retain) NSMutableArray <VideoModel *>*videoModelArray;
@property (nonatomic, copy) void(^ leftRightBtnBlock)(JYVideoEditVideoDeleteOrImportViewBtn btn);
@property (nonatomic, copy) void(^ collectionViewBlock)(NSInteger index);
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end


NS_ASSUME_NONNULL_END
