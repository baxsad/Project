//
//  QRCodeScanner.m
//  Project
//
//  Created by jearoc on 2017/9/22.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "QRCodeScanner.h"
#import <QuartzCore/QuartzCore.h>

CGFloat const kFocalPointOfInterestX = 0.5;
CGFloat const kFocalPointOfInterestY = 0.5;

static NSString *kErrorDomain = @"QRCodeScannerError";

static const NSInteger kErrorCodeStillImageCaptureInProgress = 1000;
static const NSInteger kErrorCodeSessionIsClosed = 1001;
static const NSInteger kErrorCodeNotScanning = 1002;
static const NSInteger kErrorCodeSessionAlreadyActive = 1003;
static const NSInteger kErrorCodeTorchModeUnavailable = 1004;

@interface QRCodeScanner () <AVCaptureMetadataOutputObjectsDelegate, AVCapturePhotoCaptureDelegate>

@property (strong) dispatch_queue_t privateSessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *capturePreviewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *currentCaptureDeviceInput;
@property (nonatomic, strong) AVCaptureMetadataOutput *captureOutput;
@property (nonatomic, copy) NSArray<NSString *> *metaDataObjectTypes;
@property (nonatomic, weak) UIView *previewView;
@property (nonatomic, assign) AVCaptureAutoFocusRangeRestriction initialAutoFocusRangeRestriction;
@property (nonatomic, assign) CGPoint initialFocusPoint;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
#pragma GCC diagnostic pop
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, copy) void (^stillImageCaptureBlock)(UIImage *image, NSError *error);

@end

@implementation QRCodeScanner

#pragma mark - Lifecycle

- (instancetype)init {
  NSAssert(NO, @"QRCodeScanner init is not supported. Please use initWithPreviewView: \
           or initWithMetadataObjectTypes:previewView: to instantiate a QRCodeScanner");
  return nil;
}

- (instancetype)initWithPreviewView:(UIView *)previewView {
  return [self initWithMetadataObjectTypes:[self defaultMetaDataObjectTypes] previewView:previewView];
}

- (instancetype)initWithMetadataObjectTypes:(NSArray<NSString *> *)metaDataObjectTypes previewView:(UIView *)previewView {
  NSParameterAssert(metaDataObjectTypes);
  NSAssert(metaDataObjectTypes.count > 0,
           @"Must initialize QRCodeScanner with at least one metaDataObjectTypes value.");
  
  self = [super init];
  if (self) {
    NSAssert(!([metaDataObjectTypes indexOfObject:AVMetadataObjectTypeFace] != NSNotFound),
             @"The type %@ is not supported by QRCodeScanner.", AVMetadataObjectTypeFace);
    
    _metaDataObjectTypes = metaDataObjectTypes;
    _previewView = previewView;
    _allowFocus = YES;
    _preferredAutoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
    [self setupSessionQueue];
    [self addObservers];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Scanning

+ (BOOL)cameraIsPresent {
  return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] != nil;
}

+ (BOOL)hasCamera:(QRScannerCameraMode)camera {
  AVCaptureDevicePosition position = [self devicePositionForCamera:camera];
  
  if (NSClassFromString(@"AVCaptureDeviceDiscoverySession")) {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                                 mediaType:AVMediaTypeVideo
                                                                  position:position];
    return (device != nil);
  } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
      if (device.position == position) {
        return YES;
      }
    }
#pragma GCC diagnostic pop
  }
  return NO;
}

+ (QRScannerCameraMode)oppositeCameraOf:(QRScannerCameraMode)camera {
  switch (camera) {
    case QRScannerCameraModeBack:
      return QRScannerCameraModeFront;
      
    case QRScannerCameraModeFront:
      return QRScannerCameraModeBack;
  }
  
  NSAssert(NO, @"Invalid camera type: %lu", (unsigned long)camera);
  return QRScannerCameraModeBack;
}

+ (BOOL)scanningIsProhibited {
  switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
    case AVAuthorizationStatusDenied:
    case AVAuthorizationStatusRestricted:
      return YES;
      break;
      
    default:
      return NO;
      break;
  }
}

+ (void)requestCameraPermissionWithSuccess:(void (^)(BOOL success))successBlock {
  if (![self cameraIsPresent]) {
    successBlock(NO);
    return;
  }
  
  switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
    case AVAuthorizationStatusAuthorized:
      successBlock(YES);
      break;
      
    case AVAuthorizationStatusDenied:
    case AVAuthorizationStatusRestricted:
      successBlock(NO);
      break;
      
    case AVAuthorizationStatusNotDetermined:
      [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                               completionHandler:^(BOOL granted) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                   successBlock(granted);
                                 });
                                 
                               }];
      break;
  }
}

- (BOOL)startScanningWithError:(NSError **)error {
  return [self startScanningWithResultBlock:self.resultBlock error:error];
}

- (BOOL)startScanningWithResultBlock:(void (^)(NSArray<AVMetadataMachineReadableCodeObject *> *codes))resultBlock error:(NSError **)error {
  NSAssert([QRCodeScanner cameraIsPresent], @"Attempted to start scanning on a device with no camera. Check requestCameraPermissionWithSuccess: method before calling startScanningWithResultBlock:");
  NSAssert(![QRCodeScanner scanningIsProhibited], @"Scanning is prohibited on this device. \
           Check requestCameraPermissionWithSuccess: method before calling startScanningWithResultBlock:");
  NSAssert(resultBlock, @"startScanningWithResultBlock: requires a non-nil resultBlock.");
  
  if (self.session) {
    if (error) {
      *error = [NSError errorWithDomain:kErrorDomain
                                   code:kErrorCodeSessionAlreadyActive
                               userInfo:@{NSLocalizedDescriptionKey : @"Do not start scanning while another session is in use."}];
    }
    
    return NO;
  }
  
  self.captureDevice = [self newCaptureDeviceWithCamera:self.cameraMode];
  AVCaptureSession *session = [self newSessionWithCaptureDevice:self.captureDevice error:error];
  
  if (!session) {
    return NO;
  }
  
  self.session = session;
  
  self.capturePreviewLayer.cornerRadius = self.previewView.layer.cornerRadius;
  [self.previewView.layer insertSublayer:self.capturePreviewLayer atIndex:0];
  [self refreshVideoOrientation];
  
  [self configureTapToFocus];
  
  self.resultBlock = resultBlock;
  
  dispatch_async(self.privateSessionQueue, ^{
    self.captureOutput.rectOfInterest = [self rectOfInterestFromScanRect:self.scanRect];
    
    [self.session startRunning];
    
    if (self.didStartScanningBlock) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.didStartScanningBlock();
      });
    }
  });
  
  return YES;
}

- (void)stopScanning {
  if (!self.session) {
    return;
  }
  
  self.torchMode = QRScannerTorchModeOff;
  [self.capturePreviewLayer removeFromSuperlayer];
  [self stopRecognizingTaps];
  self.resultBlock = nil;
  self.capturePreviewLayer = nil;
  
  AVCaptureSession *session = self.session;
  AVCaptureDeviceInput *deviceInput = self.currentCaptureDeviceInput;
  self.session = nil;
  
  dispatch_async(self.privateSessionQueue, ^{
    [self removeDeviceInput:deviceInput session:session];
    for (AVCaptureOutput *output in session.outputs) {
      [session removeOutput:output];
    }
    [session stopRunning];
  });
}

- (BOOL)isScanning {
  return [self.session isRunning];
}

- (BOOL)hasOppositeCamera {
  QRScannerCameraMode otherCamera = [[self class] oppositeCameraOf:self.cameraMode];
  return [[self class] hasCamera:otherCamera];
}

- (void)flipCamera {
  [self flipCameraWithError:nil];
}

- (BOOL)flipCameraWithError:(NSError **)error {
  if (!self.isScanning) {
    if (error) {
      *error = [NSError errorWithDomain:kErrorDomain
                                   code:kErrorCodeNotScanning
                               userInfo:@{NSLocalizedDescriptionKey : @"Camera cannot be flipped when isScanning is NO"}];
    }
    
    return NO;
  }
  
  QRScannerCameraMode otherCamera = [[self class] oppositeCameraOf:self.cameraMode];
  return [self setCamera:otherCamera error:error];
}

#pragma mark - Tap to Focus

- (void)configureTapToFocus {
  if (self.allowFocus) {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTapped:)];
    [self.previewView addGestureRecognizer:tapGesture];
    self.gestureRecognizer = tapGesture;
  }
}

- (void)focusTapped:(UITapGestureRecognizer *)tapGesture {
  CGPoint tapPoint = [self.gestureRecognizer locationInView:self.gestureRecognizer.view];
  CGPoint devicePoint = [self.capturePreviewLayer captureDevicePointOfInterestForPoint:tapPoint];
  
  AVCaptureDevice *device = self.captureDevice;
  NSError *error = nil;
  
  if ([device lockForConfiguration:&error]) {
    if (device.isFocusPointOfInterestSupported &&
        [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
      
      device.focusPointOfInterest = devicePoint;
      device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    }
    [device unlockForConfiguration];
  } else {
    NSLog(@"Failed to acquire lock for focus change: %@", error);
  }
  
  if (self.didFocusBlock) {
    self.didFocusBlock(tapPoint);
  }
}

- (void)stopRecognizingTaps {
  if (self.gestureRecognizer) {
    [self.previewView removeGestureRecognizer:self.gestureRecognizer];
  }
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  if (!self.resultBlock) return;
  
  NSMutableArray *codes = [[NSMutableArray alloc] init];
  
  for (AVMetadataObject *metaData in metadataObjects) {
    AVMetadataMachineReadableCodeObject *barCodeObject = (AVMetadataMachineReadableCodeObject *)[self.capturePreviewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metaData];
    if (barCodeObject) {
      [codes addObject:barCodeObject];
    }
  }
  
  self.resultBlock(codes);
}

#pragma mark - Rotation

- (void)handleApplicationDidChangeStatusBarNotification:(NSNotification *)notification {
  [self refreshVideoOrientation];
}

- (void)refreshVideoOrientation {
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  self.capturePreviewLayer.frame = self.previewView.bounds;
  if ([self.capturePreviewLayer.connection isVideoOrientationSupported]) {
    self.capturePreviewLayer.connection.videoOrientation = [self captureOrientationForInterfaceOrientation:orientation];
  }
}

- (AVCaptureVideoOrientation)captureOrientationForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  switch (interfaceOrientation) {
    case UIInterfaceOrientationPortrait:
      return AVCaptureVideoOrientationPortrait;
    case UIInterfaceOrientationPortraitUpsideDown:
      return AVCaptureVideoOrientationPortraitUpsideDown;
    case UIInterfaceOrientationLandscapeLeft:
      return AVCaptureVideoOrientationLandscapeLeft;
    case UIInterfaceOrientationLandscapeRight:
      return AVCaptureVideoOrientationLandscapeRight;
    default:
      return AVCaptureVideoOrientationPortrait;
  }
}

#pragma mark - Background Handling

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification {
  [self updateForTorchMode:self.torchMode error:nil];
}

#pragma mark - Session Configuration

- (AVCaptureSession *)newSessionWithCaptureDevice:(AVCaptureDevice *)captureDevice error:(NSError **)error {
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:error];
  
  if (!input) {
    return nil;
  }
  
  AVCaptureSession *newSession = [[AVCaptureSession alloc] init];
  [self setDeviceInput:input session:newSession];
  
  [newSession setSessionPreset:AVCaptureSessionPresetHigh];
  
  self.captureOutput = [[AVCaptureMetadataOutput alloc] init];
  [self.captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  
  [newSession addOutput:self.captureOutput];
  self.captureOutput.metadataObjectTypes = self.metaDataObjectTypes;
  
  if (!NSClassFromString(@"AVCapturePhotoOutput")) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.stillImageOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    
    if ([self.stillImageOutput isStillImageStabilizationSupported]) {
      self.stillImageOutput.automaticallyEnablesStillImageStabilizationWhenAvailable = YES;
    }
    
    if ([self.stillImageOutput respondsToSelector:@selector(isHighResolutionStillImageOutputEnabled)]) {
      self.stillImageOutput.highResolutionStillImageOutputEnabled = YES;
    }
    [newSession addOutput:self.stillImageOutput];
#pragma GCC diagnostic pop
  }
  
  dispatch_async(self.privateSessionQueue, ^{
    self.captureOutput.rectOfInterest = [self rectOfInterestFromScanRect:self.scanRect];
  });
  
  self.capturePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:newSession];
  self.capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  self.capturePreviewLayer.frame = self.previewView.bounds;
  
  [newSession commitConfiguration];
  
  return newSession;
}

- (AVCaptureDevice *)newCaptureDeviceWithCamera:(QRScannerCameraMode)camera {
  AVCaptureDevice *newCaptureDevice = nil;
  AVCaptureDevicePosition position = [[self class] devicePositionForCamera:camera];
  
  if (NSClassFromString(@"AVCaptureDeviceDiscoverySession")) {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                                 mediaType:AVMediaTypeVideo
                                                                  position:position];
    newCaptureDevice = device;
  } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in videoDevices) {
      if (device.position == position) {
        newCaptureDevice = device;
        break;
      }
    }
#pragma GCC diagnostic pop
  }
  
  if (!newCaptureDevice) {
    newCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  }
  
  NSError *error = nil;
  if ([newCaptureDevice lockForConfiguration:&error]) {
    if ([newCaptureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
      newCaptureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    }
    [newCaptureDevice unlockForConfiguration];
  } else {
    NSLog(@"Failed to acquire lock for initial focus mode: %@", error);
  }
  
  return newCaptureDevice;
}

+ (AVCaptureDevicePosition)devicePositionForCamera:(QRScannerCameraMode)camera {
  switch (camera) {
    case QRScannerCameraModeFront:
      return AVCaptureDevicePositionFront;
    case QRScannerCameraModeBack:
      return AVCaptureDevicePositionBack;
  }
  
  NSAssert(NO, @"Invalid camera type: %lu", (unsigned long)camera);
  return AVCaptureDevicePositionUnspecified;
}

#pragma mark - Default Values

- (NSArray<NSString *> *)defaultMetaDataObjectTypes {
  NSMutableArray *types = [@[AVMetadataObjectTypeQRCode,
                             AVMetadataObjectTypeUPCECode,
                             AVMetadataObjectTypeCode39Code,
                             AVMetadataObjectTypeCode39Mod43Code,
                             AVMetadataObjectTypeEAN13Code,
                             AVMetadataObjectTypeEAN8Code,
                             AVMetadataObjectTypeCode93Code,
                             AVMetadataObjectTypeCode128Code,
                             AVMetadataObjectTypePDF417Code,
                             AVMetadataObjectTypeAztecCode] mutableCopy];
  
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
    [types addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code,
                                 AVMetadataObjectTypeITF14Code,
                                 AVMetadataObjectTypeDataMatrixCode
                                 ]];
  }
  
  return [types copy];
}

#pragma mark - Helper Methods

- (void)addObservers {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleApplicationDidChangeStatusBarNotification:)
                                               name:UIApplicationDidChangeStatusBarOrientationNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationWillEnterForegroundNotification:)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}

- (void)setupSessionQueue {
  NSAssert(self.privateSessionQueue == NULL, @"Queue should only be set up once");
  
  if (self.privateSessionQueue) {
    return;
  }
  
  self.privateSessionQueue = dispatch_queue_create("com.mikebuss.QRCodeScanner.captureSession", DISPATCH_QUEUE_SERIAL);
}

- (void)setDeviceInput:(AVCaptureDeviceInput *)deviceInput session:(AVCaptureSession *)session {
  if (deviceInput == nil) {
    return;
  }
  
  [self removeDeviceInput:self.currentCaptureDeviceInput session:session];
  
  self.currentCaptureDeviceInput = deviceInput;
  [self updateFocusPreferencesOfDevice:deviceInput.device reset:NO];
  
  [session addInput:deviceInput];
}

- (void)removeDeviceInput:(AVCaptureDeviceInput *)deviceInput session:(AVCaptureSession *)session {
  if (deviceInput == nil) {
    return;
  }
  
  [self updateFocusPreferencesOfDevice:deviceInput.device reset:YES];
  
  [session removeInput:deviceInput];
  self.currentCaptureDeviceInput = nil;
}

- (void)updateFocusPreferencesOfDevice:(AVCaptureDevice *)inputDevice reset:(BOOL)reset {
  NSParameterAssert(inputDevice);
  
  if (!inputDevice) {
    return;
  }
  
  NSError *lockError;
  
  if (![inputDevice lockForConfiguration:&lockError]) {
    NSLog(@"Failed to acquire lock to (re)set focus options: %@", lockError);
    return;
  }
  
  if (inputDevice.isAutoFocusRangeRestrictionSupported) {
    if (!reset) {
      self.initialAutoFocusRangeRestriction = inputDevice.autoFocusRangeRestriction;
      inputDevice.autoFocusRangeRestriction = self.preferredAutoFocusRangeRestriction;
    } else {
      inputDevice.autoFocusRangeRestriction = self.initialAutoFocusRangeRestriction;
    }
  }
  
  if (inputDevice.isFocusPointOfInterestSupported) {
    if (!reset) {
      self.initialFocusPoint = inputDevice.focusPointOfInterest;
      inputDevice.focusPointOfInterest = CGPointMake(kFocalPointOfInterestX, kFocalPointOfInterestY);
    } else {
      inputDevice.focusPointOfInterest = self.initialFocusPoint;
    }
  }
  
  [inputDevice unlockForConfiguration];
  
  [self updateForTorchMode:self.torchMode error:nil];
}

#pragma mark - Torch Control

- (void)setTorchMode:(QRScannerTorchMode)torchMode {
  [self setTorchMode:torchMode error:nil];
}

- (BOOL)setTorchMode:(QRScannerTorchMode)torchMode error:(NSError **)error {
  if ([self updateForTorchMode:torchMode error:error]) {
    _torchMode = torchMode;
    return YES;
  }
  
  return NO;
}

- (void)toggleTorch {
  switch (self.torchMode) {
    case QRScannerTorchModeOn:
      self.torchMode = QRScannerTorchModeOff;
      break;
      
    case QRScannerTorchModeOff:
      self.torchMode = QRScannerTorchModeOn;
      break;
  }
}

- (BOOL)updateForTorchMode:(QRScannerTorchMode)preferredTorchMode error:(NSError **)error {
  AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  AVCaptureTorchMode avTorchMode = [self avTorchModeForMTBTorchMode:preferredTorchMode];
  
  if (!([backCamera isTorchAvailable] && [backCamera isTorchModeSupported:avTorchMode])) {
    if (error) {
      *error = [NSError errorWithDomain:kErrorDomain
                                   code:kErrorCodeTorchModeUnavailable
                               userInfo:@{NSLocalizedDescriptionKey : @"Torch unavailable or mode not supported."}];
    }
    
    return NO;
  }
  
  if (![backCamera lockForConfiguration:error]) {
    NSLog(@"Failed to acquire lock to update torch mode.");
    return NO;
  }
  
  [backCamera setTorchMode:avTorchMode];
  [backCamera unlockForConfiguration];
  
  return YES;
}

- (BOOL)hasTorch {
  AVCaptureDevice *captureDevice = [self newCaptureDeviceWithCamera:self.cameraMode];
  NSError *error = nil;
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
  return input.device.hasTorch;
}

- (AVCaptureTorchMode)avTorchModeForMTBTorchMode:(QRScannerTorchMode)torchMode {
  switch (torchMode) {
    case QRScannerTorchModeOn:
      return AVCaptureTorchModeOn;
      
    case QRScannerTorchModeOff:
      return AVCaptureTorchModeOff;
  }
  
  NSAssert(NO, @"Invalid torch mode: %lu", (unsigned long)torchMode);
  return AVCaptureTorchModeOff;
}

#pragma mark - Capture

- (void)freezeCapture {
  self.capturePreviewLayer.connection.enabled = NO;
  self -> _isFreezeCapture = YES;
  dispatch_async(self.privateSessionQueue, ^{
    [self.session stopRunning];
  });
}

- (void)unfreezeCapture {
  if (!self.session) {
    return;
  }
  
  self.capturePreviewLayer.connection.enabled = YES;
  self -> _isFreezeCapture = NO;
  
  if (!self.session.isRunning) {
    [self setDeviceInput:self.currentCaptureDeviceInput session:self.session];
    dispatch_async(self.privateSessionQueue, ^{
      [self.session startRunning];
    });
  }
}


- (void)captureStillImage:(void (^)(UIImage *image, NSError *error))captureBlock {
  if ([self isCapturingStillImage]) {
    if (captureBlock) {
      NSError *error = [NSError errorWithDomain:kErrorDomain
                                           code:kErrorCodeStillImageCaptureInProgress
                                       userInfo:@{NSLocalizedDescriptionKey : @"Still image capture is already in progress. Check with isCapturingStillImage"}];
      captureBlock(nil, error);
    }
    return;
  }
  
  if (NSClassFromString(@"AVCapturePhotoOutput")) {
    AVCapturePhotoSettings *settings = [AVCapturePhotoSettings photoSettings];
    AVCapturePhotoOutput *output = [[AVCapturePhotoOutput alloc] init];
    [self.session addOutput:output];
    self.stillImageCaptureBlock = captureBlock;
    [output capturePhotoWithSettings:settings delegate:self];
  } else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    AVCaptureConnection *stillConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (stillConnection == nil) {
      if (captureBlock) {
        NSError *error = [NSError errorWithDomain:kErrorDomain
                                             code:kErrorCodeSessionIsClosed
                                         userInfo:@{NSLocalizedDescriptionKey : @"AVCaptureConnection is closed"}];
        captureBlock(nil, error);
      }
      return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillConnection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                         if (error) {
                                                           captureBlock(nil, error);
                                                           return;
                                                         }
                                                         
                                                         NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                         UIImage *image = [UIImage imageWithData:jpegData];
                                                         if (captureBlock) {
                                                           captureBlock(image, nil);
                                                         }
                                                       }];
#pragma GCC diagnostic pop
  }
}

#pragma mark - AVCapturePhotoCaptureDelegate

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error {
  NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
  UIImage *image = nil;
  if (data) {
    image = [UIImage imageWithData:data];
  }
  
  if (self.stillImageCaptureBlock) {
    self.stillImageCaptureBlock(image, error);
  }
  
  [self.session removeOutput:captureOutput];
}

- (BOOL)isCapturingStillImage {
  return self.stillImageOutput.isCapturingStillImage;
}

#pragma mark - Setters

- (void)setCamera:(QRScannerCameraMode)camera {
  [self setCamera:camera error:nil];
}

- (BOOL)setCamera:(QRScannerCameraMode)camera error:(NSError **)error {
  if (camera == _cameraMode) {
    return YES;
  }
  
  if (!self.isScanning) {
    if (error) {
      *error = [NSError errorWithDomain:kErrorDomain
                                   code:kErrorCodeNotScanning
                               userInfo:@{NSLocalizedDescriptionKey : @"Camera cannot be set when isScanning is NO"}];
    }
    
    return NO;
  }
  
  AVCaptureDevice *captureDevice = [self newCaptureDeviceWithCamera:camera];
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:error];
  
  if (!input) {
    // we rely on deviceInputWithDevice:error to populate the error in this case
    return NO;
  }
  
  [self setDeviceInput:input session:self.session];
  _cameraMode = camera;
  
  return YES;
}

- (void)setScanRect:(CGRect)scanRect {
  NSAssert(!CGRectIsEmpty(scanRect), @"Unable to set an empty rectangle as the scanRect of QRCodeScanner");
  NSAssert(self.isScanning, @"Scan rect cannot be set when not (yet) scanning. You may want to set it within didStartScanningBlock.");
  
  if (!self.isScanning) {
    return;
  }
  
  [self refreshVideoOrientation];
  
  _scanRect = scanRect;
  
  dispatch_async(self.privateSessionQueue, ^{
    self.captureOutput.rectOfInterest = [self.capturePreviewLayer metadataOutputRectOfInterestForRect:_scanRect];
  });
}

- (void)setPreferredAutoFocusRangeRestriction:(AVCaptureAutoFocusRangeRestriction)preferredAutoFocusRangeRestriction {
  if (preferredAutoFocusRangeRestriction == _preferredAutoFocusRangeRestriction) {
    return;
  }
  
  _preferredAutoFocusRangeRestriction = preferredAutoFocusRangeRestriction;
  
  if (!self.currentCaptureDeviceInput) {
    return;
  }
  
  [self updateFocusPreferencesOfDevice:self.currentCaptureDeviceInput.device reset:NO];
}

#pragma mark - Getters

- (CALayer *)previewLayer {
  return self.capturePreviewLayer;
}

#pragma mark - Helper Methods

- (CGRect)rectOfInterestFromScanRect:(CGRect)scanRect {
  CGRect rect = CGRectZero;
  if (!CGRectIsEmpty(self.scanRect)) {
    rect = [self.capturePreviewLayer metadataOutputRectOfInterestForRect:self.scanRect];
  } else {
    rect = CGRectMake(0, 0, 1, 1); // Default rectOfInterest for AVCaptureMetadataOutput
  }
  return rect;
}

@end
