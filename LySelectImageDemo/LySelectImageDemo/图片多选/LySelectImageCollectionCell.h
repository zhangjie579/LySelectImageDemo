//
//  LySelectImageCollectionCell.h
//  Eyed
//
//  Created by 张杰 on 2017/4/13.
//  Copyright © 2017年 Calvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LySelectImageCollectionCell : UICollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@property(nonatomic,strong)UIImage *image;

@end
