//
//  GWLPhotoGroup.m
//  GWLPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 GWL. All rights reserved.
//

#import "GWLPhotoGroup.h"

@implementation GWLPhotoGroup

- (NSMutableArray *)photoALAssets {
    if (!_photoALAssets) {
        _photoALAssets = [NSMutableArray array];
    }
    return _photoALAssets;
}

- (void)setGroupName:(NSString *)groupName {
    if ([groupName isEqualToString:@"Camera Roll"]) {
        groupName = @"相机胶卷";
    }
    _groupName = groupName;
}

@end
