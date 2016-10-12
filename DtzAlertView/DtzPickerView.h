//
//  DtzPickerView.h
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/10/7.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DtzPickerViewDelegate <NSObject>

@optional
- (void)clickPickerWithTag:(NSInteger)tag;

@end

@interface DtzPickerView : UIView

@property (strong, nonatomic) id<DtzPickerViewDelegate> delegate;

@property BOOL isPresented;

- (void)createBtns;

@end
