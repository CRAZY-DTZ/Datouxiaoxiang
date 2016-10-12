//
//  WebviewVC.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/10/11.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "WebviewVC.h"
#import "AppDelegate.h"

@interface WebviewVC () {
    
    IBOutlet UIWebView *_webview;
    IBOutlet UIButton *_logoutBtn;
    AppDelegate * _appDelegate;
    
}

@end

@implementation WebviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebview];
    [self navigatorAppearence];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - webview setting
- (void)setupWebview {
    NSString * htmlStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"html"];
    if (htmlStr) {
        [_webview loadHTMLString:htmlStr  baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
    }
    _webview.scalesPageToFit = YES;
    _webview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webview];
}

- (void)navigatorAppearence {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

    self.title = @"更多";
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)logoutAction:(id)sender {
    
    // 清空缓存
    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setSignInVC];
}



@end
