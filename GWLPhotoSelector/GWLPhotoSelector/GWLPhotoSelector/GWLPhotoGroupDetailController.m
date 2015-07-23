//
//  GWLPhotoGroupDetailController.m
//  GWLPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 GWL. All rights reserved.
//

#import "GWLPhotoGroupDetailController.h"
#import "GWLPhotoALAssets.h"

@interface GWLPhotoCell : UICollectionViewCell

@property(nonatomic, strong) GWLPhotoALAssets *photoALAsset;

@property(nonatomic, weak) UIImageView *iconView;
@property(nonatomic, weak) UIView *selectedView;
@property(nonatomic, weak) UIButton *selectedBtn;

@end

@implementation GWLPhotoCell

- (void)setPhotoALAsset:(GWLPhotoALAssets *)photoALAsset {
    _photoALAsset = photoALAsset;
    ALAsset *alasset = photoALAsset.photoALAsset;
    if ([[alasset valueForProperty:@"ALAssetPropertyType"] isEqualToString:ALAssetTypePhoto]) {
        self.iconView.image = [UIImage imageWithCGImage:alasset.thumbnail];
    }
    self.selectedView.hidden = !photoALAsset.isSelected;
    self.selectedBtn.hidden = !photoALAsset.isSelected;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self.contentView addSubview:iconView];
        _iconView = iconView;
    }
    return _iconView;
}

- (UIView *)selectedView {
    if (!_selectedView) {
        UIView *selectedView = [[UIView alloc]initWithFrame:self.bounds];
        selectedView.backgroundColor = [UIColor whiteColor];
        selectedView.alpha = 0.2f;
        [self.iconView addSubview:selectedView];
        _selectedView = selectedView;
    }
    return _selectedView;
}

- (UIButton *)selectedBtn {
    if (!_selectedBtn) {
        UIButton *selectedBtn = [[UIButton alloc]init];
        selectedBtn.userInteractionEnabled = NO;
        [selectedBtn setImage:[UIImage imageNamed:@"GWLPhotoSelector_sel"] forState:UIControlStateNormal];
        CGFloat margin = 5;
        CGFloat selectedBtnX = CGRectGetWidth(_iconView.frame) - CGRectGetWidth(selectedBtn.frame) - margin;
        CGFloat selectedBtnY = CGRectGetHeight(_iconView.frame) - CGRectGetHeight(selectedBtn.frame) - margin;
        selectedBtn.frame = CGRectMake(selectedBtnX, selectedBtnY, selectedBtn.currentImage.size.width, selectedBtn.currentImage.size.height);
        [self.iconView addSubview:selectedBtn];
        _selectedBtn = selectedBtn;
    }
    return _selectedBtn;
}

@end

@interface GWLPhotoGroupDetailController ()

@property(nonatomic, strong) NSMutableArray *selectedPhotos;
@property(nonatomic, assign) NSInteger photosCount;
@property(nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation GWLPhotoGroupDetailController

static NSString * const reuseIdentifier = @"photoCell";
static int const kROWPHOTO = 4;

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = ([UIScreen mainScreen].bounds.size.width - kROWPHOTO * 2) / kROWPHOTO;
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick:)];
    [self.collectionView registerClass:[GWLPhotoCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)doneBtnClick:(UIBarButtonItem *)doneBarButtonItem {
    doneBarButtonItem.enabled = NO;
    __weak typeof (self) selfVc = self;
    [[[NSOperationQueue alloc]init] addOperationWithBlock:^{
        for (GWLPhotoALAssets *photoALAsset in self.selectedPhotos)
        {
            ALAsset *sset = photoALAsset.photoALAsset;
            ALAssetRepresentation *assetRepresentation = [sset defaultRepresentation];
            CGFloat imageScale = [assetRepresentation scale];
            UIImageOrientation imageOrientation = (UIImageOrientation)[assetRepresentation orientation];
            UIImage *originalImage = [UIImage imageWithCGImage:sset.defaultRepresentation.fullResolutionImage scale:imageScale orientation:imageOrientation];
            [selfVc.imageArray addObject:originalImage];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (selfVc.block) {
                selfVc.block(selfVc.imageArray);
            }
            selfVc.selectedPhotos = nil;
            selfVc.imageArray = nil;
        });
    }];
}

- (void)setPhotoALAssets:(NSArray *)photoALAssets {
    _photoALAssets = photoALAssets;
    if (photoALAssets.count > 0)
        self.photosCount = photoALAssets.count - 1;
    [self.collectionView reloadData];
}

- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos)
        _selectedPhotos = [NSMutableArray array];
    return _selectedPhotos;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoALAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GWLPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    GWLPhotoALAssets *photoALAssets = self.photoALAssets[self.photosCount - indexPath.row];
    cell.photoALAsset = photoALAssets;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GWLPhotoALAssets *photoALAsset = self.photoALAssets[self.photosCount - indexPath.row];
    photoALAsset.selected = !photoALAsset.isSelected;
    
    if (photoALAsset.isSelected) {
        [self.selectedPhotos addObject:photoALAsset];
        if (self.selectedPhotos.count > self.maxCount) {
            [self.selectedPhotos removeLastObject];
            photoALAsset.selected = NO;
            NSLog(@"%@",[NSString stringWithFormat:@"本次最多可选择%zd张照片",self.maxCount]);
        }
    }
    else {
        [self.selectedPhotos removeObject:photoALAsset];
    }
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - getter && setter
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

@end
