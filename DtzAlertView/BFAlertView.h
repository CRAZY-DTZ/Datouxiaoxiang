//
//  BFAlertView.h
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/10/3.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BFAlertViewDelegate <NSObject>

@optional
- (void)clickBFBtnWithTag:(NSInteger)tag;

@end

@interface BFAlertView : UIView

@property (strong, nonatomic) id<BFAlertViewDelegate> delegate;

@property BOOL isPresented;

- (void)createBtns;

@end
