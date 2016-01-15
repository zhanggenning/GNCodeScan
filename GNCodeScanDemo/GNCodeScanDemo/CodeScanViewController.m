//
//  CodeScanViewController.m
//  GNCodeScanDemo
//
//  Created by zhanggenning on 16/1/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "CodeScanViewController.h"
#import "CodeScanCore.h"
#import "CodeScanView.h"

@interface CodeScanViewController ()

@property (nonatomic, strong) CodeScanCore *codeScanCore;

@property (weak, nonatomic) IBOutlet CodeScanView *codeScanView;

@property (weak, nonatomic) IBOutlet UILabel *resultLable;
@end

@implementation CodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _codeScanCore = [[CodeScanCore alloc] initWithView:self.view];
    
    __weak typeof(self) weakSelf = self;
    _codeScanCore.resultBlock = ^(NSString *string){
        
        weakSelf.resultLable.text = [NSString stringWithFormat:@"%@", string];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    if (!CGRectEqualToRect(_codeScanCore.viewBounds, self.view.bounds))
    {
        //调整预览区域
        _codeScanCore.viewBounds = self.view.bounds;
    }
    
    if (!CGRectEqualToRect(_codeScanCore.scanRect, _codeScanView.frame))
    {
        //调整扫描区域
        _codeScanCore.scanRect = _codeScanView.frame;
    }
}

@end
