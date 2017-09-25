//
//  UIScene.m
//  XX_iOS_APP
//
//  Created by pmo on 2017/8/16.
//  Copyright © 2017年 pmo. All rights reserved.
//

#import "UIScene.h"
#import "UIScene+UI.h"
#import "UINavigationScene.h"
#import "UIKeyboardManager.h"

@interface UISceneHideKeyboardDelegateObject : NSObject <UIGestureRecognizerDelegate, UIKeyboardManagerDelegate>
@property(nonatomic, weak) UIScene *scene;
- (instancetype)initWithScene:(UIScene *)scene;
@end

@interface UIScene (){
  UITapGestureRecognizer *_hideKeyboardTapGestureRecognizer;
  UIKeyboardManager *_hideKeyboardManager;
  UISceneHideKeyboardDelegateObject *_hideKeyboadDelegateObject;
}
@property(nonatomic,strong,readwrite) UINavigationTitleView *titleView;
@end

@implementation UIScene
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - 生命周期

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [self didInitialized];
  }
  return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self didInitialized];
  }
  return self;
}
- (void)didInitialized
{
  self.titleView = [[UINavigationTitleView alloc] init];
  self.titleView.title = self.title;
  
  self.hidesBottomBarWhenPushed = HidesBottomBarWhenPushedInitially;
  self.extendedLayoutIncludesOpaqueBars = YES;
  self.automaticallyAdjustsScrollViewInsets = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(contentSizeCategoryDidChanged:)
                                               name:UIContentSizeCategoryDidChangeNotification
                                             object:nil];
  self.autorotate = NO;
  self.supportedOrientationMask = UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setNavigationItemsIsInEditMode:NO animated:NO];
  [self setToolbarItemsIsInEditMode:NO animated:NO];
}

- (void)setTitle:(NSString *)title {
  [super setTitle:title];
  self.titleView.title = title;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!self.view.backgroundColor) {
    UIColor *backgroundColor = UIColorForBackground;
    if (backgroundColor) {
      self.view.backgroundColor = backgroundColor;
    }
  }
  
  _hideKeyboadDelegateObject = [[UISceneHideKeyboardDelegateObject alloc] initWithScene:self];
  _hideKeyboardTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL];
  self.hideKeyboardTapGestureRecognizer.delegate = _hideKeyboadDelegateObject;
  self.hideKeyboardTapGestureRecognizer.enabled = NO;
  [self.view addGestureRecognizer:self.hideKeyboardTapGestureRecognizer];
  _hideKeyboardManager = [[UIKeyboardManager alloc] initWithDelegate:_hideKeyboadDelegateObject];
  
  [self initSubviews];
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
  return self.autorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return self.supportedOrientationMask;
}

#pragma mark - <UINavigationControllerDelegate>

- (BOOL)shouldSetStatusBarStyleLight {
  return StatusbarStyleLightInitially;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return StatusbarStyleLightInitially ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (BOOL)preferredNavigationBarHidden {
  return NavigationBarHiddenInitially;
}

- (void)viewControllerKeepingAppearWhenSetViewControllersWithAnimated:(BOOL)animated {
  [self setNavigationItemsIsInEditMode:NO animated:NO];
  [self setToolbarItemsIsInEditMode:NO animated:NO];
}

#pragma clang diagnostic pop
@end

@implementation UIScene (UIKeyboard)
- (UITapGestureRecognizer *)hideKeyboardTapGestureRecognizer {
  return _hideKeyboardTapGestureRecognizer;
}
- (UIKeyboardManager *)hideKeyboardManager {
  return _hideKeyboardManager;
}
- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
  return NO;
}
@end

@implementation UISceneHideKeyboardDelegateObject

- (instancetype)initWithScene:(UIScene *)scene {
  if (self = [super init]) {
    self.scene = scene;
  }
  return self;
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer != self.scene.hideKeyboardTapGestureRecognizer) {
    return YES;
  }
  
  if (![UIKeyboardManager isKeyboardVisible]) {
    return NO;
  }
  
  UIView *targetView = nil;
  CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
  targetView = [gestureRecognizer.view hitTest:location withEvent:nil];
  
  // 点击了本身就是输入框的 view，就不要降下键盘了
  if ([targetView isKindOfClass:[UITextField class]] || [targetView isKindOfClass:[UITextView class]]) {
    return NO;
  }
  
  if ([self.scene shouldHideKeyboardWhenTouchInView:targetView]) {
    [self.scene.view endEditing:YES];
  }
  return NO;
}

#pragma mark - <QMUIKeyboardManagerDelegate>

- (void)keyboardWillShowWithUserInfo:(UIKeyboardUserInfo *)keyboardUserInfo {
  if (![self.scene isViewLoadedAndVisible]) return;
  BOOL hasOverrideMethod = [self.scene hasOverrideMethod:@selector(shouldHideKeyboardWhenTouchInView:) ofSuperclass:[UIScene class]];
  self.scene.hideKeyboardTapGestureRecognizer.enabled = hasOverrideMethod;
}

- (void)keyboardWillHideWithUserInfo:(UIKeyboardUserInfo *)keyboardUserInfo {
  self.scene.hideKeyboardTapGestureRecognizer.enabled = NO;
}

@end
