//
//  GWLPhotoGroupTableViewController.h
//  GWLPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 GWL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GWLPhotoSelectorHeader.h"

@interface GWLPhotoGroupTableViewController : UITableViewController

@property(nonatomic, assign) NSInteger maxCount;
@property(nonatomic, strong) NSArray *photoGroupArray;
/**回调*/
@property (nonatomic, copy) photoSelectorBlock block;

- (void)showErrorMessageView;

@end
