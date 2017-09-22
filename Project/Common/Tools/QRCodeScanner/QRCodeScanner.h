//
//  QRCodeScanner.h
//  Project
//
//  Created by jearoc on 2017/9/22.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QRScannerCameraMode) {
  QRScannerCameraModeBack,
  QRScannerCameraModeFront,
};

typedef NS_ENUM(NSUInteger, QRScannerTorchMode) {
  QRScannerTorchModeOff,
  QRScannerTorchModeOn,
};

@interface QRCodeScanner : NSObject

@property (nonatomic, assign, readonly) QRScannerCameraMode cameraMode;
@property (nonatomic, assign) QRScannerTorchMode torchMode;
@property (nonatomic, assign) BOOL allowFocus;///< Defaults to YES.
@property (nonatomic, assign, readonly) BOOL isFreezeCapture;
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, strong) CALayer *previewLayer;
@property (nonatomic, copy) void (^didStartScanningBlock)(void);
@property (nonatomic, copy) void (^didFocusBlock)(CGPoint point);
@property (nonatomic, copy) void (^resultBlock)(NSArray<AVMetadataMachineReadableCodeObject *> *codes);
@property (nonatomic, assign) AVCaptureAutoFocusRangeRestriction preferredAutoFocusRangeRestriction;///< Defaults to AVCaptureAutoFocusRangeRestrictionNear.

- (instancetype)initWithPreviewView:(UIView *)previewView;
- (instancetype)initWithMetadataObjectTypes:(NSArray<NSString *> *)metaDataObjectTypes
                                previewView:(UIView *)previewView;

/**
 返回该设备中是否存在摄像头。

 @return cameraIsPresent
 */
+ (BOOL)cameraIsPresent;

/**
 是否可以翻转摄像头

 @return hasOppositeCamera
 */
- (BOOL)hasOppositeCamera;

/**
 返回该设备的用户是否禁止扫描。

 @return scanningIsProhibited
 */
+ (BOOL)scanningIsProhibited;

/**
 请求访问设备上的摄像机。

 @param successBlock successBlock
 */
+ (void)requestCameraPermissionWithSuccess:(void (^)(BOOL success))successBlock;

/**
 开始扫描条形码。

 @param error error
 @return result
 */
- (BOOL)startScanningWithError:(NSError **)error;

/**
 开始扫描条形码。

 @param resultBlock resultBlock
 @param error error
 @return result
 */
- (BOOL)startScanningWithResultBlock:(void (^)(NSArray<AVMetadataMachineReadableCodeObject *> *codes))resultBlock
                               error:(NSError **)error;

/**
 停止扫描条形码。
 */
- (void)stopScanning;

/**
 扫描仪是否正在扫描条形码

 @return isScanning
 */
- (BOOL)isScanning;

/**
 切换摄像头
 */
- (void)flipCamera;

/**
 切换摄像头

 @param camera QRScannerCameraMode
 @param error error
 @return result
 */
- (BOOL)setCamera:(QRScannerCameraMode)camera
            error:(NSError **)error;

/**
 切换摄像头

 @param error error
 @return result
 */
- (BOOL)flipCameraWithError:(NSError **)error;

/**
 是否有闪光灯

 @return hasTorch
 */
- (BOOL)hasTorch;

/**
 更改闪光灯状态
 */
- (void)toggleTorch;

/**
 设置闪光灯状态

 @param torchMode QRScannerTorchMode
 @param error NSError
 @return result
 */
- (BOOL)setTorchMode:(QRScannerTorchMode)torchMode
               error:(NSError **)error;

/**
 冻结保持最后一帧上previewview捕获。
 如果startscanning之前调用，它没有影响。
 */
- (void)freezeCapture;

/**
 解冻冷冻捕获。
 */
- (void)unfreezeCapture;

/**
 捕获当前相机馈送的静止图像。

 @param captureBlock callback
 */
- (void)captureStillImage:(void (^)(UIImage *image, NSError *error))captureBlock;

/**
 确定当前是否捕获静止图像。

 @return isCapturingStillImage
 */
- (BOOL)isCapturingStillImage;

@end
