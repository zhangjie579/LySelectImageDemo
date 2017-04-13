//
//  LySelectImageCollectionCell.m
//  Eyed
//
//  Created by 张杰 on 2017/4/13.
//  Copyright © 2017年 Calvin. All rights reserved.
//

#import "LySelectImageCollectionCell.h"

@interface LySelectImageCollectionCell ()

@property(nonatomic,strong)UIImageView *logo;

@end

@implementation LySelectImageCollectionCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LySelectImageCollectionCell";
    [collectionView registerClass:[LySelectImageCollectionCell class] forCellWithReuseIdentifier:ID];
    LySelectImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.logo];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.logo.image = image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logo.frame = self.contentView.bounds;
}

- (UIImageView *)logo
{
    if (!_logo) {
        _logo = [[UIImageView alloc] init];
        _logo.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logo;
}

@end
