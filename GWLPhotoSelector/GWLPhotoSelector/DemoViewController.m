//
//  DemoViewController.m
//  GWLPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 GWL. All rights reserved.
//

#import "DemoViewController.h"
#import "GWLPhotoLibrayController.h"

@interface DemoViewController ()

@property (nonatomic, strong) UIButton *addPhotoButton;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:({
        _addPhotoButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _addPhotoButton.frame = CGRectMake(0, 25, 44, 44);
        [_addPhotoButton addTarget:self action:@selector(addPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _addPhotoButton;
    })];
}

- (void)addPhotoButtonClick {
    __weak typeof (self)weakSelf = self;
    GWLPhotoLibrayController *photoSelector = [GWLPhotoLibrayController photoLibrayControllerWithBlock:^(NSArray *images) {
        [weakSelf displayImages:images];
    }];
    photoSelector.maxCount = 10;
    photoSelector.multiAlbumSelect = YES;
    [self presentViewController:photoSelector animated:YES completion:nil];
}

- (void)displayImages:(NSArray *)images {
    for (UIImageView *imageView in self.imageViewArray) {
        [imageView removeFromSuperview];
    }
    [self.imageViewArray removeAllObjects];
    self.imageViewArray = nil;
    
    NSInteger index = 0;
    NSInteger rowMax = 5;
    CGFloat imageViewWidth = CGRectGetWidth(self.view.frame) / rowMax;
    CGFloat imageViewHeight = imageViewWidth;
    for (UIImage *image in images) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        CGFloat imageViewX = (index % rowMax) * imageViewWidth;
        CGFloat imageViewY = (index / rowMax) * imageViewHeight;
        imageView.frame = CGRectMake(imageViewX, CGRectGetMaxY(_addPhotoButton.frame) + imageViewY + 10, imageViewWidth, imageViewHeight);
        NSLog(@"%@", NSStringFromCGSize(image.size));
        [imageView setImage:image];
        [self.view addSubview:imageView];
        [self.imageViewArray addObject:imageView];
        index++;
    }
}

#pragma mark Layz loading
- (NSMutableArray *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

@end
