//
//  LySelectImageView.h
//  Eyed
//
//  Created by 张杰 on 2017/4/13.
//  Copyright © 2017年 Calvin. All rights reserved.
//  图片选择器，多选

#import <UIKit/UIKit.h>

@protocol LySelectImageViewDelegate <NSObject>

@optional
//视图改变高度的回调
- (void)lySelectImageViewChangeViewHeight:(CGFloat)height;
@end

@interface LySelectImageView : UIView

@property(nonatomic,weak)id<LySelectImageViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray<UIImage *>  *arrayImage;//选择的图片

- (instancetype)initWithController:(UIViewController *)controller numberOfLine:(NSInteger) numberOfLine totalCount:(NSInteger)totalCount;
//初始化的高度,width为视图的宽
- (CGFloat)ly_getHeightWithViewWidth:(CGFloat)width;
@end
