//
//  NetworkManager.h
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/29.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

#define baseUrl @"http://xiaoxiang.mklaus.cn"
#define QNDomain @"http://dtxx.mklaus.cn"
#define newBaseUrl @"http://datou.mklaus.cn"

typedef void (^ DtzSuccessBlock)(NSDictionary * successBlock);
typedef void (^ DtzFailBlock)(NSError * failBlock);

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

@property (strong, nonatomic) AFHTTPRequestOperationManager * httpManager;

- (void)getQiNiuTokenWithDtzSuccessblock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock ;

- (void)uploadAvatarToQNserverWithImageData:(NSData *)imageData Key:(NSString *)key UploadToken:(NSString *)uploadToken DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock;

- (void)wechatLoginByRequestForUserInfoWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock ;

- (void)sendVerCodeWithMobile:(NSString *)mobile DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock ;

- (void)userLoginWithMobile:(NSString *)mobile Code:(NSString *)code DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock ;

- (void)getUrlWithImageUrlStr:(NSString *)imageUrlStr Status:(int)status Type:(int)type DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock;

- (void)refreshToken ;

- (void)getLinkWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock;

- (void)getIconListWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock ;

- (void)uploadUsinfoToServerWithUnionId:(NSString *)unionId DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock ;

- (void)getMoreLinkWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock ;

- (void)getLinkUpdateTimeWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock ;

@end
