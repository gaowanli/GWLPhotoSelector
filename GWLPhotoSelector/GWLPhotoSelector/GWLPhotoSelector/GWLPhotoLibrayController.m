//
//  GWLPhotoLibrayController.m
//  GWLPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 GWL. All rights reserved.
//

#import "GWLPhotoLibrayController.h"
#import "GWLPhotoGroup.h"
#import "GWLPhotoALAssets.h"
#import "GWLPhotoGroupTableViewController.h"

@interface GWLPhotoLibrayController ()

@property (nonatomic, copy) photoSelectorBlock block;
@property(nonatomic, strong) GWLPhotoGroupTableViewController *photoGroupTableViewController;
@property(nonatomic, strong) ALAssetsLibrary *library;
@property(nonatomic, strong) NSMutableArray *photoGroupArray;

@end

@implementation GWLPhotoLibrayController

+ (instancetype)photoLibrayControllerWithBlock:(photoSelectorBlock) block {
    return [[self alloc]initWithBlock:block];
}

- (instancetype)initWithBlock:(photoSelectorBlock) block {
    _block = block;
    return [super initWithRootViewController:self.photoGroupTableViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupImagePickerController];
}

- (void)setupImagePickerController {
    __weak typeof (self) selfVc = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error) {
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [selfVc.photoGroupTableViewController showErrorMessageView];
                });
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result != NULL) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    GWLPhotoGroup *photoGroup = [selfVc.photoGroupArray lastObject];
                    GWLPhotoALAssets *photoALAssets = [[GWLPhotoALAssets alloc]init];
                    photoALAssets.photoALAsset = result;
                    photoALAssets.selected = NO;
                    [photoGroup.photoALAssets addObject:photoALAssets];
                }
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup *aLAssets, BOOL* stop){
            if (aLAssets != nil) {
                NSString *groupName = [aLAssets valueForProperty:ALAssetsGroupPropertyName];
                UIImage *posterImage = [UIImage imageWithCGImage:[aLAssets posterImage]];
                
                GWLPhotoGroup *photoGroup = [[GWLPhotoGroup alloc]init];
                photoGroup.groupName = groupName;
                photoGroup.groupIcon = posterImage;
                [selfVc.photoGroupArray addObject:photoGroup];
                
                [aLAssets enumerateAssetsUsingBlock:groupEnumerAtion];
                dispatch_async(dispatch_get_main_queue(), ^{
                    selfVc.photoGroupTableViewController.photoGroupArray = selfVc.photoGroupArray;
                });
            }
        };
        
        [selfVc.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:libraryGroupsEnumeration failureBlock:failureblock];
    });
}

#pragma mark - getter && setter
- (GWLPhotoGroupTableViewController *)photoGroupTableViewController {
    if (!_photoGroupTableViewController) {
        _photoGroupTableViewController = [[GWLPhotoGroupTableViewController alloc]init];
    }
    return _photoGroupTableViewController;
}

- (ALAssetsLibrary *)library {
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (NSMutableArray *)photoGroupArray {
    if (!_photoGroupArray) {
        _photoGroupArray = [NSMutableArray array];
    }
    return _photoGroupArray;
}

- (void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
    self.photoGroupTableViewController.maxCount = maxCount;
    self.photoGroupTableViewController.block = self.block;
}

- (void)setMultiAlbumSelect:(BOOL)multiAlbumSelect {
    _multiAlbumSelect = multiAlbumSelect;
    self.photoGroupTableViewController.multiAlbumSelect = multiAlbumSelect;
}

@end
