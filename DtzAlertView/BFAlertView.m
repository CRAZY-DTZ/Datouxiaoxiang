//
//  BFAlertView.m
//  Datouxiaoxiang
//
//  Created by wuhaibin on 16/10/3.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "BFAlertView.h"

#define winSize [[UIScreen mainScreen]bounds]

@implementation BFAlertView

- (void)createBtns {
    UIButton * shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 1, winSize.size.width - 10, 50)];
    shareBtn.tag = 1;
    [shareBtn setTitleColor:[UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1] forState:UIControlStateNormal];
    [shareBtn setTitle:@"分享到微信" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(clickBFBtns:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"highlighted"] forState:UIControlStateHighlighted];
    
    
    UIButton * saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 52, winSize.size.width - 10, 50)];
    saveBtn.tag = 2;
    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(clickBFBtns:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"highlighted"] forState:UIControlStateHighlighted];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(5,  52 * 2 + 4, winSize.size.width - 10, 50)];
    cancelBtn.tag = 3;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:74.0/255 green:74.0/255 blue:74.0/255 alpha:1] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickBFBtns:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"highlighted"] forState:UIControlStateHighlighted];
    
    self.backgroundColor = [UIColor colorWithRed:216.0/255 green:216.0/255 blue:216.0/255 alpha:0.7];
    [self addSubview:shareBtn];
    [self addSubview:saveBtn];
    [self addSubview:cancelBtn];
}

- (void)clickBFBtns:(id)sender {
    UIButton * btn = (UIButton *)sender;
    [self.delegate clickBFBtnWithTag:btn.tag];
}

@end
