//
//  CodeScanCore.h
//  GNCodeScanDemo
//
//  Created by zhanggenning on 16/1/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//  二维码识别服务

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ScanResultBlock)(NSString *str);

@interface CodeScanCore : NSObject

//预览区域，默认为view.bounds
@property (nonatomic, assign) CGRect viewBounds;

//扫描区域，默认为view.bounds
@property (nonatomic, assign) CGRect scanRect;

//扫描结果回调
@property (nonatomic, strong) ScanResultBlock resultBlock;


/**
 *  初始化
 *
 *  @param view : 预览view
 *
 *  @return
 */
- (instancetype)initWithView:(UIView *)view;

@end
