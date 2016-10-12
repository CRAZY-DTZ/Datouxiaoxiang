//
//  SignInVC.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/30.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "SignInVC.h"
#import "PhoneSignInVC.h"
#import "WXApi.h"
#import "NetworkManager.h"
#import "AppDelegate.h"


#define appSecret @"9bb1075fbea6f762bd94395f2425bf52"
#define appId @"wx8ba83c31e91faa23"


@interface SignInVC ()<WXApiDelegate, UINavigationBarDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate> {
    
    IBOutlet UIButton *_plBtn;
    
    IBOutlet UIButton *_wechatBtn;
    
    NetworkManager * _networkManager;
    
    AppDelegate * _appDelegate;
    
    int _count;
    
//    NSTimer * _timer;
}

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 60;
    NSString * appDomain = [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLoginSuccess) name:@"wechatLoginSuccess" object:nil];
    [self networkManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
}

#pragma mark - networkManager
- (void)networkManager {
    _networkManager = [NetworkManager sharedInstance];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
        [navigationController setNavigationBarHidden:YES animated:animated];
}

- (IBAction)phoneLoginAction:(id)sender {
    PhoneSignInVC * phoneSignInVC = [[PhoneSignInVC alloc]init];
    [self.navigationController pushViewController:phoneSignInVC animated:YES];
}

- (IBAction)wechatLoginAction:(id)sender {
    //微信登陆 获取到头像 先在缓存中 查看是否存在 如果不存在就下载 下载完加载.
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq * req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }else {
        NSLog(@"微信登陆失败");
    }
}

@end
