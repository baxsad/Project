//
//  YGBQRCodeScanScene.m
//  Project
//
//  Created by jearoc on 2017/9/22.
//  Copyright © 2017年 jearoc. All rights reserved.
//

#import "YGBQRCodeScanScene.h"
#import "QRCodeScanner.h"

@interface YGBQRCodeScanScene ()
@property (nonatomic, strong) UIView *scanPreview;
@property (nonatomic, strong) QRCodeScanner *scanner;
@end

@implementation YGBQRCodeScanScene

- (void)viewDidLoad {
  [super viewDidLoad];
  self.titleView.title = @"二维码/条码";
  
#pragma mark - setup
  [self _setupScanPriview];
  [self _setupScanner];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated
{
  [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
  UIBarButtonItem *xc = [UINavigationButton barButtonItemWithType:UINavigationButtonTypeNormal
                                                            title:@"相册"
                                                         position:UINavigationButtonPositionRight
                                                           target:self
                                                           action:@selector(openAlbum)];
  self.navigationItem.rightBarButtonItem = xc;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (self.scanner.isFreezeCapture) {
    [self.scanner unfreezeCapture];
  }else {
    [QRCodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
      if (success) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          __strong typeof(self) strongSelf = weakSelf;
          [strongSelf startScanning];
        });
      } else {
        [self displayPermissionMissingAlert];
      }
    }];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  if (!self.scanner.isFreezeCapture) {
    [self.scanner freezeCapture];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self stopScanning];
}

#pragma mark - setup UI

- (void)_setupScanPriview
{
  @weakify(self);
  if (_scanPreview == nil) {
    _scanPreview = [UIView new];
    _scanPreview.backgroundColor = NavBarBarTintColor;
    _scanPreview.clipsToBounds = YES;
  }
  if (_scanPreview.superview == nil) {
    [self.view addSubview:_scanPreview];
    [_scanPreview mas_makeConstraints:^(MASConstraintMaker *make) {
      @strongify(self);
      make.left.right.and.top.bottom.equalTo(self.view).offset(0);
    }];
  }
}

#pragma mark - setup Scanner

- (void)_setupScanner
{
  if (_scanner == nil) {
    _scanner = [[QRCodeScanner alloc] initWithPreviewView:_scanPreview];
  }
}

#pragma mark - Scan

- (void)startScanning {
  NSError *error = nil;
  [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
    for (AVMetadataMachineReadableCodeObject *code in codes) {
      if (code.stringValue) {
        NSLog(@"扫描结果: %@",code.stringValue);
      }
    }
  } error:&error];
  
  if (error) {
    NSLog(@"扫描错误: %@", error.localizedDescription);
  }
}

- (void)stopScanning {
  [self.scanner stopScanning];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)displayPermissionMissingAlert {
  NSString *message = nil;
  if ([QRCodeScanner scanningIsProhibited]) {
    message = @"程序未授权使用相机";
  } else if (![QRCodeScanner cameraIsPresent]) {
    message = @"设备没有摄像头";
  } else {
    message = @"未知错误";
  }
  
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"失败"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认"
                                                   style:UIAlertActionStyleDefault
                                                 handler:nil];
  [alertController addAction:action];
  [self presentViewController:alertController
                     animated:YES
                   completion:nil];
}

#pragma mark -

- (void)openAlbum
{
  
}

@end
