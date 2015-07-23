//
//  GWLPhotoGroupDetailController.h
//  GWLPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 GWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWLPhotoSelectorHeader.h"

@interface GWLPhotoGroupDetailController : UICollectionViewController

@property(nonatomic, assign) NSInteger maxCount;
@property(nonatomic, strong) NSArray *photoALAssets;
/**回调*/
@property (nonatomic, copy) photoSelectorBlock block;

@end
