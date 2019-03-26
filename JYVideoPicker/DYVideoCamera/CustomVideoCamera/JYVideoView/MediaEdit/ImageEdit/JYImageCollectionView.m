//
//  JYImageCollectionView.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/25.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYImageCollectionView.h"
#import "JYVideoImageCell.h"
#import "Masonry.h"
static NSString *cellID= @"cellID";

@interface JYImageCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UICollectionView *collectionView;
///布局
@property (nonatomic, strong) UICollectionViewFlowLayout* layout;
@end
@implementation JYImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
            make.height.mas_equalTo(60);
        }];
    }
    return self;
}
- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JYVideoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.iconImgView.image = self.dataSource[indexPath.row];
    [cell.iconImgView makeCornerRadius:4 borderColor:nil borderWidth:0];
    return cell;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 1, 1) collectionViewLayout:self.layout];
        [_collectionView registerClass:[JYVideoImageCell class] forCellWithReuseIdentifier:cellID];
        //设置背景颜色
        _collectionView.backgroundColor = [UIColor clearColor];
        
        // 设置数据源,展示数据
        _collectionView.dataSource = self;
        //设置代理,监听
        _collectionView.delegate = self;

        //设置滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
        
    }
    return _collectionView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectBlock(indexPath.row);
}
-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.estimatedItemSize = CGSizeMake(52, 52);
        //设置垂直间距
        _layout.minimumLineSpacing = 12;
        //水平滚动
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置额外滚动区域
        _layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        // 设置cell间距
        //设置水平间距, 注意点:系统可能会跳转(计算不准确)
        
    }
    return _layout;
}
@end
