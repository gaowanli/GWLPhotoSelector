//
//  GWLPhotoGroup.h
//  GWLPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 GWL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GWLPhotoGroup : NSObject

@property(nonatomic, copy) NSString *groupName;
@property(nonatomic, strong) UIImage *groupIcon;
@property(nonatomic, strong) NSMutableArray *photoALAssets;

@end
