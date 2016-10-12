//
//  DtzAlertView.h
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/30.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DtzAlertViewDelegate <NSObject>

@optional
- (void)clickButtonWithTag:(NSInteger)tag;

@end

@interface DtzAlertView : UIView

@property BOOL isPresented;

@property (strong, nonatomic) id<DtzAlertViewDelegate> delegate;

- (void)createBtns;

@end
