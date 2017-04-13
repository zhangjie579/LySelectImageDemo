//
//  ZJPhoneBrower.m
//  ZJRefreshDemo
//
//  Created by 张杰 on 2016/12/27.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import "ZJPhoneBrower.h"
#import "ZJFlowLayout.h"
#import "ZJCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface ZJPhoneBrower ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate>

@property(nonatomic,strong)NSMutableArray    *array_image;
@property(nonatomic,assign)BOOL              isWebImage;

@property(nonatomic,strong)UILabel           *label;
@property(nonatomic,strong)UICollectionView  *collectionView;
@property(nonatomic,strong)ZJFlowLayout      *flowLayout;
@property(nonatomic,strong)UIPageControl     *pageControl;

@property(nonatomic,strong)UIView            *view_nav;//导航栏
@property(nonatomic,strong)UIButton          *btn_delete;//删除按钮

@end

@implementation ZJPhoneBrower

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        [self addSubview:self.view_nav];
        [self.view_nav addSubview:self.btn_delete];
        [self.view_nav addSubview:self.label];
        self.view_nav.hidden = YES;
    }
    return self;
}

- (void)setIsContainDel:(BOOL)isContainDel
{
    _isContainDel = isContainDel;
    
    if (isContainDel) {
        self.view_nav.hidden = NO;
    } else {
        self.view_nav.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.view_nav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    self.btn_delete.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 45, 20, 30, 30);
    
    self.label.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 60) / 2, 16, 60, 30);
    
    self.pageControl.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 30, [UIScreen mainScreen].bounds.size.width, 10);
    
}

- (void)showImages:(NSArray<UIImage *> *)array_images current:(NSInteger )current
{
    [self.array_image removeAllObjects];
    
    self.isWebImage = NO;
    
    [self.array_image addObjectsFromArray:array_images];
    
    if (current > self.array_image.count - 1 || current < 0)
    {
        return;
    }
    
    [self.collectionView reloadData];
    
    if (array_images.count > 15)
    {
        self.label.hidden = NO;
        self.pageControl.hidden = YES;
        self.label.text = [NSString stringWithFormat:@"%ld/%ld",current + 1,self.array_image.count];
    }
    else
    {
        self.label.hidden = YES;
        self.pageControl.hidden = NO;
        self.pageControl.currentPage = current;
        self.pageControl.numberOfPages = self.array_image.count;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
    
    self.collectionView.contentOffset = CGPointMake(current * [UIScreen mainScreen].bounds.size.width, 0);
}

- (void)showImages:(NSArray<NSString *> *)array_images current:(NSInteger )current isWebImage:(BOOL)isWebImage
{
    [self.array_image removeAllObjects];
    
    self.isWebImage = isWebImage;
    
    if (isWebImage)
    {
        [self.array_image addObjectsFromArray:array_images];
    }
    else
    {
        for (NSInteger i = 0; i < array_images.count; i++) {
            UIImage *image = [UIImage imageNamed:array_images[i]];
            [self.array_image addObject:image];
        }
    }
    
    if (current > self.array_image.count - 1 || current < 0)
    {
        return;
    }
    
    [self.collectionView reloadData];
    
    if (array_images.count > 15)
    {
        self.label.hidden = NO;
        self.pageControl.hidden = YES;
        self.label.text = [NSString stringWithFormat:@"%ld/%ld",current + 1,self.array_image.count];
    }
    else
    {
        self.label.hidden = YES;
        self.pageControl.hidden = NO;
        self.pageControl.currentPage = current;
        self.pageControl.numberOfPages = self.array_image.count;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
    
    self.collectionView.contentOffset = CGPointMake(current * [UIScreen mainScreen].bounds.size.width, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger row = x / [UIScreen mainScreen].bounds.size.width + 0.5;
    
    self.label.text = [NSString stringWithFormat:@"%ld/%ld",row + 1,self.array_image.count];
    self.pageControl.currentPage = row;
    
//    NSInteger current = x / [UIScreen mainScreen].bounds.size.width;
    
    if (row < 0) {
        row = 0;
    } else if (row > self.array_image.count - 1) {
        row = self.array_image.count - 1;
    }
    
    //使当前滑动图片恢复到默认大小
    ZJCollectionCell *cell = (ZJCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    if (cell) {
        [cell changeImageWithDefaultScale];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array_image.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJCollectionCell *cell = [ZJCollectionCell cellWithCollectionView:collectionView indexPath:indexPath];
    
    if (self.isWebImage)
    {
        [cell.logo sd_setImageWithURL:[NSURL URLWithString:self.array_image[indexPath.row]]];
    }
    else
    {
//        cell.logo.image = [UIImage imageNamed:self.array_image[indexPath.row]];
        cell.logo.image = self.array_image[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self removeFromSuperview];
    }];
}

#pragma mark - 删除图片功能
- (void)btnDelete
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"是否真的删除?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [action addButtonWithTitle:@"删除"];
    [action addButtonWithTitle:@"取消"];
    action.cancelButtonIndex = action.numberOfButtons-1;
    [action showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSInteger current = self.pageControl.currentPage;
        if (current < 0) {
            current = 0;
        } else if (current > self.array_image.count - 1) {
            current = self.array_image.count - 1;
        }
        
        [self.array_image removeObjectAtIndex:current];
        
        if (self.array_image.count > 0)//还有图片
        {
            if ([self.delegate respondsToSelector:@selector(zJPhoneBrowerDeleteImage:isNone:)]) {
                [self.delegate zJPhoneBrowerDeleteImage:current isNone:NO];
            }
            
            [self.collectionView reloadData];
            
            if (current == self.array_image.count) {//删除了最后一张
                current = self.array_image.count - 1;
            }
            
            self.pageControl.currentPage = current;
            self.pageControl.numberOfPages = self.array_image.count;
            
            self.collectionView.contentOffset = CGPointMake(current * [UIScreen mainScreen].bounds.size.width, 0);
        }
        else//没图片
        {
            if ([self.delegate respondsToSelector:@selector(zJPhoneBrowerDeleteImage:isNone:)]) {
                [self.delegate zJPhoneBrowerDeleteImage:1000 isNone:YES];
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                [self removeFromSuperview];
            }];
        }
    }
}

- (ZJFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[ZJFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (NSMutableArray *)array_image
{
    if (!_array_image) {
        _array_image = [[NSMutableArray alloc] init];
    }
    return _array_image;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:24];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (UIView *)view_nav
{
    if (!_view_nav) {
        _view_nav = [[UIView alloc] init];
        _view_nav.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    }
    return _view_nav;
}

- (UIButton *)btn_delete
{
    if (!_btn_delete) {
        _btn_delete = [[UIButton alloc] init];
        [_btn_delete setImage:[UIImage imageNamed:@"nav_default_delete"] forState:UIControlStateNormal];
        [_btn_delete addTarget:self action:@selector(btnDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn_delete;
}

@end
