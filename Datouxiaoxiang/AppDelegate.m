//
//  AppDelegate.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/29.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "WXApi.h"
#import "SignInVC.h"
#import <AFNetworking.h>
#import <IQKeyboardManager.h>

#define appSecret @"9bb1075fbea6f762bd94395f2425bf52"
#define appId @"wx8ba83c31e91faa23"

@interface AppDelegate () <WXApiDelegate> {
    SignInVC * _signInVC;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [IQKeyboardManager sharedManager] .enable = YES;
    [WXApi registerApp:appId withDescription:@"Wechat"];

    // 判断是手机登陆还是 微信登陆 还是没有登陆过 ...  获取
    NSString * unionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"unionid"];
    if (unionId) {
        MainViewController * mainVC = [[MainViewController alloc]init];
        UINavigationController * navigator = [[UINavigationController alloc]initWithRootViewController:mainVC];
        mainVC.isWechatLogin = YES;
        self.window.rootViewController = navigator;
    }else {
        NSString * mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"];
        if (mobile) {
            MainViewController * mainVC = [[MainViewController alloc]init];
            UINavigationController * navigator = [[UINavigationController alloc]initWithRootViewController:mainVC];
            self.window.rootViewController = navigator;
        }else {
            SignInVC * signInVC = [[SignInVC alloc]init];
            UINavigationController * signInNavigator = [[UINavigationController alloc]initWithRootViewController:signInVC];
            self.window.rootViewController = signInNavigator;
        }
    }
    return YES;
}

- (void)setPhoneLoginMainViewcontroller {
    MainViewController * mainVC = [[MainViewController alloc]init];
    UINavigationController * navigator = [[UINavigationController alloc]initWithRootViewController:mainVC];
    mainVC.isWechatLogin = NO;
    self.window.rootViewController = navigator;
}

- (void)setMainViewcontroller {
    MainViewController * mainVC = [[MainViewController alloc]init];
    UINavigationController * navigator = [[UINavigationController alloc]initWithRootViewController:mainVC];
    mainVC.isWechatLogin = YES;
    self.window.rootViewController = navigator;
}

- (void)setSignInVC {
    SignInVC * signInVC = [[SignInVC alloc]init];
    UINavigationController * navigator = [[UINavigationController alloc]initWithRootViewController:signInVC];
    self.window.rootViewController = navigator;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // 判断是来自 WeChat 还是Weibo 的请求。
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onReq:(BaseReq *)req {
    NSLog(@"ddd");
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        NSString *code = aresp.code;
        if (code) {
            NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",appId,appSecret,code];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *zoneUrl = [NSURL URLWithString:url];
                NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data){
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        NSString *openID = dic[@"openid"];
                        NSString *unionid = dic[@"unionid"];
                        NSString * refresh_token = dic[@"refresh_token"];
                        NSString * access_token = dic[@"access_token"];
                        [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:@"accessToken"];
                        [[NSUserDefaults standardUserDefaults] setObject:refresh_token forKey:@"refreshToken"];
                        [[NSUserDefaults standardUserDefaults] setObject:unionid forKey:@"unionid"];
                        [[NSUserDefaults standardUserDefaults] setObject:openID forKey:@"openID"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatLoginSuccess" object:nil];
                        //完成之后 用于调度
                        [self setMainViewcontroller];
                    }
                });
            });
        }else {
            // 微信取消登陆.
        
        }
    }
    
}

@end
