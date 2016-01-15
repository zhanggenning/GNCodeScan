//
//  CodeScanCore.m
//  GNCodeScanDemo
//
//  Created by zhanggenning on 16/1/15.
//  Copyright © 2016年 zhanggenning. All rights reserved.
//

#import "CodeScanCore.h"
#import <AVFoundation/AVFoundation.h>

@interface CodeScanCore () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureSession *_session;
    AVCaptureVideoPreviewLayer *_previewLayer;
}

@property (nonatomic, strong) ScanResultBlock completeBlock;

@end

@implementation CodeScanCore

- (void)dealloc
{
    [_output setMetadataObjectsDelegate:nil queue:nil];
    
    if (_session.isRunning)
    {
        [_session stopRunning];
    }

    NSLog(@"释放");
}

- (instancetype)initWithView:(UIView *)view
{
    if (self = [super init])
    {
        //device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //input
        NSError *error = nil;
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
        if (error)
        {
            NSLog(@"没有摄像头-%@", error.localizedDescription);
            
            return nil;
        }
        
        //output
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_output setRectOfInterest:view.bounds];
        
        //session
        _session = [[AVCaptureSession alloc] init];
        
        // 读取质量，质量越高，可读取小尺寸的二维码
        if ([_session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
        {
            [_session setSessionPreset:AVCaptureSessionPreset1920x1080];
        }
        else if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720])
        {
            [_session setSessionPreset:AVCaptureSessionPreset1280x720];
        }
        else
        {
            [_session setSessionPreset:AVCaptureSessionPresetPhoto];
        }
        
        if ([_session canAddInput:_input])
        {
            [_session addInput:_input];
        }
        
        if ([_session canAddOutput:_output])
        {
            [_session addOutput:_output];
        }
        
        //设置输出的格式
        //一定要先设置会话的输出为output之后，再指定输出的元数据类型
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeCode128Code];
        
        //Preview
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = view.bounds;
        [view.layer insertSublayer:_previewLayer atIndex:0];
    }
    return self;
}

- (CGRect)viewBounds
{
    return _previewLayer.frame;
}

- (void)setViewBounds:(CGRect)viewBounds
{
    _previewLayer.frame = viewBounds;
}

- (void)setScanRect:(CGRect)scanRect
{
    _scanRect = scanRect;
 
    //转换坐标系
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat newWidth = scanRect.size.width / screenWidth;
    CGFloat newHeight = scanRect.size.height / screenHeight;
    CGFloat newX = scanRect.origin.x / screenWidth;
    CGFloat newY = scanRect.origin.y / screenHeight;
    
    //范围(0,0,1,1),xy交换，wh交换
    _output.rectOfInterest = CGRectMake(newY, newX, newHeight, newWidth);
    
    //开始扫描
    if (!_session.isRunning)
    {
        [_session startRunning];
    }
}

#pragma mark -- <AVCaptureMetadataOutputObjectsDelegate>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];

        if (_resultBlock)
        {
            _resultBlock(metadataObject.stringValue);
        }
    }
}

@end
