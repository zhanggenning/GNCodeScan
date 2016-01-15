//
//  MainViewController.m
//  GNCodeScanDemo
//
//  Created by zhanggenning on 16/1/14.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "MainViewController.h"
#import "CodeScanViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goCodeScan:(id)sender
{
    [self.navigationController pushViewController:[CodeScanViewController new] animated:YES];
}

@end
