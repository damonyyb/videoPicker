//
//  JYVideoEditVideoDeleteOrImportView.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/27.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "JYVideoEditVideoDeleteOrImportView.h"
#import "VideoManager.h"
static NSString *cellID = @"cellID";
#define itemWidth [UIScreen mainScreen].bounds.size.width*75/375
#define itemHeight [UIScreen mainScreen].bounds.size.width*40/375
#define space [UIScreen mainScreen].bounds.size.width*5/375.f
#define buttonSize [UIScreen mainScreen].bounds.size.width*52/375.f
@interface JYVideoEditVideoDeleteOrImportView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;



@end
@implementation JYVideoEditVideoDeleteOrImportView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews
{
    [self initLeftAndRightBtn];
    //collectionView
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.leftBtn.mas_right);
        make.right.mas_equalTo(self.rightBtn.mas_left);
        make.height.mas_equalTo(itemHeight);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    });
    
}
- (void)initLeftAndRightBtn
{
    NSArray *imgArray = @[@"video_edit_playVideo",@"video_edit_addVideo"];
    for (int i=0; i<imgArray.count; i++) {
        UIButton *btn = [UIButton new];
        btn.tag = JYVideoEditVideoDeleteOrImportView_leftBtn+i;
        [btn setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftRighgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if (i == 0) {
            self.leftBtn = btn;
        }else{
            self.rightBtn = btn;
        }
    }
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(buttonSize);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.height.mas_equalTo(buttonSize);
    }];
}
//[weakSelf.redPointView.layer removeAnimationForKey:@"aAlpha"];
#pragma mark -- collection delegate&&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoModelArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JYVideoEditVideoDeleteOrImportViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.videoModelArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.collectionViewBlock(indexPath.row);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    cell = [collectionView cellForItemAtIndexPath:self.currentIndexPath];
    cell.selected = NO;
    self.currentIndexPath = indexPath;
}
#pragma mark -- Action

- (void)leftRighgBtnClick:(UIButton *)button
{
    self.leftRightBtnBlock(button.tag);
}

#pragma mark -- setter

- (void)setVideoModelArray:(NSMutableArray<VideoModel *> *)videoModelArray
{
    _videoModelArray = videoModelArray;
    [self.collectionView reloadData];
}
#pragma mark -- lazy load


- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        //        layout.estimatedItemSize = CGSizeMake(itemWidth, itemWidth);
        // 设置水平滚动方向
        //水平滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 设置额外滚动区域
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // 设置cell间距
        //设置垂直间距
        layout.minimumLineSpacing = space;
        //初始化collectionView
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[JYVideoEditVideoDeleteOrImportViewCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.f];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}


@end
@interface JYVideoEditVideoDeleteOrImportViewCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *redPoint;

@end
@implementation JYVideoEditVideoDeleteOrImportViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews
{
    //图片
    _imgView = [UIImageView new];
    _imgView.tag = 100;
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = 2;
    _imgView.layer.borderWidth = 0.5;
    _imgView.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    //时间
    _label = [UILabel new];;
    [self addSubview:_label];
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = [UIColor whiteColor];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.bottom.right.mas_equalTo(0);
    }];
    //红点
    _redPoint = [UIView new];
    [self addSubview:_redPoint];
    _redPoint.backgroundColor = [UIColor redColor];
    [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-3);
        make.width.height.mas_equalTo(4);
    }];
    _redPoint.layer.cornerRadius = 2;
    
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
}
-(void)setSelected:(BOOL)selected
{
    self.redPoint.hidden = !selected;
    if (selected) {
        self.layer.borderWidth = 1;
    }else{
        self.layer.borderWidth = 0;
    }
}
- (void)setModel:(VideoModel *)model
{
    _model = model;
    
    self.imgView.image = model.videoModel.thumbPhoto;
    self.label.text = [NSString stringWithFormat:@"%.1f",model.videoModel.asset.duration];
}
@end
