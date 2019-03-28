
//
//  JYVideoEditCustomCollectionView.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/26.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYVideoEditCustomCollectionView.h"
static NSString *cellID = @"cellID";
@interface JYVideoEditCustomCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UICollectionView *collectionView;

///按钮布局
@property (nonatomic, assign) JYButtonLaoutStyle style;
///图片与文字之间的间距
@property (nonatomic, assign) float space;
@end
@implementation JYVideoEditCustomCollectionView

- (void)setupSubviews
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    JYVideoEditCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.imageName = self.imageArray[indexPath.row];
    [cell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cell.button layoutButtonWithButtonLaoutStyle:self.style space:3];
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.videoMakeDetailActionBlock(indexPath.row);
}

- (void)reloadData
{
    [self.collectionView reloadData];
}
-(UICollectionViewFlowLayout *)layout
{
    
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        
        _layout.estimatedItemSize = CGSizeMake(60*SCREEN_WIDTH/375, 100);
        //设置垂直间距
        _layout.minimumLineSpacing = 30*SCREEN_WIDTH/375;
        //水平滚动
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // 设置额外滚动区域
        _layout.sectionInset = UIEdgeInsetsMake(10, 26*SCREEN_WIDTH/375, 10, 26*SCREEN_WIDTH/375);
    }
    return _layout;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) collectionViewLayout:self.layout];
        //设置背景颜色
        _collectionView.backgroundColor = [UIColor clearColor];
        // 设置数据源,展示数据
        _collectionView.dataSource = self;
        //设置代理,监听
        _collectionView.delegate = self;
        
        // 注册cell
        [_collectionView registerClass:[JYVideoEditCustomCollectionViewCell class] forCellWithReuseIdentifier:cellID];
//        [_collectionView registerClass:[JYVideoImageCell class] forCellWithReuseIdentifier:kStickerCellID];
        /* 设置UICollectionView的属性 */
        //设置滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
        
    }
    return _collectionView;
}

- (void)setButtonLayoutStyle:(JYButtonLaoutStyle)style space:(float)space
{
    _style = style;
    _space = space;
    [self.collectionView reloadData];
}
@end
@implementation JYVideoEditCustomCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _button = [UIButton new];
        [self addSubview:_button];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _button.enabled = NO;
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.button setTitle:title forState:UIControlStateNormal];
}
-(void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
@end
