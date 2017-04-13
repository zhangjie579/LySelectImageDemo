//
//  ZJCollectionViewCell.m
//  ZJRefreshDemo
//
//  Created by 张杰 on 2016/12/27.
//  Copyright © 2016年 张杰. All rights reserved.
//

#import "ZJCollectionCell.h"

@interface ZJCollectionCell ()<UIActionSheetDelegate,UIGestureRecognizerDelegate>

//@property(nonatomic,strong)UIImageView *logo;
@property(nonatomic,assign)CGFloat currentScale;

@end

@implementation ZJCollectionCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ZJCollectionCell";
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:ID];
    return [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.logo];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.logo.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//使图片回复到默认大小
- (void)changeImageWithDefaultScale
{
//    self.currentScale = 1;
    [UIView animateWithDuration:0.1 animations:^{
        self.logo.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

-(void)handlePinches:(UIPinchGestureRecognizer *)paramSender
{
    if (paramSender.state == UIGestureRecognizerStateEnded)
    {
        self.currentScale = paramSender.scale;
    }
    else if(paramSender.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f)
    {
        paramSender.scale = self.currentScale;
    }
    
    if (paramSender.scale != NAN && paramSender.scale != 0.0) {
        
        paramSender.view.transform = CGAffineTransformMakeScale(paramSender.scale, paramSender.scale);
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longs
{
    if (longs.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [action addButtonWithTitle:@"保存"];
        [action addButtonWithTitle:@"取消"];
        action.cancelButtonIndex = action.numberOfButtons-1;
        [action showInView:self];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImageWriteToSavedPhotosAlbum(self.logo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

/**
 *  通过UIImageWriteToSavedPhotosAlbum函数写入图片完毕后就会调用这个方法
 *
 *  @param image       写入的图片
 *  @param error       错误信息
 *  @param contextInfo UIImageWriteToSavedPhotosAlbum函数的最后一个参数
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
//        [MBProgressHUD showSuccess:@"图片保存失败!" toView:self];
        NSLog(@"图片保存失败!");
    } else {
        NSLog(@"图片保存成功!");
//        [MBProgressHUD showSuccess:@"图片保存成功!" toView:self];
    }
}

- (UIImageView *)logo
{
    if (!_logo) {
        _logo = [[UIImageView alloc] init];
        _logo.contentMode = UIViewContentModeScaleAspectFit;
        _logo.clipsToBounds = YES;
        _logo.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longs = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longs.delegate = self;
        [_logo addGestureRecognizer:longs];
        
        //捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinches:)];
        [_logo addGestureRecognizer:pinch];
    }
    return _logo;
}

@end
