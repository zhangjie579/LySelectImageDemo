//
//  ZJFlowLayout.m
//  ZJRefreshDemo
//
//  Created by 张杰 on 2016/12/27.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import "ZJFlowLayout.h"

@implementation ZJFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}
//
//- (void)prepareLayout{
//
//    [super prepareLayout];
//
//    self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//
//    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//
////    // 设置内边距
////    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
////
////
////    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
//
//}
//
///*
// * 返回rect中的所有的元素的布局属性
// */
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    // 获得super已经计算好的布局属性
//    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
//
//    // 计算collectionView最中心点的x值
//    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
//
////    NSLog(@"collectionView最中心点的x值  %f",centerX);
//
//    // 在原有布局属性的基础上，进行微调
//    for (UICollectionViewLayoutAttributes *attrs in attributes) {
//        // cell的中心点x 和 collectionView最中心点的x值 的间距
//        CGFloat delta = ABS(attrs.center.x - centerX);//整数的绝对值
//
////        NSLog(@"差  %f",attrs.center.x );
//
//        // 根据间距值 计算 cell的缩放比例
//        CGFloat scale = 1.2 - delta / self.collectionView.frame.size.width;
//
////        NSLog(@"%f,%f",delta,scale);
//        // 设置缩放比例
//        attrs.transform = CGAffineTransformMakeScale(scale, scale);
//    }
//
//    return  attributes;
//
//}

@end
