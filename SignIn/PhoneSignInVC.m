//
//  PhoneSignInVC.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/30.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "PhoneSignInVC.h"
#import "NetworkManager.h"
#import <MBProgressHUD.h>
#import "MainViewController.h"
#import "AppDelegate.h"

@interface PhoneSignInVC () {
    
    IBOutlet UITextField *_phoneTextfield;
    
    IBOutlet UITextField *_vercodeTextfield;
    
    IBOutlet UIButton *_vercodeBtn;
    
    IBOutlet UIButton *_loginBtn;
    
    NetworkManager * _networkManager;
    
    MBProgressHUD * _mbpHUD;

    AppDelegate * _appDelegate;
}

@end

@implementation PhoneSignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self networkManager];
    [self tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - timer setting
- (void)timerSetting {
    
    __block int timeout= 60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [_vercodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                
                
                _vercodeBtn.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            int seconds = timeout % 61;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                NSLog(@"____%@",strTime);
                
                [_vercodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                
                _vercodeBtn.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
}


#pragma mark - networkManager
- (void)networkManager {
    _networkManager = [NetworkManager sharedInstance];
}

#pragma mark - IBAction
- (IBAction)vercodeAction:(id)sender {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    if (_phoneTextfield.text.length == 11) {
        [_networkManager sendVerCodeWithMobile:_phoneTextfield.text DtzSuccessBlock:^(NSDictionary *successBlock) {
            // 输出结果.
            _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _mbpHUD.labelText = @"发送成功";
            _mbpHUD.mode = MBProgressHUDModeText;
            [self timerSetting];
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        } DtzFailBlock:^(NSError *failBlock) {
            _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _mbpHUD.labelText = @"网络故障";
            _mbpHUD.mode = MBProgressHUDModeText;
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    }else {
        _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _mbpHUD.labelText = @"手机号码格式不正确";
        _mbpHUD.mode = MBProgressHUDModeText;
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

- (IBAction)loginAction:(id)sender {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    if (_phoneTextfield.text.length == 11 && _vercodeTextfield.text.length == 4) {
        //先判断
        _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _mbpHUD.labelText = @"正在登陆";
        [_networkManager userLoginWithMobile:_phoneTextfield.text Code:_vercodeTextfield.text DtzSuccessBlock:^(NSDictionary *successBlock) {
            NSLog(@"%@",successBlock);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSNumber * code = [successBlock objectForKey:@"code"];
            if (code.intValue == 0) {
                //登陆成功
                // 跳转到mainviewcontroller
                NSString * token = [successBlock objectForKey:@"token"];
                if (token) {
                    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                }
                [[NSUserDefaults standardUserDefaults] setObject:_phoneTextfield.text forKey:@"mobile"];
                _appDelegate = [UIApplication sharedApplication].delegate;
                [_appDelegate setPhoneLoginMainViewcontroller];
            }
        } DtzFailBlock:^(NSError *failBlock) {
            _mbpHUD.labelText = @"网络故障";
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }];
    }else {
        _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _mbpHUD.labelText = @"请检查输入是否正确";
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    }
 
}

#pragma mark - tapGesture
- (void)tapGesture {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)hideKeyboard {
    if ([_phoneTextfield isFirstResponder]) {
        [_phoneTextfield resignFirstResponder];
    }
    if ([_vercodeTextfield isFirstResponder]) {
        [_vercodeTextfield resignFirstResponder];
    }
}


@end
