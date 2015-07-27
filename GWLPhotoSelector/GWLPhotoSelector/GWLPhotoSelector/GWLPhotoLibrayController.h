//
//  GWLPhotoLibrayController.h
//  GWLPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 GWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWLPhotoSelectorHeader.h"

@interface GWLPhotoLibrayController : UINavigationController

/**最多能选择的照片数量*/
@property(nonatomic, assign) NSInteger maxCount;
/**是否可以跨相册选择*/
@property (nonatomic, assign) BOOL multiAlbumSelect;

+ (instancetype)photoLibrayControllerWithBlock:(photoSelectorBlock) block;

@end
