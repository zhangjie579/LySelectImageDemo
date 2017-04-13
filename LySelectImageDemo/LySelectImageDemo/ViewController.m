//
//  ViewController.m
//  LySelectImageDemo
//
//  Created by 张杰 on 2017/4/13.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "ViewController.h"
#import "LySelectImageView.h"

@interface ViewController ()<LySelectImageViewDelegate>;

@property(nonatomic,strong)LySelectImageView *selectImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.selectImageView];
}

- (void)lySelectImageViewChangeViewHeight:(CGFloat)height
{
    CGRect rect = self.selectImageView.frame;
    rect.size.height = height;
    self.selectImageView.frame = rect;
}

- (LySelectImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [[LySelectImageView alloc] initWithController:self numberOfLine:4 totalCount:9];
        CGFloat h = [_selectImageView ly_getHeightWithViewWidth:[UIScreen mainScreen].bounds.size.width];
        _selectImageView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, h);
        _selectImageView.delegate = self;
    }
    return _selectImageView;
}

@end
