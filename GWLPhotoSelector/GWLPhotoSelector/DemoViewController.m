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

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:({
        _addPhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 40, 100, 44)];
        [_addPhotoButton setTitle:@"选择照片" forState:UIControlStateNormal];
        [_addPhotoButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_addPhotoButton setBackgroundColor:[UIColor lightGrayColor]];
        [_addPhotoButton addTarget:self action:@selector(addPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _addPhotoButton;
    })];
}

- (void)addPhotoButtonClick {
    GWLPhotoLibrayController *photoSelector = [[GWLPhotoLibrayController alloc]init];
    photoSelector.maxCount = 10;
    __weak typeof (self)weakSelf = self;
    photoSelector.block = ^(id result){
        [weakSelf displayImages:result];
    };
    [self presentViewController:photoSelector animated:YES completion:nil];
}

- (void)displayImages:(NSArray *)images {
    NSLog(@"%@", images);
}

@end
