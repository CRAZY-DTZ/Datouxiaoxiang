//
//  StateIconManager.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/10/10.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "StateIconManager.h"

@implementation StateIconManager {
    NetworkManager * _networkManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    _networkManager = [NetworkManager sharedInstance];
    return self;
}

- (void)getStateArrayWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    [_networkManager getIconListWithDtzSuccessBlock:^(NSDictionary *successBlock) {
        NSNumber * code = [successBlock objectForKey:@"code"];
        if (code.intValue == 0) {
            NSArray * status_list = [successBlock objectForKey:@"status_list"];
            [[NSUserDefaults standardUserDefaults] setObject:status_list forKey:@"status_list"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self downloadIconlistWithArray:status_list];
        }
        dtzSuccessBlock(successBlock);
    } DtzFailBlock:^(NSError *failBlock) {
        
    }];
}

- (void)clearCache {
    //清楚缓存的 图片.
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)downloadIconlistWithArray:(NSArray *)statuslist{
    for (int i = 0;i < statuslist.count; i ++) {
        NSDictionary * dic = [statuslist objectAtIndex:i];
        [self downloadIconWithDictionary:dic Index:i Count:(int)statuslist.count];
    }
}

- (void)downloadIconWithDictionary:(NSDictionary *)iconDic Index:(int)index Count:(int)count{
    NSString * iconUrl = [iconDic objectForKey:@"link"];
    NSString * name = [iconDic objectForKey:@"name"];
    iconUrl = [iconUrl stringByAppendingString:@"?imageView2/1/w/60/h/60/q/75/format/png"];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:iconUrl]
                                                          options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                              
                                                          }
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            if (image && finished) {
                                                                [[SDImageCache sharedImageCache] storeImage:image forKey:name];
                                                                if (index == count - 1) {
                                                                    
                                                                }
                                                            }
                                                            if (error) {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    self.mainVC.isIconlistDone = NO;
                                                                });
                                                            }
    }];
    
}




@end
