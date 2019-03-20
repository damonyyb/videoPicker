//
//  JYVideoPasterView.m
//  DYVideoCamera
//
//  Created by Joblee on 2019/3/12.
//  Copyright © 2019年 huyangyang. All rights reserved.
//

#import "JYVideoPasterView.h"
#import "JYVideoCommonCell.h"
#import "Masonry.h"
#import "JYVideoImageCell.h"
#import "UIView+Tools.h"
#import "UIColor+JYHex.h"
#define kFilterCellID @"filterCellID"
#define kStickerCellID @"stickerCellID"
@interface JYVideoPasterView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UICollectionView *pasterCollectionView;
@property (nonatomic, assign) CGFloat selfHeight;
///蒙层
@property (nonatomic, strong) UIVisualEffectView *visualView;
///标题
@property (nonatomic, strong) UILabel *titleLab;
///布局
@property (nonatomic, strong) UICollectionViewFlowLayout* layout;
///横线
@property (nonatomic, strong) UIView *lineView;




@end
@implementation JYVideoPasterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (self.style) {
        case JYVideoPasterViewStyle_filter:
        {
            return self.filterModelArray.count;
        }
            break;
        case JYVideoPasterViewStyle_Paster:
        {
            return self.stickersModelArray.count;
        }
            break;
        default:
            return 0;
            break;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    switch (self.style) {
        case JYVideoPasterViewStyle_filter:
            {
                JYVideoCommonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFilterCellID forIndexPath:indexPath];
                FilterModel *model = self.filterModelArray[indexPath.row];
                cell.nameLabel.text = model.name;
                cell.iconImgView.image = [UIImage imageWithContentsOfFile:model.iconPath];
                if (model.isSelected) {
                    [cell.iconImgView makeCornerRadius:30 borderColor:[UIColor redColor] borderWidth:1];
                }else{
                    [cell.iconImgView makeCornerRadius:30 borderColor:nil borderWidth:0];
                }
                return cell;
            }
            break;
        default:
        {
            JYVideoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kStickerCellID forIndexPath:indexPath];
            StickersModel *model = self.stickersModelArray[indexPath.row];
            cell.iconImgView.image = [UIImage imageWithContentsOfFile:model.stickersImgPaht];
            if (model.isSelected) {
                [cell.iconImgView makeCornerRadius:30 borderColor:[UIColor redColor] borderWidth:1];
            }else{
                [cell.iconImgView makeCornerRadius:30 borderColor:[UIColor colorWithWhite:1.0 alpha:0.2] borderWidth:1];
            }
            return cell;
        }
            break;
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.videoPasterViewBlock(indexPath);
}
- (void)setupWithStyle:(JYVideoPasterViewStyle)style dataSource:(id)dataSource
{
    self.style = style;
    switch (style) {
        case JYVideoPasterViewStyle_filter:
        {
            self.selfHeight = 110;
            self.filterModelArray = dataSource;
        }
            break;
        case JYVideoPasterViewStyle_Paster:
        {
            self.selfHeight = 200;
            self.stickersModelArray = dataSource;
        }
            break;
        default:
            break;
    }
    //添加标题栏
    [self addTitleLab];
    
    //添加collectionview
    [self.pasterCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(self.selfHeight);
    }];
    
    //添加蒙层
    [self addCoverView];
}
#pragma mark -- reloadCollectionView
-(void)reloadCollectionView
{
    [self.pasterCollectionView reloadData];
}
- (void)changeBackgroundColor:(UIColor *)color
{
    if (color == [UIColor whiteColor]) {
        self.titleLab.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        self.visualView.hidden = YES;
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    }else{
        self.backgroundColor = [UIColor clearColor];
        self.visualView.hidden = NO;
        self.titleLab.textColor = [UIColor whiteColor];
        self.lineView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.2f];
    }
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
- (void)addTitleLab{
    self.titleLab = [UILabel new];
    [self addSubview:self.titleLab];
    switch (self.style) {
        case JYVideoPasterViewStyle_filter:
            self.titleLab.text = @"滤镜";
            break;
        case JYVideoPasterViewStyle_Paster:
            self.titleLab.text = @"贴纸";
        default:
            break;
    }
    
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = [UIColor whiteColor];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    UIView *lineView = [UIView new];
    [self.titleLab addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.2f];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    self.lineView = lineView;
}
#pragma mark -- lazy load

-(UIVisualEffectView *)visualView
{
    if (!_visualView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    }
    return _visualView;
}
-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        switch (self.style) {
            case JYVideoPasterViewStyle_filter:
                {
                    _layout.estimatedItemSize = CGSizeMake(60, 100);
                    //设置垂直间距
                    _layout.minimumLineSpacing = 22;
                    //水平滚动
                    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                }
                break;
                
            case JYVideoPasterViewStyle_Paster:
            {
                _layout.estimatedItemSize = CGSizeMake(60, 60);
                //设置垂直间距
                _layout.minimumLineSpacing = 10;
                //水平滚动
                _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            }
                break;
            default:
                break;
        }
        
        // 设置额外滚动区域
        _layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        // 设置cell间距
        //设置水平间距, 注意点:系统可能会跳转(计算不准确)
        
    }
    return _layout;
}
- (UICollectionView *)pasterCollectionView
{
    if (!_pasterCollectionView) {
        _pasterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) collectionViewLayout:self.layout];
        
        //设置背景颜色
        _pasterCollectionView.backgroundColor = [UIColor clearColor];
        
        
        // 设置数据源,展示数据
        _pasterCollectionView.dataSource = self;
        //设置代理,监听
        _pasterCollectionView.delegate = self;
        
        // 注册cell
        [_pasterCollectionView registerClass:[JYVideoCommonCell class] forCellWithReuseIdentifier:kFilterCellID];
        [_pasterCollectionView registerClass:[JYVideoImageCell class] forCellWithReuseIdentifier:kStickerCellID];
        /* 设置UICollectionView的属性 */
        //设置滚动条
        _pasterCollectionView.showsHorizontalScrollIndicator = NO;
        _pasterCollectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_pasterCollectionView];
        
        
    }
    return _pasterCollectionView;
}
@end
