//
//  UploadAvatarImpl.h
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/10/9.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

@interface UploadAvatarImpl : NSObject

@property (strong, nonatomic ) MainViewController * mainViewController;

- (id)init ;

- (void)uploadAvatarWithImage:(UIImage *)image DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock;

- (void)downloadBFImageWithDZLink:(NSString *)dzLink;

- (void)updateAvaImageAndBFImageWithOriginalUrl:(NSString *)url ;


@end
