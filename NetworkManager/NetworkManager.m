//
//  NetworkManager.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/29.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "NetworkManager.h"
#import <QiniuSDK.h>


//https://api.weixin.qq.com/sns/userinfo
#define WX_BASE_URL @"https://api.weixin.qq.com/sns/userinfo"

#define WX_Refresh @"https://api.weixin.qq.com/sns"

#define appSecret @"9bb1075fbea6f762bd94395f2425bf52"
#define appId @"wx8ba83c31e91faa23"

@implementation NetworkManager

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

+ (NetworkManager *)sharedInstance {
    static NetworkManager * _instance = nil;
    @synchronized (self) {
        if (!_instance) {
            _instance = [[NetworkManager alloc]
                         init];
            _instance.httpManager = [[AFHTTPRequestOperationManager alloc]init];
            _instance.httpManager.requestSerializer.timeoutInterval = 60;
            return _instance;
        }
    }
    return _instance;
}

#pragma mark - userLogin
///auth/code/send
- (void)sendVerCodeWithMobile:(NSString *)mobile DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    NSString * requestUrl = @"/auth/code/send";
    requestUrl = [baseUrl stringByAppendingString:requestUrl];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    params[@"mobile"] = mobile;
//    params[@"state"] = [NSNumber numberWithInt:1];
    [self.httpManager POST:requestUrl parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSNumber * code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
            dtzSuccessBlock(responseObject);
        }else {
            dtzFailBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        dtzFailBlock(nil);
    }];
}

- (void)userLoginWithMobile:(NSString *)mobile Code:(NSString *)code DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    NSString * requestUrl = @"/auth/token";
    requestUrl = [baseUrl stringByAppendingString:requestUrl];
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:code forKey:@"code"];
    [self.httpManager POST:requestUrl parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSNumber * code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
            dtzSuccessBlock(responseObject);
        }else {
            dtzFailBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        dtzFailBlock(nil);
    }];
}

#pragma mark - QN UPLOAD
- (void)getQiNiuTokenWithDtzSuccessblock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    NSString * requestUrl = @"/qiniu/uptoken";
    requestUrl = [baseUrl stringByAppendingString:requestUrl];
    [self.httpManager POST:requestUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSNumber * code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
            //回调成功
            dtzSuccessBlock(responseObject);
        }else {
            dtzFailBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        dtzFailBlock(nil);
    }];
}

- (void)uploadAvatarToQNserverWithImageData:(NSData *)imageData Key:(NSString *)key UploadToken:(NSString *)uploadToken DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    QNUploadManager * upManager = [[QNUploadManager alloc]init];
    [upManager putData:imageData key:key token:uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.statusCode == 200) {
            //返回成功
            NSString * avatarUrl = [QNDomain stringByAppendingString:[NSString stringWithFormat:@"//%@",key]];
            [[NSUserDefaults standardUserDefaults]setObject:avatarUrl forKey:@"originalAvaUrl"];
            dtzSuccessBlock(nil);
        }
    } option:nil];
}

// AppDelegate.m
// 获取用户个人信息（UnionID机制）
- (void)wechatLoginByRequestForUserInfoWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setTimeoutInterval:10];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
//    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
//    if (accessToken) {
//        NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:@"openID"];
//        NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
//        [params setObject:accessToken forKey:@"access_token"];
//        [params setObject:openID forKey:@"openid"];
//        [manager GET:WX_BASE_URL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSString * headimgurl = responseData[@"headimgurl"];
//            NSString * nickname = responseData[@"nickname"];
//            NSString * language = responseData[@"language"];
//            [[NSUserDefaults standardUserDefaults]setObject:headimgurl forKey:@"photo"];
//            [[NSUserDefaults standardUserDefaults]setObject:headimgurl forKey:@"originalAvaUrl"];
//            [[NSUserDefaults standardUserDefaults]setObject:nickname forKey:@"nickname"];
//            [[NSUserDefaults standardUserDefaults]setObject:language forKey:@"language"];
//            dtzSuccessBlock(responseData);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//            dtzFailBlock(nil);
//        }];
//    }
}

- (void)getUrlWithImageUrlStr:(NSString *)imageUrlStr Status:(int)status Type:(int)type DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:10];
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSString * requestUrl = @"/image/convert";
    requestUrl = [baseUrl stringByAppendingString:requestUrl];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * nickname = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
    [params setObject:imageUrlStr forKey:@"link"];
    [params setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [params setObject:@"大头小像" forKey:@"nickname"];
    if (nickname) {
        [params setObject:nickname forKey:@"nickname"];
    }
    [self.httpManager POST:requestUrl parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber * code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
            dtzSuccessBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        dtzFailBlock(nil);
    }];
}

- (void)refreshToken {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *openID = [[NSUserDefaults standardUserDefaults] objectForKey:@"openID"];
    // 如果已经请求过微信授权登录，那么考虑用已经得到的access_token
    https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=APPID&grant_type=refresh_token&refresh_token=REFRESH_TOKEN
    if (accessToken && openID) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:10];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        NSString *refreshToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refreshToken"];
        NSString *refreshUrlStr = [NSString stringWithFormat:@"%@/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@", WX_Refresh, appId, refreshToken];
        [manager GET:refreshUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"请求reAccess的response = %@", responseObject);
            NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *refreshDict = [NSDictionary dictionaryWithDictionary:responseData];
            NSString *reAccessToken = [refreshDict objectForKey:@"access_token"];
            // 如果reAccessToken为空,说明reAccessToken也过期了,反之则没有过期
            if (reAccessToken) {
                // 更新access_token、refresh_token、open_id
                [[NSUserDefaults standardUserDefaults] setObject:reAccessToken forKey:@"accessToken"];
                [[NSUserDefaults standardUserDefaults] setObject:[refreshDict objectForKey:@"refresh_token"] forKey:@"refreshToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // 当存在reAccessToken不为空时直接执行AppDelegate中的wechatLoginByRequestForUserInfo方法
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatLoginSuccess" object:nil];
            }
            else {
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"用refresh_token来更新accessToken时出错 = %@", error);
        }];
    }
}

- (void)getLinkWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    NSString * requestUrl = @"/more";
    requestUrl = [baseUrl stringByAppendingString:requestUrl];
}

- (void)uploadUsinfoToServerWithUnionId:(NSString *)unionId DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    NSString * requestUrl = @"/wechat/userinfo";
    requestUrl = [baseUrl stringByAppendingString:requestUrl];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    if (unionId) {
        [params setObject:unionId forKey:@"unionid"];
    }
    [self.httpManager POST:requestUrl parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber * code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
            NSDictionary * userDic = [responseObject objectForKey:@"user"];
            NSString * nickname = [userDic objectForKey:@"nickname"];
            NSString * headimgurl = [userDic objectForKey:@"headimgurl"];
            if (nickname) {
                [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];
            }
            if (headimgurl) {
                [[NSUserDefaults standardUserDefaults]setObject:headimgurl forKey:@"photo"];
                [[NSUserDefaults standardUserDefaults]setObject:headimgurl forKey:@"originalAvaUrl"];
            }
            dtzSuccessBlock(responseObject);
            
        }else {
            dtzFailBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        dtzFailBlock(nil);
    }];
}

- (void)getShareLinkWithUnionId:(NSString *)unionId DtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    NSString * requestUrl = @"/share/link";
    requestUrl = [baseUrl stringByAppendingString:requestUrl];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:unionId forKey:@"unionid"];
    [self.httpManager POST:requestUrl parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        dtzSuccessBlock(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        dtzFailBlock(nil);
    }];
}

- (void)getLinkUpdateTimeWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    NSString * requestUrl = @"/updatetime";
    requestUrl = [newBaseUrl stringByAppendingString:requestUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager GET:requestUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSNumber * code = [responseData objectForKey:@"code"];
        if (code.intValue == 0) {
            NSNumber * updateTime = [responseData objectForKey:@"updatetime"];
            [[NSUserDefaults standardUserDefaults] setObject:updateTime forKey:@"newUpdateTime"];
            dtzSuccessBlock(responseData);
        }else {
            dtzFailBlock(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dtzFailBlock(nil);
    }];
}

- (void)getMoreLinkWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    NSString * requestUrl = @"/more";
    requestUrl = [baseUrl stringByAppendingString:requestUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager GET:requestUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        NSString* html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [[NSUserDefaults standardUserDefaults]setObject:html forKey:@"html"];
        dtzSuccessBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dtzFailBlock(nil);
    }];
}

- (void)getIconListWithDtzSuccessBlock:(DtzSuccessBlock)dtzSuccessBlock DtzFailBlock:(DtzFailBlock)dtzFailBlock {
    NSString * requestUrl = @"/icon/list";
    requestUrl = [baseUrl stringByAppendingString:requestUrl];
    [self.httpManager POST:requestUrl parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSNumber * code = [responseObject objectForKey:@"code"];
        if (code.intValue == 0) {
            dtzSuccessBlock(responseObject);
        }else {
            dtzFailBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        dtzFailBlock(nil);
    }];
}

@end
