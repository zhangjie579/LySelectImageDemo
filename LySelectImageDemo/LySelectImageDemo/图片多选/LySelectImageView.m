//
//  LySelectImageView.m
//  Eyed
//
//  Created by 张杰 on 2017/4/13.
//  Copyright © 2017年 Calvin. All rights reserved.
//

#import "LySelectImageView.h"
#import "LySelectImageCollectionCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "TZImagePickerController.h"
#import "ZJPhoneBrower.h"

@interface LySelectImageView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,ZJPhoneBrowerDelegate>

@property(nonatomic,strong)UICollectionView           *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,assign)NSInteger                  numberOfLine;//一行的个数
@property(nonatomic,assign)NSInteger                  totalCount;//总共的个数
@property(nonatomic,weak)UIViewController             *controller;
@property(nonatomic,strong)UIAlertController          *alertController;
@property(nonatomic,strong)ZJPhoneBrower              *phoneBrower;//图片浏览器

@end

static const int  kimageEdgeHorizontal = 10;//图片之间的间隔,水平间隙
static const int  kimageEdgeVertical = 13;//图片到View 竖直间隙

@implementation LySelectImageView

- (instancetype)initWithController:(UIViewController *)controller numberOfLine:(NSInteger) numberOfLine totalCount:(NSInteger)totalCount
{
    if (self = [super init]) {
        self.controller = controller;
        self.numberOfLine = numberOfLine;
        self.totalCount = totalCount;
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.arrayImage.count < self.totalCount)//有选择图片
    {
        return self.arrayImage.count + 1;
    }
    else
    {
        return self.arrayImage.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LySelectImageCollectionCell *cell = [LySelectImageCollectionCell cellWithCollectionView:collectionView indexPath:indexPath];
    
    if (self.arrayImage.count < self.totalCount)//有选择图片
    {
        if (indexPath.row == self.arrayImage.count)
        {
            cell.image = [UIImage imageNamed:@"image_add_n"];
        }
        else
        {
            cell.image = self.arrayImage[indexPath.row];
        }
    }
    else
    {
        cell.image = self.arrayImage[indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.arrayImage.count < self.totalCount && indexPath.row == self.arrayImage.count)//上传图片
    {
        [self.controller presentViewController:self.alertController animated:YES completion:nil];
    }
    else
    {
        [self.phoneBrower showImages:self.arrayImage current:indexPath.row];
    }
}

#pragma mark - 浏览图片的时候删除的回调

- (void)zJPhoneBrowerDeleteImage:(NSInteger)page isNone:(BOOL)isNone
{
    if (isNone)
    {
        [self.arrayImage removeAllObjects];
    }
    else
    {
        [self.arrayImage removeObjectAtIndex:page];
    }
    [self.collectionView reloadData];
    [self changeHeight];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = (self.frame.size.width - (self.numberOfLine + 1) * kimageEdgeHorizontal) / self.numberOfLine;
    self.flowLayout.itemSize = CGSizeMake(w, w);
    
    self.collectionView.frame = self.bounds;
}

- (CGFloat)ly_getHeightWithViewWidth:(CGFloat)width
{
    CGFloat w = (width - (self.numberOfLine + 1) * kimageEdgeHorizontal) / self.numberOfLine;
    NSInteger count = 0;
    
    if (self.arrayImage.count < self.totalCount)
    {
        count = self.arrayImage.count + 1;
    }
    else
    {
        count = self.arrayImage.count;
    }
    
    NSInteger line = (count - 1) / self.numberOfLine + 1;
    CGFloat h = (w + kimageEdgeHorizontal) * line + kimageEdgeHorizontal;
    return h;
}

//回调改变高度
- (void)changeHeight
{
    CGFloat h = [self ly_getHeightWithViewWidth:self.frame.size.width];
    
    //如果高度不变，就不回调
    if (h == self.frame.size.height) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(lySelectImageViewChangeViewHeight:)]) {
        [self.delegate lySelectImageViewChangeViewHeight:h];
    }
}

#pragma mark - 选择图片

- (void)openAlnum
{
    //判断相册权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    if (author == AVAuthorizationStatusRestricted || author ==AVAuthorizationStatusDenied)
    {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用名称
        NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        NSString *errorStr = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相册”选项中，允许%@访问你的相册",appCurName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:errorStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.maxImagesCount = self.totalCount-self.arrayImage.count;
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.oKButtonTitleColorNormal = [UIColor blueColor];
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor blueColor];
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.arrayImage addObjectsFromArray:photos];
        [strongSelf.collectionView reloadData];
        [strongSelf changeHeight];
    }];
    
    [self.controller presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)openCamera
{
    if (![self isRearCameraAvailable])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请在iPhone的“设置-隐私-相机”选项中，允许爱的访问你的相机" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
        return;
    }
    //iOS判断应用是否有使用相机的权限
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 当前应用名称
        NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *errorStr = [NSString stringWithFormat:@"请在iPhone的“设置-隐私-相机”选项中，允许%@访问你的相机",appCurName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:errorStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alert show];
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [self.controller presentViewController:ipc animated:YES completion:nil];
}

// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

//完成图片选择
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData * data = UIImageJPEGRepresentation(image, 0.3f);
    UIImage * impressImage = [UIImage imageWithData:data];
    
    [self.arrayImage addObject:impressImage];
    [self.collectionView reloadData];
    [self changeHeight];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - get

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = kimageEdgeHorizontal;
        _flowLayout.minimumLineSpacing = kimageEdgeVertical;
        _flowLayout.sectionInset = UIEdgeInsetsMake(kimageEdgeHorizontal, kimageEdgeHorizontal, 0, kimageEdgeHorizontal);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor= [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIAlertController *)alertController
{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"选择相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openCamera];
        }];
        
        UIAlertAction *alnum = [UIAlertAction actionWithTitle:@"选择相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openAlnum];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [_alertController addAction:camera];
        [_alertController addAction:alnum];
        [_alertController addAction:cancel];
    }
    return _alertController;
}

- (NSMutableArray<UIImage *> *)arrayImage
{
    if (!_arrayImage) {
        _arrayImage = [[NSMutableArray alloc] init];
    }
    return _arrayImage;
}

- (ZJPhoneBrower *)phoneBrower
{
    if (!_phoneBrower) {
        _phoneBrower = [[ZJPhoneBrower alloc] init];
        _phoneBrower.delegate = self;
        _phoneBrower.isContainDel = YES;
        _phoneBrower.sourceImagesContainerView = self.collectionView;
    }
    return _phoneBrower;
}

@end
