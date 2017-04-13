//
//  ZJCollectionViewCell.h
//  ZJRefreshDemo
//
//  Created by 张杰 on 2016/12/27.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJCollectionCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)UIImageView *logo;

//使图片回复到默认大小
- (void)changeImageWithDefaultScale;

@end
