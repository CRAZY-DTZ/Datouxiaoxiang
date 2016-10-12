//
//  StateIconManager.h
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/10/10.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

@interface StateIconManager : NSObject

- (id)init ;

- (void)saveStateIconWithDictionary:(NSMutableDictionary *)stateIconDictionary ;

- (void)clearCache;

- (void)getStateArray ;

@property (strong , nonatomic) MainViewController * mainVC;

- (void)getStateArrayWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock ;

@end
