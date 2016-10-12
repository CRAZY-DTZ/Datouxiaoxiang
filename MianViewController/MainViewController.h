//
//  MainViewController.h
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/29.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DtzAlertView.h"

@interface MainViewController : UIViewController

@property int avatarState;

- (void)setWechatInfo;

- (void)updateBfImageWithCacheImage:(UIImage *)cacheImage;

- (void)updateAvatarImageWithCacheImage:(UIImage *)cacheImage;

- (void)changeAlertViewAppearenceWithAlert:(DtzAlertView *)dtzAlertView;

- (void)changeStateWithState:(int)state BFImage:(UIImage *)bfImage;

@property (strong, nonatomic) UIImage * currentAvatarImage;

@property (strong, nonatomic) UIImage * currentBFImage;

@property BOOL isWechatLogin;

@property BOOL isIconlistDone;

@property BOOL isAvatarDone;

@property BOOL isBFDone;

@end
