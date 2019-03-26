//
//  JYCustomCollectionView.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/21.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYCustomCollectionView.h"
#import "Masonry.h"
#import "JYVideoCommonCell.h"

#import "JYVideoImageCell.h"

#define kFilterCellID @"filterCellID"
#define kStickerCellID @"stickerCellID"

@interface JYCustomCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UICollectionView *pasterCollectionView;
@property (nonatomic ,strong) NSIndexPath* lastFilterIndex;
///布局
@property (nonatomic, strong) UICollectionViewFlowLayout* layout;
@property (nonatomic, assign) CGFloat selfHeight;
@end
@implementation JYCustomCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        
    }
    return self;
}
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self.pasterCollectionView reloadData];
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
            if (self.textColor) {
                cell.nameLabel.textColor = self.textColor;
            }
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
    
    switch (self.style) {
            case JYVideoPasterViewStyle_filter:
        {
            //1.修改数据源
            FilterModel* selectedModel = [self.filterModelArray objectAtIndex:indexPath.row];
            selectedModel.isSelected = YES;
            FilterModel* lastModel = [self.filterModelArray objectAtIndex:self.lastFilterIndex.row];
            lastModel.isSelected = NO;
            //2.刷新collectionView
            self.lastFilterIndex = indexPath;
            [self.pasterCollectionView reloadData];
        }
            break;
            case JYVideoPasterViewStyle_Paster:
        {
            //1.修改数据源
            StickersModel* selectedModel = [self.stickersModelArray objectAtIndex:indexPath.row];
            selectedModel.isSelected = YES;
            StickersModel* lastModel = [self.stickersModelArray objectAtIndex:self.lastFilterIndex.row];
            lastModel.isSelected = NO;
            //2.刷新collectionView
            self.lastFilterIndex = indexPath;
            [self.pasterCollectionView reloadData];
        }
            break;
        default:
            break;
    }
    
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
    //添加collectionview
    [self.pasterCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.pasterCollectionView reloadData];
}
- (void)reloadData
{
    [self.pasterCollectionView reloadData];
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
