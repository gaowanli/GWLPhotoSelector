//
//  GWLPhotoALAssets.h
//  GWLPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 GWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GWLPhotoALAssets : NSObject

@property(nonatomic ,strong) ALAsset *photoALAsset;
@property(nonatomic, assign, getter=isSelected) BOOL selected;

@end
