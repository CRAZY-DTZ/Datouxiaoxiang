//
//  AppDelegate.h
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/29.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window ;

@property (strong, nonatomic) MainViewController * mainViewController ;

- (void)setMainViewcontroller ;

- (void)setSignInVC ;

- (void)setPhoneLoginMainViewcontroller ;

@property int isMainVC ;

@end

