//
//  ZJPhoneBrower.h
//  ZJRefreshDemo
//
//  Created by 张杰 on 2016/12/27.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJPhoneBrowerDelegate <NSObject>

@optional

/**
 删除图片的回调
 
 @param page 删除的第几张
 @param isNone 如果为yes，说明没了图片
 */
- (void)zJPhoneBrowerDeleteImage:(NSInteger)page isNone:(BOOL)isNone;
@end

@interface ZJPhoneBrower : UIView

//注意:要求父控件只有这个图片视图
@property(nonatomic, weak )UIView   *sourceImagesContainerView;//imageView的父控件
@property(nonatomic,assign)BOOL     isContainDel;//是否包含删除功能
@property(nonatomic,weak  )id<ZJPhoneBrowerDelegate> delegate;
/**
 展示图片浏览器
 
 @param array_images 图片数组，传string
 @param current 当前点击第几个
 @param isWebImage 是否为网络图片
 */
- (void)showImages:(NSArray<NSString *> *)array_images current:(NSInteger )current isWebImage:(BOOL)isWebImage;

- (void)showImages:(NSArray<UIImage *> *)array_images current:(NSInteger )current;

@end
