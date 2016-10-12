//
//  MainViewController.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/9/29.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "MainViewController.h"
#import "DtzAlertView.h"
#import "NetworkManager.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>
#import "DtzStateAlertView.h"
#import "BFAlertView.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "DtzPickerView.h"
#import "UploadAvatarImpl.h"
#import "StateIconManager.h"
#import "WebviewVC.h"

#define winSize [[UIScreen mainScreen]bounds]

#define QNDomain @"http://dtxx.mklaus.cn"

@interface MainViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DtzAlertViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,DtzStateAlertViewDelegate,BFAlertViewDelegate,WXApiDelegate,DtzPickerViewDelegate> {
    
    IBOutlet UIButton *_stateBtn;
    
    IBOutlet UIButton *_imageBtn;
    
    IBOutlet UIImageView *_avatarImageView;
    
    DtzAlertView * _alertView;
    
    DtzStateAlertView * _stateAlertView;
    
    BFAlertView * _bfAlertView;
    
    DtzPickerView * _dtzPickerView;
    
    UIView * _coverView;
    
    UIImagePickerController * _imagePicker;
    
    IBOutlet UIButton *_bigImageBtn;
    
    NetworkManager * _networkManager;
    
    MBProgressHUD * _mbpHUD;
    
    UIImage * _currentImage;
    
    NSString * _avatarUrlStr;
    
    NSString * _bigImageUrlStr;

    IBOutlet UIButton *_logoutBtn;
    
    UploadAvatarImpl * _uploadAvatarImpl;
    
    StateIconManager * _stateIconManager;
    
    UINavigationController * _webViewNavigator;
    
    WebviewVC * _webviewVC;
    
    IBOutlet UIView *_blinkingVIew;
    
    IBOutlet UIButton *_morebtn;
    
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置为在线
    _avatarState = 0;
    _bigImageBtn.hidden = YES;
    [self photoAccess];
    [self networkManager];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self setAlertView];
    [self iconlistManager];
    [self avatarImageTapGesture];
    [self notificationSetting];
    [self applyImpl];
    [self setWebview];
    [self getUpdateTime];
    //微信登陆
    if (self.isWechatLogin) {
        [self wechatLoginSuccess];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)iconlistManager {
    _stateIconManager = [[StateIconManager alloc]init];
    [_stateIconManager getStateArrayWithDtzSuccessBlock:^(NSDictionary *successBlock) {
        NSArray * status_list = [[NSUserDefaults standardUserDefaults]objectForKey:@"status_list"];
        _stateAlertView = [[DtzStateAlertView alloc]initWithFrame:CGRectMake(0, winSize.size.height, winSize.size.width, 52 * status_list.count)];
        _stateAlertView.isPresented = NO;
        _stateAlertView.delegate = self;
        _stateAlertView.statuslist = status_list;
        [_stateAlertView createBtns];
        [self.view addSubview:_stateAlertView];
    } DtzFailBlock:^(NSError *failBlock) {
        
    }];
}

#pragma mark - wechat login success 
- (void)notificationSetting {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLoginSuccess) name:@"wechatLoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneIconlist) name:@"doneIconlist" object:nil];
}

- (void)doneIconlist {

}

- (void)wechatLoginSuccess {
    NSString * unionId = [[NSUserDefaults standardUserDefaults]objectForKey:@"unionid"];
    [_networkManager uploadUsinfoToServerWithUnionId:unionId DtzSuccessBlock:^(NSDictionary *successBlock) {
        NSString * originalAvaUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"originalAvaUrl"];
        [_uploadAvatarImpl updateAvaImageAndBFImageWithOriginalUrl:originalAvaUrl];
    } DtzFailBlock:^(NSError *failBlock) {
        
    }];
}

#pragma mark - uploadAvatarImpl
- (void)applyImpl {
    if (!_uploadAvatarImpl) {
        _uploadAvatarImpl = [[UploadAvatarImpl alloc]init];
        _uploadAvatarImpl.mainViewController = self;
    }
}

#pragma mark - ib action
- (IBAction)stateAction:(id)sender {
    //选中了statebtn
    NSArray * status_list = [[NSUserDefaults standardUserDefaults]objectForKey:@"status_list"];
    if (status_list && _stateAlertView) {
            if (!_stateAlertView.isPresented && _stateAlertView.isCompeleted) {
                [UIView animateWithDuration:0.2 animations:^{
                    _stateAlertView.isPresented = YES;
                    _coverView.hidden = NO;
                    _stateAlertView.frame = CGRectMake(0, winSize.size.height - (52 * status_list.count), winSize.size.width, 52 * status_list.count);
                } completion:^(BOOL finished) {
                    
                }];
        }
    }else {
        _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _mbpHUD.labelText = @"正在加载";
        _mbpHUD.mode = MBProgressHUDModeText;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

#pragma mark - imagePicker
- (void)imagePicker {
    _imagePicker = [[UIImagePickerController alloc]init];
}

#pragma mark - photo access 
- (void)photoAccess {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        // 无权限
        // do something...
    }else {
        
    }
    AVAuthorizationStatus status2 = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status2 == AVAuthorizationStatusRestricted || status2 == AVAuthorizationStatusDenied)
    {
        // 无权限
        // do something...
    }
}

#pragma mark - networkManager
- (void)networkManager {
    _networkManager = [NetworkManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
}

- (void)showBigImageView {
    [UIView animateWithDuration:0.2 animations:^{
        _bfAlertView.frame = CGRectMake(0, winSize.size.height - (52 * 3 + 4), winSize.size.width, 52 * 3 + 4);
        _bfAlertView.isPresented = YES;
        _coverView.hidden = NO;
    }];
}

#pragma mark - imagepicker delegate
- (void)dtzImagePickerSettings {
    _imagePicker = [[UIImagePickerController alloc]init];
}

#pragma mark - avatarImageTapgesture 
- (void)avatarImageTapGesture {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarImageView)];
    tapGesture.numberOfTapsRequired = 1;
    _avatarImageView.userInteractionEnabled = YES;
    [_avatarImageView addGestureRecognizer:tapGesture];
}

- (IBAction)clickBigBtn:(id)sender {
    [self showBigImageView];
}

#pragma mark - avatarBtn action 
- (IBAction)clickAvatarBtn:(id)sender {
    //click 头像
//    if (!_alertView.isPresented) {
        [UIView animateWithDuration:0.2 animations:^{
            //设置alertview 的frame
            _alertView.isPresented = YES;
            _coverView.hidden = NO;
            _alertView.frame = CGRectMake(0, winSize.size.height - (52 * 4 + 4), winSize.size.width, 52 * 4 + 4);
        } completion:^(BOOL finished) {
            
        }];
//    }
}

#pragma mark - 初始化 alertviews
- (void)setAlertView {
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, winSize.size.width, winSize.size.height)];
    _coverView.backgroundColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:0.7];
    [self.view addSubview:_coverView];
    _coverView.hidden = YES;

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCoverView)];
    tapGesture.numberOfTapsRequired = 1;
    _coverView.userInteractionEnabled = YES;
    [_coverView addGestureRecognizer:tapGesture];
    
    _alertView = [[DtzAlertView alloc]initWithFrame:CGRectMake(0, winSize.size.height, winSize.size.width, 52 * 4 + 4)];
    _alertView.isPresented = NO;
    _alertView.delegate = self;
    [_alertView createBtns];
    [self.view addSubview:_alertView];
    
    _bfAlertView = [[BFAlertView alloc]initWithFrame:CGRectMake(0, winSize.size.height, winSize.size.width, 52 * 3 + 4)];
    _bfAlertView.isPresented = NO;
    [_bfAlertView createBtns];
    _bfAlertView.delegate = self;
    [self.view addSubview:_bfAlertView];
    
    _dtzPickerView = [[DtzPickerView alloc]initWithFrame:CGRectMake(0, winSize.size.height, winSize.size.width, 52 * 3 +4)];
    _dtzPickerView.isPresented = NO;
    [_dtzPickerView createBtns];
    _dtzPickerView.delegate = self;
    [self.view addSubview:_dtzPickerView];
}

#pragma mark - bfalertView delegate 
- (void)clickBFBtnWithTag:(NSInteger)tag {
    // 选中1 为 分享到朋友圈 选中2 为保存图片 选中3 为取消.
    switch (tag) {
        case 1:
            [self shareToFriendsWithImage:nil];
            [self hideDtzAlertView];
            break;
        case 2:
            // 保存大字图片到本地
            //获取cache的图片. 再保存.
            if (_currentBFImage) {
                [self saveImageToPhotos:_currentBFImage];
            }
            [self hideDtzAlertView];
            break;
        case 3:
            //取消
            [self hideDtzAlertView];
            break;
        default:
            break;
    }
}

#pragma mark - photoAlertView
- (void)clickPickerWithTag:(NSInteger)tag {
    switch (tag) {
        case 1:
            //拍照
            _imagePicker = [[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _imagePicker.delegate = self;
                _imagePicker.allowsEditing = YES;
                [self presentViewController:_imagePicker animated:YES completion:^{
                    
                }];
            }
            break;
        case 2:
            //相册
            _imagePicker = [[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                _imagePicker.delegate = self;
                _imagePicker.allowsEditing = YES;
                [self presentViewController:_imagePicker animated:YES completion:^{
                    
                }];
            }
            break;
        case 3:
            //取消
            
            break;
        default:
            break;
    }
    [self hideDtzAlertView];
}

#pragma mark - 状态的更改策略
- (void)clickStateBtnsWithTag:(NSInteger)tag {
    NSArray * status_list = [[NSUserDefaults standardUserDefaults]objectForKey:@"status_list"];
    if ((tag - 1) < status_list .count) {
        
    }
    NSDictionary * dic = [status_list objectAtIndex:tag - 1];
    NSString * name = dic[@"name"];
    if (name) {
        UIImage * image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:name];
        _avatarState = (int)tag - 1;
        [_stateBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_stateBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    // 获取到最新设置的 头像 可能是wechat 登陆的头像
    NSString * originalAvaUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"originalAvaUrl"];
    if (originalAvaUrl) {
        [_uploadAvatarImpl updateAvaImageAndBFImageWithOriginalUrl:originalAvaUrl];
    }else {
        //提示token过期 需要重新登陆.
    }
    [self hideDtzAlertView];
}


#pragma mark - 头像的更改策略
- (void)clickButtonWithTag:(NSInteger)tag {
    if (tag == 1) {
    //使用微信登陆
        [_networkManager refreshToken];
        if ([WXApi isWXAppInstalled]) {
            SendAuthReq * req = [[SendAuthReq alloc]init];
            req.scope = @"snsapi_userinfo";
            req.state = @"App";
            [WXApi sendReq:req];
        }else {
            NSLog(@"微信登陆失败");
        }
        [self hideDtzAlertView];
    }else if (tag == 2) {
        //弹出拍照的alter view
        [self showPhotoAlertView];
    }else if (tag == 0) {
        //取消
        [self hideDtzAlertView];
    }else if (tag == 3) {
        if (_currentAvatarImage) {
            [self saveImageToPhotos:_currentAvatarImage];
        }
        [self hideDtzAlertView];
    }

}

- (void)showPhotoAlertView {
    [UIView animateWithDuration:0.2 animations:^{
        _alertView.isPresented = NO;
        _alertView.frame = CGRectMake(0, winSize.size.height, winSize.size.width, 52 * 4 + 4);
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.2 animations:^{
        _dtzPickerView.isPresented = YES;
        _dtzPickerView.frame = CGRectMake(0,winSize.size.height - (52 * 3 + 4), winSize.size.width, 52 * 3 + 4);
    }];
}

- (void)tapCoverView {
    [self hideDtzAlertView];
}

- (void)hideDtzAlertView {
    //动画隐藏 alertView
    if (_alertView.isPresented) {
        [UIView animateWithDuration:0.2 animations:^{
            _alertView.isPresented = NO;
            _coverView.hidden = YES;
            _alertView.frame = CGRectMake(0, winSize.size.height, winSize.size.width, 52 * 4 + 4);
        } completion:^(BOOL finished) {
            
        }];
    }
    if (_stateAlertView.isPresented) {
        [UIView animateWithDuration:0.2 animations:^{
            _stateAlertView.isPresented = NO;
            _coverView.hidden = YES;
            _stateAlertView.frame = CGRectMake(0, winSize.size.height, winSize.size.width, 52 * 5);
        } completion:^(BOOL finished) {
            
        }];
    }
    if (_bfAlertView.isPresented) {
        [UIView animateWithDuration:0.2 animations:^{
            _bfAlertView.isPresented = NO;
            _coverView.hidden = YES;
            _bfAlertView.frame = CGRectMake(0, winSize.size.height, winSize.size.width, 52 * 3 + 4);
        } completion:^(BOOL finished) {

        }];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _dtzPickerView.isPresented = NO;
        _coverView.hidden = YES;
        _dtzPickerView.frame = CGRectMake(0 , winSize.size.height , winSize.size.width , 52 * 3 + 4);
    }];
    
}

#pragma mark - imagepicker delegate 
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_imagePicker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"cancel 了imagepicker");
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //获取图片
    //裁剪图片为正方形.
    if (_stateBtn.hidden) {
        _stateBtn.hidden = NO;
    }
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image =[info objectForKey:UIImagePickerControllerEditedImage];
    _currentImage = image;
    _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _mbpHUD.labelText = @"正在上传";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    NSData * data = UIImageJPEGRepresentation(image, 1);
    //上传 到七牛服务器.
    [_uploadAvatarImpl uploadAvatarWithImage:image DtzSuccessBlock:^(NSDictionary *successBlock) {
        //上传成功.
        _mbpHUD.labelText = @"上传成功";
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        [_imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_imageBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    } DtzFailBlock:^(NSError *failBlock) {
        _mbpHUD.labelText = @"网络故障";
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    }];
}

#pragma mark - 保存图片
- (void)saveImageToPhotos:(UIImage*)savedImage {
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if(error != NULL){
        _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _mbpHUD.labelText = @"保存失败";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }else{
        _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _mbpHUD.labelText = @"保存成功";
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}

#pragma mark - 分享到朋友圈
- (void)shareToFriendsWithImage:(UIImage *)bfImage {
    if (self.currentBFImage) {
        WXMediaMessage * imageMessage = [WXMediaMessage message];
        // 设置缩略图 再设置大图.
        WXImageObject * imageObject = [WXImageObject object];
        NSData *data = UIImageJPEGRepresentation(self.currentBFImage,1.0);
        imageObject.imageData = data;
        imageMessage.mediaObject = imageObject;
        SendMessageToWXReq * req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        req.message = imageMessage;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
    }
}

#pragma mark - logoutAction
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

#pragma mark - 更新 图片
- (void)updateAvatarImageWithCacheImage:(UIImage *)cacheImage {
    self.currentAvatarImage = cacheImage;
    [_imageBtn setBackgroundImage:cacheImage forState:UIControlStateNormal];
    [_imageBtn setBackgroundImage:cacheImage forState:UIControlStateHighlighted];
    self.isBFDone = YES;
    [self hideMBPHUD];
}

- (void)updateBfImageWithCacheImage:(UIImage *)cacheImage {
    self.currentBFImage = cacheImage;
    _bigImageBtn.hidden = NO;
    [_bigImageBtn setBackgroundImage:cacheImage forState:UIControlStateNormal];
    [_bigImageBtn setBackgroundImage:cacheImage forState:UIControlStateHighlighted];
    self.isAvatarDone = YES;
    [self hideMBPHUD];
}

- (void)hideMBPHUD {
    if (self.isBFDone && self.isAvatarDone) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.isBFDone = NO;
        self.isAvatarDone = NO;
    }
}


#pragma mark - webviewvc
- (void)setWebview {
    [_networkManager getMoreLinkWithDtzSuccessBlock:^(NSDictionary *successBlock) {
        _webviewVC = [[WebviewVC alloc]init];
        _webViewNavigator = [[UINavigationController alloc]initWithRootViewController:_webviewVC];
    } DtzFailBlock:^(NSError *failBlock) {
        NSLog(@"%@",failBlock);
    }];
}

- (void)getUpdateTime {
    [_networkManager getLinkUpdateTimeWithDtzSuccessBlock:^(NSDictionary *successBlock) {
        NSNumber * oldUpdateTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"oldUpdateTime"];
        NSNumber * newUpdateTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"newUpdateTime"];
        NSString * isClicked = [[NSUserDefaults standardUserDefaults]objectForKey:@"isClicked"];
        if (oldUpdateTime && newUpdateTime) {
            if (oldUpdateTime.intValue != newUpdateTime.intValue) {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isClicked"];
            }
        }
        if (oldUpdateTime) {
            if (oldUpdateTime.intValue == newUpdateTime.intValue && [isClicked isEqualToString:@"YES"]) {
                // 如果是一样的 就不显示 闪框 ...
                [self hideBlinkingView:YES];
            }else {
                //  闪框
                [self hideBlinkingView:NO];
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isClicked"];
            }
        }else {
            // 去掉闪框
            [self hideBlinkingView:NO];
            [[NSUserDefaults standardUserDefaults] setObject:newUpdateTime forKey:@"oldUpdateTime"];
        }
    } DtzFailBlock:^(NSError *failBlock) {
        
    }];
}

- (void)hideBlinkingView:(BOOL)hidden {
    // 设置忽隐忽现
    if (hidden) {
        // 隐藏
        _blinkingVIew.hidden = YES;
    }else {
        // 不隐藏 添加动画
        _blinkingVIew.hidden = NO;
        [self blinkingViewAnimation];
    }
}

#pragma mark - tipsLabel
- (void)blinkingViewAnimation {
    CABasicAnimation *fadeInAndOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAndOut.duration = 0.5;
    fadeInAndOut.repeatCount = 1000;
    fadeInAndOut.autoreverses = YES;
    fadeInAndOut.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAndOut.toValue = [NSNumber numberWithFloat:1.0];
    fadeInAndOut.repeatCount = HUGE_VALF;
    fadeInAndOut.fillMode = kCAFillModeBoth;
    [_morebtn.layer addAnimation:fadeInAndOut forKey:@"myanimation"];
}

- (IBAction)moreAction:(id)sender {
    if (_webviewVC) {
        // 隐藏blinking view
        NSNumber * oldUpdateTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"oldUpdateTime"];
        NSNumber * newUpdateTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"newUpdateTime"];
        if (newUpdateTime) {
            [[NSUserDefaults standardUserDefaults] setObject:newUpdateTime forKey:@"oldUpdateTime"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isClicked"];
        [self hideBlinkingView:YES];
        [self presentViewController:_webViewNavigator animated:YES completion:^{
            
        }];
    }else {
        _mbpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _mbpHUD.labelText = @"正在加载";
        _mbpHUD.mode = MBProgressHUDModeText;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
}


@end
