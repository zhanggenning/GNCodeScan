//
//  CodeScanView.m
//  GNCodeScanDemo
//
//  Created by zhanggenning on 16/1/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "CodeScanView.h"

@interface CodeScanView ()
{
    CGRect _curBounds;
    CALayer *_borderLayer;
    UIImageView *_lineView;
    UIImageView *_leftTopView;
    UIImageView *_rightTopView;
    UIImageView *_leftBottomView;
    UIImageView *_rightBottomView;
}
@end

@implementation CodeScanView

- (void)dealloc
{
    [self stopLineAnimation];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self customInit];
    }
    
    return self;
}

- (void) customInit
{
    self.backgroundColor = [UIColor clearColor];
    
    //边框
    _borderLayer = [CALayer layer];
    _borderLayer.borderColor = [UIColor greenColor].CGColor;
    _borderLayer.borderWidth = 1.0;
    [self.layer addSublayer:_borderLayer];
    
    //边角
    _leftTopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRCodeTopLeft"]];
    [self addSubview:_leftTopView];
    
    _rightTopView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRCodeTopRight"]];
    [self addSubview:_rightTopView];
    
    _leftBottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRCodebottomLeft"]];
    [self addSubview:_leftBottomView];
    
    _rightBottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRCodebottomRight"]];
    [self addSubview:_rightBottomView];
    
    //横线
    _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRCodeLine"]];
    [self addSubview:_lineView];
}

- (void)layoutSubviews
{
    if (!CGRectEqualToRect(_curBounds, self.bounds))
    {
        _borderLayer.frame = CGRectMake(8, 8, self.bounds.size.width - 16, self.bounds.size.height - 16);
        
        _leftTopView.frame = CGRectMake(0, 0, 20, 20);
        _rightTopView.frame = CGRectMake(self.bounds.size.width - 20, 0, 20, 20);
        _leftBottomView.frame = CGRectMake(0, self.bounds.size.height - 20, 20, 20);
        _rightBottomView.frame = CGRectMake(self.bounds.size.width - 20,
                                            self.bounds.size.height - 20,
                                            20, 20);
        [self stopLineAnimation];
        _lineView.frame = CGRectMake(0, 8, self.bounds.size.width, 6);
        [self startLineAnimation];
        
        _curBounds = self.bounds;
    }
}

#pragma mark - Private

/**
 *  开始扫描线动画
 */
- (void)startLineAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:HUGE_VALF];
    
    _lineView.frame= CGRectMake(0, self.bounds.size.height - 16, self.bounds.size.width, 6);
    
    [UIView commitAnimations];
}

/**
 *  停止扫描线动画
 */
- (void)stopLineAnimation
{
    [_lineView.layer removeAllAnimations];
}

@end
