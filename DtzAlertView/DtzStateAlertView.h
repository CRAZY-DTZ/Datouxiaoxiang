//
//  DtzStateAlertView.h
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/30.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DtzStateAlertViewDelegate <NSObject>

@optional
- (void)clickStateBtnsWithTag:(NSInteger)tag;

@end

@interface DtzStateAlertView : UIView

@property (strong, nonatomic) id<DtzStateAlertViewDelegate> delegate;

@property BOOL isPresented;

- (void)createBtns;

@property (strong, nonatomic) NSArray * statuslist;

@property BOOL isCompeleted;

@end
