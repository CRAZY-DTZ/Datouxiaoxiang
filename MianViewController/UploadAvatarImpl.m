//
//  UploadAvatarImpl.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/10/9.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "UploadAvatarImpl.h"

@implementation UploadAvatarImpl {
    MBProgressHUD * _mbpHUD;
    NetworkManager * _networkManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    _networkManager = [NetworkManager sharedInstance];
    return self;
}

- (void)downloadAndSettingAvaImageWithStateImageWithIconlink:(NSString *)iconlink {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    SDWebImageDownloader * downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:iconlink]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (error) {
                                   //返回错误
                                   _mbpHUD.labelText = @"网络故障";
                                   dispatch_after(popTime, dispatch_get_main_queue(), ^{
                                       [MBProgressHUD hideHUDForView:self.mainViewController.view animated:YES];
                                   });
                               }
                               if (image && finished) {
                                   UIImage * cacheImage = image;
                                   //保存机制 获取到state和image设置在mainviewcontroller的dtxxmodel 中.
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       //下载 bfimage
                                       self.mainViewController.currentAvatarImage = cacheImage;
                                       [self.mainViewController updateAvatarImageWithCacheImage:cacheImage];
                                   });
                               }
                           }];
}

- (void)uploadAvatarWithImage:(UIImage *)image DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock{
    _networkManager = [NetworkManager sharedInstance];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    [_networkManager getQiNiuTokenWithDtzSuccessblock:^(NSDictionary *successBlock) {
        NSString * key = [successBlock objectForKey:@"key"];
        if (key) {
            [[NSUserDefaults standardUserDefaults]setObject:key forKey:@"key"];
        }
        NSString * uptoken = [successBlock objectForKey:@"uptoken"];
        if (uptoken) {
            [[NSUserDefaults standardUserDefaults] setObject:uptoken forKey:@"uptoken"];
        }
        [_networkManager uploadAvatarToQNserverWithImageData:imageData Key:key UploadToken:uptoken DtzSuccessBlock:^(NSDictionary *successBlock) {
            NSString * avatarUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"originalAvaUrl"];
            if (avatarUrl) {
                // 下载带有状态的头像到本地 并且更换.
                [self updateAvaImageAndBFImageWithOriginalUrl:avatarUrl];
            }
            dtzSuccessBlock(nil);
        } DtzFailBlock:^(NSError *failBlock) {
            _mbpHUD = [MBProgressHUD showHUDAddedTo:self.mainViewController.view animated:YES];
            _mbpHUD.labelText = @"服务器故障";
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.mainViewController.view animated:YES];
            });
            dtzFailBlock(nil);
        }];
    } DtzFailBlock:^(NSError *failBlock) {
        _mbpHUD = [MBProgressHUD showHUDAddedTo:self.mainViewController.view animated:YES];
        _mbpHUD.labelText = @"服务器故障";
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.mainViewController.view animated:YES];
        });
        dtzFailBlock(nil);
    }];
}

- (void)updateAvaImageAndBFImageWithOriginalUrl:(NSString *)url {
    //用新的icon url 来获取大字图 .
    _mbpHUD = [MBProgressHUD showHUDAddedTo:self.mainViewController.view animated:YES];
    _mbpHUD.labelText = @"正在加载";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    if (url) {
        [_networkManager getUrlWithImageUrlStr:url Status:self.mainViewController.avatarState Type:1 DtzSuccessBlock:^(NSDictionary *successBlock) {
            NSNumber * code = [successBlock objectForKey:@"code"];
            if (code.intValue == 0) {
                NSString * iconlink = [successBlock objectForKey:@"icon_link"];
                if (iconlink) {
                    iconlink = [QNDomain stringByAppendingString:[NSString stringWithFormat:@"//%@",iconlink]];
                    // 下载头像到本地
                    // 先生成第一个款头像到本地
                    [self downloadAndSettingAvaImageWithStateImageWithIconlink:iconlink];
                }
                NSString * dzLink = [successBlock objectForKey:@"dazi_link"];
                if (dzLink) {
                    dzLink = [QNDomain stringByAppendingString:[NSString stringWithFormat:@"//%@",dzLink]];
                    [[NSUserDefaults standardUserDefaults]setObject:dzLink forKey:@"bgimage"];
                    [self downloadBFImageWithDZLink:dzLink];
                }
            }
        } DtzFailBlock:^(NSError *failBlock) {
            NSLog(@"获取 大字图 失败");
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.mainViewController.view animated:YES];
            });
        }];
    }
}

- (void)downloadBFImageWithDZLink:(NSString *)dzLink {
    // 需要缓存
    if (dzLink) {
        // 先判断 缓存中是否存在该图片 如果存在就不需要再去 找了
        SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        [downloader downloadImageWithURL:[NSURL URLWithString:dzLink]
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                }
                               completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                   if (error) {
                                       //返回错误
                                       NSLog(@"%@",error);
                                   }
                                   if (image && finished) {
                                       UIImage * cacheImage = image;
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [MBProgressHUD hideHUDForView:self.mainViewController.view animated:YES];
                                           self.mainViewController.currentBFImage = cacheImage;
                                           [self.mainViewController updateBfImageWithCacheImage:cacheImage];
                                       });
                                   }
                               }];
    }
}



@end
